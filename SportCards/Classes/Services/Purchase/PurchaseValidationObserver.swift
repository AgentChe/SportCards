//
//  PurchaseValidationObserver.swift
//  Soccer
//
//  Created by Андрей Чернышев on 03.02.2022.
//

import OtterScaleiOS
import Combine

final class PurchaseValidationObserver {
    static let shared = PurchaseValidationObserver()
    
    private lazy var trigger = PassthroughSubject<Void, Never>()
    
    private init() {}
    
    func startObserve() {
        OtterScale.shared.addReceiptValidation(delegate: self)
    }
}

// MARK: OtterScaleReceiptValidationDelegate
extension PurchaseValidationObserver: OtterScaleReceiptValidationDelegate {
    func otterScaleDidValidatedReceipt(with result: AppStoreValidateResult?) {
        trigger.send(())
    }
}

// MARK: Public
extension PurchaseValidationObserver {
    var didValidatedWithActiveSubscription: AnyPublisher<Void, Never> {
        trigger.eraseToAnyPublisher()
    }
}
