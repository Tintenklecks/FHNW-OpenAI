//
//  OpenAIApp.swift
//  OpenAI
//
//  Created by Ingo Boehme on 11.12.22.
//

import SwiftUI

@main
struct OpenAIApp: App {
    @StateObject var appState = AppState()
    init() {
        
    }
    var body: some Scene {
        WindowGroup {
            MainView()
                .environmentObject(appState)
        }
    }
}
