//
//  APIRequestBody.swift
//  SportCards
//
//  Created by Vitaliy Zagorodnov on 30.09.2024.
//

import Alamofire
import Combine

protocol APIRequestBody {
    var url: String { get }
    var method: HTTPMethod { get }
    var parameters: Parameters? { get }
    var headers: HTTPHeaders? { get }
    var encoding: ParameterEncoding { get }
    var cookies: [HTTPCookie] { get }
}

// MARK: Default
extension APIRequestBody {
    var url: String {
        ""
    }
    
    var method: HTTPMethod {
        .get
    }
    
    var parameters: Parameters? {
        nil
    }
    
    var headers: HTTPHeaders? {
        nil
    }
    
    var encoding: ParameterEncoding {
        JSONEncoding.default
    }
    
    var cookies: [HTTPCookie] {
        []
    }
}
