//
//  CollectionTab.swift
//  SportCards
//
//  Created by Vitaliy Zagorodnov on 07.10.2024.
//

import Foundation

enum CollectionTab: String, CaseIterable {
    case scanned = "scan"
    case wishList = "collect"
}

extension CollectionTab: TabItemProtocol {
    var name: String {
        switch self {
        case .scanned:
            "Collection.Tab.Scanned".localized
        case .wishList:
            "Collection.Tab.WishList".localized
        }
    }
}
