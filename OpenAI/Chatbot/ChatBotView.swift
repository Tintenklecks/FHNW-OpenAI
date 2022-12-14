//
//  ChatBotView.swift
//  OpenAI
//
//  Created by Ingo Boehme on 14.12.22.
//

import SwiftUI

struct ChatBotView: View {
//    @EnvironmentObject var appState: AppState

    @StateObject var viewModel = ViewModel()
    @State private var text: String = ""
    var body: some View {
        ScrollView {
            LazyVStack(alignment: .leading) {
                ForEach(viewModel.messages) { message in
                    HStack {
                        if !message.isAI {
                            Spacer()
                        }
                        Text(message.text)
                            .background(message.isAI ? Color.blue : Color.green)
                        if message.isAI {
                            Spacer()
                        }
                    }
                }
            }
            
        }
    }
}

struct ChatBotView_Previews: PreviewProvider {
    static var viewModel = ChatBotView.ViewModel()
    static var previews: some View {
        ChatBotView()
            .onAppear {
                viewModel.messages.append(Message(isAI: false, text: "Hallo Bot"))
                viewModel.messages.append(Message(isAI: true, text: "Hallo Mensch"))
                
            }
    }
}
