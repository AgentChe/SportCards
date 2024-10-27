//
//  OnboardingViewModel.swift
//  SportCards
//
//  Created by Vitaliy Zagorodnov on 29.09.2024.
//

import Foundation
import Combine

final class OnboardingViewModel: ObservableObject {
    @Published var selectedCategory: CardCategory? = nil
    @Published var selectedGrade: Grade? = nil
    
    @Published var categories: [CardCategory] = []
    @Published var grades: [Grade] = []
    
    @Published var pages: [OnboardingPageItem] = OnboardingPageItem.allCases
    @Published var currentPage: OnboardingPageItem = .onboarding1
    
    @Published var screenState: ScreenState = .loaded
    @Published var isFinish: Bool = false
    
    private lazy var cardsManager = CardsManager()
    private lazy var profileManager: ProfileManagerProtocol = ProfileManager()
    
    private var cancellable: AnyCancellable?
    
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
    
    func nextPage() {
        guard let index = pages.firstIndex(of: currentPage) else {
            return
        }
        
        if pages.indices.contains(index + 1) {
            currentPage = pages[index + 1]
        } else {
            saveData()
        }
    }
    
    func saveData() {
        screenState = .loading
        cancellable = profileManager
            .saveAttributes(
                grade: selectedGrade?.alias,
                category: selectedCategory?.alias
            )
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                if case .failure = completion {
                    self?.screenState = .error
                }
            }, receiveValue: { [weak self] in
                self?.isFinish = true
            })
    }
}
