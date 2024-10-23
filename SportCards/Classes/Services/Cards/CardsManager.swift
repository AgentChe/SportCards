//
//  CardsManager.swift
//  SportCards
//
//  Created by Vitaliy Zagorodnov on 03.10.2024.
//

import Foundation
import Alamofire
import Combine

protocol CardsManagerProtocol {
    func categories() -> AnyPublisher<[CardCategory], NetworkError>
}

final class CardsManager {
    private lazy var restApiTransport = RestAPITransport()
    private lazy var sessionManager = SessionManager()
}

extension CardsManager: CardsManagerProtocol {
    func makeCategories(forceUpdate: Bool) -> AnyPublisher<[CardCategory], NetworkError> {
        forceUpdate ? categories() : cachedCategories()
    }
    
    func makeGrades(forceUpdate: Bool) -> AnyPublisher<[Grade], NetworkError> {
        forceUpdate ? grades() : cachedGrades()
    }
    
    func categories() -> AnyPublisher<[CardCategory], NetworkError> {
        let request = CategoriesRequest(
            anonymousId: sessionManager.anonymousId,
            internalId: sessionManager.anonymousId
        )
        
        return restApiTransport
            .callServerApi(requestBody: request)
            .map { CardCategory.map(response: $0) }
            .handleEvents(receiveOutput: { items in
                if let data = try? JSONEncoder().encode(items) {
                    UserDefaults.standard.set(data, forKey: Constants.categories)
                }
            })
            .eraseToAnyPublisher()
    }
    
    func grades() -> AnyPublisher<[Grade], NetworkError> {
        let request = GradesRequest(
            anonymousId: sessionManager.anonymousId,
            internalId: sessionManager.anonymousId
        )
        
        return restApiTransport
            .callServerApi(requestBody: request)
            .map { Grade.map(response: $0) }
            .handleEvents(receiveOutput: { items in
                if let data = try? JSONEncoder().encode(items) {
                    UserDefaults.standard.set(data, forKey: Constants.grades)
                }
            })
            .eraseToAnyPublisher()
    }
    
    func cards(text: String, filters: Filters, for page: Int) -> AnyPublisher<Result<CardDiscoverResponse?, NetworkError>, Never> {
        let request = DiscoverRequest(
            anonymousId: sessionManager.anonymousId,
            internalId: sessionManager.anonymousId,
            text: text,
            filters: filters,
            page: page
        )
        
        return restApiTransport.callServerApi(requestBody: request)
            .map(CardDiscoverResponse.init(from:))
            .asResult()
            .eraseToAnyPublisher()
    }
    
    func cards(text: String, filters: Filters, for page: Int) async throws -> CardDiscoverResponse? {
        let request = DiscoverRequest(
            anonymousId: sessionManager.anonymousId,
            internalId: sessionManager.anonymousId,
            text: text,
            filters: filters,
            page: page
        )
        
        let data = try await restApiTransport.callServerApi1(requestBody: request)
        
        return CardDiscoverResponse(from: data)
    }
    
    func cachedCategories() -> AnyPublisher<[CardCategory], NetworkError> {
        Future { promise in
            let categories = UserDefaults.standard.data(forKey: Constants.categories).flatMap {
                try? JSONDecoder().decode([CardCategory].self, from: $0)
            } ?? []
            
            promise(.success(categories))
        }
        .eraseToAnyPublisher()
    }
    
    func cachedGrades() -> AnyPublisher<[Grade], NetworkError> {
        Future { promise in
            let grades = UserDefaults.standard.data(forKey: Constants.grades).flatMap {
                try? JSONDecoder().decode([Grade].self, from: $0)
            } ?? []
            
            promise(.success(grades))
        }
        .eraseToAnyPublisher()
    }
    
    func cachedCategories() -> [CardCategory] {
        UserDefaults.standard.data(forKey: Constants.categories).flatMap {
            try? JSONDecoder().decode([CardCategory].self, from: $0)
        } ?? []
    }
    
    func cachedGrades() -> [Grade] {
        UserDefaults.standard.data(forKey: Constants.grades).flatMap {
            try? JSONDecoder().decode([Grade].self, from: $0)
        } ?? []
    }
    
    func upload(image: UIImage) -> AnyPublisher<CardUploadResponse?, Never> {
        let anonymousId = sessionManager.anonymousId.data(using: .utf8)
        let internalId = sessionManager.internalId.data(using: .utf8)
        
        return Future { promise in
            let url = URL(string: GlobalDefinitions.domain + "/api/v1/cards/scan")
            let jpeg = image.jpegData(compressionQuality: 0.5)
            
            
            guard let url, let jpeg, let anonymousId, let internalId else {
                promise(.success(nil))
                return
            }
            
            let headers: HTTPHeaders = [
                "Access-Token": GlobalDefinitions.apiKey
            ]
            
            let request = AF.upload(multipartFormData: { multipartFormData in
                multipartFormData.append(jpeg, withName: "image", fileName: "\(UUID().uuidString).jpeg", mimeType: "image/jpeg")
                multipartFormData.append(anonymousId, withName: "anonymous_id")
                multipartFormData.append(internalId, withName: "internal_id")
            }, to: url, headers: headers)
            
            request
                .response { response in
                    guard let data = response.data else {
                        promise(.success(nil))
                        return
                    }
                    
                    let result = CardUploadResponse(response: data)
                    promise(.success(result))
                }
        }
        .eraseToAnyPublisher()
    }
}

private extension CardsManager {
    enum Constants {
        static let categories = "cards_manager_categories_key"
        static let grades = "cards_manager_grades_key"
    }
}
