//
//  AlertPresentation.swift
//  SportCards
//
//  Created by Vitaliy Zagorodnov on 27.10.2024.
//

import SwiftUI

extension View {
    func confirmAlert<Content>(isPresented: Binding<Bool>, @ViewBuilder content: @escaping () -> Content) -> some View where Content : View {
        modifier(AlertPresentation(isPresented: isPresented, alertContent: content))
    }
}
struct AlertPresentation<Alert: View>: ViewModifier {
    @Binding var isPresented: Bool
    var alertContent: () -> Alert
    
    func body(content: Content) -> some View {
        content
            .overlay {
                if isPresented {
                    Color.black.opacity(0.8)
                        .ignoresSafeArea()
                        .transition(.opacity)
                    
                    alertContent()
                        .padding(.horizontal, 25.scale)
                        .transition(.move(edge: .bottom).combined(with: .opacity))
                }
            }
            .animation(.bouncy(), value: isPresented)
            .navigationBarBackButtonHidden(isPresented)
    }
}
