//
//  AlertPresentation.swift
//  SportCards
//
//  Created by Vitaliy Zagorodnov on 27.10.2024.
//

import SwiftUI

extension View {
    func confirmAlert<Content>(isPresented: Binding<Bool>, @ViewBuilder content: @escaping () -> Content) -> some View where Content : View {
        overlay {
            content().modifier(AlertPresentation(isPresented: isPresented))
        }
    }
}
struct AlertPresentation: ViewModifier {
    @Binding var isPresented: Bool
    
    func body(content: Content) -> some View {
        if isPresented {
            VStack {
                Spacer()
                content
                    .padding(.horizontal, 40.scale)
                    .transition(.asymmetric(insertion: .move(edge: .bottom), removal: .move(edge: .bottom)))
                Spacer()
            }
            .background(Color.black.opacity(0.8))
            .ignoresSafeArea()
        }
    }
}
