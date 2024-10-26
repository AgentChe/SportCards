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
    @Published var error: ErrorScreenType? = nil
    
    private lazy var profileManager: ProfileManagerProtocol = ProfileManager()
    private lazy var cardsManager = CardsManager()
    
    func makeData() {
        let homeRequestResult = profileManager
            .home()
            .shareReplay(1)
        
        let categories = cardsManager
            .makeCategories(forceUpdate: false)
            .replaceError(with: [])
        
        let homeResult = homeRequestResult
            .compactMap { $0.success }
        
        Publishers
            .CombineLatest(homeResult, categories)
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
            .assign(to: &$dataSource)
        
        homeRequestResult
            .filter { $0.error != nil }
            .map { _ in .request }
            .assign(to: &$error)
    }
}
