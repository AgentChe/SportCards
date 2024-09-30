//
//  OnboardingCardView3.swift
//  SportCards
//
//  Created by Vitaliy Zagorodnov on 28.09.2024.
//

import SwiftUI

struct OnboardingCardView3: View {
    let continueAction: () -> Void
    let skipAction: () -> Void
    
    var body: some View {
        VStack(spacing: 0) {
            Image("Onboarding3")
                .padding(.top, ScreenSize.isIphoneXFamily ? 54.scale : 34.scale)
                .padding(.bottom, ScreenSize.isIphoneXFamily ? 46.scale : 26.scale)
            
            Text("Onboarding.Title3".localized.attributed(with: .onboardingTitle))
                .multilineTextAlignment(.center)
                .lineSpacing(5.scale)
                .padding(.bottom, 24.scale)
            
            Text("Onboarding.Subtitle3".localized.attributed(with: .onboardingSubtitle))
                .multilineTextAlignment(.center)
                .lineSpacing(10.scale)
            
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
    OnboardingCardView3(continueAction: {}, skipAction: {})
}
