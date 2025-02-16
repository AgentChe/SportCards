//
//  CameraView.swift
//  SportCards
//
//  Created by Vitaliy Zagorodnov on 11.10.2024.
//

import SwiftUI

struct CameraView: View {
    @Binding var image: Image?
    var tapOnPoint: (CGPoint) -> Void
    
    var body: some View {
        GeometryReader { geometry in
            if let image = image {
                image
                    .resizable()
                    .scaledToFill()
                    .frame(width: geometry.size.width, height: geometry.size.height)
                    .overlay(alignment: .center) {
                        Image("Scanner.Border")
                            .resizable()
                            .padding(10.scale)
                    }
                    .onTapGesture { point in
                        let convertedPoint = CGPoint(
                            x: point.x / geometry.size.width,
                            y: point.y / geometry.size.height
                        )
                        tapOnPoint(convertedPoint)
                    }
            }
        }
        
    }
}

#Preview {
    CameraView(image: .constant(Image(systemName: "arrow.triangle.2.circlepath")), tapOnPoint: { _ in })
}
