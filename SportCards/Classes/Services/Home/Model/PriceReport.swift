//
//  PriceReport.swift
//  SportCards
//
//  Created by Vitaliy Zagorodnov on 30.09.2024.
//

import Foundation

struct PriceReport: Equatable, Hashable {
    let today: [Item]
    let week: [Item]
    let twoWeek: [Item]
    let month: [Item]
    
    struct Item: Equatable, Hashable {
        let dateTime: Date
        let price: String
        let priceRaw: Double
        let diffPercent: Double
    }
}

extension PriceReport {
    init?(from body: [String: Any]) {
        today = (body["today"] as? [[String: Any]]).flatMap { $0.compactMap { Item(from: $0) }} ?? []
        week = (body["week"] as? [[String: Any]]).flatMap { $0.compactMap { Item(from: $0) }} ?? []
        twoWeek = (body["14_days"] as? [[String: Any]]).flatMap { $0.compactMap { Item(from: $0) }} ?? []
        month = (body["month"] as? [[String: Any]]).flatMap { $0.compactMap { Item(from: $0) }} ?? []
    }
}

private extension PriceReport.Item {
    init?(from body: [String: Any]) {
        guard
            let dateTime = body["datetime"] as? TimeInterval,
            let price = body["price"] as? String,
            let priceRaw = body["price_raw"] as? Double,
            let diffPercent = body["diff_percent"] as? Double
        else { return nil }
        
        self.dateTime = .init(timeIntervalSince1970: dateTime)
        self.price = price
        self.priceRaw = priceRaw
        self.diffPercent = diffPercent
    }
}

//extension PriceReport: Decodable {
//    enum CodingKeys: String, CodingKey {
//        case today
//        case week
//        case twoWeek = "14_days"
//        case month
//    }
//}
//
//extension PriceReport.Item: Decodable {
//    enum CodingKeys: String, CodingKey {
//        case dateTime = "datetime"
//        case price
//        case priceRaw = "price_raw"
//        case diffPercent = "diff_percent"
//    }
//}
