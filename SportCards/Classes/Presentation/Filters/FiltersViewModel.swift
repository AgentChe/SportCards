//
//  FiltersViewModel.swift
//  SportCards
//
//  Created by Vitaliy Zagorodnov on 10.10.2024.
//

import Foundation

final class FiltersViewModel: ObservableObject {
    @Published var categories: [CardCategory] = []
    @Published var grades: [Grade] = []
    
    private lazy var cardsManager = CardsManager()
    
    init() {
        cardsManager
            .makeCategories(forceUpdate: false)
            .replaceError(with: [])
            .receive(on: DispatchQueue.main)
            .assign(to: &$categories)
        
        cardsManager
            .makeGrades(forceUpdate: false)
            .replaceError(with: [])
            .receive(on: DispatchQueue.main)
            .assign(to: &$grades)
    }
}
