//
//  HomeViewModel.swift
//  SportCards
//
//  Created by Vitaliy Zagorodnov on 01.10.2024.
//

import Foundation
import Combine

final class HomeViewModel: ObservableObject {
    @Published private(set) var dataSource: [HomeViewCellType] = []
    @Published var searchIsFocused: Bool = false
    @Published var screenState: ScreenState = .loading
    
    private lazy var profileManager: ProfileManagerProtocol = ProfileManager()
    private lazy var cardsManager = CardsManager()
    private let retrySubject = PassthroughSubject<Void, Never>()
    
    init() {
        makeData()
    }
    
    private func makeData() {
        let updateHome = ProfileManagerMediator.shared.needUpdateCollection
            .mapToVoid()
        
        let homeRequestResult = Publishers
            .Merge(updateHome, retrySubject)
            .prepend(())
            .compactMap { [weak self] in
                self?.profileManager.home()
            }
            .switchToLatest()
            .shareReplay(1)
        
        let categories = cardsManager
            .makeCategories(forceUpdate: false)
            .replaceError(with: [])
        
        let homeResult = homeRequestResult
            .compactMap { $0.success }
        
        Publishers
            .CombineLatest(homeResult, categories)
            .compactMap { home, categories -> [HomeViewCellType]? in
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
        
        Publishers
            .Merge3(
                updateHome.map { _ in .loading },
                retrySubject.map { _ in .loading },
                homeRequestResult.map { $0.error != nil ? .error : .loaded }
            )
            .assign(to: &$screenState)
    }
}

extension HomeViewModel {
    func retry() {
        retrySubject.send(())
    }
}
