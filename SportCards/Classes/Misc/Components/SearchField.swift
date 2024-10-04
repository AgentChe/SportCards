//
//  SearchField.swift
//  SportCards
//
//  Created by Vitaliy Zagorodnov on 01.10.2024.
//

import SwiftUI

struct SearchField: View {
    @Binding var searchText: String
    var body: some View {
        TextField(text: $searchText) {
            Text("Search")
                .font(Fonts.Inter.font(size: 18.scale, weight: .w400))
                .foregroundStyle(.white.opacity(0.5))
        }
        .frame(height: 50.scale)
        .padding(.horizontal, 24.scale)
        .background(.main300, in: Capsule())
    }
}

#Preview {
    SearchField(searchText: .constant(""))
}
