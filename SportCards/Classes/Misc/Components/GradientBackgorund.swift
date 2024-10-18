//
//  GradientBackgorund.swift
//  SportCards
//
//  Created by Vitaliy Zagorodnov on 10.10.2024.
//

import SwiftUI

struct GradientBackgorund: ViewModifier {
    func body(content: Content) -> some View {
        content
            .background(
                LinearGradient(
                    colors: [.gradientBackground, .gradientBackground.opacity(0)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .opacity(0.3)
                .background(.gradientSubstrate)
                .ignoresSafeArea()
            )
    }
}

extension View {
    func gradientBackground() -> some View {
        modifier(GradientBackgorund())
    }
}
