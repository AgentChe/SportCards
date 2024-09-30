//
//  HomeView.swift
//  SportCards
//
//  Created by Vitaliy Zagorodnov on 29.09.2024.
//

import SwiftUI

enum Route {
    case paygate
}

struct HomeView: View {
    @State private var path: [Route] = []
    @State private var presentPaygate: Bool = false
    var body: some View {
        NavigationStack {
            VStack {
                Text("HOME")
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
            }
            .frame(maxHeight: .infinity)
            .background(.black)
            .task {
                presentPaygate = true
            }
        }
        .fullScreenCover(isPresented: $presentPaygate, content: {
            PaygateView()
        })
    }
}

#Preview {
    HomeView()
}
