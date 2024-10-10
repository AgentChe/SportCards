//
//  FiltersViewModel.swift
//  SportCards
//
//  Created by Vitaliy Zagorodnov on 10.10.2024.
//

import Foundation

final class FiltersViewModel: ObservableObject {
    @Published var alias: [Alias] = []
    
    private lazy var cardsManager = CardsManager()
    
    init() {
        cardsManager.cachedCategories()
            .replaceError(with: [])
            .assign(to: &$alias)
    }
}
