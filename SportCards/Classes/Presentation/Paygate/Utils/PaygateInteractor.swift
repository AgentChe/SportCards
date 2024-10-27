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
    
    private lazy var cancellables: Set<AnyCancellable> = []
    
    private lazy var callback = PassthroughSubject<PurchaseActionResult, Never>()
    
    deinit {
        OtterScale.shared.removeReceiptValidation(delegate: self)
        
        cancellables.forEach { $0.cancel() }
    }
}

// MARK: Public
extension PaygateInteractor {
    func makeActiveSubscription(by action: Action) -> AnyPublisher<PurchaseActionResult, Never> {
        OtterScale.shared.removeReceiptValidation(delegate: self)
        OtterScale.shared.addReceiptValidation(delegate: self)
        
        cancellables.forEach { $0.cancel() }
        
        let cancellable: AnyCancellable
        switch action {
        case .buy(let productId):
            cancellable = purchase(productId: productId)
        case .restore:
            cancellable = restore()
        }
        
        cancellables = [cancellable]
        
        return Deferred { [weak self] in
            Future { [weak self] promise in
                let cancellable = self?.callback.sink(receiveValue: {
                    promise(.success($0))
                })
                if let cancellable {
                    self?.cancellables.insert(cancellable)
                }
            }
        }
        .eraseToAnyPublisher()
    }
}

// MARK: OtterScaleReceiptValidationDelegate
extension PaygateInteractor: OtterScaleReceiptValidationDelegate {
    func otterScaleDidValidatedReceipt(with result: AppStoreValidateResult?) {
        OtterScale.shared.removeReceiptValidation(delegate: self)
        
        let hasActiveSubscriptions = sessionManager.hasActiveSubscriptions()
        let callbackResult = PurchaseActionResult.completed(hasActiveSubscriptions)
        callback.send(callbackResult)
    }
}

// MARK: Private
private extension PaygateInteractor {
    func purchase(productId: String) -> AnyCancellable {
        iapManager
            .buyProduct(with: productId)
            .sink(
                receiveCompletion: { _ in },
                receiveValue: { [weak self] result in
                    self?.callback.send(.cancelled)
                })
    }
    
    func restore() -> AnyCancellable {
        iapManager
            .restorePurchases()
            .sink(
                receiveCompletion: { [weak self] completion in
                    if case .failure = completion {
                        self?.callback.send(.completed(false))
                    }
                },
                receiveValue: {}
            )
    }
}
