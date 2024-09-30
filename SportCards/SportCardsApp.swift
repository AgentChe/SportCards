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
        switch manager.currentRoute {
        case .splash:
            SplashView()
                .task {
                    manager.makeStartRoute()
                }
        case .onboarding:
            OnboardingView()
                .environmentObject(manager)
        case .home:
            HomeView()
        }
    }
}

final class RootViewManager: ObservableObject {
    @Published var currentRoute: SplashRouter = .splash
    @AppStorage("showedOnboarding") private var isShowedOnboarding: Bool = false
    
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
}
