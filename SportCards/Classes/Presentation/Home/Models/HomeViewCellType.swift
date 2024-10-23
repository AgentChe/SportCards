//
//  HomeViewCellType.swift
//  SportCards
//
//  Created by Vitaliy Zagorodnov on 01.10.2024.
//

import Foundation

enum HomeViewCellType: Hashable {
    case cardScanner
    case priceReport(PriceReport)
    case sectionTitle(String)
    case recommendedCard(CardDiscover)
    case allias([CardCategory])
    case other(OtherCardModel)
}

extension HomeViewCellType: Identifiable {
    var id: Self { self }
}
