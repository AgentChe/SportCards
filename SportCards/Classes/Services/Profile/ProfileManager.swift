//
//  ProfileManager.swift
//  SportCards
//
//  Created by Vitaliy Zagorodnov on 30.09.2024.
//

import Foundation
import Combine

protocol ProfileManagerProtocol {
    func home() -> AnyPublisher<Result<HomeModel?, NetworkError>, Never>
    func collection(filters: Filters, page: Int?) -> AnyPublisher<Result<[CardDiscover], NetworkError>, Never>
    func scannedCards(filters: Filters, page: Int?) -> AnyPublisher<Result<ProfileCollectionCards?, NetworkError>, Never>
}

protocol ProfileAccountProtocol {
    func create() -> AnyPublisher<Void, NetworkError>
    func binding() -> AnyPublisher<Void, NetworkError>
}

final class ProfileManager {
    private lazy var restApiTransport = RestAPITransport()
    private lazy var sessionManager = SessionManager()
}

extension ProfileManager: ProfileManagerProtocol {
    func home() -> AnyPublisher<Result<HomeModel?, NetworkError>, Never> {
        let request = HomeRequest(
            anonymousId: sessionManager.anonymousId,
            internalId: sessionManager.internalId
        )

        return restApiTransport
            .callServerApi(requestBody: request)
            .map(HomeModel.init(from:))
            .asResult()
            .eraseToAnyPublisher()
    }
    
    func collection(filters: Filters, page: Int?) -> AnyPublisher<Result<[CardDiscover], NetworkError>, Never> {
        
        let request = ProfileCollectionRequest(
            anonymousId: sessionManager.anonymousId,
            internalId: sessionManager.internalId,
            filters: filters,
            page: page,
            type: .wishList
        )
        
        return restApiTransport
            .callServerApi(requestBody: request)
            .map(CardDiscover.map(response:))
            .asResult()
            .eraseToAnyPublisher()
    }
    
    func scannedCards(filters: Filters, page: Int?) -> AnyPublisher<Result<ProfileCollectionCards?, NetworkError>, Never> {
        let request = ProfileCollectionRequest(
            anonymousId: sessionManager.anonymousId,
            internalId: sessionManager.internalId,
            filters: filters,
            page: page,
            type: .scanned
        )
        
        return restApiTransport
            .callServerApi(requestBody: request)
            .map(ProfileCollectionCards.init(from:))
            .asResult()
            .eraseToAnyPublisher()
    }
}

extension ProfileManager: ProfileAccountProtocol {
    func create() -> AnyPublisher<Void, NetworkError> {
        let request = ProfileCreateRequest(
            anonymousId: sessionManager.anonymousId,
            internalId: sessionManager.internalId
        )
        
        return restApiTransport
            .callServerApi(requestBody: request)
            .map { _ in () }
            .eraseToAnyPublisher()
    }
    
    func binding() -> AnyPublisher<Void, NetworkError> {
        let request = ProfileBindingRequest(
            anonymousId: sessionManager.anonymousId,
            internalId: sessionManager.internalId
        )
        
        return restApiTransport
            .callServerApi(requestBody: request)
            .map { _ in () }
            .eraseToAnyPublisher()
    }
}
