//
//  ProfileRemoveCardRequest.swift
//  SportCards
//
//  Created by Vitaliy Zagorodnov on 24.10.2024.
//

import Alamofire

struct ProfileRemoveCardRequest: APIRequestBody {
    let anonymousId: String
    let internalId: String
    let id: String
    
    var url: String {
        GlobalDefinitions.domain + "/api/v1/profile/cards/remove"
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
            "id": id
        ]
    }
}
