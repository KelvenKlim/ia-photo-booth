import base64
import os
import tempfile
import traceback
import logging
from pathlib import Path
from typing import Optional

from fastapi import FastAPI, File, Form, HTTPException, Request, UploadFile
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

# Check if mock mode is enabled
MOCK_MODE = os.getenv("MOCK_MODE", "false").lower() == "true"
if MOCK_MODE:
    logger.warning("⚠️ MOCK MODE ENABLED - Images will be generated locally without using OpenAI API")


def build_prompt(theme: str, extra_instructions: Optional[str] = None) -> str:
    base = f"""
Use the uploaded image as the PRIMARY IDENTITY REFERENCE.

TASK:
Transform the real subject from the source image into a photorealistic cinematic portrait in the theme: {theme}.

IDENTITY PRESERVATION — HIGHEST PRIORITY:
- preserve the exact identity of the subject
- keep the same facial structure, eyes, nose, mouth, jawline, beard, mustache, hairline, skin tone, and natural proportions
- do not replace the subject with a lookalike
- do not beautify, de-age, idealize, or significantly alter the subject
- the final result must clearly look like the same real person from the input image

COMPOSITION:
- recompose the image beyond the original selfie framing
- use a medium or medium-wide cinematic portrait
- show the upper body and enough surrounding space to establish the setting
- keep the face clearly recognizable, but allow the environment to be a meaningful part of the composition

ENVIRONMENT:
- create a rich, developed, visually readable historical setting
- the environment must be clearly visible and must not look generic
- do not use a vague blurred backdrop as the main solution
- include recognizable period elements appropriate to the requested scene
- each variation must produce a distinct environment, not just small changes in color or lighting
- the background should support storytelling and clearly communicate the chosen setting

STYLE:
- photorealistic
- cinematic
- realistic skin texture
- high detail
- dramatic but natural lighting
- editorial quality
- immersive historical realism

NEGATIVE CONSTRAINTS:
- no cartoon
- no anime
- no painting
- no generic studio backdrop
- no empty background
- no modern clothing
- no text
- no watermark
- no logo
- no face distortion
- no duplicate people

""".strip()

    if extra_instructions:
        return base + "\n\nADDITIONAL INSTRUCTIONS:\n" + extra_instructions.strip()
    return base


def generate_mock_image(theme: str) -> str:
    """Generate a simple mock image in base64 (1x1 pixel PNG for testing)"""
    try:
        from PIL import Image, ImageDraw
        
        # Create a simple gradient image to represent the edited photo
        img = Image.new('RGB', (512, 512), color='white')
        draw = ImageDraw.Draw(img)
        
        # Add some visual indication based on theme
        theme_colors = {
            "Hamilton": (29, 53, 87),  # Dark blue
            "Colonial American": (160, 120, 80),  # Brown
            "Historical Portrait": (100, 100, 100),  # Gray
            "Vintage Studio": (139, 69, 19),  # Saddle brown
        }
        
        color = theme_colors.get(theme, (70, 130, 180))  # Steel blue default
        
        # Draw a simple frame
        draw.rectangle([50, 50, 462, 462], outline=color, width=3)
        draw.text((256, 256), f"Mock: {theme}", fill=color, anchor="mm")
        
        # Convert to base64
        import io
        buffer = io.BytesIO()
        img.save(buffer, format="PNG")
        b64_image = base64.b64encode(buffer.getvalue()).decode("utf-8")
        
        logger.info("✓ Mock image generated successfully")
        return b64_image
    except ImportError:
        # If PIL not available, return a minimal valid PNG base64
        logger.warning("PIL not available, returning minimal PNG")
        # This is a 1x1 white pixel PNG in base64
        return "iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR42mP8z8DwHwAFBQIAX8jx0gAAAABJRU5ErkJggg=="


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
    
    content = await image.read()
    if not content:
        raise HTTPException(status_code=400, detail="Arquivo de imagem vazio.")

    allowed = {"image/png", "image/jpeg", "image/jpg", "image/webp", "application/octet-stream"}
    content_type = (image.content_type or "").lower()
    if content_type and content_type not in allowed:
        raise HTTPException(
            status_code=400,
            detail=f"Formato inválido ({content_type}). Use PNG, JPG/JPEG ou WEBP.",
        )

    prompt = build_prompt(theme=theme, extra_instructions=extra_instructions)

    # MOCK MODE - for testing without consuming API tokens
    if MOCK_MODE:
        logger.info("🎭 Using MOCK mode - generating test image")
        output_b64 = generate_mock_image(theme)
        return JSONResponse(
            {
                "prompt_used": prompt,
                "image_base64": output_b64,
                "mime_type": "image/png",
            }
        )

    # REAL MODE - use OpenAI API
    api_key = os.getenv("OPENAI_API_KEY")
    if not api_key:
        raise HTTPException(status_code=500, detail="OPENAI_API_KEY não configurada no backend.")

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

from sendgrid import SendGridAPIClient
from sendgrid.helpers.mail import (
    Mail, Attachment, FileContent, FileName, FileType, Disposition
)

# Endpoint para envio de imagem por e-mail
@app.post("/api/send-email")
async def send_email(
    request: Request,
):
    body = await request.json()
    to_email = body.get("to_email", "")
    image_base64 = body.get("image_base64", "")
    theme = body.get("theme", "Hamilton")

    if not to_email or "@" not in to_email:
        raise HTTPException(status_code=400, detail="E-mail inválido.")
    if not image_base64:
        raise HTTPException(status_code=400, detail="Imagem não fornecida.")

    logger.info(f"Enviando e-mail para: {to_email}")

    template_path = Path(__file__).parent / "templates" / "email_template.html"
    html_body = template_path.read_text(encoding="utf-8").replace("{{THEME}}", theme)

    msg = Mail(
        from_email=os.getenv("SENDGRID_FROM", "noreply@icbeutechzone.com"),
        to_emails=to_email,
        subject=f"🎨 Sua foto foi processada - {theme}",
        plain_text_content="Sua foto gerada por IA está em anexo. Abra o arquivo anexado para visualizá-la!",
        html_content=html_body,
    )

    attachment = Attachment(
        file_content=FileContent(image_base64),
        file_name=FileName(f'foto_icbeu_{theme.replace(" ", "_")}.jpg'),
        file_type=FileType("image/jpeg"),
        disposition=Disposition("attachment"),
    )
    msg.attachment = attachment

    try:
        sg = SendGridAPIClient(os.getenv("SENDGRID_API_KEY", ""))
        response = sg.send(msg)
        logger.info(f"✅ E-mail enviado via SendGrid para {to_email} — status {response.status_code}")
        return JSONResponse({"success": True})
    except Exception as e:
        logger.error(f"Erro ao enviar e-mail via SendGrid: {e}")
        raise HTTPException(status_code=500, detail=f"Erro ao enviar e-mail: {e}")

