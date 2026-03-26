//
//  LocalIAApp.swift
//  LocalIA
//
//  Created by André Machado on 25/03/26.
//

import SwiftUI

@main
struct LocalIAApp: App {

    init() {
        // Configurações de aparência global
        configureAppearance()
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .preferredColorScheme(.dark)
        }
    }

    // MARK: - Private Methods

    private func configureAppearance() {
        // Configura a aparência da navegação
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor.black
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]

        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
        UINavigationBar.appearance().compactAppearance = appearance

        // Configura a aparência do toolbar
        let toolbarAppearance = UIToolbarAppearance()
        toolbarAppearance.configureWithOpaqueBackground()
        toolbarAppearance.backgroundColor = UIColor.black

        UIToolbar.appearance().standardAppearance = toolbarAppearance
        UIToolbar.appearance().scrollEdgeAppearance = toolbarAppearance

        // Configura cores do TextField
        UITextField.appearance().tintColor = .systemBlue
    }
}
