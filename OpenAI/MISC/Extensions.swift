//
//  Extensions.swift
//  OpenAI
//
//  Created by Ingo Boehme on 12.12.22.
//

import Foundation

extension JSONDecoder {
    static func testForDecodableError<T>(_ type: T.Type, from data: Data) where T: Decodable {
        let decoder = JSONDecoder()
        do {
            let modelData = try decoder.decode(T.self, from: data)
            print(modelData)
        } catch let DecodingError.dataCorrupted(context) {
            print(context)
        } catch let DecodingError.keyNotFound(key, context) {
            print("Key '\(key)' not found:", context.debugDescription)
            print("codingPath:", context.codingPath)
        } catch let DecodingError.valueNotFound(value, context) {
            print("Value '\(value)' not found:", context.debugDescription)
            print("codingPath:", context.codingPath)
        } catch let DecodingError.typeMismatch(type, context) {
            print("Type '\(type)' mismatch:", context.debugDescription)
            print("codingPath:", context.codingPath)
        } catch {
            print(error.localizedDescription)
        }
    }
}
