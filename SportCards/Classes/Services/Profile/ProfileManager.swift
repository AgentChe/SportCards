//
//  ProfileManager.swift
//  SportCards
//
//  Created by Vitaliy Zagorodnov on 30.09.2024.
//

import Foundation
import Combine

protocol ProfileManagerProtocol {
    func home() -> AnyPublisher<Result<HomeModel, Error>, Never>
    func collectionsAvailable() -> AnyPublisher<Result<Bool, Error>, Never>
    func collection(filters: Filters, page: Int?) -> AnyPublisher<Result<ProfileCollectionCards, Error>, Never>
    func scannedCards(filters: Filters, page: Int?) -> AnyPublisher<Result<ProfileScannedCards, Error>, Never>
    func addCard(to collection: CollectionTab, id: String, grade: String) -> AnyPublisher<Bool, Error>
    func removeCard(id: String) -> AnyPublisher<Bool, Error>
    func info() -> AnyPublisher<ProfileInfoModel, Error>
    func saveAttributes(grade: String?, category: String?) -> AnyPublisher<Void, Error>
    func isScannedRestriction() -> Bool
    func updateScannedCount(_ count: Int, isReplace: Bool)
}

protocol ProfileAccountProtocol {
    func create() -> AnyPublisher<Void, Error>
    func binding() -> AnyPublisher<Void, Error>
}

final class ProfileManager {
    private lazy var restApiTransport = RestAPITransport()
    private lazy var sessionManager = SessionManager()
}

extension ProfileManager: ProfileManagerProtocol {
    func saveAttributes(grade: String?, category: String?) -> AnyPublisher<Void, Error> {
        let request = ProfileAttributesRequest(
            anonymousId: sessionManager.anonymousId,
            internalId: sessionManager.internalId,
            category: category,
            grade: grade
        )
        
        return restApiTransport
            .callServerApi(requestBody: request)
            .mapToVoid()
            .eraseToAnyPublisher()
    }
    
    func info() -> AnyPublisher<ProfileInfoModel, Error> {
        let request = ProfileInfoRequest(
            anonymousId: sessionManager.anonymousId,
            internalId: sessionManager.internalId
        )
        
        return restApiTransport
            .callServerApi(requestBody: request)
    }
    
    func home() -> AnyPublisher<Result<HomeModel, Error>, Never> {
        let request = HomeRequest(
            anonymousId: sessionManager.anonymousId,
            internalId: sessionManager.internalId
        )

        return restApiTransport
            .callServerApi(requestBody: request)
            .asResult()
    }
    
    func collectionsAvailable() -> AnyPublisher<Result<Bool, Error>, Never> {
        let request = ProfileCollectionsAvailableRequest(
            anonymousId: sessionManager.anonymousId,
            internalId: sessionManager.internalId
        )

        return restApiTransport
            .callServerApi(requestBody: request)
            .asResult()
    }
    
    func collection(filters: Filters, page: Int?) -> AnyPublisher<Result<ProfileCollectionCards, Error>, Never> {
        
        let request = ProfileCollectionRequest(
            anonymousId: sessionManager.anonymousId,
            internalId: sessionManager.internalId,
            filters: filters,
            page: page,
            type: .wishList
        )
        
        return restApiTransport
            .callServerApi(requestBody: request)
            .asResult()
    }
    
    func scannedCards(filters: Filters, page: Int?) -> AnyPublisher<Result<ProfileScannedCards, Error>, Never> {
        let request = ProfileCollectionRequest(
            anonymousId: sessionManager.anonymousId,
            internalId: sessionManager.internalId,
            filters: filters,
            page: page,
            type: .scanned
        )
        
        return restApiTransport
            .callServerApi(requestBody: request)
            .asResult()
    }
    
    func addCard(to collection: CollectionTab, id: String, grade: String) -> AnyPublisher<Bool, Error> {
        let request = ProfileAddCardRequest(
            anonymousId: sessionManager.anonymousId,
            internalId: sessionManager.internalId,
            id: id,
            grade: grade,
            type: collection
        )
        
        return restApiTransport
            .callServerApi(requestBody: request)
    }
    
    func removeCard(id: String) -> AnyPublisher<Bool, Error> {
        let request = ProfileRemoveCardRequest(
            anonymousId: sessionManager.anonymousId,
            internalId: sessionManager.internalId,
            id: id
        )
        
        return restApiTransport
            .callServerApi(requestBody: request)
    }
    
    func isScannedRestriction() -> Bool {
        UserDefaults.standard.integer(forKey: Constants.scannedLimitKey) > 0
    }
    
    func updateScannedCount(_ count: Int, isReplace: Bool) {
        var value = UserDefaults.standard.integer(forKey: Constants.scannedLimitKey)
        if isReplace {
            value = count
        } else {
            value = max(value + count, 0)
        }
        UserDefaults.standard.setValue(value, forKey: Constants.scannedLimitKey)
    }
}

private extension ProfileManager {
    enum Constants {
        static let scannedLimitKey = "profile_manager_scanned_limit_key"
    }
}

extension ProfileManager: ProfileAccountProtocol {
    func create() -> AnyPublisher<Void, Error> {
        let request = ProfileCreateRequest(
            anonymousId: sessionManager.anonymousId,
            internalId: sessionManager.internalId
        )
        
        return restApiTransport
            .callServerApi(requestBody: request)
            .mapToVoid()
            .eraseToAnyPublisher()
    }
    
    func binding() -> AnyPublisher<Void, Error> {
        let request = ProfileBindingRequest(
            anonymousId: sessionManager.anonymousId,
            internalId: sessionManager.internalId
        )
        
        return restApiTransport
            .callServerApi(requestBody: request)
            .mapToVoid()
            .eraseToAnyPublisher()
    }
}
