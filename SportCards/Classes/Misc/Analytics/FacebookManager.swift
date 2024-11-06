//
//  FacebookManager.swift
//  Soccer
//
//  Created by Андрей Чернышев on 29.03.2022.
//

import FBSDKCoreKit
import OtterScaleiOS
import StoreKit
import Combine

final class FacebookManager: NSObject {
    deinit {
        SKPaymentQueue.default().remove(self)
    }
    
    static let shared = FacebookManager()
    
    private lazy var iapManager = IAPManager()
    private var cancellable: Set<AnyCancellable> = []
    
    private override init() {
        super.init()
    }
}

// MARK: OtterScaleReceiptValidationDelegate
extension FacebookManager: OtterScaleReceiptValidationDelegate {
    func otterScaleDidValidatedReceipt(with result: AppStoreValidateResult?) {
        guard let otterScaleID = result?.externalUserID ?? result?.internalUserID else {
            return
        }
        
        guard otterScaleID != OtterScale.shared.getAnonymousID() else {
            return
        }
        
        set(userID: otterScaleID)
        
        logEvent(name: "client_user_id_synced")
    }
}

// MARK: SKPaymentTransactionObserver
extension FacebookManager: SKPaymentTransactionObserver {
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        let purchased = transactions
            .filter { $0.transactionState == .purchased }
        
        guard !purchased.isEmpty else {
            return
        }
        
        let ids = purchased.map { $0.payment.productIdentifier }
        iapManager.obtainProducts(ids: ids)
            .sink { products in
                products.forEach { product in
                    let currency = product.original.priceLocale.currency?.identifier ?? "unknown"
                    
                    AppEvents.shared.logPurchase(amount: 0, currency: currency)
                }
            }
            .store(in: &cancellable)
    }
}

// MARK: Public
extension FacebookManager {
    func initialize(app: UIApplication, launchOptions: [UIApplication.LaunchOptionsKey: Any]?) {
        ApplicationDelegate.shared.application(app, didFinishLaunchingWithOptions: launchOptions)
        
        Settings.shared.isAdvertiserTrackingEnabled = true
        
        AppEvents.shared.activateApp()
        
        OtterScale.shared.addReceiptValidation(delegate: self)
        SKPaymentQueue.default().add(self)
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) {
        ApplicationDelegate.shared.application(app, open: url, options: options)
    }
    
    func set(userID: String) {
        AppEvents.shared.userID = userID
    }
    
    func logEvent(name: String) {
        let eventName = AppEvents.Name(name)
        AppEvents.shared.logEvent(eventName)
    }
}
