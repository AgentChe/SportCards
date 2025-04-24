//
//  FastFiltersSheetViewModel.swift
//  SportCards
//
//  Created by Vitaliy Zagorodnov on 22.04.2025.
//

import Foundation

final class FastFiltersSheetViewModel: ObservableObject {
    
    @Published var categories: [CardCategory] = []
    @Published var gradingService: [GradeService] = []
    @Published var grades: [String] = []
    @Published var cachedFilters: Filters
    @Published var isAvailableGrades: Bool = true
    
    private lazy var cardsManager = CardsManager()
    
    private let type: FastFilterType
    private let filters: Filters
    
    init(for type: FastFilterType, filters: Filters) {
        self.cachedFilters = filters
        self.type = type
        self.filters = filters
    }
    
    func load() async {
        switch type {
        case .gradingService:
            cardsManager
                .makeGradeServices(forceUpdate: false)
                .receive(on: DispatchQueue.main)
                .assign(to: &$gradingService)
        case .grade:
            let gradesAndAvailable = cardsManager
                .makeGradeServices(forceUpdate: false)
                .map { [filters, cardsManager] grades in
                    cardsManager.makeGradeValues(in: grades, use: filters.gradeService)
                }
                .shareReplay(1)
                
            gradesAndAvailable
                .map(\.0)
                .receive(on: DispatchQueue.main)
                .assign(to: &$grades)
            
            gradesAndAvailable
                .map(\.1)
                .print()
                .receive(on: DispatchQueue.main)
                .assign(to: &$isAvailableGrades)
        case .category:
            cardsManager
                .makeCategories(forceUpdate: false)
                .replaceError(with: [])
                .receive(on: DispatchQueue.main)
                .assign(to: &$categories)
        }
    }
}

extension FastFiltersSheetViewModel {
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
}
