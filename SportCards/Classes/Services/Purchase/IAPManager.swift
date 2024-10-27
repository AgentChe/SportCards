//
//  IAPManager.swift
//  Soccer
//
//  Created by Андрей Чернышев on 03.02.2022.
//

import SwiftyStoreKit
import StoreKit
import Combine

final class IAPManager {}

// MARK: Public
extension IAPManager {
    static func initialize() {
        SwiftyStoreKit.completeTransactions { purchases in
            for purchase in purchases {
                let state = purchase.transaction.transactionState
                if state == .purchased || state == .restored {
                    SwiftyStoreKit.finishTransaction(purchase.transaction)
                }
            }
        }
        
        SwiftyStoreKit.shouldAddStorePaymentHandler = { _, _ in
            true
        }
    }
    
    func obtainProducts(ids: [String]) -> AnyPublisher<[IAPProduct], Never> {
        Deferred {
            Future { promise in
                SwiftyStoreKit.retrieveProductsInfo(Set(ids)) { result in
                    let products = result.retrievedProducts.map { IAPProduct(original: $0) }
                    
                    promise(.success(products))
                }
            }
        }
        .eraseToAnyPublisher()
    }
    
    func obtainPrices(for ids: [String]) -> AnyPublisher<[ProductPrice], Never> {
        Deferred {
            Future { promise in
                SwiftyStoreKit.retrieveProductsInfo(Set(ids)) { results in
                    let prices = results.retrievedProducts.map { product -> ProductPrice in
                        ProductPrice(product: product)
                    }
                    
                    promise(.success(prices))
                }
            }
        }
        .eraseToAnyPublisher()
    }
    
    func buyProduct(with id: String) -> AnyPublisher<IAPActionResult, IAPError> {
        guard SwiftyStoreKit.canMakePayments else {
            return Fail(error: IAPError(.paymentsDisabled)).eraseToAnyPublisher()
        }
        
        return Deferred {
            Future { promise in
                SwiftyStoreKit.purchaseProduct(id, quantity: 1, atomically: true) { result in
                    switch result {
                    case .success(let purchase):
                        if purchase.productId == id {
                            promise(.success(.completed(id)))
                        }
                    case .error(let error):
                        if IAPErrorHelper.treatErrorAsCancellation(error) {
                            promise(.success(.cancelled))
                        } else if IAPErrorHelper.treatErrorAsSuccess(error) {
                            promise(.success(.completed(id)))
                        } else {
                            promise(.failure(IAPError(.paymentFailed, underlyingError: error)))
                        }
                    }
                }
            }
        }
        .eraseToAnyPublisher()
    }
    
    func restorePurchases() -> AnyPublisher<Void, IAPError> {
        Deferred {
            Future { promise in
                SwiftyStoreKit.restorePurchases { result in
                    if result.restoredPurchases.isEmpty {
                        promise(.failure(IAPError(.cannotRestorePurchases)))
                    } else {
                        promise(.success(Void()))
                    }
                }
            }
        }
        .eraseToAnyPublisher()
    }
}
