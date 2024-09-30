//
//  OnboardingViewModel.swift
//  SportCards
//
//  Created by Vitaliy Zagorodnov on 29.09.2024.
//

import Foundation

final class OnboardingViewModel: ObservableObject {
    @Published var games: Set<Game> = []
    @Published var grades: Set<Grade> = []
}
