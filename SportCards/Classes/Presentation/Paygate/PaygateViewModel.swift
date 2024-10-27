//
//  PaygateViewModel.swift
//  SportCards
//
//  Created by Vitaliy Zagorodnov on 30.09.2024.
//

import Foundation
import Combine

final class PaygateViewModel: ObservableObject {
    typealias Products = (yearly: ProductPrice, weekly: ProductPrice)
    
    @Published var isOnTrial: Bool = true
    @Published var currentProduct: PaygateProduct = .trial
    @Published var products: Products? = nil
    @Published var isLoading: Bool = true
    @Published var showError: Bool = false
    @Published var dismiss: Bool = false
    
    private lazy var iapManager = IAPManager()
    private lazy var paygateInteractor = PaygateInteractor()
    private lazy var buyProductSubject = PassthroughSubject<ProductPrice, Never>()
    private lazy var restoreSubject = PassthroughSubject<Void, Never>()
    
    init() {
        $isOnTrial
            .map { $0 ? .trial : .yearly }
            .assign(to: &$currentProduct)
        
        makeProducts()
            .map { $0 }
            .receive(on: DispatchQueue.main)
            .handleEvents(receiveOutput: { [weak self] _ in
                self?.isLoading = false
            })
            .assign(to: &$products)
        
        let buy = buyProductSubject
            .map { [paygateInteractor] product in
                paygateInteractor
                    .makeActiveSubscription(by: .buy(product.id))
                    .map { result -> Bool in
                        switch result {
                        case .completed(let response):
                            return response
                        case .cancelled:
                            return false
                        }
                    }
                    .replaceError(with: false)
            }
            .switchToLatest()
            
        let restore = restoreSubject
            .map { [paygateInteractor] _ in
                paygateInteractor
                    .makeActiveSubscription(by: .restore)
                    .map { result -> Bool in
                        switch result {
                        case .completed(let response):
                            return response
                        case .cancelled:
                            return false
                        }
                    }
                    .replaceError(with: false)
            }
            .switchToLatest()
        
        let result = Publishers
            .Merge(buy, restore)
            .share()
        
        result
            .map { _ in false }
            .receive(on: DispatchQueue.main)
            .assign(to: &$isLoading)
        
        result
            .map { !$0 }
            .receive(on: DispatchQueue.main)
            .assign(to: &$showError)
        
        result
            .filter { $0 }
            .receive(on: DispatchQueue.main)
            .assign(to: &$dismiss)
    }
    
    func makeProducts() -> AnyPublisher<Products, Never> {
        iapManager
            .obtainPrices(for: [
                GlobalDefinitions.Paygate.yearly,
                GlobalDefinitions.Paygate.weekly
            ])
            .compactMap { prices -> Products? in
                guard
                    let yearly = prices.first(where: { $0.id == GlobalDefinitions.Paygate.yearly }),
                    let weekly = prices.first(where: { $0.id == GlobalDefinitions.Paygate.weekly })
                else {
                    return nil
                }

                return (yearly: yearly, weekly: weekly)
            }
            .eraseToAnyPublisher()
    }
    
    func makeRestored() {
        restoreSubject.send(())
    }
    
    func byProduct() {
        switch currentProduct {
        case .trial:
            if let product = products?.weekly {
                isLoading = true
                buyProductSubject.send(product)
            }
        case .yearly:
            if let product = products?.yearly {
                isLoading = true
                buyProductSubject.send(product)
            }
        }
    }
}
