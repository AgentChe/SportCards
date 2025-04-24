//
//  FiltersViewModel.swift
//  SportCards
//
//  Created by Vitaliy Zagorodnov on 10.10.2024.
//

import Foundation
import Combine

final class FiltersViewModel: ObservableObject {
    @Published var categories: [CardCategory] = []
    @Published var gradingService: [GradeService] = []
    @Published var grades: [String] = []
    @Published var cachedFilters: Filters
    @Published var isAvailableGrades: Bool = true
    
    private lazy var cardsManager = CardsManager()
    
    init(filters: Filters) {
        cachedFilters = filters
    }
    
    func load() async {
        cardsManager
            .makeCategories(forceUpdate: false)
            .replaceError(with: [])
            .receive(on: DispatchQueue.main)
            .assign(to: &$categories)
        
        cardsManager
            .makeGradeServices(forceUpdate: false)
            .receive(on: DispatchQueue.main)
            .assign(to: &$gradingService)
        
        let gradesAndAvailable = Publishers
            .CombineLatest($gradingService, $cachedFilters)
            .map { [cardsManager] grades, filters in
                cardsManager.makeGradeValues(in: grades, use: filters.gradeService)
            }
            .shareReplay(1)
        
        gradesAndAvailable
            .map(\.0)
            .receive(on: DispatchQueue.main)
            .assign(to: &$grades)
        
        gradesAndAvailable
            .map(\.1)
            .receive(on: DispatchQueue.main)
            .assign(to: &$isAvailableGrades)
    }
}

extension FiltersViewModel {
    func gradeServiceAction(for grade: GradeService) {
        if cachedFilters.gradeService.contains(grade) {
            cachedFilters.gradeService.remove(grade)
        } else {
            cachedFilters.gradeService.insert(grade)
        }
    }
    
    func gradeValueAction(for value: String) {
        if cachedFilters.gradeValues.contains(value) {
            cachedFilters.gradeValues.remove(value)
        } else {
            cachedFilters.gradeValues.insert(value)
        }
    }
    
    func categoryAction(for category: CardCategory) {
        if cachedFilters.category.contains(category) {
            cachedFilters.category.remove(category)
        } else {
            cachedFilters.category.insert(category)
        }
    }
    
    
    func priceAction(for price: Filters.SortType) {
        cachedFilters.price = price
    }
}
