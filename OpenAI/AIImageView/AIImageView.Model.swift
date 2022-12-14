//
//  Model.swift
//  OpenAI
//
//  Created by Ingo Boehme on 11.12.22.
//

import Foundation

extension AIImageView {
    class Model: ObservableObject {
        var imageUrl: URL?
        var rating: ModerationResult?
        var ratingText: String {
            var result = ""
            if let reasons = self.rating?.categories {
                if reasons.hate { result += "hate " }
                if reasons.hateThreatening { result += "hateThreatening " }
                if reasons.selfHarm { result += "selfHarm " }
                if reasons.sexual { result += "sexual " }
                if reasons.violence { result += "violence " }
                if reasons.sexualMinors { result += "sexual-minors " }
                if reasons.violenceGraphic { result += "violenceGraphic " }
            }
            return result

        }
        
        var prompt: String = "students admiring their IT teacher"
        var numberOfPicturesToCreate = 1
        var size: OpenAIImageSizes = .small

        func checkModeration(completionHandler: @escaping (Result<Void, Error>) -> Void) {
            let parameter = ModerationRequest(input: prompt)
            OpenAI.moderation.fetchData(
                with: parameter,
                convertTo: Moderation.self) { result in
                switch result {
                case .success(let moderation):
                    self.rating = moderation.results.first
                    completionHandler(.success(()))
                case .failure(let error):
                    print("\(error.localizedDescription)")
                    completionHandler(.failure(error))
                }
            }
        }

        func fetch(completionHandler: @escaping (Result<Void, Error>) -> Void) {
            let parameter = ImageRequest(
                prompt: self.prompt,
                n: self.numberOfPicturesToCreate,
                size: self.size.asParameter)

            OpenAI.generateImage.fetchData(
                with: parameter,
                convertTo: ResultImage.self) { result in
                    switch result {
                    case .success(let resultImage):
                        if let imageUrl = resultImage.data.first?.url,
                           let url = URL(string: imageUrl)
                        {
                            self.imageUrl = url
                        }
                        completionHandler(.success(()))
                    case .failure(let error):
                        print("\(error.localizedDescription)")
                        completionHandler(.failure(error))
                    }
            }
        }
    }
}
