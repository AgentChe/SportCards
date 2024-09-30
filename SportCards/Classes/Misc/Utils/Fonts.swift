//
//  Fonts.swift
//  SportCards
//
//  Created by Vitaliy Zagorodnov on 27.09.2024.
//

import UIKit
import SwiftUI

enum Fonts {
    enum Inter {
        static func font(size: CGFloat, weight: Weight) -> UIFont {
            UIFont(name: weight.name, size: size)!
        }
        
        static func font(size: CGFloat, weight: Weight) -> Font {
            Font(font(size: size, weight: weight))
        }
        
        enum Weight {
            case w400
            case w500
            case w600
            case w700
            
            var name: String {
                switch self {
                case .w400:
                    return "Inter-Regular"
                case .w500:
                    return "Inter-Medium"
                case .w600:
                    return "Inter-SemiBold"
                case .w700:
                    return "Inter-Bold"
                }
            }
        }
    }
}
