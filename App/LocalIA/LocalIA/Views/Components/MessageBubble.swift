import SwiftUI

/// Componente de balão de mensagem individual
struct MessageBubble: View {
    let message: Message

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            if message.isUser {
                Spacer(minLength: 60)
            }

            VStack(alignment: message.isUser ? .trailing : .leading, spacing: 8) {
                // Balão de mensagem (vazio se estiver carregando)
                if !message.content.isEmpty || !message.isStreaming {
                    Text(message.content)
                        .font(.system(.body, design: .default))
                        .foregroundColor(message.textColor)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 12)
                        .background(
                            RoundedRectangle(cornerRadius: 20, style: .continuous)
                                .fill(message.bubbleColor)
                        )
                }

                // Indicador de "Pensando..." abaixo do balão (quando streaming)
                if message.isStreaming {
                    HStack(spacing: 8) {
                        Text("Pensando")
                            .font(.caption)
                            .foregroundColor(.secondary)

                        LoadingDotsView()
                    }
                    .padding(.horizontal, 8)
                }

                // Timestamp (apenas se não estiver em streaming)
                if !message.isStreaming {
                    Text(message.timestamp.formatted(date: .omitted, time: .shortened))
                        .font(.caption2)
                        .foregroundColor(.secondary)
                        .padding(.horizontal, 8)
                }
            }

            if !message.isUser {
                Spacer(minLength: 60)
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 4)
    }
}

/// Indicador de carregamento animado (3 pontos)
struct LoadingDotsView: View {
    @State private var animating = false

    var body: some View {
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
    VStack(spacing: 16) {
        MessageBubble(
            message: Message(
                content: "Olá! Como você pode me ajudar?",
                isUser: true
            )
        )
    }
    .background(Color.black)
    .preferredColorScheme(.dark)
}

#Preview("AI Message") {
    VStack(spacing: 16) {
        MessageBubble(
            message: Message(
                content: "Olá! Sou a BitNet AI, posso ajudá-lo com diversas tarefas. Como posso ser útil hoje?",
                isUser: false
            )
        )
    }
    .background(Color.black)
    .preferredColorScheme(.dark)
}

#Preview("Streaming Message") {
    VStack(spacing: 16) {
        MessageBubble(
            message: Message(
                content: "",
                isUser: false,
                isStreaming: true
            )
        )
    }
    .background(Color.black)
    .preferredColorScheme(.dark)
}

#Preview("Conversation") {
    ScrollView {
        VStack(spacing: 12) {
            MessageBubble(
                message: Message(
                    content: "Qual é a capital do Brasil?",
                    isUser: true
                )
            )

            MessageBubble(
                message: Message(
                    content: "A capital do Brasil é Brasília, localizada no Distrito Federal.",
                    isUser: false
                )
            )

            MessageBubble(
                message: Message(
                    content: "E quando foi fundada?",
                    isUser: true
                )
            )

            MessageBubble(
                message: Message(
                    content: "",
                    isUser: false,
                    isStreaming: true
                )
            )
        }
        .padding(.vertical, 16)
    }
    .background(Color.black)
    .preferredColorScheme(.dark)
}
