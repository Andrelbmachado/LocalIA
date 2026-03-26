import SwiftUI

/// Linha individual de conversa na sidebar
struct ConversationRow: View {
    let conversation: Conversation
    let isSelected: Bool
    let onSelect: () -> Void
    let onDelete: () -> Void

    @State private var showDeleteConfirmation = false

    var body: some View {
        Button(action: onSelect) {
            HStack(spacing: 12) {
                // Ícone da conversa
                Image(systemName: "message.fill")
                    .font(.system(size: 16))
                    .foregroundColor(isSelected ? .blue : .gray)
                    .frame(width: 24)

                // Conteúdo da conversa
                VStack(alignment: .leading, spacing: 4) {
                    // Título
                    Text(conversation.title)
                        .font(.system(.body, design: .default))
                        .fontWeight(isSelected ? .semibold : .regular)
                        .foregroundColor(isSelected ? .white : .gray)
                        .lineLimit(1)

                    // Preview da última mensagem
                    Text(conversation.lastMessagePreview)
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .lineLimit(1)

                    // Data
                    Text(conversation.formattedDate)
                        .font(.caption2)
                        .foregroundColor(.secondary)
                }

                Spacer()

                // Menu de ações
                Menu {
                    Button(role: .destructive, action: {
                        showDeleteConfirmation = true
                    }) {
                        Label("Deletar", systemImage: "trash")
                    }
                } label: {
                    Image(systemName: "ellipsis")
                        .font(.system(size: 14))
                        .foregroundColor(.gray)
                        .padding(8)
                }
                .buttonStyle(.plain)
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 10)
            .background(
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .fill(isSelected ? Color(hex: "2C2C2E") : Color.clear)
            )
        }
        .buttonStyle(.plain)
        .contextMenu {
            Button(role: .destructive, action: {
                showDeleteConfirmation = true
            }) {
                Label("Deletar", systemImage: "trash")
            }
        }
        .confirmationDialog(
            "Deletar conversa?",
            isPresented: $showDeleteConfirmation,
            titleVisibility: .visible
        ) {
            Button("Deletar", role: .destructive) {
                onDelete()
            }
            Button("Cancelar", role: .cancel) {}
        } message: {
            Text("Esta ação não pode ser desfeita.")
        }
    }
}

// MARK: - Preview
#Preview("Selected") {
    VStack(spacing: 8) {
        ConversationRow(
            conversation: Conversation.sample,
            isSelected: true,
            onSelect: {},
            onDelete: {}
        )
        .padding(.horizontal)
    }
    .background(Color.black)
    .preferredColorScheme(.dark)
}

#Preview("Not Selected") {
    VStack(spacing: 8) {
        ConversationRow(
            conversation: Conversation.sample,
            isSelected: false,
            onSelect: {},
            onDelete: {}
        )
        .padding(.horizontal)
    }
    .background(Color.black)
    .preferredColorScheme(.dark)
}

#Preview("Multiple") {
    ScrollView {
        VStack(spacing: 8) {
            ForEach(Conversation.samples) { conversation in
                ConversationRow(
                    conversation: conversation,
                    isSelected: conversation.id == Conversation.sample.id,
                    onSelect: {},
                    onDelete: {}
                )
            }
        }
        .padding()
    }
    .background(Color.black)
    .preferredColorScheme(.dark)
}
