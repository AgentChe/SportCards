//
//  Game.swift
//  SportCards
//
//  Created by Vitaliy Zagorodnov on 29.09.2024.
//

import Foundation

enum Game: CaseIterable {
    case allGames
    case baseball
    case basketball
    case mma
    case football
    case racing
    case soccer
    case hockey
    case wresting
    
    var name: String {
        switch self {
        case .allGames:
            "Onboarding.Tag.AllGames".localized
        case .baseball:
            "Onboarding.Tag.Baseball".localized
        case .basketball:
            "Onboarding.Tag.Basketball".localized
        case .mma:
            "Onboarding.Tag.MMA".localized
        case .football:
            "Onboarding.Tag.Football".localized
        case .racing:
            "Onboarding.Tag.Racing".localized
        case .soccer:
            "Onboarding.Tag.Soccer".localized
        case .hockey:
            "Onboarding.Tag.Hockey".localized
        case .wresting:
            "Onboarding.Tag.Wresting".localized
        }
    }
}
