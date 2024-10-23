//
//  OnboardingView.swift
//  SportCards
//
//  Created by Vitaliy Zagorodnov on 27.09.2024.
//

import SwiftUI

struct OnboardingView: View {
    @StateObject private var viewModel = OnboardingViewModel()
    @EnvironmentObject private var manager: RootViewManager
    @State private var currentIndex: Int = 0
    private let items = OnboardingPageItem.allCases
    
    var body: some View {
        VStack(spacing: 0) {
            OnboardingPageIndicatorView(count: items.count, currentIndex: $currentIndex)
                .padding(.horizontal, 16.scale)
                .padding(.top, ScreenSize.isIphoneXFamily ? 44.scale : 0)
            TabView(selection: $currentIndex) {
                ForEach(items, id: \.self) { item in
                    counfigurePage(for: item)
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
        }
        .background(.black)
    }
    
    @ViewBuilder
    private func counfigurePage(for item: OnboardingPageItem) -> some View {
        switch item {
        case .onboarding1:
            OnboardingCardView1(continueAction: nextPage, skipAction: nextPage)
                .tag(0)
        case .onboarding2:
            OnboardingCardView2(continueAction: nextPage, skipAction: nextPage)
                .tag(1)
        case .onboarding3:
            OnboardingCardView3(continueAction: nextPage, skipAction: nextPage)
                .tag(2)
        case .onboarding4:
            OnboardingCardView4(
                categories: viewModel.categories,
                selected: $viewModel.selectedCategories,
                continueAction: nextPage
            )
            .tag(3)
        case .onboarding5:
            OnboardingCardView5(
                grades: viewModel.grades,
                continueAction: { grades in
                    viewModel.selectedGrades = grades
                    nextPage()
                }, 
                skipAction: nextPage
            )
            .tag(4)
        }
    }
    
    private func nextPage() {
        withAnimation {
            if currentIndex + 1 <= items.count - 1 {
                    currentIndex += 1
            } else {
                manager.finishOnboarding()
            }
        }
    }
}

struct OnboardingPageIndicatorView: View {
    let count: Int
    @Binding var currentIndex: Int
    var body: some View {
        HStack(spacing: 6.scale) {
            ForEach(0..<count, id: \.self) { index in
                Capsule()
                    .fill(index <= currentIndex ? Appearance.main100 : Appearance.main300)
            }
        }
        .frame(height: 8.scale)
    }
}


extension TextAttributes {
    static let onboardingTitle = TextAttributes()
        .font(Fonts.Inter.font(size: 24.scale, weight: .w700))
        .textColor(Appearance.mono100)
        .textAlignment(.center)
    
    static let onboardingSubtitle = TextAttributes()
        .font(Fonts.Inter.font(size: 18.scale, weight: .w400))
        .textColor(Appearance.mono100)
}

#Preview {
    OnboardingView()
        .environmentObject(RootViewManager())
}
