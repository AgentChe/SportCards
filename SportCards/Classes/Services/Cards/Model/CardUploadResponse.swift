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
    let grades: [String]
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
        self.grades = try container.decode([String].self, forKey: .grades)
    }
}
