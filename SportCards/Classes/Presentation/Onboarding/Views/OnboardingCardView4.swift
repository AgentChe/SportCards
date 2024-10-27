//
//  OnboardingCardView4.swift
//  SportCards
//
//  Created by Vitaliy Zagorodnov on 28.09.2024.
//

import SwiftUI

struct OnboardingCardView4: View {
    
    @State private var selected: CardCategory?
    private let categories: [CardCategory]
    private let continueAction: (CardCategory?) -> Void
    
    init(categories: [CardCategory], selected: CardCategory? = nil, continueAction: @escaping (CardCategory?) -> Void) {
        self.categories = categories
        self._selected = State(initialValue: selected)
        self.continueAction = continueAction
    }
    
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
                        action: { selected = item },
                        label: { TagView(item.name, isSelected: selected == item) }
                    )
                }
            }
            .tagStyle(.checkbox)
            .padding(.top, 40.scale)
            
            Spacer()
            
            Button(
                action: { continueAction(selected) },
                label: { Text("Continue".localized) }
            )
            .buttonStyle(.button(.primary))
            .padding(.bottom, 20.scale)
            .disabled(selected == nil)
        }
        .padding(.horizontal, 16.scale)
        .background(.black)
    }
}

#Preview {
    OnboardingCardView4(categories: [], selected: nil, continueAction: { _ in })
}
