//
//  FastFilterType.swift
//  SportCards
//
//  Created by Vitaliy Zagorodnov on 23.04.2025.
//

import Foundation

enum FastFilterType: Equatable, Identifiable, CaseIterable {
    case gradingService
    case grade
    case category
    
    var id: Self {
        self
    }
    
    var title: String {
        switch self {
        case .gradingService:
            "Filters.Section.GradingService".localized
        case .grade:
            "Filters.Section.Grade".localized
        case .category:
            "Filters.Section.Category".localized
        }
    }
}
