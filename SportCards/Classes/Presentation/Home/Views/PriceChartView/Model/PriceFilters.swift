//
//  PriceFilters.swift
//  SportCards
//
//  Created by Vitaliy Zagorodnov on 02.10.2024.
//

import Foundation

enum PriceFilters: CaseIterable, Hashable {
    case today
    case week
    case twoWeek
    case month
    
    var name: String {
        switch self {
        case .today:
            "Today".localized
        case .week:
            "Week".localized
        case .twoWeek:
            "14 days".localized
        case .month:
            "Month".localized
        }
    }
}
