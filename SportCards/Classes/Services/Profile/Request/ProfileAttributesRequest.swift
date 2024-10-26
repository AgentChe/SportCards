//
//  ProfileAttributesRequest.swift
//  SportCards
//
//  Created by Vitaliy Zagorodnov on 26.10.2024.
//

import Alamofire

struct ProfileAttributesRequest: APIRequestBody {
    let anonymousId: String
    let internalId: String
    let category: String?
    let grade: String?
    
    var url: String {
        GlobalDefinitions.domain + "/api/v1/profile/attribute"
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
        
        var attrs: [String: Any] = [:]
        
        attrs["category"] = category
        attrs["grade"] = grade
        if !attrs.isEmpty {
            params["attrs"] = attrs
        }
        
        return params
    }
}
