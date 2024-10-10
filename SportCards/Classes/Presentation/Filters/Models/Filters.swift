//
//  Filters.swift
//  SportCards
//
//  Created by Vitaliy Zagorodnov on 04.10.2024.
//

import Foundation

struct Filters {
    var price: SortType?
    var category: Set<Alias>
    var grade: Set<Grade>
    
    enum SortType: String, CaseIterable {
        case low
        case hight
    }
}

extension Filters {
    init() {
        price = nil
        category = []
        grade = []
    }
    
    var count: Int {
        let price = price == nil ? 0 : 1
        return category.count + grade.count + price
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
