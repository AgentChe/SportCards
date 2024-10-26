//
//  Filters.swift
//  SportCards
//
//  Created by Vitaliy Zagorodnov on 04.10.2024.
//

import Foundation

struct Filters: Hashable {
    var price: SortType?
    var category: CardCategory?
    var grade: Grade?
    
    enum SortType: String, CaseIterable {
        case low
        case hight
    }
}

extension Filters {
    var count: Int {
        let price = price == nil ? 0 : 1
        let category = category == nil ? 0 : 1
        let grade = grade == nil ? 0 : 1
        return category + grade + price
    }
}

extension Filters.SortType {
    var name: String {
        switch self {
        case .low:
            "Filters.Sort.Low".localized
        case .hight:
            "Filters.Sort.Hight".localized
        }
    }
}
