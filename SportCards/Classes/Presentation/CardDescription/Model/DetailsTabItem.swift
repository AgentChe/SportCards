//
//  DetailsTabItem.swift
//  SportCards
//
//  Created by Vitaliy Zagorodnov on 24.10.2024.
//

import Foundation

enum DetailsTabItem: TabItemProtocol, CaseIterable {
    case sales
    case parallels
    
    var name: String {
        switch self {
        case .sales:
            "CardDetails.SalesTab".localized
        case .parallels:
            "CardDetails.ParallelsTab".localized
        }
    }
}
