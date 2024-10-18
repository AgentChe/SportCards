//
//  WishListViewModel.swift
//  SportCards
//
//  Created by Vitaliy Zagorodnov on 09.10.2024.
//

import Foundation
import Combine

final class WishListViewModel: ObservableObject {
    @Published var filters: Filters = Filters()
    @Published var cards: [CardDiscover] = []
    
    private lazy var profileManager = ProfileManager()
    private let loadNext = PassthroughSubject<Void, Never>()
    
    func makeData() {
        let result = $filters
            .compactMap { [weak self] filters -> AnyPublisher<Result<[CardDiscover], NetworkError>, Never>? in
                guard let self else { return nil }
                
                var page = 1
                
                let result = loadNext
                    .prepend(())
                    .map { _ in page }
                    .flatMap { [weak self] pageNumber -> AnyPublisher<Result<[CardDiscover], NetworkError>, Never> in
                        guard let self else { return Empty().eraseToAnyPublisher() }
                        return profileManager
                            .collection(filters: filters, page: pageNumber)
                            .handleEvents(receiveOutput: { result in
                                if let model = result.success, model.count > 0 {
                                    page += 1
                                }
                            })
                            .eraseToAnyPublisher()
                    }
                    .shareReplay(1)
                
                let success = result
                    .compactMap { $0.success }
                    .scan([CardDiscover](), +)
                    .removeDuplicates()
                    
                
                return Publishers
                    .Merge(success.map { .success($0) }, result.filter { $0.error != nil } )
                    .eraseToAnyPublisher()
            }
            .switchToLatest()
            .receive(on: DispatchQueue.main)
            .shareReplay(1)
        
        result
            .compactMap { $0.success }
            .assign(to: &$cards)
    }
}

extension WishListViewModel {
    func makeLoadNext() {
        loadNext.send(())
    }
}
