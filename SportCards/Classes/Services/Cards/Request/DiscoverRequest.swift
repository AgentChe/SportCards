//
//  DiscoverRequest.swift
//  SportCards
//
//  Created by Vitaliy Zagorodnov on 04.10.2024.
//

import Alamofire

struct DiscoverRequest: APIRequestBody {
    let anonymousId: String
    let internalId: String
    let text: String
    let filters: Filters
    let page: Int
    
    var url: String {
        GlobalDefinitions.domain + "/api/v2/cards/discover"
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
            "internal_id": internalId,
            "page": page
        ]
        
        params["search"] = text
        
        if let price = filters.price?.rawValue {
            params["sort"] = ["price": price]
        }
        var filtersParams: [String: Any] = [:]
        
        filtersParams["category"] = filters.category.map(\.alias)
        filtersParams["grade"] = filters.gradeRequest
        
        if !filtersParams.isEmpty {
            params["filter"] = filtersParams
        }
        
        return params
    }
}
