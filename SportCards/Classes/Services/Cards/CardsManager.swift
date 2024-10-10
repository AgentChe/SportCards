//
//  CardsManager.swift
//  SportCards
//
//  Created by Vitaliy Zagorodnov on 03.10.2024.
//

import Foundation
import Combine

protocol CardsManagerProtocol {
    func categories() -> AnyPublisher<[Alias], NetworkError>
}

final class CardsManager {
    private lazy var restApiTransport = RestAPITransport()
    private lazy var sessionManager = SessionManager()
}

extension CardsManager: CardsManagerProtocol {
    func makeCategories(forceUpdate: Bool) -> AnyPublisher<[Alias], NetworkError> {
        forceUpdate ? categories() : cachedCategories()
    }
    
    func categories() -> AnyPublisher<[Alias], NetworkError> {
        let request = CategoriestRequest(
            anonymousId: sessionManager.anonymousId,
            internalId: sessionManager.anonymousId
        )
        
        return restApiTransport
            .callServerApi(requestBody: request)
            .map { Alias.map(response: $0) }
            .handleEvents(receiveOutput: { items in
                if let data = try? JSONEncoder().encode(items) {
                    UserDefaults.standard.set(data, forKey: Constants.categories)
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
    
    func cachedCategories() -> AnyPublisher<[Alias], NetworkError> {
        Future { promise in
            let categories = UserDefaults.standard.data(forKey: Constants.categories).flatMap {
                try? JSONDecoder().decode([Alias].self, from: $0)
            } ?? []
            
            promise(.success(categories))
        }
        .eraseToAnyPublisher()
    }
    
    func cachedCategories() -> [Alias] {
        UserDefaults.standard.data(forKey: Constants.categories).flatMap {
            try? JSONDecoder().decode([Alias].self, from: $0)
        } ?? []
    }
}

private extension CardsManager {
    enum Constants {
        static let categories = "cards_manager_categories_key"
    }
}
