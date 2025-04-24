//
//  PreferencesViewModel.swift
//  SportCards
//
//  Created by Vitaliy Zagorodnov on 26.10.2024.
//

import Foundation
import Combine

final class PreferencesViewModel: ObservableObject {
    @Published var currentCategory: CardCategory? = nil
    @Published var currentGrade: GradeService? = nil
    @Published var screenState: ScreenState = .loading
    @Published var categories: [CardCategory] = []
    @Published var grades: [GradeService] = []
    @Published var isLoading: Bool = false
    
    private lazy var profileManager: ProfileManagerProtocol = ProfileManager()
    private lazy var cardsManager = CardsManager()
    
    private var infoCancellable: AnyCancellable? = nil
    private var applyCancellable: AnyCancellable? = nil
    
    
    func load() async {
        cardsManager
            .makeCategories(forceUpdate: false)
            .replaceError(with: [])
            .receive(on: DispatchQueue.main)
            .assign(to: &$categories)
        
        let gradeResponse = cardsManager
            .makeGrades(forceUpdate: false)
            .replaceError(with: nil)
        
        gradeResponse
            .compactMap { $0?.service }
            .receive(on: DispatchQueue.main)
            .assign(to: &$grades)
        
        makeProfile()
    }
    
    private func makeProfile() {
        infoCancellable = profileManager
            .info()
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { [weak self] completion in
                    if case .failure = completion {
                        self?.screenState = .error
                    }
                }, 
                receiveValue: { [weak self] model in
                    self?.currentCategory = self?.categories.first(where: { $0.alias == model.category })
                    self?.currentGrade = self?.grades.first(where: { $0.alias == model.grade })
                    self?.screenState = .loaded
                }
            )
    }
    
    func apply() {
        isLoading = true
        
        applyCancellable = profileManager
            .saveAttributes(grade: currentGrade?.alias, category: currentCategory?.alias)
            .sink(
                receiveCompletion: { [weak self] completion in
                    if case .failure = completion {
                        self?.screenState = .error
                    }
                    self?.isLoading = false
                },
                receiveValue: { [weak self] _ in
                    self?.screenState = .loaded
                    self?.isLoading = false
                }
            )
    }
}

extension PreferencesViewModel {
    func retry() {
        if applyCancellable != nil {
            screenState = .loaded
            apply()
        } else {
            makeProfile()
        }
    }
}
