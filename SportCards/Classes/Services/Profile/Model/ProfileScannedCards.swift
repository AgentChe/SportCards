//
//  ProfileScannedCards.swift
//  SportCards
//
//  Created by Vitaliy Zagorodnov on 24.10.2024.
//

import Foundation

struct ProfileScannedCards {
    let totalPrice: String
    let totalPriceRaw: Double
    let total: Int
    let items: [CardDiscover]
    let pagination: Pagination
}

extension ProfileScannedCards: Decodable {
    enum CodingKeys: String, CodingKey {
        case totalPrice = "total_price"
        case totalPriceRaw = "total_price_raw"
        case total
        case items
        case pagination
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.totalPrice = try container.decode(String.self, forKey: .totalPrice)
        self.totalPriceRaw = try container.decode(Double.self, forKey: .totalPriceRaw)
        self.total = try container.decode(Int.self, forKey: .total)
        self.items = (try? container.decode([CardDiscover].self, forKey: .items)) ?? []
        self.pagination = try container.decode(Pagination.self, forKey: .pagination)
    }
}
