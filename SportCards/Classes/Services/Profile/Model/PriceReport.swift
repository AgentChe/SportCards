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

extension PriceReport: Decodable {
    enum CodingKeys: String, CodingKey {
        case today
        case week
        case twoWeek = "14_days"
        case month
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.today = try container.decode([PriceReport.Item].self, forKey: .today)
        self.week = try container.decode([PriceReport.Item].self, forKey: .week)
        self.twoWeek = try container.decode([PriceReport.Item].self, forKey: .twoWeek)
        self.month = try container.decode([PriceReport.Item].self, forKey: .month)
    }
}

extension PriceReport.Item: Decodable {
    enum CodingKeys: String, CodingKey {
        case dateTime = "datetime"
        case price
        case priceRaw = "price_raw"
        case diffPercent = "diff_percent"
    }
}
