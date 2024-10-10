//
//  ProfileCollectionRequest.swift
//  SportCards
//
//  Created by Vitaliy Zagorodnov on 08.10.2024.
//

import Alamofire

private extension CollectionTab {
    var mockName: String {
        switch self {
        case .scanned:
            "ScannedResponse"
        case .wishList:
            "CollectResponse"
        }
    }
}

struct ProfileCollectionRequest: APIRequestBody {
    let anonymousId: String
    let internalId: String
    let filters: Filters
    let page: Int?
    let type: CollectionTab
    
    var url: String {
        return URL(fileURLWithPath: Bundle.main.path(forResource: type.mockName, ofType: "json")!).absoluteString
//        GlobalDefinitions.domain + "/api/v1/profile/cards"
    }
    
    var method: HTTPMethod {
        .post
    }
    
    var headers: HTTPHeaders? {
        [
            "Access-Token": GlobalDefinitions.apiKey
        ]
    }
    
    var parameters: Parameters? {
        var params: [String: Any] = [
            "anonymous_id": anonymousId,
            "internal_id": internalId
        ]
        
        params["page"] = page
        params["sort"] = filters.price?.rawValue
        
        var filtersParams: [String: Any] = [:]
        if !filters.category.isEmpty {
            filtersParams["category"] = filters.category.map(\.alias)
        }
        
        if !filters.grade.isEmpty {
            filtersParams["grade"] = filters.grade.map(\.rawValue)
        }
        
        filtersParams["type"] = type.rawValue
        
        if !filtersParams.isEmpty {
            params["filter"] = filtersParams
        }
        
        return params
    }
}
