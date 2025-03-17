//
//  SearchEmptyResultView.swift
//  SportCards
//
//  Created by Vitaliy Zagorodnov on 16.02.2025.
//

import SwiftUI

struct SearchEmptyResultView: View {
    var body: some View {
        VStack(spacing: 16.scale) {
            Spacer()
            Image("Onboarding4")
                .resizable()
                .frame(width: 150.scale, height: 150.scale)
            Text("Search.Empty.Title".localized)
                .font(Fonts.Inter.font(size: 22.scale, weight: .w700))
                .foregroundStyle(.mono100)
            Text("Search.Empty.Subtitle".localized)
                .font(Fonts.Inter.font(size: 16.scale, weight: .w400))
                .foregroundStyle(.mono100.opacity(0.5))
            Spacer()
        }
        .frame(maxWidth: .infinity)
        .contentShape(Rectangle())
    }
}

#Preview {
    SearchEmptyResultView()
}
