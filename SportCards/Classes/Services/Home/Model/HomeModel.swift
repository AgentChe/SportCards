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

//extension HomeModel: Decodable {
//    enum ContainerKeys: String, CodingKey {
//        case body
//    }
//    
//    enum CodingKeys: String, CodingKey {
//        case personalScanner = "personal_scanner"
//        case recommendation
//        case other
//    }
//    
//    init(from decoder: Decoder) throws {
//        let root = try decoder.container(keyedBy: ContainerKeys.self)
//        
//        let container = try root.nestedContainer(keyedBy: CodingKeys.self, forKey: .body)
//        
//        personalScanner = try? container.decode(PriceReport.self, forKey: .personalScanner)
//        let recommendationObjects = try? container.decode([OptionalObject<CardDiscover>].self, forKey: .recommendation)
//        let otherObjects = try? container.decode([OptionalObject<OtherCardModel>].self, forKey: .other)
//        recommendation = recommendationObjects?.compactMap(\.value) ?? []
//        other = otherObjects?.compactMap(\.value) ?? []
//    }
//}
//
//
//struct OptionalObject<T: Decodable>: Decodable {
//    public let value: T?
//
//    public init(from decoder: Decoder) throws {
//        do {
//            let container = try decoder.singleValueContainer()
//            self.value = try container.decode(T.self)
//        } catch {
//            self.value = nil
//        }
//    }
//}

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
