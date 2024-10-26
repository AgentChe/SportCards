//
//  ProfileCollectionCards.swift
//  SportCards
//
//  Created by Vitaliy Zagorodnov on 08.10.2024.
//

import Foundation

struct ProfileCollectionCards {
    let items: [CardDiscover]
    let pagination: Pagination
}

extension ProfileCollectionCards: Decodable {
    enum CodingKeys: String, CodingKey {
        case items
        case pagination
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.items = (try? container.decode([CardDiscover].self, forKey: .items)) ?? []
        self.pagination = try container.decode(Pagination.self, forKey: .pagination)
    }
}
