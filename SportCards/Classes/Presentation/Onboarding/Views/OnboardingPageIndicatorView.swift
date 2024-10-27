//
//  OnboardingPageIndicatorView.swift
//  SportCards
//
//  Created by Vitaliy Zagorodnov on 27.10.2024.
//

import SwiftUI

struct OnboardingPageIndicatorView: View {
    @Binding var pages: [OnboardingPageItem]
    @Binding var current: OnboardingPageItem
    
    var body: some View {
        HStack(spacing: 6.scale) {
            ForEach(pages) { page in
                Capsule()
                    .fill(current == page ? Appearance.main100 : Appearance.main300)
            }
        }
        .frame(height: 8.scale)
    }
}
