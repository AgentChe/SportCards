//
//  Button+Styles.swift
//  SportCards
//
//  Created by Vitaliy Zagorodnov on 27.09.2024.
//

import SwiftUI

struct SportCardsButtonStyle: ButtonStyle {
    let buttonType: ButtonType
    @Environment(\.isEnabled) private var isEnabled
    
    enum ButtonType {
        case primary
        case secondary
        case destroy
        
        var background: Color {
            switch self {
            case .primary:
                Appearance.main100
            case .secondary:
                Appearance.main400
            case .destroy:
                Appearance.main500
            }
        }
    }
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(Fonts.Inter.font(size: 16.scale, weight: .w700))
            .foregroundStyle(Appearance.mono100.opacity(isEnabled ? 1 : 0.5))
            .frame(maxWidth: .infinity)
            .padding(16.scale)
            .background(buttonType.background, in: Capsule())
    }
}

extension ButtonStyle where Self == SportCardsButtonStyle {
    static func button(_ buttonType: SportCardsButtonStyle.ButtonType) -> Self { .init(buttonType: buttonType) }
}
