//
//  RestAPITransport.swift
//  SportCards
//
//  Created by Vitaliy Zagorodnov on 30.09.2024.
//

import Combine
import Alamofire

final class RestAPITransport {
    func callServerApi(requestBody: APIRequestBody) -> AnyPublisher<Any, Error> {
        Future { promise in
            let manager = Alamofire.Session.default
            manager.session.configuration.timeoutIntervalForRequest = 30
            
            let encodedUrl = requestBody.url.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
            
            _ = manager.request(encodedUrl,
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
    
    func callServerApi<T: Decodable>(requestBody: APIRequestBody) -> AnyPublisher<T, Error> {
        Deferred {
            Future { promise in
                let manager = Alamofire.Session.default
                manager.session.configuration.timeoutIntervalForRequest = 30
                
                let encodedUrl = requestBody.url.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
                
                _ = manager
                    .request(
                        encodedUrl,
                        method: requestBody.method,
                        parameters: requestBody.parameters,
                        encoding: requestBody.encoding,
                        headers: requestBody.headers
                    )
                    .validate(statusCode: [200, 201])
                    .responseContainer(of: T.self) { response in
                        switch response.result {
                        case .success(let result):
                            promise(.success(result))
                        case .failure(let error):
                            promise(.failure(error))
                        }
                    }
            }
        }
        .eraseToAnyPublisher()
    }
}

struct ResponseContainer<T: Decodable>: Decodable {
    let body: T?
    let error: APIError?
}

struct APIError: Error, Decodable {
    let code: Int
    let message: Int
}

final class APIDecodableResponseSerializer<T: Decodable>: ResponseSerializer {
    let dataPreprocessor: DataPreprocessor
    let decoder: DataDecoder
    let emptyResponseCodes: Set<Int>
    let emptyRequestMethods: Set<HTTPMethod>
    
    init(dataPreprocessor: DataPreprocessor = PassthroughPreprocessor(),
                emptyResponseCodes: Set<Int> = [204, 205],
                emptyRequestMethods: Set<HTTPMethod> = [.head]) {
        self.dataPreprocessor = dataPreprocessor
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .secondsSince1970
        self.decoder = decoder
        self.emptyResponseCodes = emptyResponseCodes
        self.emptyRequestMethods = emptyRequestMethods
    }
    
    func serialize(request: URLRequest?, response: HTTPURLResponse?, data: Data?, error: Error?) throws -> T {
        guard error == nil else { throw error! }
        
        guard var data, !data.isEmpty else {
            guard emptyResponseAllowed(forRequest: request, response: response) else {
                throw AFError.responseSerializationFailed(reason: .inputDataNilOrZeroLength)
            }

            guard let emptyResponseType = T.self as? EmptyResponse.Type, let emptyValue = emptyResponseType.emptyValue() as? T else {
                throw AFError.responseSerializationFailed(reason: .invalidEmptyResponse(type: "\(T.self)"))
            }

            return emptyValue
        }
        
        data = try dataPreprocessor.preprocess(data)
        
        do {
            let container = try decoder.decode(ResponseContainer<T>.self, from: data)
            if let error = container.error {
                throw error
            } else if let body = container.body {
                return body
            } else {
                throw AFError.responseSerializationFailed(reason: .decodingFailed(error: NSError(domain: "SportCards", code: -1)))
            }
        } catch {
            throw AFError.responseSerializationFailed(reason: .decodingFailed(error: error))
        }
    }
}

extension DataRequest {
    @discardableResult
    func responseContainer<T: Decodable>(of type: T.Type = T.self, completionHandler: @escaping (AFDataResponse<T>) -> Void) -> Self {
        response(
            responseSerializer: APIDecodableResponseSerializer(),
            completionHandler: completionHandler
        )
    }
}
