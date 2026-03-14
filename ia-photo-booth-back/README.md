# Historical Portrait Editor

Pequeno software para receber uma imagem e gerar uma versão histórica usando a API de imagens da OpenAI.

## O que ele faz

- recebe uma foto de referência
- envia a imagem para edição com um prompt de preservação facial
- permite informar tema e instruções extras
- mostra a imagem original e o resultado final na interface
- retorna a imagem em base64 para download imediato

## Stack

- **Backend:** FastAPI
- **Frontend:** HTML + CSS + JavaScript puro
- **IA:** OpenAI Images API (`images.edit`)

Segundo a documentação oficial da OpenAI, a API de imagens suporta **gerações** e **edições** com os modelos GPT Image (`gpt-image-1.5`, `gpt-image-1`, `gpt-image-1-mini`), e o uso recomendado para experiências conversacionais e edições iterativas também pode ser feito pela Responses API.

## Estrutura

```text
hamilton-face-edit-app/
├─ backend/
│  ├─ main.py
│  ├─ requirements.txt
│  └─ .env.example
├─ frontend/
│  ├─ index.html
│  ├─ app.js
│  └─ style.css
└─ README.md
```

## Como rodar

### 1. Backend

```bash
cd backend
python -m venv .venv
source .venv/bin/activate  # Linux / macOS
# .venv\Scripts\activate   # Windows
pip install -r requirements.txt
cp .env.example .env
```

Adicione sua chave no arquivo `.env`:

```env
OPENAI_API_KEY=sk-...
```

Suba a API:

```bash
uvicorn main:app --reload --port 8000
```

### 2. Frontend

Abra `frontend/index.html` no navegador.

Para evitar problemas de CORS e paths locais, o ideal é servir a pasta `frontend` com um servidor simples:

```bash
cd frontend
python -m http.server 5500
```

Depois abra:

```text
http://localhost:5500
```

## Endpoint principal

### `POST /api/edit-image`

Form-data:

- `image`: arquivo PNG/JPG/WEBP
- `theme`: tema da transformação
- `extra_instructions`: instruções complementares
- `size`: `1024x1024`, `1536x1024`, `1024x1536`
- `quality`: `high`, `medium`, `low`
- `model`: `gpt-image-1.5`, `gpt-image-1`, `gpt-image-1-mini`

Resposta:

```json
{
  "prompt_used": "...",
  "image_base64": "...",
  "mime_type": "image/png"
}
```

## Prompt usado no projeto

O projeto foi desenhado para priorizar **preservação de identidade** antes de ambientação. Isso é importante porque, em edições históricas, o modelo pode priorizar o figurino e o cenário se a instrução facial estiver fraca. A documentação da OpenAI destaca GPT Image como o modelo mais indicado para edição detalhada e melhor aderência a instruções. 

## Limitações importantes

Mesmo com prompt reforçado, **OpenAI Images sozinho não é a solução mais forte para travar identidade facial com precisão máxima**. Para um produto mais fiel, a evolução ideal é:

- OpenAI para edição e direção estética
- um segundo estágio com **InstantID / IP-Adapter Face** para reforçar identidade
- comparação de similaridade facial antes de aceitar o resultado

Essa recomendação é uma inferência de arquitetura: a OpenAI fornece edição de imagens e melhor aderência a instruções, mas não expõe um parâmetro dedicado de “identity lock” facial de alta precisão no endpoint de imagens documentado.

## Próximos passos recomendados

- adicionar fila assíncrona para edições longas
- salvar histórico em banco de dados
- criar autenticação
- adicionar presets de prompt
- permitir múltiplas tentativas automáticas
- incluir score de fidelidade facial

## Observação

Para máxima fidelidade para rostos reais, a próxima versão em:

- **Frontend:** React
- **Backend:** FastAPI
- **Workers:** Celery / RQ
- **Storage:** S3 ou Cloudflare R2
- **Banco:** Postgres
- **Pipeline:** OpenAI + InstantID
