# LocalIA - IA Local no iOS

<div align="center">

![iOS](https://img.shields.io/badge/iOS-26.4+-blue.svg)
![Swift](https://img.shields.io/badge/Swift-5.9-orange.svg)
![SwiftUI](https://img.shields.io/badge/SwiftUI-✓-green.svg)
![License](https://img.shields.io/badge/License-MIT-yellow.svg)

**Interface ChatGPT nativa para BitNet AI rodando 100% local no iPhone/iPad**

[Características](#características) • [Screenshots](#screenshots) • [Instalação](#instalação) • [Arquitetura](#arquitetura) • [Roadmap](#roadmap)

</div>

---

## 🌟 Características

- ✅ **Interface estilo ChatGPT** - Design moderno e familiar
- ✅ **100% Local** - IA roda diretamente no dispositivo, sem internet
- ✅ **BitNet 1-bit** - Tecnologia revolucionária da Microsoft para IA eficiente
- ✅ **Tema Escuro** - Design otimizado para OLED
- ✅ **Sidebar Inteligente** - Gerenciamento de conversas
- ✅ **Busca Avançada** - Encontre conversas pelo conteúdo
- ✅ **Persistência** - Todas as conversas são salvas automaticamente
- ✅ **Otimizado para Apple Silicon** - Preparado para M-series e A-series

## 📱 Interface

### Layout Principal

```
┌─────────────────────────────────────────────┐
│  Sidebar (35%)     │    Chat (65%)          │
│                    │                         │
│  [Nova Conversa]   │  ┌─ Título da Conversa │
│  [🔍 Buscar...]    │  │                      │
│                    │  │  ┌──────────────┐   │
│  ● Conversa 1      │  │  │ Mensagem AI  │   │
│    Preview...      │  │  └──────────────┘   │
│    há 2 min        │  │      ┌──────────┐   │
│                    │  │      │ User Msg │   │
│  ○ Conversa 2      │  │      └──────────┘   │
│    Preview...      │  │                      │
│    ontem           │  └──────────────────────│
│                    │  [Digite mensagem...] 🔵│
└─────────────────────────────────────────────┘
```

### Cores do Design System

| Elemento | Cor | Hex |
|----------|-----|-----|
| Fundo Principal | Preto | `#000000` |
| Sidebar | Cinza Escuro | `#1C1C1E` |
| Mensagem Usuário | Cinza Claro | `#E5E5EA` |
| Mensagem IA | Cinza Escuro | `#3C3C3C` |
| Elementos UI | Cinza Médio | `#2C2C2E` |

## 🏗 Arquitetura

### Estrutura de Pastas

```
LocalIA/
├── Models/                  # 📦 Modelos de dados
│   ├── Message.swift       # Mensagem individual
│   └── Conversation.swift  # Conversa completa
│
├── Views/                   # 🎨 Interface do usuário
│   ├── ContentView.swift   # Container principal
│   ├── ChatView.swift      # Tela do chat
│   ├── Sidebar.swift       # Gerenciador de conversas
│   └── Components/
│       ├── MessageBubble.swift    # Balão de mensagem
│       ├── InputBar.swift         # Barra de input
│       └── ConversationRow.swift  # Item da lista
│
├── ViewModels/              # 🧠 Lógica de negócio
│   └── ChatViewModel.swift # ViewModel principal
│
└── Services/                # ⚙️ Serviços
    ├── BitNetService.swift    # Engine BitNet
    └── StorageService.swift   # Persistência
```

### Padrão MVVM

- **Models**: Estruturas de dados puras (Message, Conversation)
- **Views**: SwiftUI views reativas
- **ViewModels**: Lógica de negócio e estado (@MainActor)
- **Services**: Integrações externas (BitNet, Storage)

## 🚀 Instalação

### Requisitos

- Xcode 15.0+
- iOS 16.0+ (iPhone/iPad)
- macOS 13.0+ (para desenvolvimento)

### Passo a Passo

1. **Clone o repositório**
   ```bash
   cd /Users/andremachado/Documents/Trabalho/Apps/LocalIA/App
   ```

2. **Abra no Xcode**
   ```bash
   open LocalIA.xcodeproj
   ```

3. **Build & Run**
   - Selecione um simulador ou dispositivo
   - Pressione `Cmd + R`

## 📐 Componentes Principais

### ChatView
Interface principal do chat com scroll automático e estados vazios.

**Features:**
- Lista de mensagens com LazyVStack
- Auto-scroll para última mensagem
- Input bar fixo na parte inferior
- Toolbar com opções

### Sidebar
Gerenciador de conversas com busca em tempo real.

**Features:**
- Lista de conversas ordenada por data
- Busca por título ou conteúdo
- Criar nova conversa
- Deletar conversas (com confirmação)

### MessageBubble
Balão de mensagem com design responsivo.

**Features:**
- Alinhamento dinâmico (usuário: direita, IA: esquerda)
- Cores distintas por remetente
- Indicador de streaming
- Timestamp

### InputBar
Barra de input multi-linha com botão de enviar.

**Features:**
- TextField expansível (1-6 linhas)
- Botão de enviar com estados
- Indicador de loading
- Submit com Enter

## 💾 Persistência

### StorageService

```swift
// Salva conversas automaticamente
storageService.saveConversations(conversations)

// Carrega ao iniciar
let saved = storageService.loadConversations()

// Exportar para backup
let url = storageService.exportConversations(conversations)
```

**Estratégia:**
- Arquivo JSON principal
- Backup em UserDefaults
- Auto-save em cada mudança

## 🤖 BitNet Integration

### BitNetService

```swift
// Gerar resposta
let response = try await bitnetService.generateResponse(
    for: prompt,
    conversationHistory: messages
)

// Streaming (futuro)
for try await token in bitnetService.generateStreamingResponse(...) {
    print(token)
}
```

**Status Atual:**
- ✅ API definida
- ✅ Simulação funcionando
- ⏳ Bridge C++ pendente
- ⏳ Modelo .gguf pendente

## 🗺 Roadmap

### Fase 1: Interface ✅ CONCLUÍDO
- [x] ChatView com mensagens
- [x] Sidebar com conversas
- [x] Busca de conversas
- [x] Persistência de dados
- [x] Tema escuro

### Fase 2: BitNet Integration 🔄 EM PROGRESSO
- [ ] Bridge C++/Swift
- [ ] Carregar modelo .gguf
- [ ] Inferência real
- [ ] Streaming de respostas
- [ ] Otimização Metal

### Fase 3: Features Avançadas 📋 PLANEJADO
- [ ] Markdown nas mensagens
- [ ] Code highlighting
- [ ] Exportar conversas
- [ ] Configurações do modelo
- [ ] Multimodal (imagens)
- [ ] iCloud sync
- [ ] Widget

### Fase 4: Performance 📋 PLANEJADO
- [ ] Otimização Apple Silicon
- [ ] Cache de embeddings
- [ ] Quantização dinâmica
- [ ] Batching de requests

## 🔧 Desenvolvimento

### Executar Testes
```bash
xcodebuild test -project LocalIA.xcodeproj -scheme LocalIA
```

### Gerar Preview
```bash
# Abra qualquer arquivo .swift e use Canvas
Cmd + Option + Enter
```

### Code Style
- Documentação em português
- Comentários MARK para organização
- SwiftUI best practices
- Actor para concorrência

## 📄 Licença

MIT License - Veja [LICENSE](LICENSE) para detalhes.

## 🙏 Agradecimentos

- **Microsoft Research** - BitNet architecture
- **Apple** - SwiftUI framework
- **Comunidade** - Open source models

## 📧 Contato

André Machado - [@andremachado](https://github.com/andremachado)

---

<div align="center">

**Desenvolvido com ❤️ usando Claude Code**

[⬆ Voltar ao topo](#localia---ia-local-no-ios)

</div>
