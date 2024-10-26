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

extension OtherCardModel: Decodable {}
