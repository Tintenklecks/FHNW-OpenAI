//
//  OpenAPIService.swift
//  OpenAI
//
//  Created by Ingo Boehme on 12.12.22.
//

import Foundation

// MARK: - NetworkError

enum NetworkError: Error {
    case decoding
    case internet
    case noData
    case httpError(Int)
    case misc(String)
}

// MARK: - OpenAIImageSizes

enum OpenAIImageSizes: Int, CaseIterable {
    case small = 256
    case medium = 512
    case large = 1024

    var asParameter: String { "\(self.rawValue)x\(self.rawValue)" }
    var width: CGFloat { CGFloat(self.rawValue) }
    var height: CGFloat { CGFloat(self.rawValue) }
}

// MARK: - OpenAI

enum OpenAI: String {
    case moderation = "https://api.openai.com/v1/moderations" // Checks if wording is acceptable
    case generateImage = "https://api.openai.com/v1/images/generations" // creates the image
    case chatBot = "https://api.openai.com/v1/completions" // Returns an answer on a text
    case getAllModels = "https://api.openai.com/v1/models" // Get all available models
    var url: URL {
        guard let url = URL(string: rawValue) else {
            fatalError("URL is defective")
        }
        return url
    }

    var method: String {
        switch self {
        case .getAllModels: return "GET"
        default: return "POST"
        }
    }

    var request: URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = self.method
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(Secret.apiKey)", forHTTPHeaderField: "Authorization")
        return request
    }

    func request(for queryData: Encodable?) -> URLRequest {
        var request = self.request
        if let queryData {
            request.httpBody = try? JSONEncoder().encode(queryData)
        }
        return request
    }

    func fetchData<S: Encodable, T: Decodable>(
        with parameter: S,
        convertTo type: T.Type,
        completionHandler: @escaping (Result<T, NetworkError>) -> Void)
    {
        let request = request(for: parameter)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let response = response as? HTTPURLResponse {
                if response.statusCode >= 300 {
                    completionHandler(.failure(.httpError(response.statusCode)))
                    return
                }
            }

            if let error {
                completionHandler(.failure(.misc(error.localizedDescription)))
                return
            }

            guard let data else {
                completionHandler(.failure(.noData))
                return
            }

            do {
                let result = try JSONDecoder().decode(T.self, from: data)
                completionHandler(.success(result))
            } catch {
                JSONDecoder.testForDecodableError(T.self, from: data)
                completionHandler(.failure(.misc(error.localizedDescription)))
            }
        }
        .resume()
    }
}
