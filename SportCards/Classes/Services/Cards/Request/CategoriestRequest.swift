//
//  CategoriestRequest.swift
//  SportCards
//
//  Created by Vitaliy Zagorodnov on 03.10.2024.
//

import Alamofire

struct CategoriestRequest: APIRequestBody {
    let anonymousId: String
    let internalId: String
    
    var url: String {
        return URL(fileURLWithPath: Bundle.main.path(forResource: "CategoriesResponse", ofType: "json")!).absoluteString
//        GlobalDefinitions.domain + "/cards/categories"
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
        [
            "anonymous_id": anonymousId,
            "internal_id": internalId,
        ]
    }
}
