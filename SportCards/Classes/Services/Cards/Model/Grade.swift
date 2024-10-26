//
//  Grade.swift
//  SportCards
//
//  Created by Vitaliy Zagorodnov on 17.10.2024.
//

import Foundation

struct Grade: Codable {
    let alias: String
    let name: String
}

extension Grade: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(alias)
    }
}
