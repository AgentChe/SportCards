//
//  Filters.swift
//  SportCards
//
//  Created by Vitaliy Zagorodnov on 04.10.2024.
//

import Foundation

struct Filters: Hashable {
    var price: SortType?
    var category: Set<CardCategory> = []
    var gradeService: Set<GradeService> = []
    var gradeValues: Set<String> = []
    
    enum SortType: String, CaseIterable {
        case low
        case hight
    }
}

extension Filters {
    var count: Int {
        let price = price == nil ? 0 : 1
        let category = category.count
        let gradeService = gradeService.count
        let gradeValues = gradeValues.count
        return category + gradeService + gradeValues + price
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

extension Filters {
    var gradeRequest: [String] {
        gradeService.flatMap { grade in
            guard grade.alias.uppercased() != "RAW" else { return [grade.alias] }
            let intersection = grade.values.intersection(gradeValues)
            
            guard !intersection.isEmpty else { return [grade.alias] }
            
            return intersection.map {
                "\(grade.alias) \($0)"
            }
        }
    }
}
