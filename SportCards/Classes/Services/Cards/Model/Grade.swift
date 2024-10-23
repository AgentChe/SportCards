//
//  Grade.swift
//  SportCards
//
//  Created by Vitaliy Zagorodnov on 17.10.2024.
//

import Foundation

struct Grade {
    let alias: String
    let name: String
}

extension Grade: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(alias)
    }
}

extension Grade {
    init?(from json: [String: Any]) {
        guard
            let alias = json["alias"] as? String,
            let name = json["name"] as? String
        else { return nil }
        
        self.alias = alias
        self.name = name
    }
    
    static func map(response: Any) -> [Grade] {
        guard
            let json = response as? [String: Any],
            let body = json["body"] as? [[String: Any]]
        else { return [] }
        
        return body.compactMap { Grade(from: $0) }
    }
}

extension Grade: Codable {}
