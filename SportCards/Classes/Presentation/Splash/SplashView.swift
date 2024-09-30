//
//  SplashView.swift
//  SportCards
//
//  Created by Vitaliy Zagorodnov on 29.09.2024.
//

import SwiftUI

enum SplashRouter: Hashable {
    case splash
    case onboarding
    case home
}

struct SplashView: View {
    var body: some View {
        VStack {
            Image("Splash")
                .padding(.top, ScreenSize.isIphoneXFamily ? 104.scale : 84.scale)
                .padding(.bottom, ScreenSize.isIphoneXFamily ? 46.scale : 26.scale)
            
            Text("Splash.Title".localized.attributed(with: .onboardingTitle))
                .multilineTextAlignment(.center)
                .lineSpacing(5.scale)
                .padding(.bottom, 24.scale)
            
            Text("Splash.Subtitle".localized.attributed(with: .onboardingSubtitle))
                .multilineTextAlignment(.center)
                .lineSpacing(10.scale)
            
            Spacer()
            LoaderView()
                .frame(width: 40.scale, height: 40.scale)
                .padding(.bottom, 56.scale)
                .foregroundStyle(.white)
        }
        .frame(maxWidth: .infinity)
        .padding(.horizontal, 16.scale)
        .background(.black)
    }
}


struct LoaderView: View {
    @State var isLoading = false
    var body: some View {
        Image("Loader")
            .resizable()
            .rotationEffect(isLoading ? .degrees(-360) : .degrees(0))
        .task {
            withAnimation(.linear(duration: 1).speed(0.8).repeatForever(autoreverses: false)) {
                isLoading = true
            }
        }
    }
}
#Preview {
    SplashView()
}
