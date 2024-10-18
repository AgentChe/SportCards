//
//  CardsManager.swift
//  SportCards
//
//  Created by Vitaliy Zagorodnov on 03.10.2024.
//

import Foundation
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
    
    func cards(text: String, filters: Filters, for page: Int) -> AnyPublisher<Result<[CardDiscover], NetworkError>, Never> {
        let request = DiscoverRequest(
            anonymousId: sessionManager.anonymousId,
            internalId: sessionManager.anonymousId,
            text: text,
            filters: filters,
            page: page
        )
        
        return restApiTransport.callServerApi(requestBody: request)
            .map { CardDiscover.map(response: $0) }
            .asResult()
            .eraseToAnyPublisher()
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
            let categories = UserDefaults.standard.data(forKey: Constants.categories).flatMap {
                try? JSONDecoder().decode([Grade].self, from: $0)
            } ?? []
            
            promise(.success(categories))
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
}

private extension CardsManager {
    enum Constants {
        static let categories = "cards_manager_categories_key"
        static let grades = "cards_manager_grades_key"
    }
}
