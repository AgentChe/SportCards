//
//  HomeModel.swift
//  SportCards
//
//  Created by Vitaliy Zagorodnov on 30.09.2024.
//

import Foundation

struct HomeModel {
    let personalScanner: PriceReport?
    let recommendation: [CardDiscover]
    let other: [OtherCardModel]
}

extension HomeModel: Decodable {
    enum CodingKeys: String, CodingKey {
        case personalScanner = "personal_scanner"
        case recommendation
        case other
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.personalScanner = try? container.decodeIfPresent(PriceReport.self, forKey: .personalScanner)
        self.recommendation = try container.decode([CardDiscover].self, forKey: .recommendation)
        self.other = try container.decode([OtherCardModel].self, forKey: .other)
    }
}

extension Result {
    var success: Success? {
        switch self {
        case .success(let success):
            success
        case .failure:
            nil
        }
    }
    
    var error: Failure? {
        switch self {
        case .success:
            nil
        case .failure(let failure):
            failure
        }
    }
}
