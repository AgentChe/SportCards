//
//  OnboardingCardView5.swift
//  SportCards
//
//  Created by Vitaliy Zagorodnov on 29.09.2024.
//

import SwiftUI

struct OnboardingCardView5: View {
    private let grades: [Grade]
    private let continueAction: (Grade?) -> Void
    private let skipAction: () -> Void
    
    
    @State private var selected: Grade?
    
    init(grades: [Grade], selected: Grade? = nil, continueAction: @escaping (Grade?) -> Void, skipAction: @escaping () -> Void) {
        self.grades = grades
        self._selected = State(initialValue: selected)
        self.continueAction = continueAction
        self.skipAction = skipAction
    }
    
    var body: some View {
        VStack(spacing: 0) {
            Image("Onboarding4")
                .padding(.top, ScreenSize.isIphoneXFamily ? 40.scale : 20.scale)
                .padding(.horizontal, 16.scale)
            
            Text("Onboarding.Title5".localized.attributed(with: .onboardingTitle))
                .multilineTextAlignment(.center)
                .lineSpacing(5.scale)
                .padding(.top, 24.scale)
                .padding(.horizontal, 32.scale)
                .padding(.bottom, ScreenSize.isIphoneXFamily ? 40.scale : 20.scale)
            
            ScrollView(.vertical) {
                LazyVStack(spacing: 16.scale) {
                    ForEach(grades, id: \.self) { grage in
                        Button(
                            action: { selected = grage },
                            label: { GradeView(grade: grage, isSelected: selected == grage) }
                        )
                    }
                }
                .padding(.horizontal, 16.scale)
                .padding(.top, 5.scale)
            }
            .padding(.bottom, 18.scale)
            
            Button(
                action: { continueAction(selected) },
                label: { Text("Continue".localized) }
            )
            .buttonStyle(.button(.primary))
            .padding(.bottom, 16.scale)
            .padding(.horizontal, 16.scale)
            
            Button(
                action: skipAction,
                label: { Text("Skip".localized) }
            )
            .buttonStyle(.button(.secondary))
            .padding(.horizontal, 16.scale)
            .padding(.bottom, 20.scale)
        }
        .background(.black)
    }
}

struct GradeView: View {
    var grade: Grade
    var isSelected: Bool
    
    var body: some View {
        HStack(spacing: 15.scale) {
            VStack(alignment: .leading, spacing: 10.scale) {
                Text(grade.alias)
                    .font(Fonts.Inter.font(size: 14.scale, weight: .w700))
                    .lineSpacing(8.scale)
                if isSelected {
                    Text(grade.name)
                        .font(Fonts.Inter.font(size: 14.scale, weight: .w400))
                        .lineSpacing(8.scale)
                }
            }
            .multilineTextAlignment(.leading)
            .foregroundStyle(Appearance.mono100)
            
            Spacer()
            
            Image(isSelected ? "Checkbox.Selected" : "Checkbox.Default")
        }
        .padding(16.scale)
        .background(isSelected ? .main400 : .black)
        .clipShape(RoundedRectangle(cornerRadius: 12.scale))
        .overlay {
            RoundedRectangle(cornerRadius: 12.scale)
                .stroke(.main200, lineWidth: 1.scale)
        }
    }
}

#Preview {
    OnboardingCardView5(grades: [], continueAction: { _ in }, skipAction: {})
}
