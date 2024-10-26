//
//  CardOtherModel.swift
//  SportCards
//
//  Created by Vitaliy Zagorodnov on 03.10.2024.
//

import Foundation

struct OtherCardModel: Hashable {
    let cardId: String
    let category: CardCategory
    let image: URL?
    let name: String
    let grade: String
}

extension OtherCardModel: Identifiable {
    var id: String { cardId + grade }
}

extension OtherCardModel: Decodable {
    enum CodingKeys: String, CodingKey {
        case cardId = "id"
        case category
        case image
        case name
        case grade
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.cardId = try container.decode(String.self, forKey: .cardId)
        self.category = try container.decode(CardCategory.self, forKey: .category)
        self.image = try container.decodeIfPresent(URL.self, forKey: .image)
        self.name = try container.decode(String.self, forKey: .name)
        self.grade = try container.decode(String.self, forKey: .grade)
    }
}
