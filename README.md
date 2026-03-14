# IA Photo Booth

Uma aplicação completa de edição de fotos usando inteligência artificial para transformar imagens em versões históricas ou temáticas. O projeto consiste em um backend robusto (FastAPI) e um frontend moderno (React + TypeScript).

## 🎯 O que faz

- ✅ Recebe uma foto de referência
- ✅ Envia a imagem para edição com IA (OpenAI Images API)
- ✅ Permite customizar tema e instruções extras
- ✅ Mostra a imagem original e o resultado final lado a lado
- ✅ Retorna a imagem em base64 para download imediato
- ✅ Interface responsiva e moderna (mobile-first)

## 📊 Stack Tecnológico

### Backend
- **Framework:** FastAPI (Python)
- **Server:** Uvicorn
- **IA:** OpenAI Images API (`images.edit`)
- **Requisitos:** Python 3.8+

### Frontend
- **Framework:** React 18+
- **Linguagem:** TypeScript
- **Build Tool:** Vite
- **Styling:** Tailwind CSS
- **UI Components:** shadcn/ui
- **Requisitos:** Node.js 18+ / Bun

## 📁 Estrutura do Projeto

```
ia-photo-booth/
├── ia-photo-booth-back/          # Backend (FastAPI)
│   ├── main.py                   # Aplicação principal
│   ├── requirements.txt           # Dependências Python
│   └── README.md
├── ia-photo-booth-front/         # Frontend (React + TypeScript)
│   ├── src/
│   │   ├── components/           # Componentes React
│   │   ├── pages/                # Páginas
│   │   ├── services/             # Serviços API
│   │   ├── types/                # Types TypeScript
│   │   └── App.tsx
│   ├── package.json
│   ├── vite.config.ts
│   ├── tailwind.config.ts
│   └── README.md
└── README.md                     # Este arquivo
```

## 🚀 Como Rodar

### Pré-requisitos

- **Python 3.8+** (para o backend)
- **Node.js 18+** ou **Bun** (para o frontend)
- Chave de API da OpenAI (para usar a IA)

### 1. Backend (FastAPI)

```bash
# Navegue para a pasta do backend
cd ia-photo-booth-back

# Crie um ambiente virtual (recomendado)
python -m venv .venv

# Ative o ambiente virtual
# No Windows:
.venv\Scripts\activate
# No Linux/macOS:
source .venv/bin/activate

# Instale as dependências
pip install -r requirements.txt

# Configure as variáveis de ambiente
# Crie um arquivo .env com sua chave da OpenAI:
echo OPENAI_API_KEY=sua_chave_aqui > .env

# Inicie o servidor com Uvicorn
uvicorn main:app --reload --port 8000
# O backend estará disponível em http://localhost:8000
# A documentação interativa estará em http://localhost:8000/docs
```

**Endpoints principais:**
- `POST /upload` - Envia imagem e configurações para edição
- `GET /docs` - Documentação interativa (Swagger UI)

### 2. Frontend (React)

```bash
# Navegue para a pasta do frontend
cd ia-photo-booth-front

# Instale as dependências
# Com npm:
npm install
# Ou com Bun:
bun install

# Inicie o servidor de desenvolvimento
npm run dev
# Ou:
bun run dev

# O frontend estará disponível em http://localhost:5173
```

**Scripts disponíveis:**
- `npm run dev` - Inicia o servidor de desenvolvimento
- `npm run build` - Cria build para produção
- `npm run preview` - Visualiza a build em produção
- `npm run lint` - Executa o ESLint
- `npm run test` - Executa testes (Vitest)
- `npm run test:watch` - Executa testes em modo watch

## 🔧 Configuração

### Backend - Variáveis de Ambiente

Crie um arquivo `.env` na pasta `ia-photo-booth-back/`:

```env
OPENAI_API_KEY=sk-sua-chave-aqui
OPENAI_MODEL=gpt-image-1
```

### Frontend - Configuração da API

Atualize a URL da API em `src/services/api.ts` se necessário:

```typescript
const API_BASE_URL = 'http://localhost:8000';
```

## 📦 Dependências Principais

### Backend

| Pacote | Versão | Uso |
|--------|--------|-----|
| fastapi | 0.116.1 | Framework Web |
| uvicorn | 0.35.0 | ASGI Server |
| openai | 1.107.0 | API de IA |
| python-dotenv | 1.1.0 | Variáveis de Ambiente |
| python-multipart | 0.0.20 | Upload de Arquivos |

### Frontend

- **React**: Interface de usuário
- **TypeScript**: Type safety
- **Vite**: Build tool rápido
- **Tailwind CSS**: Utility-first CSS
- **shadcn/ui**: Componentes UI customizáveis
- **Vitest**: Testes unitários
- **ESLint**: Linting

## 🎨 Features

### Componentes Frontend
- `ActionButtons` - Botões de ação (editar, reset, etc)
- `AppHeader` - Cabeçalho da aplicação
- `ConfigFormCard` - Formulário de configuração
- `ImageUploadCard` - Upload de imagens
- `ResultCard` - Exibição do resultado
- `ShareButtons` - Botões de compartilhamento
- Biblioteca completa de componentes UI (shadcn/ui)

### API Backend
- Suporte a CORS para requisições do frontend
- Validação de imagens
- Integração com OpenAI Images API
- Tratamento de erros robusto
- Respostas em JSON

## 🧪 Testes

### Frontend

```bash
cd ia-photo-booth-front

# Executar testes uma vez
npm run test

# Executar testes em modo watch
npm run test:watch
```

## 🐛 Troubleshooting

### Erro de conexão ao instalar dependências (pip)
Se receber erro de conexão ao fazer `pip install`, verifique:
- Se está conectado à internet
- Se precisa de proxy (corporate networks)
- Tente: `pip install --index-url https://pypi.org/simple/ -r requirements.txt`

### Erro CORS no frontend
Certifique-se que:
- O backend está rodando em `http://localhost:8000`
- O backend tem CORS configurado para `http://localhost:5173`

### Chave da OpenAI não reconhecida
- Verifique se o arquivo `.env` está no diretório correto
- Confirme que a chave é válida no painel da OpenAI
- Reinicie o servidor após adicionar a chave

## 📚 Documentação Adicional

- [Backend - README](./ia-photo-booth-back/README.md)
- [Frontend - README](./ia-photo-booth-front/README.md)
- [FastAPI Docs](https://fastapi.tiangolo.com/)
- [React Docs](https://react.dev/)
- [OpenAI API Docs](https://platform.openai.com/docs/api-reference/images)

## 👨‍💻 Desenvolvimento

### Contribuindo

1. Crie uma branch para sua feature (`git checkout -b feature/AmazingFeature`)
2. Commit suas mudanças (`git commit -m 'Add some AmazingFeature'`)
3. Push para a branch (`git push origin feature/AmazingFeature`)
4. Abra um Pull Request

### Code Style

- **Backend**: Siga as convenções Python (PEP 8)
- **Frontend**: ESLint será executado no commit

## 📝 Licença

Este projeto é de código aberto. Veja o arquivo `LICENSE` para mais detalhes.

## 🤝 Suporte

Se encontrar problemas ou tiver sugestões, abra uma issue no repositório.

---

**Última atualização:** Março 2026
