//
//  ProfileAddCardRequest.swift
//  SportCards
//
//  Created by Vitaliy Zagorodnov on 24.10.2024.
//

import Alamofire

struct ProfileAddCardRequest: APIRequestBody {
    let anonymousId: String
    let internalId: String
    let id: String
    let grade: String
    let type: CollectionTab
    
    var url: String {
        GlobalDefinitions.domain + "/api/v1/profile/cards/add"
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
            "grade": grade,
            "type": type.rawValue
        ]
    }
}
