import base64
import os
import tempfile
import traceback
import logging
from pathlib import Path
from typing import Optional

from fastapi import FastAPI, File, Form, HTTPException, UploadFile
from fastapi.middleware.cors import CORSMiddleware
from fastapi.responses import JSONResponse
from dotenv import load_dotenv
from openai import OpenAI

# Configure logging
logging.basicConfig(level=logging.DEBUG)
logger = logging.getLogger(__name__)

load_dotenv()

app = FastAPI(title="Historical Portrait Editor")

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)


def build_prompt(theme: str, extra_instructions: Optional[str] = None) -> str:
    base = f"""
Use the provided photo as the primary facial identity reference.

Recreate the SAME people from the reference photo in a {theme} scene.

CRITICAL IDENTITY PRESERVATION REQUIREMENTS:
- preserve the exact facial identity of each person
- keep the same face shape, nose, mouth, eyes, skin tone, hairline, and body proportions
- preserve glasses, beard, mustache, and other defining facial details when present in the source image
- do not replace the subjects with lookalikes
- do not beautify, de-age, or significantly alter the subjects
- the result must clearly look like the same real people from the input photo

VISUAL REQUIREMENTS:
- photorealistic image
- cinematic composition
- natural pose adaptation based on the original image
- realistic skin texture
- high detail
- no text, watermark, logo, or frame
- no cartoon, anime, painting, or illustration style

SCENE GUIDANCE:
- historically believable wardrobe and environment
- preserve the relative position of the people where possible
- use dramatic but realistic lighting
""".strip()

    if extra_instructions:
        return base + "\n\nADDITIONAL INSTRUCTIONS:\n" + extra_instructions.strip()
    return base


@app.get("/health")
def health() -> dict:
    return {"status": "ok"}


@app.post("/api/edit-image")
async def edit_image(
    image: UploadFile = File(...),
    theme: str = Form(...),
    extra_instructions: Optional[str] = Form(None),
    size: str = Form("1024x1024"),
    quality: str = Form("high"),
    model: str = Form("gpt-image-1"),
):
    logger.info(f"Received request - theme: {theme}, size: {size}, quality: {quality}, model: {model}")
    logger.info(f"Image: {image.filename}, content_type: {image.content_type}")
    logger.info(f"Extra instructions: {extra_instructions}")
    
    api_key = os.getenv("OPENAI_API_KEY")
    if not api_key:
        raise HTTPException(status_code=500, detail="OPENAI_API_KEY não configurada no backend.")

    content = await image.read()
    if not content:
        raise HTTPException(status_code=400, detail="Arquivo de imagem vazio.")

    allowed = {"image/png", "image/jpeg", "image/webp"}
    if image.content_type not in allowed:
        raise HTTPException(
            status_code=400,
            detail="Formato inválido. Use PNG, JPG/JPEG ou WEBP.",
        )

    prompt = build_prompt(theme=theme, extra_instructions=extra_instructions)

    client = OpenAI(api_key=api_key)

    suffix = Path(image.filename or "input.png").suffix or ".png"
    with tempfile.NamedTemporaryFile(delete=False, suffix=suffix) as tmp:
        tmp.write(content)
        tmp_path = tmp.name

    try:
        with open(tmp_path, "rb") as img_file:
            result = client.images.edit(
                model=model,
                image=img_file,
                prompt=prompt,
                size=size,
                quality=quality,
            )

        output_b64 = result.data[0].b64_json
        if not output_b64:
            raise HTTPException(status_code=500, detail="A API não retornou imagem em base64.")

        return JSONResponse(
            {
                "prompt_used": prompt,
                "image_base64": output_b64,
                "mime_type": "image/png",
            }
        )
    except Exception as exc:
        error_msg = f"Falha ao editar imagem: {str(exc)}"
        logger.error(f"Error: {error_msg}")
        logger.error(f"Traceback: {traceback.format_exc()}")
        raise HTTPException(status_code=500, detail=error_msg) from exc
    finally:
        try:
            os.remove(tmp_path)
        except OSError:
            pass
