//
//  ConfirmDeleteView.swift
//  SportCards
//
//  Created by Vitaliy Zagorodnov on 23.10.2024.
//

import SwiftUI

struct ConfirmDeleteView: View {
    private let deleteAction: () -> Void
    private let cancelAction: () -> Void
    
    init(deleteAction: @escaping () -> Void, cancelAction: @escaping () -> Void) {
        self.deleteAction = deleteAction
        self.cancelAction = cancelAction
    }
    
    var body: some View {
        VStack(spacing: 0) {
            Image("Onboarding4")
                .resizable()
                .frame(width: 150.scale, height: 150.scale)
                .padding(.top, 38.scale)
                .padding(.bottom, 14.scale)
            
            Text("CardDetails.ConfirmMessage".localized)
                .font(Fonts.Inter.font(size: 16.scale, weight: .w700))
                .foregroundStyle(.mono100)
                .lineSpacing(10.scale)
                .multilineTextAlignment(.center)
                .padding(.bottom, 24.scale)
                .padding(.horizontal, 30.scale)
            
            Button(
                action: deleteAction,
                label: { Text("Delete".localized )}
            )
            .buttonStyle(.button(.destroy))
            .padding(.bottom, 12.scale)
            
            Button(
                action: cancelAction,
                label: { Text("Cancel".localized )}
            )
            .buttonStyle(.button(.secondary))
            .padding(.bottom, 24.scale)
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
    ConfirmDeleteView(deleteAction: {}, cancelAction: {})
}
