//
//  OnboardingCardView4.swift
//  SportCards
//
//  Created by Vitaliy Zagorodnov on 28.09.2024.
//

import SwiftUI

struct OnboardingCardView4: View {
    
    @Binding var selected: Set<Game>
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
                ForEach(Game.allCases, id: \.self) { item in
                    Button(
                        action: { tagAction(for: item) },
                        label: {
                            TagView(
                                title: item.name,
                                isSelected: selected.contains(item)
                            )
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
    
    private func tagAction(for item: Game) {
        if selected.contains(item) {
            selected.remove(.allGames)
            selected.remove(item)
        } else {
            selected.insert(item)
        }
        
        if selected.contains(.allGames) {
            selected = Set(Game.allCases)
        }
    }
}

struct TagView: View {
    let title: String
    let isSelected: Bool
    var body: some View {
        HStack(spacing: 6.scale) {
            Image(isSelected ? "Checkbox.Selected" : "Checkbox.Default")
                .resizable()
                .frame(width: 24.scale, height: 24.scale)
                .padding(.vertical, 8.scale)
            Text(title)
                .font(Fonts.Inter.font(size: 14.scale, weight: .w400))
                .foregroundStyle(Appearance.mono100)
        }
        .padding(.leading, 8.scale)
        .padding(.trailing, 14.scale)
        .background(Appearance.main300, in: Capsule())
        .overlay {
            Capsule()
                .stroke(lineWidth: 1.scale)
                .fill(Appearance.main200)
        }
    }
}

#Preview {
    OnboardingCardView4(selected: .constant([]), continueAction: {  })
}
