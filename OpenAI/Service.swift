////
////  Service.swift
////  OpenAI
////
////  Created by Ingo Boehme on 11.12.22.
////
//
//import Foundation
//
//// MARK: - NetworkError
//
//// MARK: - NetworkService
//
//enum NetworkService {
//    static func post<T: Decodable>(
//        from url: URL,
//        header: [String: String] = [:],
//        body: Encodable? = nil,
//        convertTo type: T.Type,
//        completionHandler: @escaping (Result<T, NetworkError>) -> Void
//    ) {
//        var request = URLRequest(url: url)
//        request.httpMethod = "POST"
//        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
//        header.forEach { key, value in
//            request.setValue(value, forHTTPHeaderField: key)
//        }
//        if let body {
//            request.httpBody = try? JSONEncoder().encode(body)
//        }
//        
//        // execute request
//        URLSession.shared.dataTask(with: request) { data, _, error in
//            if let error {
//                print("Error: \(error.localizedDescription)")
//                completionHandler(.failure(.internet))
//                return
//            }
//            
//            guard let data else {
//                print("Error: No data available")
//                completionHandler(.failure(.internet))
//                return
//            }
//            
//            guard let decodedData = try? JSONDecoder().decode(type.self, from: data) else {
//                // zum Debugging
//                // JSONDecoder.testForDecodableError(type.self, from: data)
//                
//                completionHandler(.failure(.decoding))
//                return
//            }
//            
//            completionHandler(.success(decodedData))
//        }
//        .resume()
//
//
//// fetch data with publisher
////        URLSession.shared.dataTaskPublisher(for: request)
////            .tryMap { data, response in
////                guard let httpResponse = response as? HTTPURLResponse,
////                      httpResponse.statusCode == 200 else {
////                    throw NetworkError.internet
////                }
////                return data
//
////            }post<T: Decodable>(
////            .decode(type: type, decoder: JSONDecoder())
////            .receive(on: DispatchQueue.main)
////            .sink(receiveCompletion: { completion in
////                switch completion {
////                case .failure(let error):
////                    print(error)
////                case .finished:
////                    print("finished")
////                }
////            }, receiveValue: { value in
////                print(value)
////            })
////            .store(in: &cancellables)
//
//// fetch data mit async await
////        Task {
////            do {
////                let (data, _) = try await URLSession.shared.data(for: request)
////                let decodedData = try JSONDecoder().decode(type.self, from: data)
////                completionHandler(.success(decodedData))
////            } catch {
////                completionHandler(.failure(.internet))
////            }
////        }
//
//
//        
//        
//    }
//
//    static func load<T: Decodable>(
//        from url: URL,
//        convertTo type: T.Type,
//        onSuccess: @escaping (T) -> Void,
//        onError: @escaping (String) -> Void = { _ in }
//    ) {
//        URLSession.shared.dataTask(with: url) { data, _, error in
//
//            if let error {
//                onError("Error: \(error.localizedDescription)")
//                return
//            }
//
//            guard let data else {
//                onError("Error: No data available")
//                return
//            }
//
//            guard let decodedData = try? JSONDecoder().decode(type.self, from: data) else {
//                // zum Debugging
////                JSONDecoder.testForDecodableError(type.self, from: data)
//
//                onError("json couldnt be encoded")
//                return
//            }
//
//            onSuccess(decodedData)
//        }
//        .resume()
//    }
//}
