# LocalIA - Estrutura do Projeto

## 📁 Arquitetura

O projeto segue o padrão **MVVM (Model-View-ViewModel)** com separação clara de responsabilidades:

```
LocalIA/
├── Models/              # Modelos de dados
│   ├── Message.swift    # Modelo de mensagem individual
│   └── Conversation.swift # Modelo de conversa
│
├── Views/               # Interface do usuário
│   ├── ContentView.swift    # View principal (container)
│   ├── ChatView.swift       # View do chat
│   ├── Sidebar.swift        # Sidebar de conversas
│   └── Components/          # Componentes reutilizáveis
│       ├── MessageBubble.swift      # Balão de mensagem
│       ├── InputBar.swift           # Barra de input inferior
│       └── ConversationRow.swift    # Linha de conversa na sidebar
│
├── ViewModels/          # Lógica de negócio
│   └── ChatViewModel.swift # ViewModel principal do chat
│
├── Services/            # Serviços e integrações
│   ├── BitNetService.swift     # Integração com BitNet AI
│   └── StorageService.swift    # Persistência de dados
│
└── LocalIAApp.swift    # Ponto de entrada do app
```

## 🎨 Design System

### Cores
- **Fundo Principal**: Preto (`#000000`)
- **Fundo Sidebar**: Cinza escuro (`#1C1C1E`)
- **Mensagem do Usuário**: Cinza claro (`#E5E5EA`)
- **Mensagem da IA**: Cinza escuro (`#3C3C3C`)
- **Elementos secundários**: (`#2C2C2E`)

### Layout
- **Mensagem do usuário**: Alinhada à direita, cor cinza claro
- **Mensagem da IA**: Alinhada à esquerda, cor cinza escuro
- **Sidebar**: 35% da largura da tela (máximo 320px)
- **Chat**: Ocupa o restante do espaço

## 🔧 Componentes Principais

### 1. ContentView
- Container principal que gerencia Sidebar e ChatView
- Controla visibilidade da sidebar
- Layout responsivo

### 2. ChatView
- Exibe lista de mensagens
- Input bar na parte inferior
- Scroll automático para última mensagem
- Estados vazios

### 3. Sidebar
- Lista de conversas
- Barra de busca
- Botão de nova conversa
- Gerenciamento de conversas (deletar, selecionar)

### 4. MessageBubble
- Exibe mensagem individual
- Suporte a streaming
- Indicador de loading
- Timestamp

### 5. InputBar
- Campo de texto multi-linha
- Botão de enviar
- Estado de loading
- Auto-submit com Enter

### 6. ConversationRow
- Preview da conversa
- Título e última mensagem
- Data relativa
- Menu de ações (deletar)

## 🚀 Funcionalidades

### ✅ Implementadas
- [x] Interface de chat estilo ChatGPT
- [x] Balões de mensagem (usuário: direita/claro, IA: esquerda/escuro)
- [x] Sidebar para gerenciamento de conversas
- [x] Busca de conversas por conteúdo
- [x] Criar nova conversa
- [x] Deletar conversas
- [x] Persistência de dados (JSON)
- [x] Tema escuro
- [x] Animações e transições
- [x] Preview das conversas
- [x] Estados vazios

### 🔄 Próximas Implementações
- [ ] Integração completa com BitNet C++
- [ ] Streaming de respostas em tempo real
- [ ] Suporte a markdown nas mensagens
- [ ] Exportar/Importar conversas
- [ ] Configurações do modelo
- [ ] Otimização para Apple Silicon
- [ ] Suporte a imagens (multimodal)
- [ ] Temas personalizáveis
- [ ] iCloud sync

## 🔌 Integração BitNet

O `BitNetService` atualmente usa respostas simuladas para demonstração. Para integração real:

1. **Bridge C++/Swift**: Criar bridge para chamar código C++ do BitNet
2. **Modelo**: Adicionar arquivo `.gguf` ao bundle do app
3. **Otimização**: Configurar para Apple Silicon (Metal/ANE)
4. **Streaming**: Implementar callback para streaming de tokens

## 📝 Notas de Desenvolvimento

### Persistência
- Usa JSON para armazenamento simples
- Backup em UserDefaults
- Suporte a exportação/importação

### Performance
- LazyVStack para lista de mensagens
- Scroll otimizado
- Componentes leves e reutilizáveis

### UX
- Animações suaves
- Feedback visual
- Estados de loading
- Confirmações para ações destrutivas

## 🎯 Padrões de Código

- ✅ Documentação em português
- ✅ Comentários MARK para organização
- ✅ SwiftUI best practices
- ✅ @MainActor para ViewModels
- ✅ Actor para serviços assíncronos
- ✅ Previews para todos os componentes
- ✅ Separação de concerns
- ✅ Código limpo e legível

## 🛠️ Build & Run

```bash
# Abrir projeto no Xcode
open LocalIA.xcodeproj

# Ou via linha de comando
xcodebuild -project LocalIA.xcodeproj -scheme LocalIA -sdk iphoneos
```

## 📱 Requisitos

- iOS 16.0+
- Xcode 15.0+
- Swift 5.9+
- SwiftUI

---

**Desenvolvido com ❤️ usando Claude Code**
