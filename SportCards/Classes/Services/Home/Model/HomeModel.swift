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

extension HomeModel {
    init?(from response: Any) {
        guard
            let json = response as? [String: Any],
            let body = json["body"] as? [String: Any]
        else { return nil }
        
        personalScanner = (body["personal_scanner"] as? [String: Any]).flatMap { PriceReport(from: $0) }
        recommendation = (body["recommendation"] as? [[String: Any]]).flatMap { $0.compactMap { CardDiscover(from: $0) } } ?? []
        
        other = (body["other"] as? [[String: Any]]).flatMap { $0.compactMap { OtherCardModel(from: $0)}} ?? []
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
