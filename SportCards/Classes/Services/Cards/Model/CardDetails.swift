//
//  CardDetails.swift
//  SportCards
//
//  Created by Vitaliy Zagorodnov on 23.10.2024.
//

import Foundation

struct CardDetails {
    let cardId: String
    let imageURL: URL?
    let title: String
    let subtilte: String
    let grade: String
    let currentPrice: String
    let currentPriceRaw: Double
    let collectionName: String?
    let details: [Detail]
    let parallels: [CardDiscover]
    let sales: Sale?
    let isFavorite: Bool
    
    struct Detail: Hashable, Decodable {
        let name: String
        let value: String
    }
    
    struct Sale {
        let date: Date
        let currentPrice: String
        let currentPriceRaw: Double
        let numberSales: Int?
        let lowPrice: String?
        let lowPriceRaw: Double?
        let hightPrice: String?
        let hightPriceRaw: Double?
        let report: PriceReport?
    }
}

extension CardDetails.Sale: Decodable {
    enum CodingKeys: String, CodingKey {
        case date = "datetime"
        case currentPrice = "current_price"
        case currentPriceRaw = "current_price_raw"
        case numberSales = "number_sales"
        case lowPrice = "low_price"
        case lowPriceRaw = "low_price_raw"
        case hightPrice = "high_price"
        case hightPriceRaw = "hight_price_raw"
        case report = "report"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let time = try container.decode(TimeInterval.self, forKey: .date)
        self.date = .init(timeIntervalSince1970: time)
        self.currentPrice = try container.decode(String.self, forKey: .currentPrice)
        self.currentPriceRaw = try container.decode(Double.self, forKey: .currentPriceRaw)
        self.numberSales = try container.decodeIfPresent(Int.self, forKey: .numberSales)
        self.lowPrice = try container.decodeIfPresent(String.self, forKey: .lowPrice)
        self.lowPriceRaw = try container.decodeIfPresent(Double.self, forKey: .lowPriceRaw)
        self.hightPrice = try container.decodeIfPresent(String.self, forKey: .hightPrice)
        self.hightPriceRaw = try container.decodeIfPresent(Double.self, forKey: .hightPriceRaw)
        self.report = try? container.decodeIfPresent(PriceReport.self, forKey: .report)
    }
}

extension CardDetails: Decodable {
    enum CodingKeys: String, CodingKey {
        case id
        case imageURL = "image"
        case title
        case subtilte
        case grade
        case currentPrice = "current_price"
        case currentPriceRaw = "current_price_raw"
        case collectionName = "collection_name"
        case detail
        case parallels
        case sales
        case isFavorite = "is_favorite"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.cardId = try container.decode(String.self, forKey: .id)
        self.imageURL = try container.decodeIfPresent(URL.self, forKey: .imageURL)
        self.title = try container.decode(String.self, forKey: .title)
        self.subtilte = (try? container.decode(String.self, forKey: .subtilte)) ?? ""
        self.grade = try container.decode(String.self, forKey: .grade)
        self.currentPrice = try container.decode(String.self, forKey: .currentPrice)
        self.currentPriceRaw = try container.decode(Double.self, forKey: .currentPriceRaw)
        self.collectionName = try container.decodeIfPresent(String.self, forKey: .collectionName)
        self.details = try container.decode([CardDetails.Detail].self, forKey: .detail)
        self.parallels = try container.decode([CardDiscover].self, forKey: .parallels)
        self.sales = try container.decodeIfPresent(CardDetails.Sale.self, forKey: .sales)
        self.isFavorite = try container.decode(Bool.self, forKey: .isFavorite)
    }
}
