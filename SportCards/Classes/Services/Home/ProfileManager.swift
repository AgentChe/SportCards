//
//  ProfileManager.swift
//  SportCards
//
//  Created by Vitaliy Zagorodnov on 30.09.2024.
//

import Foundation
import Combine

protocol ProfileManagerProtocol {
//    func home() -> AnyPublisher<HomeModel?, NetworkError>
}

final class ProfileManager {
    private lazy var restApiTransport = RestAPITransport()
}

extension ProfileManager: ProfileManagerProtocol {
    func home() -> AnyPublisher<Result<HomeModel?, NetworkError>, Never> {
        let request = HomeRequest(
            anonymousId: "",
            internalId: ""
        )

        return restApiTransport
            .callServerApi(requestBody: request)
            .map(HomeModel.init(from:))
            .asResult()
            .eraseToAnyPublisher()
    }
    
    func collection(filters: Filters, page: Int?, type: CollectionTab) -> AnyPublisher<Result<ProfileCollectionCards?, NetworkError>, Never> {
        
        let request = ProfileCollectionRequest(
            anonymousId: "",
            internalId: "",
            filters: filters,
            page: page,
            type: type
        )
        
        return restApiTransport
            .callServerApi(requestBody: request)
            .map(ProfileCollectionCards.init(from:))
            .asResult()
            .eraseToAnyPublisher()
    }
}
