//
//  MainTabView.swift
//  SportCards
//
//  Created by Vitaliy Zagorodnov on 02.10.2024.
//

import SwiftUI

struct MainTabView: View {
    @State private var presentPaygate: Bool = false
    @State private var selectedTab: MainTabType = .home
    
    private let tabs = MainTabType.allCases
    
    init() {
        let coloredNavAppearance = UINavigationBarAppearance()
        coloredNavAppearance.configureWithOpaqueBackground()
        coloredNavAppearance.backgroundColor = .black
        UINavigationBar.appearance().standardAppearance = coloredNavAppearance
        UINavigationBar.appearance().scrollEdgeAppearance = coloredNavAppearance
    }
    
    var body: some View {
        NavigationStack {
            TabBarView(items: tabs, selected: $selectedTab) {
                ForEach(tabs, id: \.self) {
                    $0.screen
                }
            }
            .frame(maxHeight: .infinity)
            .background(.black)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Text(selectedTab.navigationTitle)
                        .font(Fonts.Inter.font(size: 22.scale, weight: .w700))
                        .foregroundStyle(.white)
                }
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: {}) {
                        Image("Home.Menu")
                            .resizable()
                            .frame(width: 24.scale, height: 24.scale)
                    }
                }
            }
            .animation(.easeInOut, value: selectedTab)
            .navigationBarBackButtonHidden()
        }
        .fullScreenCover(isPresented: $presentPaygate, content: { PaygateView() })
    }
}

#Preview {
    MainTabView()
}

private extension MainTabType {
    @ViewBuilder var screen: some View {
        switch self {
        case .home:
            HomeView()
        case .collection:
            CardCollectionView()
        }
    }
    
    var navigationTitle: String {
        switch self {
        case .home:
            "Home.Title.Home".localized
        case .collection:
            "Home.Title.Collection".localized
        }
    }
}
