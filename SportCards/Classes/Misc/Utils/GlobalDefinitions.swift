//
//  GlobalDefinitions.swift
//  SportCards
//
//  Created by Vitaliy Zagorodnov on 27.09.2024.
//

import Foundation

enum GlobalDefinitions {
    static let domain = "https://sportcards.korrekted.com"
    static let apiKey = "aB2AKoWZ6yYOcqrSO5"
    
    static let otterScaleHost = "https://api.korrekted.com"
    static let otterScaleApiKey = "Tg0hAPk5QrHx5TwQ"
    
    static let privacyPolicy: URL = URL(string: "https://sergeyapps.com/privacy-policy")!
    static let termsOfUse: URL = URL(string: "https://sergeyapps.com/terms-of-use")!
    static let support: URL = URL(string: "https://sergeyapps.com/contact")!
    
    static let applicationTag = "SPORT_CARDS"
    static let amplitudeApiKey = "d433d2c66723aeefd10c5b65f91c1fa3"
    
    enum Paygate {
        static let yearly = "sj.sportcards.yearly"
        static let weekly = "sj.sportcards.weekly"
    }
}
