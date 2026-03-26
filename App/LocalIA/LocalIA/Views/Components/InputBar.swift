import SwiftUI

/// Barra de input para digitar e enviar mensagens
struct InputBar: View {
    @Binding var messageText: String
    let isLoading: Bool
    let onSend: () -> Void
    let onStop: () -> Void

    @FocusState private var isFocused: Bool

    var body: some View {
        HStack(alignment: .bottom, spacing: 12) {
            // Campo de texto
            TextField("Digite uma mensagem...", text: $messageText, axis: .vertical)
                .textFieldStyle(.plain)
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .background(
                    RoundedRectangle(cornerRadius: 24, style: .continuous)
                        .fill(Color(hex: "2C2C2E"))
                )
                .foregroundColor(.white)
                .focused($isFocused)
                .lineLimit(1...6)
                .onSubmit {
                    if !isLoading {
                        onSend()
                    }
                }

            // Botão de enviar ou parar
            Button(action: {
                if isLoading {
                    onStop()
                } else {
                    onSend()
                }
            }) {
                ZStack {
                    if isLoading {
                        // Botão de parar (X vermelho)
                        Image(systemName: "stop.circle.fill")
                            .font(.system(size: 32))
                            .foregroundColor(.red)
                    } else {
                        // Botão de enviar
                        Image(systemName: "arrow.up.circle.fill")
                            .font(.system(size: 32))
                            .foregroundColor(canSend ? .blue : .gray)
                    }
                }
            }
            .disabled(!canSend && !isLoading)
            .frame(width: 36, height: 36)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(Color.black)
    }

    private var canSend: Bool {
        !messageText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
}

// MARK: - Preview
#Preview("Empty") {
    VStack {
        Spacer()
        InputBar(
            messageText: .constant(""),
            isLoading: false,
            onSend: {},
            onStop: {}
        )
    }
    .background(Color.black)
    .preferredColorScheme(.dark)
}

#Preview("With Text") {
    VStack {
        Spacer()
        InputBar(
            messageText: .constant("Olá! Como você pode me ajudar?"),
            isLoading: false,
            onSend: {},
            onStop: {}
        )
    }
    .background(Color.black)
    .preferredColorScheme(.dark)
}

#Preview("Loading") {
    VStack {
        Spacer()
        InputBar(
            messageText: .constant(""),
            isLoading: true,
            onSend: {},
            onStop: {}
        )
    }
    .background(Color.black)
    .preferredColorScheme(.dark)
}
