//
//  RootView.swift
//  SportCards
//
//  Created by Vitaliy Zagorodnov on 27.10.2024.
//

import SwiftUI

struct RootView: View {
    @StateObject private var manager = RootViewManager()
    
    var body: some View {
        ZStack {
            switch manager.currentRoute {
            case .splash:
                SplashView()
                    .task { manager.makeInitialize() }
                    .screenState($manager.screenState, tryAgain: manager.login)
                    .transition(.opacity)
            case .onboarding:
                OnboardingView()
                    .environmentObject(manager)
            case .home:
                MainTabView()
                    .transition(.opacity)
            }
        }
        .background(.black)
        .animation(.easeOut, value: manager.currentRoute)
    }
}
