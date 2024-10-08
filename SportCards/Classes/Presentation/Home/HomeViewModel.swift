//
//  HomeViewModel.swift
//  SportCards
//
//  Created by Vitaliy Zagorodnov on 01.10.2024.
//

import Foundation
import Combine

final class HomeViewModel: ObservableObject {
    @Published private(set) var recommendations: [CardDiscover] = []
    @Published private(set) var dataSource: [HomeViewCellType] = []
    @Published var searchIsFocused: Bool = false
    @Published var searchText: String = ""
    @Published var filters: Filters = .init()
    
    private lazy var profileManager = ProfileManager()
    private lazy var cardsManager = CardsManager()
    
    func makeData() {
        let homeRequestResult = profileManager
            .home()
            .shareReplay(1)
        
        let categoriesRequestResult = cardsManager
            .categories()
            .shareReplay(1)
        
        let homeResult = homeRequestResult
            .compactMap { $0.success }
        
        let categoriesResult = categoriesRequestResult
            .compactMap { $0.success }
        
        let homeDataSource = Publishers
            .CombineLatest(homeResult, categoriesResult)
            .compactMap { home, categories -> [HomeViewCellType]? in
                guard let home else { return nil }
                var dataSource: [HomeViewCellType] = []
                
                if let priceReport = home.personalScanner {
                    dataSource.append(.priceReport(priceReport))
                } else {
                    dataSource.append(.cardScanner)
                }
                dataSource.append(.sectionTitle("Home.Section.Recommended".localized))
                dataSource.append(contentsOf: home.recommendation.map { .recommendedCard($0) })
                
                if !categories.isEmpty {
                    dataSource.append(.allias(categories))
                }
                
                dataSource.append(.sectionTitle("Home.Section.Other".localized))
                dataSource.append(contentsOf: home.other.map { .other($0) })
                
                return dataSource
            }
            .prepend(makeTestDataSource())
            .assign(to: &$dataSource)
        
        let searchTrigger = $searchText
            .removeDuplicates()
            .filter { $0.count >= 3 }
            .debounce(for: 0.3, scheduler: DispatchQueue.main)
        
        let searchDataSource = Publishers
            .CombineLatest(searchTrigger, $filters)
            .map { text, filters in
                
            }
        
//        Publishers.CombineLatest(homeResult, categoriesResult)
//            .flatMap { [weak self] home, categories -> AnyPublisher<[HomeViewCellType], Never> in
//                guard let self, let home else { return Empty().eraseToAnyPublisher() }
//                var dataSource: [HomeViewCellType] = []
//                
//                if let priceReport = home.personalScanner {
//                    dataSource.append(.priceReport(priceReport))
//                } else {
//                    dataSource.append(.cardScanner)
//                }
//                dataSource.append(.sectionTitle("Home.Section.Recommended".localized))
//                dataSource.append(contentsOf: home.recommendation.map { .recommendedCard($0) })
//                
//                if !categories.isEmpty {
//                    dataSource.append(.allias(categories))
//                }
//                
//                dataSource.append(.sectionTitle("Home.Section.Other".localized))
//                dataSource.append(contentsOf: home.other.map { .other($0) })
//                
//                return $searchText
//                    .removeDuplicates()
//                    .debounce(for: 0.5, scheduler: DispatchQueue.main)
//                    .map { text -> [HomeViewCellType] in
//                        guard text.count >= 3 else { return dataSource }
//                        
//                        return home.recommendation.compactMap { card in
//                            guard card.title.contains(text) else { return nil }
//                            return .recommendedCard(card)
//                        }
//                    }
//                    .prepend(dataSource)
//                    .eraseToAnyPublisher()
//            }
    }
    
    private func makeTestDataSource() -> [HomeViewCellType] {
        let items: [CardDiscover] = [
            .init(
                id: "2",
                imageURL: URL(string: "https://www.scottssportscards.com/wp-content/uploads/Scotts-Jewelry-Sports-Cards-barry-sanders-min.jpg"),
                title: "John Smoltz",
                subtitle: "Topps",
                grade: .psa,
                currentPrice: "$249.99",
                currentPriceRaw: 249.99,
                collectionName: "Finest"
            ),
            .init(
                id: "1",
                imageURL: URL(string: "https://www.scottssportscards.com/wp-content/uploads/Scotts-Jewelry-Sports-Cards-aaron-mays-min.jpg"),
                title: "Wilt Chamberlain Smoltz",
                subtitle: "Fleer Basketball",
                grade: .psa,
                currentPrice: "$5499.99",
                currentPriceRaw: 5499.99,
                collectionName: nil
            ),
            .init(
                id: "3",
                imageURL: URL(string: "https://www.scottssportscards.com/wp-content/uploads/Scotts-Jewelry-Sports-Cards-barry-sanders-min.jpg"),
                title: "Smoltz John Smoltz Chamberlain",
                subtitle: "Topps",
                grade: .raw,
                currentPrice: "$249.99",
                currentPriceRaw: 249.99,
                collectionName: "Finest"
            )
        ]
        
        return [
            .priceReport(.init(today: [], week: [], twoWeek: [], month: [])),
            .sectionTitle("Recommended cards for you")
        ] + items.map { .recommendedCard($0) }
        
    }
}
