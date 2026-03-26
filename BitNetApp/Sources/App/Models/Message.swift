import Foundation
import SwiftUI

/// Representa uma mensagem individual no chat
struct Message: Identifiable, Codable, Equatable {
    let id: UUID
    let content: String
    let isUser: Bool
    let timestamp: Date
    var isStreaming: Bool = false

    init(id: UUID = UUID(), content: String, isUser: Bool, timestamp: Date = Date(), isStreaming: Bool = false) {
        self.id = id
        self.content = content
        self.isUser = isUser
        self.timestamp = timestamp
        self.isStreaming = isStreaming
    }

    static func == (lhs: Message, rhs: Message) -> Bool {
        lhs.id == rhs.id
    }
}

// MARK: - Message Extensions
extension Message {
    /// Retorna a cor de fundo do balão baseado no remetente
    var bubbleColor: Color {
        isUser ? Color(hex: "E5E5EA") : Color(hex: "3C3C3C")
    }

    /// Retorna a cor do texto baseado no remetente
    var textColor: Color {
        isUser ? .black : .white
    }

    /// Retorna o alinhamento da mensagem
    var alignment: HorizontalAlignment {
        isUser ? .trailing : .leading
    }
}

// MARK: - Color Extension for Hex
extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}
