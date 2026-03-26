import SwiftUI

/// Sidebar para gerenciamento de conversas
struct Sidebar: View {
    @ObservedObject var viewModel: ChatViewModel

    var body: some View {
        VStack(spacing: 0) {
            // Header com título e botão de nova conversa
            header

            // Barra de busca
            searchBar

            // Lista de conversas
            conversationList

            Spacer()
        }
        .background(Color(hex: "1C1C1E"))
    }

    // MARK: - Header
    private var header: some View {
        HStack {
            // Botão de fechar sidebar
            Button(action: {
                withAnimation {
                    viewModel.showSidebar = false
                }
            }) {
                Image(systemName: "xmark")
                    .font(.system(size: 16))
                    .foregroundColor(.gray)
                    .frame(width: 32, height: 32)
            }

            Text("Conversas")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.white)

            Spacer()

            Button(action: {
                viewModel.createNewConversation()
            }) {
                Image(systemName: "square.and.pencil")
                    .font(.system(size: 20))
                    .foregroundColor(.blue)
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 16)
    }

    // MARK: - Search Bar
    private var searchBar: some View {
        HStack(spacing: 8) {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.gray)
                .font(.system(size: 14))

            TextField("Buscar conversas...", text: $viewModel.searchText)
                .textFieldStyle(.plain)
                .foregroundColor(.white)
                .autocorrectionDisabled()

            if !viewModel.searchText.isEmpty {
                Button(action: {
                    viewModel.searchText = ""
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.gray)
                        .font(.system(size: 14))
                }
            }
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background(
            RoundedRectangle(cornerRadius: 10, style: .continuous)
                .fill(Color(hex: "2C2C2E"))
        )
        .padding(.horizontal, 16)
        .padding(.bottom, 12)
    }

    // MARK: - Conversation List
    private var conversationList: some View {
        ScrollView {
            LazyVStack(spacing: 4) {
                if viewModel.filteredConversations.isEmpty {
                    emptyStateView
                } else {
                    ForEach(viewModel.filteredConversations) { conversation in
                        ConversationRow(
                            conversation: conversation,
                            isSelected: viewModel.currentConversation?.id == conversation.id,
                            onSelect: {
                                viewModel.selectConversation(conversation)
                            },
                            onDelete: {
                                viewModel.deleteConversation(conversation)
                            }
                        )
                    }
                }
            }
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
        }
    }

    // MARK: - Empty State
    private var emptyStateView: some View {
        VStack(spacing: 16) {
            Image(systemName: viewModel.searchText.isEmpty ? "message" : "magnifyingglass")
                .font(.system(size: 40))
                .foregroundColor(.gray)

            Text(viewModel.searchText.isEmpty ? "Nenhuma conversa" : "Nenhum resultado")
                .font(.body)
                .foregroundColor(.gray)

            if !viewModel.searchText.isEmpty {
                Text("Tente buscar por outro termo")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.top, 60)
    }
}

// MARK: - Preview
#Preview {
    Sidebar(viewModel: .preview)
        .frame(width: 320)
        .preferredColorScheme(.dark)
}

#Preview("Empty") {
    let viewModel = ChatViewModel()
    viewModel.conversations = []
    return Sidebar(viewModel: viewModel)
        .frame(width: 320)
        .preferredColorScheme(.dark)
}

#Preview("With Search") {
    let viewModel = ChatViewModel.preview
    viewModel.searchText = "programação"
    return Sidebar(viewModel: viewModel)
        .frame(width: 320)
        .preferredColorScheme(.dark)
}
