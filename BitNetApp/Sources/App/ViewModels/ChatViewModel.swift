import Foundation
import Combine
import SwiftUI

/// ViewModel principal que gerencia o estado do chat e comunicação com o modelo BitNet
@MainActor
class ChatViewModel: ObservableObject {
    // MARK: - Published Properties
    @Published var conversations: [Conversation] = []
    @Published var currentConversation: Conversation?
    @Published var searchText: String = ""
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    @Published var showSidebar: Bool = true

    // MARK: - Private Properties
    private let bitnetService: BitNetService
    private let storageService: StorageService
    private var cancellables = Set<AnyCancellable>()

    // MARK: - Computed Properties
    var filteredConversations: [Conversation] {
        if searchText.isEmpty {
            return conversations.sorted { $0.updatedAt > $1.updatedAt }
        } else {
            return conversations.filter { conversation in
                conversation.title.localizedCaseInsensitiveContains(searchText) ||
                conversation.messages.contains { message in
                    message.content.localizedCaseInsensitiveContains(searchText)
                }
            }.sorted { $0.updatedAt > $1.updatedAt }
        }
    }

    // MARK: - Initialization
    init(
        bitnetService: BitNetService = .shared,
        storageService: StorageService = .shared
    ) {
        self.bitnetService = bitnetService
        self.storageService = storageService
        loadConversations()
    }

    // MARK: - Public Methods

    /// Cria uma nova conversa
    func createNewConversation() {
        let newConversation = Conversation()
        conversations.append(newConversation)
        currentConversation = newConversation
        saveConversations()
    }

    /// Seleciona uma conversa existente
    func selectConversation(_ conversation: Conversation) {
        currentConversation = conversation
    }

    /// Deleta uma conversa
    func deleteConversation(_ conversation: Conversation) {
        conversations.removeAll { $0.id == conversation.id }
        if currentConversation?.id == conversation.id {
            currentConversation = conversations.first
        }
        saveConversations()
    }

    /// Envia uma mensagem e recebe resposta do modelo
    func sendMessage(_ content: String) async {
        guard !content.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return }

        // Cria conversa se não existir
        if currentConversation == nil {
            createNewConversation()
        }

        guard var conversation = currentConversation else { return }

        // Adiciona mensagem do usuário
        let userMessage = Message(content: content, isUser: true)
        conversation.addMessage(userMessage)
        updateConversation(conversation)

        isLoading = true
        errorMessage = nil

        do {
            // Cria mensagem de IA em streaming
            let aiMessage = Message(content: "", isUser: false, isStreaming: true)
            conversation.addMessage(aiMessage)
            updateConversation(conversation)

            // Obtém resposta do modelo BitNet com streaming
            let response = try await bitnetService.generateResponse(
                for: content,
                conversationHistory: conversation.messages.dropLast()
            )

            // Atualiza mensagem com resposta completa
            if var updatedConversation = currentConversation,
               let lastIndex = updatedConversation.messages.lastIndex(where: { !$0.isUser }) {
                updatedConversation.messages[lastIndex] = Message(
                    id: aiMessage.id,
                    content: response,
                    isUser: false,
                    isStreaming: false
                )
                updateConversation(updatedConversation)
            }

        } catch {
            errorMessage = "Erro ao gerar resposta: \(error.localizedDescription)"
            // Remove mensagem de streaming em caso de erro
            if var updatedConversation = currentConversation {
                updatedConversation.messages.removeAll { $0.isStreaming }
                updateConversation(updatedConversation)
            }
        }

        isLoading = false
    }

    /// Limpa as mensagens da conversa atual
    func clearCurrentConversation() {
        guard var conversation = currentConversation else { return }
        conversation.clearMessages()
        updateConversation(conversation)
    }

    // MARK: - Private Methods

    private func updateConversation(_ conversation: Conversation) {
        if let index = conversations.firstIndex(where: { $0.id == conversation.id }) {
            conversations[index] = conversation
        }
        currentConversation = conversation
        saveConversations()
    }

    private func loadConversations() {
        conversations = storageService.loadConversations()
        if conversations.isEmpty {
            createNewConversation()
        } else {
            currentConversation = conversations.first
        }
    }

    private func saveConversations() {
        storageService.saveConversations(conversations)
    }
}

// MARK: - Preview Mock
extension ChatViewModel {
    static var preview: ChatViewModel {
        let viewModel = ChatViewModel()
        viewModel.conversations = Conversation.samples
        viewModel.currentConversation = Conversation.sample
        return viewModel
    }
}
