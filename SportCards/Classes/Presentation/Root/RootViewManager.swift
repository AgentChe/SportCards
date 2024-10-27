//
//  RootViewManager.swift
//  SportCards
//
//  Created by Vitaliy Zagorodnov on 27.10.2024.
//

import Foundation
import Combine
import SwiftUI

final class RootViewManager: ObservableObject {
    @Published var currentRoute: SplashRouter = .splash
    @AppStorage("showedOnboarding") private var isShowedOnboarding: Bool = false
    @Published var screenState: ScreenState = .loaded
    
    private lazy var sdkInitialize = SplashReceiptValidationObserver()
    private lazy var profileManager: ProfileAccountProtocol = ProfileManager()
    private lazy var sessionManager = SessionManager()
    private lazy var cardsManager = CardsManager()
    
    private var cancellable: AnyCancellable?
    
    func makeStartRoute() {
        if isShowedOnboarding {
            currentRoute = .home
        } else {
            currentRoute = .onboarding
        }
    }
    
    func finishOnboarding() {
        isShowedOnboarding = true
        currentRoute = .home
    }
    
    func makeInitialize() {
        sdkInitialize.observe { [weak self] in
            self?.login()
        }
    }
    
    func login() {
        screenState = .loaded
        let anonymousId = sessionManager.anonymousId
        let internalId = sessionManager.internalId
        
        let request = anonymousId == internalId
            ? profileManager.create()
            : profileManager.binding()
        
        cancellable = request
            .map { [cardsManager] _ -> AnyPublisher<Void, Error> in
                let categories = cardsManager.makeCategories(forceUpdate: true)
                    .mapToVoid()
                
                let grades = cardsManager.makeGrades(forceUpdate: true)
                    .mapToVoid()
                
                return Publishers.Zip(categories, grades)
                    .mapToVoid()
            }
            .switchToLatest()
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                if case .failure = completion {
                    self?.screenState = .error
                }
            }, receiveValue: { [weak self] _ in
                self?.makeStartRoute()
            })
            
    }
}
