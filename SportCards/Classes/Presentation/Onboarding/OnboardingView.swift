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
    
    var body: some View {
        VStack(spacing: 0) {
            OnboardingPageIndicatorView(pages: $viewModel.pages, current: $viewModel.currentPage)
                .padding(.horizontal, 16.scale)
                .padding(.top, ScreenSize.isIphoneXFamily ? 44.scale : 0)

            counfigurePage(for: viewModel.currentPage)
                .transition(.asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .leading)))
        }
        .animation(.default, value: viewModel.currentPage)
        .background(.black)
        .screenState($viewModel.screenState, tryAgain: viewModel.saveData)
        .onReceive(viewModel.$isFinish) { value in
            if value {
                manager.finishOnboarding()
            }
        }
    }
    
    @ViewBuilder
    private func counfigurePage(for item: OnboardingPageItem) -> some View {
        switch item {
        case .onboarding1:
            OnboardingCardView1(
                continueAction: viewModel.nextPage,
                skipAction: viewModel.nextPage
            )
        case .onboarding2:
            OnboardingCardView2(
                continueAction: viewModel.nextPage,
                skipAction: viewModel.nextPage
            )
        case .onboarding3:
            OnboardingCardView3(
                continueAction: viewModel.nextPage,
                skipAction: viewModel.nextPage
            )
        case .onboarding4:
            OnboardingCardView4(
                categories: viewModel.categories,
                selected: viewModel.selectedCategory,
                continueAction: { category in
                    viewModel.selectedCategory = category
                    viewModel.nextPage()
                }
            )
        case .onboarding5:
            OnboardingCardView5(
                grades: viewModel.grades,
                continueAction: { grades in
                    viewModel.selectedGrade = grades
                    viewModel.nextPage()
                },
                skipAction: viewModel.nextPage
            )
        }
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
