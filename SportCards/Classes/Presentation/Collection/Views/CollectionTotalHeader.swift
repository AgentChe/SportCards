//
//  CollectionTotalHeader.swift
//  SportCards
//
//  Created by Vitaliy Zagorodnov on 07.10.2024.
//

import SwiftUI

struct CollectionTotalHeader: View {
    let model: TotalPriceModel
    var body: some View {
        VStack(spacing: 14.scale) {
            HStack {
                Text(model.price)
                Spacer()
                Text("\(model.count)")
            }
            .font(Fonts.Inter.font(size: 28.scale, weight: .w700))
            HStack {
                Text("Collection.Total.Price".localized)
                Spacer()
                Text("Collection.Total.Count".localized)
            }
            .font(Fonts.Inter.font(size: 16.scale, weight: .w400))
        }
        .foregroundStyle(.mono100)
    }
}

#Preview {
    VStack {
        CollectionTotalHeader(model: .init(price: "$ 12.23", count: 10))
        Spacer()
    }
    .padding(.horizontal, 16.scale)
    .background(.black)
}
