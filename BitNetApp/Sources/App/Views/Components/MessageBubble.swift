import SwiftUI

/// Componente de balão de mensagem individual
struct MessageBubble: View {
    let message: Message

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            if message.isUser {
                Spacer(minLength: 60)
            }

            VStack(alignment: message.isUser ? .trailing : .leading, spacing: 4) {
                // Conteúdo da mensagem
                Text(message.content.isEmpty && message.isStreaming ? "Pensando..." : message.content)
                    .font(.system(.body, design: .default))
                    .foregroundColor(message.textColor)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)
                    .background(
                        RoundedRectangle(cornerRadius: 20, style: .continuous)
                            .fill(message.bubbleColor)
                    )
                    .overlay(
                        Group {
                            if message.isStreaming {
                                LoadingDotsView()
                                    .padding(.trailing, 8)
                                    .padding(.bottom, 8)
                            }
                        },
                        alignment: .bottomTrailing
                    )

                // Timestamp
                Text(message.timestamp.formatted(date: .omitted, time: .shortened))
                    .font(.caption2)
                    .foregroundColor(.secondary)
                    .padding(.horizontal, 8)
            }

            if !message.isUser {
                Spacer(minLength: 60)
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 4)
    }
}

/// Indicador de carregamento animado
struct LoadingDotsView: View {
    @State private var animating = false

    var body: some View {
        HStack(spacing: 4) {
            ForEach(0..<3) { index in
                Circle()
                    .fill(Color.white.opacity(0.6))
                    .frame(width: 6, height: 6)
                    .scaleEffect(animating ? 1.0 : 0.5)
                    .animation(
                        Animation.easeInOut(duration: 0.6)
                            .repeatForever()
                            .delay(Double(index) * 0.2),
                        value: animating
                    )
            }
        }
        .onAppear {
            animating = true
        }
    }
}

// MARK: - Preview
#Preview("User Message") {
    MessageBubble(
        message: Message(
            content: "Olá! Como você pode me ajudar?",
            isUser: true
        )
    )
    .preferredColorScheme(.dark)
}

#Preview("AI Message") {
    MessageBubble(
        message: Message(
            content: "Olá! Sou a BitNet AI, posso ajudá-lo com diversas tarefas. Como posso ser útil hoje?",
            isUser: false
        )
    )
    .preferredColorScheme(.dark)
}

#Preview("Streaming Message") {
    MessageBubble(
        message: Message(
            content: "",
            isUser: false,
            isStreaming: true
        )
    )
    .preferredColorScheme(.dark)
}
