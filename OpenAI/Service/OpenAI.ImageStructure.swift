//
//  OpenAIImageStructure.swift
//  OpenAI
//
//  Created by Ingo Boehme on 11.12.22.
//

import Foundation

// MARK: - REQUEST STRUCTURES -
struct ChatBotRequest: Codable {
    let model: String
    let prompt: String
    var max_tokens = 2048
    var temperature = 1.0
}

// MARK: - REQUEST STRUCTURES Moderation -
struct ModerationRequest: Codable {
    let input: String
}


// MARK: - REQUEST STRUCTURE IMAGE -

struct ImageRequest: Codable {
    let prompt: String
    let n: Int
    let size: String
}

// MARK: - RESULT STRUCTURES -
struct ResultImage: Codable {
    let created: Int
    let data: [ImageEntry]
}

// MARK: - ImageEntry
struct ImageEntry: Codable {
    let url: String
}

// MARK: - Moderation
struct Moderation: Codable {
    let id: String
    let model: String
    let results: [ModerationResult]
}

// MARK: - Result
struct ModerationResult: Codable {
    let categories: ModerationCategories
    let categoryScores: ModerationCategoryScores
    let flagged: Bool

    enum CodingKeys: String, CodingKey {
        case categories = "categories"
        case categoryScores = "category_scores"
        case flagged = "flagged"
    }

}

// MARK: - Categories
struct ModerationCategories: Codable {
    let hate: Bool
    let hateThreatening: Bool
    let selfHarm: Bool
    let sexual: Bool
    let sexualMinors: Bool
    let violence: Bool
    let violenceGraphic: Bool
    
    enum CodingKeys: String, CodingKey {
        case hate = "hate"
        case hateThreatening = "hate/threatening"
        case selfHarm = "self-harm"
        case sexual = "sexual"
        case sexualMinors = "sexual/minors"
        case violence = "violence"
        case violenceGraphic = "violence/graphic"
    }

}

// MARK: - CategoryScores
struct ModerationCategoryScores: Codable {
    let hate: Double
    let hateThreatening: Double
    let selfHarm: Double
    let sexual: Double
    let sexualMinors: Double
    let violence: Double
    let violenceGraphic: Double
    enum CodingKeys: String, CodingKey {
        case hate = "hate"
        case hateThreatening = "hate/threatening"
        case selfHarm = "self-harm"
        case sexual = "sexual"
        case sexualMinors = "sexual/minors"
        case violence = "violence"
        case violenceGraphic = "violence/graphic"
    }

}


// MARK: - ChatbotResult
struct ChatbotResult: Codable {
    let id: String
    let object: String
    let created: Int
    let model: String
    let choices: [Choice]
}

// MARK: - Choice
struct Choice: Codable {
    let text: String
}

