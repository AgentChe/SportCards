//
//  DetectCardErrorAlert.swift
//  SportCards
//
//  Created by Vitaliy Zagorodnov on 17.10.2024.
//

import SwiftUI

struct DetectCardErrorAlert: View {
    private let primaryAction: () -> Void
    private let secondaryAction: () -> Void
    
    init(primaryAction: @escaping () -> Void, secondaryAction: @escaping () -> Void) {
        self.primaryAction = primaryAction
        self.secondaryAction = secondaryAction
    }
    
    var body: some View {
        VStack(spacing: 0) {
            Image("Scanner.Alert.Icon")
                .resizable()
                .frame(width: 108.scale, height: 108.scale)
                .padding(.top, 30.scale)
                .padding(.bottom, 24.scale)
            
            Text("CardScanner.Error.Title".localized)
                .multilineTextAlignment(.center)
                .font(Fonts.Inter.font(size: 16.scale, weight: .w700))
                .foregroundStyle(.mono100)
                .padding(.bottom, 10.scale)
            
            Text("CardScanner.Error.Subtitle")
                .multilineTextAlignment(.center)
                .font(Fonts.Inter.font(size: 14.scale, weight: .w400))
                .lineSpacing(2.scale)
                .foregroundStyle(.white)
                .padding(.bottom, 22.scale)
            
            Button(
                action: primaryAction,
                label: { Text("CardScanner.Error.PrimaryAction".localized) }
            )
            .buttonStyle(.button(.primary))
            
            Button(
                action: secondaryAction,
                label: { Text("CardScanner.Error.SecondaryAction".localized) }
            )
            .buttonStyle(.button(.secondary))
            .padding(.bottom, 24.scale)
            .padding(.top, 12.scale)
        }
        .padding(.horizontal, 30.scale)
        .background(.gradientSubstrate, in: RoundedRectangle(cornerRadius: 16.scale))
        .overlay {
            RoundedRectangle(cornerRadius: 16.scale)
                .stroke(.main400, lineWidth: 1.scale)
        }
    }
}

#Preview {
    DetectCardErrorAlert(primaryAction: {}, secondaryAction: {})
}
