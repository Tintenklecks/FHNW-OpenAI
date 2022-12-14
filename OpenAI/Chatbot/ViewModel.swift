//
//  ViewModel.swift
//  OpenAI
//
//  Created by Ingo Boehme on 14.12.22.
//

import Foundation

struct Message: Identifiable {
    let id = UUID()
    let timestamp = Date()
    let isAI: Bool
    let text: String
}

extension ChatBotView {
    class ViewModel: ObservableObject {
        @Published var messages : [Message] = []
        
        var model = Model()
        
        func sendMessage(text: String) {
            
            self.messages.append(Message(isAI: false, text: text))
            
            model.send(message: text) { result in
                
                switch result {
                case .success(let answer):
                    DispatchQueue.main.async {
                        
                        self.messages.append(Message(isAI: true, text: answer.trimmingCharacters(in: .whitespacesAndNewlines)))
                    }
                case .failure(let error):
                    print("\(error.localizedDescription)")
                }
            }
        }
    }
}
