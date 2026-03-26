//
//  ContentView.swift
//  LocalIA
//
//  Created by André Machado on 25/03/26.
//

import SwiftUI

/// View principal que contém Sidebar e ChatView
struct ContentView: View {
    @StateObject private var viewModel = ChatViewModel()

    var body: some View {
        GeometryReader { geometry in
            HStack(spacing: 0) {
                // Sidebar
                if viewModel.showSidebar {
                    Sidebar(viewModel: viewModel)
                        .frame(width: geometry.size.width * 0.70)
                        .transition(.move(edge: .leading))
                }

                // Divider
                if viewModel.showSidebar {
                    Divider()
                        .background(Color(hex: "2C2C2E"))
                }

                // Chat principal
                NavigationStack {
                    ChatView(viewModel: viewModel)
                        .toolbar(.hidden, for: .tabBar)
                }
                .frame(maxWidth: .infinity)
            }
        }
        .preferredColorScheme(.dark)
        .onAppear {
            // Configuração inicial se necessário
        }
    }
}

// MARK: - Preview
#Preview {
    ContentView()
}

#Preview("With Sidebar Hidden") {
    ContentView()
}
