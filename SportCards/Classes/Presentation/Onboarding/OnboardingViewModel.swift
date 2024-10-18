//
//  OnboardingViewModel.swift
//  SportCards
//
//  Created by Vitaliy Zagorodnov on 29.09.2024.
//

import Foundation

final class OnboardingViewModel: ObservableObject {
    @Published var selectedCategories: Set<CardCategory> = []
    @Published var selectedGrades: Set<Grade> = []
    
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
