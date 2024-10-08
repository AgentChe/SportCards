//
//  CollectionViewModel.swift
//  SportCards
//
//  Created by Vitaliy Zagorodnov on 08.10.2024.
//

import Foundation
import Combine

final class CollectionViewModel: ObservableObject {
    @Published var filters: Filters = Filters()
    @Published var cards: [CardDiscover] = []
    @Published var price: TotalPriceModel? = nil
    
    private lazy var profileManager = ProfileManager()
    private let loadNext = PassthroughSubject<Void, Never>()
    private let tab: CollectionTab
    
    init(tab: CollectionTab) {
        self.tab = tab
    }
    
    func makeData() {
        let result = $filters
            .compactMap { [weak self] filters -> AnyPublisher<Result<ProfileCollectionCards?, NetworkError>, Never>? in
                guard let self else { return nil }
                
                var page = 1
                
                let result = loadNext
                    .prepend(())
                    .map { _ in page }
                    .flatMap { [weak self] pageNumber -> AnyPublisher<Result<ProfileCollectionCards?, NetworkError>, Never> in
                        guard let self else { return Empty().eraseToAnyPublisher() }
                        return profileManager
                            .collection(filters: filters, page: pageNumber, type: tab)
                            .handleEvents(receiveOutput: { result in
                                let model = result.success?.flatMap { $0 }
                                if let model, model.items.count > 0 {
                                    page += 1
                                }
                            })
                            .eraseToAnyPublisher()
                    }
                    .shareReplay(1)
                
                let success = result
                    .compactMap { $0.success?.flatMap { $0 } }
                    .scan(ProfileCollectionCards?.none) { result, model in
                        guard let result else { return model }
                        return result.append(model: model)
                    }
                    .compactMap { $0 }
                    .removeDuplicates()
                    
                
                return Publishers
                    .Merge(success.map { .success($0) }, result.filter { $0.error != nil } )
                    .eraseToAnyPublisher()
            }
            .switchToLatest()
            .shareReplay(1)
        
        result
            .compactMap { $0.success?.flatMap { $0.items } }
            .assign(to: &$cards)
        
        result
            .compactMap { result -> TotalPriceModel? in
                let model = result.success?.flatMap { $0 }
                return model.map {
                    TotalPriceModel(price: $0.totalPrice, count: $0.total)
                }
            }
            .removeDuplicates()
            .assign(to: &$price)
    }
}

extension CollectionViewModel {
    func makeLoadNext() {
        loadNext.send(())
    }
}

private extension ProfileCollectionCards {
    func append(model: Self) -> Self {
        return .init(
            totalPrice: model.totalPrice,
            totalPriceRaw: model.totalPriceRaw,
            total: model.total,
            items: self.items + model.items
        )
    }
}
