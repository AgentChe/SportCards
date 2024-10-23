//
//  SplashView.swift
//  SportCards
//
//  Created by Vitaliy Zagorodnov on 29.09.2024.
//

import SwiftUI

struct ViewDidLoadModifier: ViewModifier {
    @State private var isLoaded: Bool = false
    let action: () -> Void
    
    func body(content: Content) -> some View {
        content
            .onAppear {
                if !isLoaded {
                    isLoaded = true
                    action()
                }
            }
    }
}

extension View {
    func onViewDidLoad(action: @escaping () -> Void) -> some View {
        modifier(ViewDidLoadModifier(action: action))
    }
}

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
            ProgressView()
                .progressViewStyle(.sportCards)
                .frame(width: 40.scale, height: 40.scale)
                .padding(.bottom, 56.scale)
                .foregroundStyle(.white)
        }
        .frame(maxWidth: .infinity)
        .padding(.horizontal, 16.scale)
        .background(.black)
    }
}
#Preview {
    SplashView()
}
