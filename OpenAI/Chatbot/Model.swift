//
//  Model.swift
//  OpenAI
//
//  Created by Ingo Boehme on 14.12.22.
//

import Foundation

extension ChatBotView {
    public enum ModelError: Error {
        case modelError
    }
    
    class Model {
        
        func send(message: String, completionHandler: @escaping (Result<String, Error>) -> Void) {
            let requestStructure = ChatBotRequest(model: "text-davinci-003", prompt: message)
            
            OpenAI.chatBot.fetchData(with: requestStructure, convertTo: ChatbotResult.self) { result in
                
                switch result {
                case .success(let chatBotResult):
                    for statement in chatBotResult.choices {
                        completionHandler(.success(statement.text))
                    }
                case .failure(let error):
                    completionHandler(.failure(error))
                }
            }
        }
    }
}
