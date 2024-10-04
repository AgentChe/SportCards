//
//  RestAPITransport.swift
//  SportCards
//
//  Created by Vitaliy Zagorodnov on 30.09.2024.
//

import Combine
import Alamofire

final class RestAPITransport {
    func callServerApi(requestBody: APIRequestBody) -> AnyPublisher<Any, NetworkError> {
        Future { promise in
            let manager = Alamofire.Session.default
            manager.session.configuration.timeoutIntervalForRequest = 30
            
            let encodedUrl = requestBody.url.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
            
            let request = manager.request(encodedUrl,
                                          method: requestBody.method,
                                          parameters: requestBody.parameters,
                                          encoding: requestBody.encoding,
                                          headers: requestBody.headers)
                .validate(statusCode: [200, 201])
                .responseJSON(completionHandler: { response in
                    switch response.result {
                    case .success(let json):
                        promise(.success(json))
                    case .failure(let error):
                        promise(.failure(NetworkError(.serverNotAvailable, underlyingError: error)))
                    }
                })
        }
        .eraseToAnyPublisher()
    }
    
    func callServerApi<T: Decodable>(requestBody: APIRequestBody) -> AnyPublisher<Result<T, NetworkError>, Never> {
        let manager = Alamofire.Session.default
        manager.session.configuration.timeoutIntervalForRequest = 30
        
        let encodedUrl = requestBody.url.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
        
        
        return manager
            .request(encodedUrl,
                     method: requestBody.method,
                     parameters: requestBody.parameters,
                     encoding: requestBody.encoding,
                     headers: requestBody.headers
            )
            .validate(statusCode: [200, 201])
            .publishDecodable(type: T.self)
            .result()
            .map { result in
                result.mapError { NetworkError(.serverNotAvailable, underlyingError: $0) }
            }
            .eraseToAnyPublisher()
    }
}
