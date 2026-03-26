import Foundation
import SwiftUI

/// Representa uma conversa completa com múltiplas mensagens
struct Conversation: Identifiable, Codable, Equatable {
    let id: UUID
    var title: String
    var messages: [Message]
    let createdAt: Date
    var updatedAt: Date

    init(
        id: UUID = UUID(),
        title: String = "Nova Conversa",
        messages: [Message] = [],
        createdAt: Date = Date(),
        updatedAt: Date = Date()
    ) {
        self.id = id
        self.title = title
        self.messages = messages
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }

    static func == (lhs: Conversation, rhs: Conversation) -> Bool {
        lhs.id == rhs.id
    }
}

// MARK: - Conversation Extensions
extension Conversation {
    /// Retorna um preview da última mensagem
    var lastMessagePreview: String {
        guard let lastMessage = messages.last else {
            return "Sem mensagens"
        }
        let preview = lastMessage.content.prefix(50)
        return preview.count < lastMessage.content.count ? "\(preview)..." : String(preview)
    }

    /// Retorna a data formatada da última atualização
    var formattedDate: String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .abbreviated
        return formatter.localizedString(for: updatedAt, relativeTo: Date())
    }

    /// Adiciona uma nova mensagem à conversa
    mutating func addMessage(_ message: Message) {
        messages.append(message)
        updatedAt = Date()

        // Atualiza o título se for a primeira mensagem do usuário
        if messages.filter({ $0.isUser }).count == 1 {
            updateTitle(from: message.content)
        }
    }

    /// Atualiza o título baseado no conteúdo da primeira mensagem
    private mutating func updateTitle(from content: String) {
        let words = content.split(separator: " ").prefix(6)
        title = words.isEmpty ? "Nova Conversa" : words.joined(separator: " ")
        if content.split(separator: " ").count > 6 {
            title += "..."
        }
    }

    /// Remove todas as mensagens
    mutating func clearMessages() {
        messages.removeAll()
        updatedAt = Date()
    }
}

// MARK: - Sample Data
extension Conversation {
    static let sample = Conversation(
        title: "Conversa de exemplo",
        messages: [
            Message(content: "Olá! Como você pode me ajudar?", isUser: true),
            Message(content: "Olá! Sou a BitNet AI, uma IA de 1-bit otimizada para dispositivos móveis. Posso ajudá-lo com diversas tarefas como responder perguntas, fornecer informações e muito mais!", isUser: false),
            Message(content: "Que interessante! Você é rápida?", isUser: true),
            Message(content: "Sim! Graças à arquitetura de 1-bit, consigo processar informações muito rapidamente, mesmo em dispositivos com recursos limitados como smartphones.", isUser: false)
        ]
    )

    static let samples: [Conversation] = [
        sample,
        Conversation(
            title: "Perguntas sobre programação",
            messages: [
                Message(content: "Como funciona o Swift?", isUser: true),
                Message(content: "Swift é uma linguagem de programação moderna e poderosa...", isUser: false)
            ]
        ),
        Conversation(
            title: "Dúvidas gerais",
            messages: [
                Message(content: "O que é inteligência artificial?", isUser: true)
            ]
        )
    ]
}
