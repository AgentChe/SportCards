//
//  MainTabType.swift
//  SportCards
//
//  Created by Vitaliy Zagorodnov on 03.10.2024.
//

import Foundation

enum MainTabType: CaseIterable, Hashable, Identifiable {
    case home
    case collection
    
    var id: Self { self }
}
