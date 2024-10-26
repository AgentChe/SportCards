//
//  CardDiscoverResponse.swift
//  SportCards
//
//  Created by Vitaliy Zagorodnov on 21.10.2024.
//

import Foundation

struct CardDiscoverResponse {
    let items: [CardDiscover]
    let pagination: Pagination
}

struct Pagination: Decodable {
    let current: Int
    let next: Int
    let total: Int
}

extension CardDiscoverResponse: Decodable {
    enum CodingKeys: CodingKey {
        case items
        case pagination
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.items = (try? container.decode([CardDiscover].self, forKey: .items)) ?? []
        self.pagination = try container.decode(Pagination.self, forKey: .pagination)
    }
}


extension Pagination {
    var isEnd: Bool { current >= total }
}
