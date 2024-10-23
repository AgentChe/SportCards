//
//  ManualCardSearchViewModel.swift
//  SportCards
//
//  Created by Vitaliy Zagorodnov on 21.10.2024.
//

import Foundation
import Combine

final class ManualCardSearchViewModel: ObservableObject {
    
    @Published var filters: Filters = .init()
    @Published var isFocused: Bool = false
    @Published var searchText: String = ""
    @Published var elements: [CardDiscover] = []
    @Published var isFinished: Bool = false
    
    private let loadNext = PassthroughSubject<Void, Never>()
    
    private lazy var manager = CardsManager()
    
    init() {
        makeData()
    }
    
    func loadMore() {
        loadNext.send(())
    }
   
    func makeData() {
        let currentText = $searchText
            .debounce(for: 0.3, scheduler: DispatchQueue.main)
            .map { $0.count >= 3 ? $0 : "" }
            .prepend("")
            .removeDuplicates()
        
        let filters = $filters
            .removeDuplicates()
        
        Publishers
            .CombineLatest(currentText, filters)
            .compactMap { [weak self] text, filters -> AnyPublisher<[CardDiscover], Never>? in
                guard let self, text.count >= 3 || filters.count > 0 else {
                    self?.isFinished = true
                    return Just([]).eraseToAnyPublisher()
                }
                isFinished = false
                var isLoading = false
                var pagination: CardDiscoverResponse.Pagination?
                
                return loadNext
                    .prepend(())
                    .compactMap { [weak self] _ -> AnyPublisher<[CardDiscover], Never>? in
                        guard let self, !isLoading, !isFinished else { return nil }
                        isLoading = true
                        let page = pagination?.next ?? 0
                        return manager
                            .cards(text: text, filters: filters, for: page)
                            .compactMap { $0.success?.flatMap { $0 }}
                            .handleEvents(receiveOutput: { [weak self] in
                                pagination = $0.pagination
                                isLoading = false
                                if let pagination {
                                    self?.isFinished = pagination.isEnd
                                }
                            })
                            .map(\.items)
                            .replaceError(with: [])
                            .eraseToAnyPublisher()
                    }
                    .switchToLatest()
                    .scan([], +)
                    .prepend([])
                    .eraseToAnyPublisher()
            }
            .switchToLatest()
            .receive(on: DispatchQueue.main)
            .assign(to: &$elements)
    }
}
