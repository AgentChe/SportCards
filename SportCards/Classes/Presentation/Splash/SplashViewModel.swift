//
//  SplashViewModel.swift
//  SportCards
//
//  Created by Vitaliy Zagorodnov on 29.09.2024.
//

import Foundation

final class SplashViewModel: ObservableObject {
    @Published var isLoaded: Bool = false
    
    func makeData() async {
        try? await Task.sleep(for: .seconds(2.0))
    }
    
    func nextRoute() -> SplashRouter {
        return .onboarding
    }
}
