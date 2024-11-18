//
//  CardSearchViewModel.swift
//  SportCards
//
//  Created by Vitaliy Zagorodnov on 21.10.2024.
//

import Foundation
import Combine

final class CardSearchViewModel: ObservableObject {
    
    @Published var filters: Filters = .init()
    @Published var searchText: String = ""
    @Published var elements: [CardDiscover] = []
    @Published var isFinished: Bool = false
    @Published var screenState: ScreenState = .loaded
    
    private let loadNext = PassthroughSubject<Void, Never>()
    private var cancellable: Set<AnyCancellable> = []
    
    private lazy var manager = CardsManager()
    
    init() {
        let currentText = $searchText
            .debounce(for: 0.3, scheduler: DispatchQueue.main)
            .map { $0.count >= 3 ? $0 : "" }
            .prepend("")
            .removeDuplicates()
        
        let filters = $filters
            .removeDuplicates()
        
        Publishers
            .CombineLatest(currentText, filters)
            .compactMap { [weak self] text, filters -> AnyPublisher<Result<[CardDiscover], Error>, Never>? in
                guard let self, text.count >= 3 || filters.count > 0 else {
                    self?.isFinished = true
                    return Just(.success([])).eraseToAnyPublisher()
                }
                
                return pagination(text: text, filters: filters)
            }
            .switchToLatest()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                switch result {
                case let .success(items):
                    self?.elements = items
                    self?.screenState = .loaded
                case .failure:
                    self?.screenState = .error
                }
            }
            .store(in: &cancellable)
    }
    
    private func pagination(text: String, filters: Filters) -> AnyPublisher<Result<[CardDiscover], Error>, Never> {
        isFinished = false
        var isLoading = false
        var pagination: Pagination?
        
        let request = loadNext
            .prepend(())
            .compactMap { [weak self] _ -> AnyPublisher<Result<CardDiscoverResponse, Error>, Never>? in
                guard let self, !isLoading, !isFinished else { return nil }
                isLoading = true
                let page = pagination?.next ?? 0
                
                return manager
                    .cards(text: text, filters: filters, for: page)
            }
            .switchToLatest()
            .share()
        
        let success = request
            .compactMap(\.success)
            .handleEvents(receiveOutput: { [weak self] in
                pagination = $0.pagination
                isLoading = false
                if let pagination {
                    self?.isFinished = pagination.isEnd
                }
            })
            .map(\.items)
            .scan([], +)
            .prepend([])
        
        let error = request.compactMap(\.error)
        
        return Publishers
            .Merge(
                success.map { Result.success($0) },
                error.map { Result.failure($0) }
            )
            .handleEvents(receiveOutput: { _ in isLoading = false })
            .eraseToAnyPublisher()
    }
     
    
    func loadMore() {
        loadNext.send(())
    }
    
    @MainActor
    func retry() {
        screenState = .loading
        loadNext.send(())
    }
}
