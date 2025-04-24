//
//  GradingHelpType.swift
//  SportCards
//
//  Created by Vitaliy Zagorodnov on 23.04.2025.
//

import Foundation

enum GradingHelpType: Equatable {
    case service
    case grade
    
    var title: String {
        switch self {
        case .service:
            "Help.Service".localized
        case .grade:
            "Help.Grade".localized
        }
    }
}
