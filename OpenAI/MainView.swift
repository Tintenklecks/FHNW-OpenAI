//
//  MainView.swift
//  OpenAI
//
//  Created by Ingo Boehme on 14.12.22.
//

import SwiftUI

// MARK: - MainView

struct MainView: View {
    @EnvironmentObject var appState: AppState

    var body: some View {
        TabView(selection: $appState.selectedTab) {
            AIImageView()
                .environmentObject(appState)
                .tabItem {
                    Label("AI Image", systemImage: "photo")
                }
                .tag(0)
            ChatBotView()
                // .environmentObject(appState)
                .tabItem {
                    Label("Chatbot", systemImage: "bubble.left.and.exclamationmark.bubble.right.fill")
                }
                .tag(1)
        }
    }
//    var body: some View {
//        TabView {
//            AIImageView()
//                .environmentObject(appState)
//                .tabItem {
//                    Label("AI Image", systemImage: "photo")
//                }
//                .tag(0)
//            ChatBotView()
//               // .environmentObject(appState)
//                .tabItem {
//                    Label("Chatbot", systemImage: "bubble.left.and.exclamationmark.bubble.right.fill")
//                }
//                .tag(1)
//        }
//    }
}

// MARK: - MainView_Previews

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
