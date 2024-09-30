//
//  OnboardingCardView1.swift
//  SportCards
//
//  Created by Vitaliy Zagorodnov on 28.09.2024.
//

import SwiftUI

struct OnboardingCardView1: View {
    let continueAction: () -> Void
    let skipAction: () -> Void
    
    var body: some View {
        VStack(spacing: 0) {
            Image("Onboarding1")
                .padding(.top, ScreenSize.isIphoneXFamily ? 54.scale : 34.scale)
                .padding(.bottom, ScreenSize.isIphoneXFamily ? 46.scale : 26.scale)
            
            Text("Onboarding.Title1".localized.attributed(with: .onboardingTitle))
                .multilineTextAlignment(.center)
                .lineSpacing(5.scale)
                .padding(.bottom, 24.scale)
            
            Text("Onboarding.Subtitle1".localized.attributed(with: .onboardingSubtitle))
                .multilineTextAlignment(.center)
                .lineSpacing(10.scale)
                .padding(.horizontal, 16.scale)
            
            Spacer()
            
            Button(
                action: continueAction,
                label: { Text("Continue".localized) }
            )
            .buttonStyle(.button(.primary))
            .padding(.bottom, 16.scale)
            
            Button(
                action: skipAction,
                label: { Text("Skip".localized) }
            )
            .buttonStyle(.button(.secondary))
            .padding(.bottom, 20.scale)
        }
        .padding(.horizontal, 16.scale)
        .frame(maxHeight: .infinity)
        .background(.black)
    }
}

#Preview {
    OnboardingCardView1(continueAction: {}, skipAction: {})
        .padding(.top, 8.scale)
//        .background(.black)
}
