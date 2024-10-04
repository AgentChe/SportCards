//
//  OtherCardView.swift
//  SportCards
//
//  Created by Vitaliy Zagorodnov on 03.10.2024.
//

import SwiftUI

struct OtherCardView: View {
    let model: OtherCardModel
    var body: some View {
        HStack(spacing: 0) {
            AsyncImage(
                url: model.image,
                content: { image in
                    image
                        .resizable()
                        .scaledToFill()
                },
                placeholder: {
                    RoundedRectangle(cornerRadius: 6.scale)
                        .fill(.gray)
                }
            )
            .frame(width: 60.scale, height: 87.scale)
            .clipped()
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
            
            Text(model.grade.shortName ?? "")
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
                .stroke(lineWidth: 1.scale)
                .fill(.main200)
        }
    }
}

#Preview {
    VStack(spacing: 16.scale) {
        OtherCardView(model: .init(category: .init(alias: "mma", name: "MMA"), image: URL(string: "https://sportscards.com/cdn/shop/products/90233_1_2000x.jpg?v=1645545951"), name: "Name", grade: .psa))
    }
    
    .padding(.horizontal, 16.scale)
    .frame(maxHeight: .infinity)
    .background(.black)
}
