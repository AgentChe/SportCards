//
//  LoaderView.swift
//  SportCards
//
//  Created by Vitaliy Zagorodnov on 26.10.2024.
//

import SwiftUI

struct LoaderView: View {
    enum LoaderType {
        case pagination
        case fullScreen
    }
    
    let type: LoaderType
    var body: some View {
        switch type {
        case .pagination:
            HStack { loader }
        case .fullScreen:
            VStack { loader }
                .frame(maxWidth: .infinity)
        }
    }
    
    @ViewBuilder
    private var loader: some View {
        Spacer()
        ProgressView()
            .frame(width: 40.scale, height: 40.scale)
            .progressViewStyle(.sportCards)
            .foregroundStyle(.white)
        Spacer()
    }
}

#Preview {
    LoaderView(type: .fullScreen)
}
