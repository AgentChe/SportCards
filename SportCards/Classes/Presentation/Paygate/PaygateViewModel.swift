//
//  PaygateViewModel.swift
//  SportCards
//
//  Created by Vitaliy Zagorodnov on 30.09.2024.
//

import Foundation

final class PaygateViewModel: ObservableObject {
    @Published var isOnTrial: Bool = true
    @Published var currentProduct: PaygateProduct = .trial
    
    init() {
        $isOnTrial
            .map { $0 ? .trial : .yearly }
            .assign(to: &$currentProduct)
    }
}
