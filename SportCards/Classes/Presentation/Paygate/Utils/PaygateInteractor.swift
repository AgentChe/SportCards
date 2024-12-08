//
//  PaygateInteractor.swift
//  CodeChallenge
//
//  Created by Андрей Чернышев on 20.02.2024.
//

import Combine
import OtterScaleiOS

final class PaygateInteractor {
    enum Action {
        case buy(String)
        case restore
    }
    
    enum PurchaseActionResult {
        case cancelled
        case completed(Bool)
    }
    
    private lazy var iapManager = IAPManager()
    private lazy var sessionManager = SessionManager()
    private lazy var profileManager = ProfileManager()
    
    private var cancellable: AnyCancellable?
    
    private lazy var callback = PassthroughSubject<PurchaseActionResult, Never>()
    
    deinit {
        OtterScale.shared.removeReceiptValidation(delegate: self)
        
        cancellable = nil
    }
}

// MARK: Public
extension PaygateInteractor {
    func makeActiveSubscription(by action: Action) -> AnyPublisher<PurchaseActionResult, Never> {
        OtterScale.shared.removeReceiptValidation(delegate: self)
        OtterScale.shared.addReceiptValidation(delegate: self)
        
        cancellable = nil
        
        let publisher: AnyPublisher<PurchaseActionResult, Never>
        switch action {
        case .buy(let productId):
            publisher = purchase(productId: productId)
        case .restore:
            publisher = restore()
        }
        
        return Publishers
            .Merge(publisher, callback.eraseToAnyPublisher())
            .eraseToAnyPublisher()
    }
}

// MARK: OtterScaleReceiptValidationDelegate
extension PaygateInteractor: OtterScaleReceiptValidationDelegate {
    func otterScaleDidValidatedReceipt(with result: AppStoreValidateResult?) {
        OtterScale.shared.removeReceiptValidation(delegate: self)
        
        let anonymousId = sessionManager.anonymousId
        let internalId = sessionManager.internalId
        
        let request = anonymousId == internalId
            ? profileManager.create()
            : profileManager.binding()
        
        cancellable = request
            .print()
            .mapToVoid()
            .replaceError(with: ())
            .sink(receiveValue: { [weak self] _ in
                guard let self else { return }
                let hasActiveSubscriptions = sessionManager.hasActiveSubscriptions()
                let callbackResult = PurchaseActionResult.completed(hasActiveSubscriptions)
                callback.send(callbackResult)
            })
    }
}


// MARK: Private
private extension PaygateInteractor {
    func purchase(productId: String) -> AnyPublisher<PurchaseActionResult, Never> {
        iapManager
            .buyProduct(with: productId)
            .compactMap { result -> PurchaseActionResult? in
                guard case .cancelled = result else {
                    return nil
                }
                return .cancelled
            }
            .replaceError(with: .completed(false))
            .eraseToAnyPublisher()
    }
    
    func restore() -> AnyPublisher<PurchaseActionResult, Never> {
        iapManager
            .restorePurchases()
            .compactMap { _ -> PurchaseActionResult? in
                return nil
            }
            .replaceError(with: .completed(false))
            .eraseToAnyPublisher()
    }
}
