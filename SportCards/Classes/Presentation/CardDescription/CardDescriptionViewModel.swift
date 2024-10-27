//
//  CardDescriptionViewModel.swift
//  SportCards
//
//  Created by Vitaliy Zagorodnov on 18.10.2024.
//

import Foundation
import Combine

final class CardDescriptionViewModel: ObservableObject {
    @Published var isLoading: Bool = false
    @Published var isAdded: Bool = false
    @Published var details: CardDetails? = nil
    @Published var screenState: ScreenState = .loading
    
    private lazy var cardsManager = CardsManager()
    private lazy var profileManager: ProfileManagerProtocol = ProfileManager()
    
    private var cancellable = Set<AnyCancellable>()
    private var actionCancelable: AnyCancellable?
    private lazy var retryRequest = PassthroughSubject<Void, Never>()
    private let collection: CollectionTab
    
    init(id: String, grade: String, collection: CollectionTab) {
        self.collection = collection
        
        retryRequest
            .prepend(())
            .compactMap { [weak self] _  in
                return self?.cardsManager
                    .cardDetails(id: id, grade: grade)
                    .asResult()
            }
            .switchToLatest()
            .receive(on: DispatchQueue.main)
            .sink(
                receiveValue: { [weak self] result in
                    switch result {
                    case let .success(details):
                        self?.details = details
                        self?.screenState = .loaded
                        self?.isAdded = details.isFavorite
                    case .failure:
                        self?.screenState = .error
                    }
                }
            )
            .store(in: &cancellable)
    }
    
    func retry() {
        screenState = .loading
        retryRequest.send(())
    }
    
    func addAction() {
        guard !isLoading, let details = details else { return }
        isLoading = true
        
        actionCancelable = profileManager
            .addCard(to: collection, id: details.cardId, grade: details.grade)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: receiveCompletion) { [weak self] value in
                guard let self else { return }
                isLoading = false
                guard value else { return }
                
                if collection == .scanned {
                    profileManager.updateScannedCount(1, isReplace: false)
                }
                ProfileManagerMediator.shared.updateCollection(collection)
                isAdded = true
            }
    }
    
    func removeAction() {
        guard !isLoading, let details = details else { return }
        isLoading = true
        
        actionCancelable = profileManager
            .removeCard(id: details.cardId)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: receiveCompletion) { [weak self] value in
                guard let self else { return }
                isLoading = false
                guard value else { return }
                if collection == .scanned {
                    profileManager.updateScannedCount(-1, isReplace: false)
                }
                ProfileManagerMediator.shared.updateCollection(collection)
                isAdded = false
            }
    }
    
    private var receiveCompletion: ((Subscribers.Completion<Error>)) -> Void {
        return { [weak self] _ in
            self?.isLoading = false
        }
    }
}
