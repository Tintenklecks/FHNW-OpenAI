//
//  ViewModel.swift
//  OpenAI
//
//  Created by Ingo Boehme on 11.12.22.
//

import Foundation

extension AIImageView {
    class ViewModel: ObservableObject {
        @Published var imageUrl: URL?
        @Published var isBusy = false
        @Published var numberOfPictures: Int = 1
        @Published var size: OpenAIImageSizes = .small
        @Published var prompt: String = "students admiring their IT teacher"
        
        @Published var rejectionReason = ""
        @Published var rejected = true
        
        @Published var errorMessage = ""
        @Published var showError = false
        @Published var checkDone = false
        
        @Published var promptState: [String: Double] = [:]
        
        var model = Model()
        
        private func setBusy(state: Bool) {
            DispatchQueue.main.async {
                self.isBusy = state
            }
        }
        
        // Checkes on OpenAI if the prompt is valid
        func checkPrompt() {
            setBusy(state: true)
            rejected = true
            model.prompt = prompt
            model.checkModeration { [self] result in
                DispatchQueue.main.async {
                    switch result {
                    case .success():
                        self.rejectionReason = self.model.ratingText
                        self.checkDone = true
                    case .failure(let error):
                        self.errorMessage = "Error: \(error.localizedDescription)"
                        self.showError = true
                    }
                    self.rejected = self.rejectionReason != ""
                    self.isBusy = false
                }
            }
        }

        func renderImage() {
            setBusy(state: true)
            model.prompt = prompt
            model.size = size
            model.numberOfPicturesToCreate = numberOfPictures
            
            model.fetch { result in
                DispatchQueue.main.async {
                    switch result {
                    case .success():
                        self.imageUrl = self.model.imageUrl
                        self.isBusy = false
                    case .failure(let error):
                        self.errorMessage = error.localizedDescription
                        self.showError = true
                    }
                }
            }
        }
    }
}
