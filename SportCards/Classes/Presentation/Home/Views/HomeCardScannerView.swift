//
//  HomeCardScannerView.swift
//  SportCards
//
//  Created by Vitaliy Zagorodnov on 04.10.2024.
//

import SwiftUI

struct HomeCardScannerView: View {
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 0) {
                Text("Home.Scanner.Title")
                    .font(Fonts.Inter.font(size: 14.scale, weight: .w400))
                    .foregroundStyle(.white)
                    .padding(.top, 4.scale)
                    .padding(.bottom, 8.scale)
                
                Text("Home.Scanner.Subtitle")
                    .multilineTextAlignment(.leading)
                    .font(Fonts.Inter.font(size: 22.scale, weight: .w700))
                    .foregroundStyle(.white)
                    .lineSpacing(4)
                    .padding(.bottom, 40.scale)
                
                NavigationLink(value: Route.scanner) {
                    Text("Home.Scanner.OpenScanner".localized)
                }
                .buttonStyle(.button(.primary))
                .fixedSize(horizontal: true, vertical: false)
            }
            .padding(16.scale)
            
            Spacer()
        }
        .background(Image("Home.Mask").resizable())
        .clipShape(RoundedRectangle(cornerRadius: 16.scale))
    }
}

#Preview {
    HomeCardScannerView()
}
