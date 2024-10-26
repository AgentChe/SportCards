//
//  CardCollectionEmptyView.swift
//  SportCards
//
//  Created by Vitaliy Zagorodnov on 10.10.2024.
//

import SwiftUI

struct CardCollectionEmptyView: View {
    var body: some View {
        VStack(spacing: 16.scale) {
            Spacer()
            Image("Onboarding4")
                .resizable()
                .frame(width: 150.scale, height: 150.scale)
            Text("Collection.Empty.Title".localized)
                .font(Fonts.Inter.font(size: 22.scale, weight: .w700))
                .foregroundStyle(.mono100)
            Text("Collection.Empty.Subtitle".localized)
                .font(Fonts.Inter.font(size: 16.scale, weight: .w400))
                .foregroundStyle(.mono100.opacity(0.5))
            Spacer()
        }
        .frame(maxWidth: .infinity)
    }
}

#Preview {
    CardCollectionEmptyView()
}
