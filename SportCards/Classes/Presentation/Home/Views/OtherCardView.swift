//
//  OtherCardView.swift
//  SportCards
//
//  Created by Vitaliy Zagorodnov on 03.10.2024.
//

import SwiftUI
import NukeUI

struct OtherCardView: View {
    let model: OtherCardModel
    var body: some View {
        HStack(spacing: 0) {
            LazyImage(source: model.image) { state in
                if let image = state.image {
                    image
                        .resizingMode(.aspectFill)
                        .clipShape(RoundedRectangle(cornerRadius: 6.scale))
                } else {
                    RoundedRectangle(cornerRadius: 6.scale)
                        .fill(.main200)
                }
            }
            .frame(width: 60.scale, height: 87.scale)
            .padding(.trailing, 20.scale)
            
            VStack(alignment: .leading, spacing: 8.scale) {
                Text(model.name)
                    .font(Fonts.Inter.font(size: 16.scale, weight: .w700))
                    .lineLimit(1)
                    .foregroundStyle(.mono100)
                
                Text(model.category.name)
                    .font(Fonts.Inter.font(size: 14.scale, weight: .w400))
                    .lineLimit(1)
                    .foregroundStyle(.mono100.opacity(0.5))
            }
            
            Spacer()
            
            Text(model.grade)
                .font(Fonts.Inter.font(size: 14.scale, weight: .w400))
                .foregroundStyle(.mono100)
                .padding(.horizontal, 16.5.scale)
                .padding(.vertical, 8.scale)
                .background(.main200, in: Capsule())
                .padding(.trailing, 6.scale)
        }
        .padding(EdgeInsets(top: 8.scale, leading: 21.scale, bottom: 8.scale, trailing: 16.scale))
        .background(.main300, in: RoundedRectangle(cornerRadius: 12.scale))
        .overlay {
            RoundedRectangle(cornerRadius: 12.scale)
                .stroke(.main200, lineWidth: 1.scale)
        }
    }
}

#Preview {
    VStack(spacing: 16.scale) {
        OtherCardView(model: .init(cardId: "", category: .init(alias: "mma", name: "MMA"), image: URL(string: "https://sportscards.com/cdn/shop/products/90233_1_2000x.jpg?v=1645545951"), name: "Name", grade: "PSA"))
    }
    
    .padding(.horizontal, 16.scale)
    .frame(maxHeight: .infinity)
    .background(.black)
}
