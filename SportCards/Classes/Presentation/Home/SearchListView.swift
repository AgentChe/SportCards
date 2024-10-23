//
//  SearchListView.swift
//  SportCards
//
//  Created by Vitaliy Zagorodnov on 04.10.2024.
//

import SwiftUI

struct SearchListView: View {
    @State var isAppear: Bool = false
    var body: some View {
        HStack {
            Spacer()
            ProgressView()
                .frame(width: 40.scale, height: 40.scale)
                .foregroundStyle(.white)
                .progressViewStyle(.sportCards)
            Spacer()
        }
        .background(.black)
    }
}

#Preview {
    SearchListView()
}
