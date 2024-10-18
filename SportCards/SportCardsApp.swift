//
//  SportCardsApp.swift
//  SportCards
//
//  Created by Vitaliy Zagorodnov on 27.09.2024.
//

import SwiftUI

@main
struct SportCardsApp: App {
    var body: some Scene {
        WindowGroup {
            RootView()
        }
    }
}
struct RootView: View {
    @StateObject private var manager = RootViewManager()
    var body: some View {
        ZStack {
            switch manager.currentRoute {
            case .splash:
                SplashView()
                    .task { manager.makeInitialize() }
                    .tryAgain(error: $manager.error) { manager.login() }
                    .transition(.opacity)
            case .onboarding:
                OnboardingView().environmentObject(manager)
            case .home:
                MainTabView()
                    .transition(.opacity)
            }
        }
    }
}

import Combine

final class RootViewManager: ObservableObject {
    @Published var currentRoute: SplashRouter = .splash
    @AppStorage("showedOnboarding") private var isShowedOnboarding: Bool = false
    @Published var error: ErrorScreenType? = nil
    
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
        // TODO: FIX ME
//        sdkInitialize.observe { [weak self] in
//            self?.login()
//        }
        login()
    }
    
    func login() {
        let anonymousId = sessionManager.anonymousId
        let internalId = sessionManager.internalId
        
        let request = anonymousId == internalId
            ? profileManager.create()
            : profileManager.binding()
        
        cancellable = request
            .map { [cardsManager] _ -> AnyPublisher<Void, NetworkError> in
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
                // TODO: FIX ME
//                if case let .failure(error) = completion {
//                    self?.error = .request
//                }
                self?.makeStartRoute()
            }, receiveValue: { [weak self] _ in
                self?.makeStartRoute()
            })
            
    }
}
