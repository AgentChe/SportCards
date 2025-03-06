//
//  CardUploadResponse.swift
//  SportCards
//
//  Created by Vitaliy Zagorodnov on 23.10.2024.
//

import Foundation

struct CardUploadResponse {
    let cardId: String
    let imageURL: URL?
    let title: String
    let subtitle: String?
    let grades: [String: [String]]
}

extension CardUploadResponse: Decodable {
    enum CodingKeys: String, CodingKey {
        case id
        case imageURL = "image"
        case title
        case subtitle
        case grades
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.cardId = try container.decode(String.self, forKey: .id)
        self.imageURL = try container.decodeIfPresent(URL.self, forKey: .imageURL)
        self.title = (try? container.decode(String.self, forKey: .title)) ?? ""
        self.subtitle = (try? container.decodeIfPresent(String.self, forKey: .subtitle)) ?? ""
        
        let items = try container.decode([String].self, forKey: .grades)
        
        self.grades = items.reduce(into: [String: [String]]()) { partialResult, grade in
            let args = grade.split(separator: " ", maxSplits: 2)
            guard let first = args.first else { return }
            let grade = String(first)
            var values = partialResult[grade] ?? []
            
            if let level = args[safe: 1], !level.isEmpty {
                values.append(String(level))
                partialResult[grade] = values
            } else {
                partialResult[grade] = values
            }
        }
    }
}

extension Collection {
    subscript (safe index: Index) -> Element? {
        guard indices.contains(index) else { return nil }
        return self[index]
    }
}
