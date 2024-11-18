//
//  DetailsFooterView.swift
//  SportCards
//
//  Created by Vitaliy Zagorodnov on 24.10.2024.
//

import SwiftUI

struct DetailsFooterView: View {
    @Binding var isLoading: Bool
    @Binding var isAdded: Bool
    private var action: () -> Void
    
    init(isLoading: Binding<Bool>, isAdded: Binding<Bool>, action: @escaping () -> Void) {
        self._isLoading = isLoading
        self._isAdded = isAdded
        self.action = action
    }
    
    var body: some View {
        VStack(spacing: 16.scale) {
            if isAdded {
//                buyActions
//                    .buttonStyle(.button(.primary))
                
                Button(action: action) {
                    HStack {
                        if isLoading { loader }
                        Text("CardDetails.Remove".localized)
                    }
                }
                .disabled(isLoading)
                .buttonStyle(.button(.secondary))
                
            } else {
                Button(action: action) {
                    HStack {
                        if isLoading { loader }
                        Text("CardDetails.Add".localized)
                    }
                }
                .disabled(isLoading)
                .buttonStyle(.button(.primary))
                
//                buyActions
//                    .buttonStyle(.button(.secondary))
            }
        }
    }
}

private extension DetailsFooterView {
    @ViewBuilder 
    var buyActions: some View {
        HStack(spacing: 16.scale) {
            Button(action: {}) {
                Text("CardDetails.Ebay".localized)
            }
            Button(action: {}) {
                Text("CardDetails.Pwcc".localized)
            }
        }
    }
    
    @ViewBuilder 
    var loader: some View {
        ProgressView()
            .progressViewStyle(.sportCards)
            .frame(width: 20.scale, height: 20.scale)
    }
}

#Preview {
    DetailsFooterView(isLoading: .constant(false), isAdded: .constant(false), action: {})
}
