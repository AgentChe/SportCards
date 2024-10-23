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

extension CardDiscoverResponse {
    struct Pagination {
        let current: Int
        let next: Int
        let total: Int
    }
}

extension CardDiscoverResponse.Pagination {
    var isEnd: Bool { current >= total }
}

extension CardDiscoverResponse.Pagination {
    init?(from json: [String: Any]) {
        guard
            let current = json["current"] as? Int,
            let next = json["next"] as? Int,
            let total = json["total"] as? Int
        else { return nil }
        
        self.current = current
        self.next = next
        self.total = total
    }
}

extension CardDiscoverResponse {
    init?(from response: Any) {
        guard
            let json = response as? [String: Any],
            let body = json["body"] as? [String: Any],
            let paginationJson = body["pagination"] as? [String: Any],
            let pagination = Pagination(from: paginationJson)
        else { return nil }
        
        items = (body["items"] as? [[String: Any]]).flatMap { $0.compactMap { CardDiscover(from: $0)} } ?? []
        self.pagination = pagination
    }
}
