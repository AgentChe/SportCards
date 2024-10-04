//
//  CardsManager.swift
//  SportCards
//
//  Created by Vitaliy Zagorodnov on 03.10.2024.
//

import Foundation
import Combine

protocol CardsManagerProtocol {
    func categories() -> AnyPublisher<Result<[Alias], NetworkError>, Never>
}

final class CardsManager {
    private lazy var restApiTransport = RestAPITransport()
}

extension CardsManager: CardsManagerProtocol {
    func categories() -> AnyPublisher<Result<[Alias], NetworkError>, Never> {
        let request = CategoriestRequest(
            anonymousId: "",
            internalId: ""
        )
        
        return restApiTransport
            .callServerApi(requestBody: request)
            .map { Alias.map(response: $0) }
            .handleEvents(receiveOutput: { items in
                if let data = try? JSONEncoder().encode(items) {
                    UserDefaults.standard.set(data, forKey: Constants.categories)
                }
            })
            .asResult()
            .eraseToAnyPublisher()
    }
    
    func cachedCategories() -> AnyPublisher<[Alias], Never> {
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
