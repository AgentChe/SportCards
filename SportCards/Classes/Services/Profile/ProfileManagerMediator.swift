//
//  ProfileManagerMediator.swift
//  SportCards
//
//  Created by Vitaliy Zagorodnov on 26.10.2024.
//

import Combine

final class ProfileManagerMediator {
    static let shared = ProfileManagerMediator()
    
    private init() {}
    
    private let updateCollectionSubject = PassthroughSubject<CollectionTab, Never>()
}

extension ProfileManagerMediator {
    func updateCollection(_ collection: CollectionTab) {
        updateCollectionSubject.send(collection)
    }
}

extension ProfileManagerMediator {
    var needUpdateCollection: AnyPublisher<CollectionTab, Never> {
        updateCollectionSubject.eraseToAnyPublisher()
    }
}
