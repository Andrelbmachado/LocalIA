import SwiftUI

/// View principal do chat com lista de mensagens e barra de input
struct ChatView: View {
    @ObservedObject var viewModel: ChatViewModel
    @State private var messageText: String = ""
    @State private var scrollProxy: ScrollViewProxy?

    var body: some View {
        VStack(spacing: 0) {
            // Lista de mensagens
            ScrollViewReader { proxy in
                ScrollView {
                    LazyVStack(spacing: 12) {
                        if let conversation = viewModel.currentConversation {
                            ForEach(conversation.messages) { message in
                                MessageBubble(message: message)
                                    .id(message.id)
                            }
                        } else {
                            // Estado vazio
                            emptyStateView
                        }
                    }
                    .padding(.vertical, 16)
                }
                .background(Color.black)
                .onAppear {
                    scrollProxy = proxy
                }
                .onChange(of: viewModel.currentConversation?.messages.count) {
                    scrollToBottom(proxy: proxy)
                }
            }

            // Barra de input inferior
            InputBar(
                messageText: $messageText,
                isLoading: viewModel.isLoading,
                onSend: {
                    sendMessage()
                },
                onStop: {
                    viewModel.stopGeneration()
                }
            )
            .onTapGesture {
                // Fecha sidebar ao tocar no input
                if viewModel.showSidebar {
                    withAnimation {
                        viewModel.showSidebar = false
                    }
                }
            }
        }
        .navigationTitle(viewModel.currentConversation?.title ?? "Nova Conversa")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    withAnimation {
                        viewModel.showSidebar.toggle()
                    }
                }) {
                    Image(systemName: "sidebar.left")
                        .foregroundColor(.white)
                }
            }

            ToolbarItem(placement: .navigationBarTrailing) {
                Menu {
                    Button(action: {
                        viewModel.createNewConversation()
                    }) {
                        Label("Nova Conversa", systemImage: "plus.message")
                    }

                    Button(action: {
                        viewModel.clearCurrentConversation()
                    }) {
                        Label("Limpar Conversa", systemImage: "trash")
                    }
                } label: {
                    Image(systemName: "ellipsis.circle")
                        .foregroundColor(.white)
                }
            }
        }
    }

    // MARK: - Empty State
    private var emptyStateView: some View {
        VStack(spacing: 20) {
            Image(systemName: "message.fill")
                .font(.system(size: 60))
                .foregroundColor(.gray)

            Text("Inicie uma conversa")
                .font(.title2)
                .fontWeight(.semibold)
                .foregroundColor(.white)

            Text("Digite uma mensagem abaixo para começar")
                .font(.body)
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding()
    }

    // MARK: - Private Methods
    private func sendMessage() {
        let trimmedMessage = messageText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedMessage.isEmpty else { return }

        Task {
            await viewModel.sendMessage(trimmedMessage)
        }

        messageText = ""
    }

    private func scrollToBottom(proxy: ScrollViewProxy) {
        if let lastMessage = viewModel.currentConversation?.messages.last {
            withAnimation {
                proxy.scrollTo(lastMessage.id, anchor: .bottom)
            }
        }
    }
}

// MARK: - Preview
#Preview {
    NavigationStack {
        ChatView(viewModel: .preview)
            .preferredColorScheme(.dark)
    }
}
