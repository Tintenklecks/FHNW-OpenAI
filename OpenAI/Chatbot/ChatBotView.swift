//
//  ChatBotView.swift
//  OpenAI
//
//  Created by Ingo Boehme on 14.12.22.
//

import SwiftUI

// MARK: - ChatBotView

struct ChatBotView: View {
//    @EnvironmentObject var appState: AppState

    @StateObject var viewModel = ViewModel()
    @State private var text: String = ""
    var body: some View {
        VStack {
            ScrollViewReader { value in
                ScrollView {
                    LazyVStack(alignment: .leading) {
                        ForEach(viewModel.messages) {
                            ChatBubbleView(message: $0)
                                .onAppear {
                                    value.scrollTo(viewModel.messages.last?.id, anchor: .center)
                                }
                        }
                    }
                }
            }

            Spacer()
            Divider()
            HStack {
                TextField("enter message", text: $text)
                    .textFieldStyle(.roundedBorder)
                    .onSubmit {
                        viewModel.sendMessage(text: text)
                        text = ""
                    }

                Button {
                    if text != "" {
                        viewModel.sendMessage(text: text)
                        text = ""
                    }
                } label: {
                    Image(systemName: "paperplane.fill")
                }
            }
            .padding()
        }
    }
}

// MARK: - ChatBubbleView

struct ChatBubbleView: View {
    let message: Message

    var body: some View {
        HStack {
            if !message.isAI {
                Spacer()
            }
            Text(message.text)
                .padding(.horizontal)
                .padding(.vertical, 6)
                .background(
                    Color(message.isAI ? "ChatAI" : "ChatHuman")
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                        .clipped()
                    
                )
                .padding(6)
                .padding(.leading, message.isAI ? 10 : 56)
                .padding(.trailing, message.isAI ? 56 : 10)
            if message.isAI {
                Spacer()
            }
        }
    }
}

// MARK: - ChatBubble_Previews

struct ChatBubble_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            ChatBubbleView(
                message:
                Message(isAI: false, text: "Hallo Bot")
            )
            ChatBubbleView(
                message:
                Message(isAI: true, text: "Hallo Mensch")
            )
            ChatBubbleView(
                message:
                Message(isAI: false, text: "Sagt ich zum Augenblick: `Verweile doch, Du bist so schön`, dann magst Du mich in Ketten schlagen, dann möge ich zugrunde geh'n.")
            )

        }
    }
}

// MARK: - ChatBotView_Previews

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
