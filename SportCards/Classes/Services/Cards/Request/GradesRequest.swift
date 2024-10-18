//
//  GradesRequest.swift
//  SportCards
//
//  Created by Vitaliy Zagorodnov on 17.10.2024.
//

import Alamofire

struct GradesRequest: APIRequestBody {
    let anonymousId: String
    let internalId: String
    
    var url: String {
        GlobalDefinitions.domain + "/api/v1/cards/grades"
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
