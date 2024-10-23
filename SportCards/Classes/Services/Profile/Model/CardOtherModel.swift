//
//  CardOtherModel.swift
//  SportCards
//
//  Created by Vitaliy Zagorodnov on 03.10.2024.
//

import Foundation

struct OtherCardModel: Hashable {
    let category: CardCategory
    let image: URL?
    let name: String
    let grade: String
}

extension OtherCardModel {
    init?(from json: [String: Any]) {
        guard
            let categoryRaw = json["category"] as? [String: Any],
            let category = CardCategory(from: categoryRaw),
            let url = json["image"] as? String,
            let name = json["name"] as? String,
            let grade = json["grade"] as? String
        else { return nil }
        
        self.category = category
        self.image = URL(string: url)
        self.name = name
        self.grade = grade
    }
}
