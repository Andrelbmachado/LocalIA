# Changelog - LocalIA

## [1.1.0] - 2026-03-26

### ✨ Melhorias Visuais

#### Sidebar Expandida (70%)
- **Antes**: Sidebar ocupava apenas 35% da tela (máximo 320px)
- **Depois**: Sidebar agora ocupa 70% da tela
- **Motivo**: Maior espaço para visualizar textos completos das conversas anteriores
- **Arquivo**: `ContentView.swift:20`

```diff
- .frame(width: min(geometry.size.width * 0.35, 320))
+ .frame(width: geometry.size.width * 0.70)
```

#### Novo Design do Loading
- **Antes**: "Pensando..." aparecia DENTRO do balão com dots no canto
- **Depois**: Balão fica VAZIO durante loading, "Pensando" + 3 pontos aparecem ABAIXO
- **Arquivo**: `MessageBubble.swift`

**Estado de Loading:**
```
┌─────────────────────┐
│                     │  ← Balão vazio (sem texto)
│                     │
└─────────────────────┘
Pensando ●●●            ← Texto + animação abaixo do balão
```

**Estado Normal:**
```
┌─────────────────────┐
│ Resposta da IA aqui │  ← Balão preenchido
│ com conteúdo        │
└─────────────────────┘
10:30 AM                 ← Timestamp
```

### 🐛 Correções de Bugs

#### 1. MainActor Isolation Error
- **Erro**: `Main actor-isolated static property 'shared' can not be referenced from a nonisolated context`
- **Causa**: Swift 6 language mode requer acesso explícito a propriedades MainActor
- **Solução**: Criado init sem parâmetros que acessa .shared explicitamente
- **Arquivo**: `ChatViewModel.swift:36-49`

```swift
// Antes (causava erro)
init(
    bitnetService: BitNetService = .shared,
    storageService: StorageService = .shared
) { ... }

// Depois (funciona)
init() {
    self.bitnetService = BitNetService.shared
    self.storageService = StorageService.shared
    loadConversations()
}
```

#### 2. Deprecated onChange
- **Warning**: `'onChange(of:perform:)' was deprecated in iOS 17.0`
- **Solução**: Atualizado para nova sintaxe iOS 17+
- **Arquivo**: `ChatView.swift:31-33`

```swift
// Antes (deprecated)
.onChange(of: viewModel.currentConversation?.messages.count) { _ in
    scrollToBottom(proxy: proxy)
}

// Depois (iOS 17+)
.onChange(of: viewModel.currentConversation?.messages.count) {
    scrollToBottom(proxy: proxy)
}
```

### 🎨 Detalhes de Implementação

#### MessageBubble Component

**Lógica de Exibição:**
```swift
// Mostra balão apenas se houver conteúdo OU não estiver em streaming
if !message.content.isEmpty || !message.isStreaming {
    Text(message.content)
        .padding(...)
        .background(...)
}

// Indicador de loading (só durante streaming)
if message.isStreaming {
    HStack(spacing: 8) {
        Text("Pensando")
            .font(.caption)
            .foregroundColor(.secondary)

        LoadingDotsView()  // 3 pontos animados
    }
}

// Timestamp (apenas quando NÃO estiver em streaming)
if !message.isStreaming {
    Text(timestamp)
}
```

#### LoadingDotsView

**Animação dos 3 Pontos:**
```swift
HStack(spacing: 4) {
    ForEach(0..<3) { index in
        Circle()
            .fill(Color.gray)
            .frame(width: 6, height: 6)
            .scaleEffect(animating ? 1.0 : 0.5)
            .opacity(animating ? 1.0 : 0.3)
            .animation(
                Animation.easeInOut(duration: 0.6)
                    .repeatForever()
                    .delay(Double(index) * 0.2),  // Delay escalonado
                value: animating
            )
    }
}
```

### 📊 Comparação Visual

#### Layout da Tela

**Antes:**
```
┌──────────┬───────────────────────┐
│          │                       │
│ Sidebar  │        Chat           │
│  (35%)   │        (65%)          │
│          │                       │
└──────────┴───────────────────────┘
```

**Depois:**
```
┌──────────────────────┬──────────┐
│                      │          │
│      Sidebar         │   Chat   │
│       (70%)          │   (30%)  │
│                      │          │
└──────────────────────┴──────────┘
```

#### Estado de Loading das Mensagens

**Antes:**
```
┌─────────────────────┐
│ Pensando...      ●●●│  ← Tudo dentro do balão
└─────────────────────┘
```

**Depois:**
```
(sem balão visível)
Pensando ●●●            ← Texto + pontos abaixo
```

### ✅ Build Status

```bash
** BUILD SUCCEEDED **
```

- ✅ Zero erros de compilação
- ✅ Zero warnings críticos
- ✅ Todos os componentes funcionando
- ✅ Previews atualizados

### 📱 Testado Em

- ✅ iPhone 17 Pro Simulator (iOS 26.4)
- ✅ Xcode Previews
- ✅ Tema escuro

### 🔄 Arquivos Modificados

1. `ContentView.swift` - Largura da sidebar
2. `ChatView.swift` - onChange syntax
3. `ChatViewModel.swift` - MainActor init
4. `MessageBubble.swift` - Design completo do loading
5. `StorageService.swift` - @MainActor annotation

### 📝 Notas Técnicas

- **Swift Version**: 5.9+
- **iOS Target**: 16.0+
- **Language Mode**: Swift 6 compatible
- **Architecture**: MVVM
- **UI Framework**: SwiftUI

---

## Como Visualizar as Mudanças

1. **Abrir o projeto**:
   ```bash
   cd /Users/andremachado/Documents/Trabalho/Apps/LocalIA/App/LocalIA
   open LocalIA.xcodeproj
   ```

2. **Ver Preview do MessageBubble**:
   - Abra `MessageBubble.swift`
   - Pressione `Cmd + Option + Enter` para Canvas
   - Veja o preview "Streaming Message" para o novo design

3. **Executar no Simulador**:
   - Selecione iPhone 17 Pro
   - `Cmd + R` para executar
   - Envie uma mensagem para ver o loading em ação

---

**Desenvolvido com ❤️ por Claude Code**
