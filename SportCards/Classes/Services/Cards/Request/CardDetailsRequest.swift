//
//  CardDetailsRequest.swift
//  SportCards
//
//  Created by Vitaliy Zagorodnov on 23.10.2024.
//

import Alamofire

struct CardDetailsRequest: APIRequestBody {
    let anonymousId: String
    let internalId: String
    let id: String
    let grade: String
    
    var url: String {
        GlobalDefinitions.domain + "/api/v1/cards/detail"
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
            "id": id,
            "grade": grade
        ]
    }
}
