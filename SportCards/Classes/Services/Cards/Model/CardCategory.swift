//
//  CardCategory.swift
//  SportCards
//
//  Created by Vitaliy Zagorodnov on 03.10.2024.
//

import Foundation

struct CardCategory: Hashable {
    let alias: String
    let name: String
}

extension CardCategory {
    init?(from json: [String: Any]) {
        guard
            let alias = json["alias"] as? String,
            let name = json["name"] as? String
        else { return nil }
        
        self.alias = alias
        self.name = name
    }
    
    static func map(response: Any) -> [CardCategory] {
        guard
            let json = response as? [String: Any],
            let body = json["body"] as? [[String: Any]]
        else { return [] }
        
        return body.compactMap { CardCategory(from: $0) }
    }
}

extension CardCategory: Codable {}
