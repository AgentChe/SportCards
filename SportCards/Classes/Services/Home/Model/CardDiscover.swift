//
//  CardDiscover.swift
//  SportCards
//
//  Created by Vitaliy Zagorodnov on 30.09.2024.
//

import Foundation

struct CardDiscover: Equatable, Hashable {
    let id: String
    let imageURL: URL?
    let title: String
    let subtitle: String
    let grade: Grade
    let currentPrice: String
    let currentPriceRaw: Double
    let collectionName: String?
}

extension CardDiscover {
    init?(from body: [String: Any]) {
        guard
            let id = body["id"] as? String,
            let title = body["title"] as? String,
            let subtitle = body["subtitle"] as? String,
            let grade = (body["grade"] as? String).flatMap({ Grade(rawValue: $0) }),
            let currentPrice = body["current_price"] as? String,
            let currentPriceRaw = body["current_price_raw"] as? Double
        else { return nil }
        
        self.id = id
        self.imageURL = (body["image"] as? String).flatMap { URL(string: $0) }
        self.title = title
        self.subtitle = subtitle
        self.grade = grade
        self.currentPrice = currentPrice
        self.currentPriceRaw = currentPriceRaw
        self.collectionName = body["collection_name"] as? String
    }
}

//extension CardDiscover: Decodable {
//    enum CodingKeys: String, CodingKey {
//        case id
//        case imageURL = "image"
//        case title
//        case subtitle
//        case grade
//        case currentPrice = "current_price"
//        case currentPriceRaw = "current_price_raw"
//        case collectionName = "collection_name"
//    }
//}
