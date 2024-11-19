//
//  SearchField.swift
//  SportCards
//
//  Created by Vitaliy Zagorodnov on 01.10.2024.
//

import SwiftUI

struct SearchField: View {
    @Binding var searchText: String
    @Binding var isFocused: Bool
    @FocusState private var isFocus: Bool
    
    var body: some View {
        HStack {
            TextField(text: $searchText) {
                Text("Search".localized)
                    .font(Fonts.Inter.font(size: 18.scale, weight: .w400))
                    .foregroundStyle(.white.opacity(0.5))
            }
            .foregroundStyle(.white)
            .autocorrectionDisabled()
            .frame(height: 50.scale)
            .focused($isFocus)
            
            Button(
                action: { withAnimation { searchText = "" } },
                label: { Image("Field.Clear") }
            )
            .opacity(searchText.isEmpty ? 0 : 1)
        }
        .padding(.horizontal, 24.scale)
        .background(.main300, in: Capsule())
        .onChange(of: isFocus) { value in
            if value != isFocused {
                withAnimation { isFocused = value }
            }
        }
        .onTapGesture {
            withAnimation { isFocus = true }
        }
    }
}

#Preview {
    SearchField(searchText: .constant(""), isFocused: .constant(false))
}
