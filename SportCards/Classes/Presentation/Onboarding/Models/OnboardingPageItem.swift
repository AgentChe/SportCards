//
//  OnboardingPageItem.swift
//  SportCards
//
//  Created by Vitaliy Zagorodnov on 28.09.2024.
//

import Foundation

enum OnboardingPageItem: CaseIterable, Identifiable {
    case onboarding1
    case onboarding2
    case onboarding3
    case onboarding4
    case onboarding5
    
    var id: Self { self }
}
