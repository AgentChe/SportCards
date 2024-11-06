//
//  CategoryListViewModel.swift
//  SportCards
//
//  Created by Vitaliy Zagorodnov on 26.10.2024.
//

import Foundation
import Combine

final class CategoryListViewModel: ObservableObject {
    @Published var elements: [CardDiscover] = []
    @Published var isFinished: Bool = false
    @Published var screenState: ScreenState = .loading
    
    private let category: CardCategory
    private let loadNext = PassthroughSubject<Void, Never>()
    private var cancellable: Set<AnyCancellable> = []
    
    private lazy var manager = CardsManager()
    
    init(_ category: CardCategory) {
        self.category = category
        makeData()
    }
    
    private func makeData() {
        isFinished = false
        var isLoading = false
        var pagination: Pagination?
        let filters = Filters(category: category)
        
        let request = loadNext
            .prepend(())
            .compactMap { [weak self] _ -> AnyPublisher<Result<CardDiscoverResponse, Error>, Never>? in
                guard let self, !isLoading, !isFinished else { return nil }
                isLoading = true
                let page = pagination?.next ?? 0
                
                return manager
                    .cards(text: "", filters: filters, for: page)
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
        
        let error = request.compactMap(\.error)
        
        Publishers
            .Merge(
                success.map { Result.success($0) },
                error.map { Result.failure($0) }
            )
            .handleEvents(receiveOutput: { _ in isLoading = false })
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                switch result {
                case let .success(elements):
                    self?.elements = elements
                    self?.screenState = .loaded
                case .failure:
                    self?.screenState = .error
                }
            }
            .store(in: &cancellable)
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
