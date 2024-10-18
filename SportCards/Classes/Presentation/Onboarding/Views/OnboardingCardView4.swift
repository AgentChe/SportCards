//
//  OnboardingCardView4.swift
//  SportCards
//
//  Created by Vitaliy Zagorodnov on 28.09.2024.
//

import SwiftUI

struct OnboardingCardView4: View {
    
    let categories: [CardCategory]
    @Binding var selected: Set<CardCategory>
    let continueAction: () -> Void
    
    var body: some View {
        VStack(spacing: 0) {
            Image("Onboarding4")
                .padding(.top, ScreenSize.isIphoneXFamily ? 40.scale : 20.scale)
            
            Text("Onboarding.Title4".localized.attributed(with: .onboardingTitle))
                .multilineTextAlignment(.center)
                .lineSpacing(5.scale)
                .padding(.top, 24.scale)
            
            TagLayout(spacing: 16.scale) {
                ForEach(categories, id: \.self) { item in
                    Button(
                        action: { tagAction(for: item) },
                        label: {
                            TagView(item.name,
                                isSelected: selected.contains(item)
                            )
                            .tagStyle(.checkbox)
                        }
                    )
                }
            }
            .padding(.top, 40.scale)
            Spacer()
            
            Button(
                action: { continueAction() },
                label: { Text("Continue".localized) }
            )
            .buttonStyle(.button(.primary))
            .padding(.bottom, 20.scale)
            .disabled(selected.isEmpty)
        }
        .padding(.horizontal, 16.scale)
        .background(.black)
    }
    
    private func tagAction(for item: CardCategory) {
        if selected.contains(item) {
            selected.remove(item)
        } else {
            selected.insert(item)
        }
    }
}

#Preview {
    OnboardingCardView4(categories: [], selected: .constant([]), continueAction: {  })
}
