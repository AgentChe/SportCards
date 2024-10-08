//
//  ProfileCollectionCards.swift
//  SportCards
//
//  Created by Vitaliy Zagorodnov on 08.10.2024.
//

import Foundation

struct ProfileCollectionCards: Hashable {
    let totalPrice: String
    let totalPriceRaw: Double
    let total: Int
    let items: [CardDiscover]
}

extension ProfileCollectionCards {
    init?(from response: Any) {
        guard
            let json = response as? [String: Any],
            let body = json["body"] as? [String: Any]
        else { return nil }
        
        guard
            let totalPrice = body["total_price"] as? String,
            let totalPriceRaw = body["total_price_raw"] as? Double,
            let total = body["total"] as? Int
        else { return nil }
        
        self.totalPrice = totalPrice
        self.totalPriceRaw = totalPriceRaw
        self.total = total
        self.items = (body["items"] as? [[String: Any]]).flatMap { $0.compactMap { CardDiscover(from: $0) } } ?? []
    }
}
