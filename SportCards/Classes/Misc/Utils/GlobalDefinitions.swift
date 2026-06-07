//
//  GlobalDefinitions.swift
//  SportCards
//
//  Created by Vitaliy Zagorodnov on 27.09.2024.
//

import Foundation

enum GlobalDefinitions {
    static let domain = "https://sportcards.thinkaboutapps.com"
    static let apiKey = "aB2AKoWZ6yYOcqrSO5"
    
    static let otterScaleHost = "https://api.korrekted.com"
    static let otterScaleApiKey = "Tg0hAPk5QrHx5TwQ"
    
    static let termsOfServiceUrl = URL(string: "https://thinkaboutapps.com/terms")!
    static let privacyPolicyUrl = URL(string: "https://thinkaboutapps.com/policy")!
    static let contactUsUrl = URL(string: "https://thinkaboutapps.com/contact")!
    
    enum Paygate {
        static let yearly = "sj.sportcards.yearly"
        static let weekly = "sj.sportcards.weekly"
    }
}
