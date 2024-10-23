//
//  ProgressView+Styles.swift
//  SportCards
//
//  Created by Vitaliy Zagorodnov on 21.10.2024.
//

import SwiftUI

struct SportCardsProgressStyle: ProgressViewStyle {
    @State private var rotation: Double = 0
    private let animation: Animation = .linear(duration: 1).speed(0.8).repeatForever(autoreverses: false)
    
    func makeBody(configuration: Configuration) -> some View {
        Image("Loader")
            .resizable()
            .rotationEffect(.radians(-rotation))
            .animation(animation, value: rotation)
            .task { rotation = .pi * 2 }
    }
}

extension ProgressViewStyle where Self == SportCardsProgressStyle {
    static var sportCards: Self { .init() }
}
