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
    @Published var isFinished: Bool = false
    @Published var screenState: ScreenState = .loading
    
    private lazy var profileManager = ProfileManager()
    private let loadNext = PassthroughSubject<Void, Never>()
    private var cancellable: Set<AnyCancellable> = []
    
    init() {
        ProfileManagerMediator.shared
            .needUpdateCollection
            .prepend(.wishList)
            .filter { $0 == .wishList }
            .compactMap { [weak self] _ -> AnyPublisher<Result<[CardDiscover], Error>, Never>? in
                guard let self else { return nil }
                return $filters
                    .removeDuplicates()
                    .compactMap { [weak self] in
                        return self?.pagination(filters: $0)
                    }
                    .switchToLatest()
                    .eraseToAnyPublisher()
            }
            .switchToLatest()
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] result in
                switch result {
                case let .success(items):
                    self?.cards = items
                    self?.screenState = .loaded
                case .failure:
                    self?.screenState = .error
                }
            })
            .store(in: &cancellable)
    }
    
    func pagination(filters: Filters) -> AnyPublisher<Result<[CardDiscover], Error>, Never> {
        isFinished = false
        var isLoading = false
        var pagination: Pagination?
        
        let request = loadNext
            .prepend(())
            .compactMap { [weak self] _ -> AnyPublisher<Result<ProfileCollectionCards, Error>, Never>? in
                guard let self, !isLoading, !isFinished else { return nil }
                isLoading = true
                let page = pagination?.next ?? 0
                
                return profileManager
                    .collection(filters: filters, page: page)
            }
            .switchToLatest()
            .shareReplay(1)
        
        let success = request
            .compactMap(\.success)
            .handleEvents(
                receiveOutput: { [weak self] result in
                    pagination = result.pagination
                    isLoading = false
                    if let pagination {
                        self?.isFinished = pagination.isEnd
                    }
                }
            )
            .map(\.items)
            .scan([], +)
            .eraseToAnyPublisher()
        
        let error = request.compactMap(\.error)
        
        return Publishers
            .Merge(
                success.map { Result.success($0) },
                error.map { Result.failure($0) }
            )
            .handleEvents(receiveOutput: { _ in isLoading = false })
            .eraseToAnyPublisher()
    }
}

extension WishListViewModel {
    func makeLoadNext(card: CardDiscover) {
        if cards.last == card {
            loadNext.send(())
        }
    }
    
    func retry() {
        screenState = .loading
        loadNext.send(())
    }
}
