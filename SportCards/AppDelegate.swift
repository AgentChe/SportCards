//
//  AppDelegate.swift
//  SportCards
//
//  Created by Vitaliy Zagorodnov on 27.10.2024.
//

import UIKit
import OtterScaleiOS

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FacebookManager.shared.initialize(app: application, launchOptions: launchOptions)
        OtterScale.shared.initialize(host: GlobalDefinitions.otterScaleHost, apiKey: GlobalDefinitions.otterScaleApiKey)
        
        PurchaseValidationObserver.shared.startObserve()
        
        IAPManager.initialize()
        
        return true
    }
}
