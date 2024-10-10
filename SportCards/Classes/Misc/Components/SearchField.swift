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
    @FocusState var isFocus: Bool
    var body: some View {
        HStack {
            TextField(text: $searchText) {
                Text("Search")
                    .font(Fonts.Inter.font(size: 18.scale, weight: .w400))
                    .foregroundStyle(.white.opacity(0.5))
            }
            .font(Fonts.Inter.font(size: 18.scale, weight: .w400))
            .foregroundStyle(.white)
            .frame(height: 50.scale)
            .focused($isFocus)
            if isFocus {
                Button(
                    action: { searchText = "" },
                    label: { Image("Field.Clear") }
                )
            }
        }
        .padding(.horizontal, 24.scale)
        .background(.main300, in: Capsule())
        .onChange(of: isFocus) { newValue in
            isFocused = newValue
        }
    }
}

#Preview {
    @State var test: String = ""
    return SearchField(searchText: $test, isFocused: .constant(false))
}
