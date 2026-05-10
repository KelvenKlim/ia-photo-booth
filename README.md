# IA Photo Booth

Uma aplicação completa de edição de fotos usando inteligência artificial para transformar imagens em versões históricas ou temáticas. O projeto consiste em um backend robusto (FastAPI) e um aplicativo mobile (Flutter).

## 🎯 O que faz

- ✅ Recebe uma foto de referência
- ✅ Envia a imagem para edição com IA (OpenAI Images API)
- ✅ Permite customizar tema e instruções extras
- ✅ Mostra a imagem original e o resultado final lado a lado
- ✅ Retorna a imagem em base64 para download imediato
- ✅ Interface nativa mobile (Android e iOS)

## 📊 Stack Tecnológico

### Backend
- **Framework:** FastAPI (Python)
- **Server:** Uvicorn
- **IA:** OpenAI Images API (`images.edit`)
- **Requisitos:** Python 3.8+

### Mobile
- **Framework:** Flutter
- **Linguagem:** Dart
- **Requisitos:** Flutter SDK ^3.11.1
- **Plataformas:** Android e iOS

## 📁 Estrutura do Projeto

```
ia-photo-booth/
├── ia-photo-booth-back/          # Backend (FastAPI)
│   ├── main.py                   # Aplicação principal
│   ├── requirements.txt          # Dependências Python
│   └── README.md
├── ia_photo_booth_flutter/       # App Mobile (Flutter)
│   ├── lib/
│   │   ├── config.dart           # Configuração da API
│   │   ├── main.dart             # Entrypoint
│   │   ├── models/               # Modelos de dados
│   │   ├── screens/              # Telas do app
│   │   ├── services/             # Serviços API
│   │   └── widgets/              # Componentes reutilizáveis
│   ├── android/                  # Projeto Android
│   ├── ios/                      # Projeto iOS
│   ├── pubspec.yaml              # Dependências Flutter
│   └── README.md
├── render.yaml                   # Configuração de deploy (Render)
├── iniciar-emulador.bat          # Script para iniciar emulador Android (Windows)
└── README.md                     # Este arquivo
```

## 🚀 Como Rodar

### Pré-requisitos

- **Python 3.8+** (para o backend)
- **Flutter SDK ^3.11.1** (para o app mobile)
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

### 2. App Mobile (Flutter)

```bash
# Navegue para a pasta do app mobile
cd ia_photo_booth_flutter

# Instale as dependências
flutter pub get

# Inicie um emulador ou conecte um dispositivo físico
# No Windows, você pode usar o script:
# iniciar-emulador.bat

# Execute o app
flutter run
```

**Comandos úteis:**
- `flutter run` - Executa o app em modo debug
- `flutter build apk` - Gera APK para Android
- `flutter build ios` - Gera build para iOS
- `flutter test` - Executa os testes

## 🔧 Configuração

### Backend - Variáveis de Ambiente

Crie um arquivo `.env` na pasta `ia-photo-booth-back/`:

```env
OPENAI_API_KEY=sk-sua-chave-aqui
OPENAI_MODEL=gpt-image-1
```

### Mobile - Configuração da API

Atualize a URL da API em `ia_photo_booth_flutter/lib/config.dart` se necessário:

```dart
const String apiBaseUrl = 'http://10.0.2.2:8000'; // Android emulator
// const String apiBaseUrl = 'http://localhost:8000'; // iOS simulator
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

### Mobile (Flutter)

| Pacote | Uso |
|--------|-----|
| http | Requisições HTTP |
| http_parser | Parsing de respostas HTTP |
| image_picker | Seleção de imagens da galeria/câmera |
| share_plus | Compartilhamento de imagens |
| path_provider | Acesso ao sistema de arquivos |
| permission_handler | Gerenciamento de permissões |

## 🎨 Features

### Telas e Widgets (Flutter)
- `SplashScreen` - Tela de carregamento inicial
- `HomeScreen` - Tela principal do app
- `ActionButtons` - Botões de ação (editar, reset, etc)
- `AppHeader` - Cabeçalho do app
- `ConfigFormCard` - Formulário de configuração
- `ImageUploadCard` - Seleção e upload de imagens
- `ResultCard` - Exibição do resultado da IA
- `ShareButtons` - Botões de compartilhamento
- `ProcessingOverlay` - Overlay de processamento
- `FullscreenImageViewer` - Visualizador de imagem em tela cheia

### API Backend
- Suporte a CORS para requisições do app mobile
- Validação de imagens
- Integração com OpenAI Images API
- Tratamento de erros robusto
- Respostas em JSON

## 🧪 Testes

### Mobile (Flutter)

```bash
cd ia_photo_booth_flutter

# Executar testes
flutter test
```

## 🐛 Troubleshooting

### Erro de conexão ao instalar dependências (pip)
Se receber erro de conexão ao fazer `pip install`, verifique:
- Se está conectado à internet
- Se precisa de proxy (corporate networks)
- Tente: `pip install --index-url https://pypi.org/simple/ -r requirements.txt`

### App não conecta ao backend (Android Emulator)
No emulador Android, `localhost` aponta para o próprio dispositivo. Use:
- `http://10.0.2.2:8000` para acessar o host da máquina no emulador Android

### Chave da OpenAI não reconhecida
- Verifique se o arquivo `.env` está no diretório correto
- Confirme que a chave é válida no painel da OpenAI
- Reinicie o servidor após adicionar a chave

## 📚 Documentação Adicional

- [Backend - README](./ia-photo-booth-back/README.md)
- [Mobile - README](./ia_photo_booth_flutter/README.md)
- [FastAPI Docs](https://fastapi.tiangolo.com/)
- [Flutter Docs](https://docs.flutter.dev/)
- [OpenAI API Docs](https://platform.openai.com/docs/api-reference/images)

## 👨‍💻 Desenvolvimento

### Contribuindo

1. Crie uma branch para sua feature (`git checkout -b feature/AmazingFeature`)
2. Commit suas mudanças (`git commit -m 'Add some AmazingFeature'`)
3. Push para a branch (`git push origin feature/AmazingFeature`)
4. Abra um Pull Request

### Code Style

- **Backend**: Siga as convenções Python (PEP 8)
- **Mobile**: Siga as convenções Dart/Flutter (`flutter analyze`)

## 📝 Licença

Este projeto é de código aberto. Veja o arquivo `LICENSE` para mais detalhes.

## 🤝 Suporte

Se encontrar problemas ou tiver sugestões, abra uma issue no repositório.

---

**Última atualização:** Maio 2026
