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
        coloredNavAppearance.configureWithTransparentBackground()
        UINavigationBar.appearance().standardAppearance = coloredNavAppearance
        UINavigationBar.appearance().scrollEdgeAppearance = coloredNavAppearance
    }
    
    var body: some View {
        RootNavigationStack {
            TabBarView(items: tabs, selected: $selectedTab) {
                ForEach(tabs) { $0.screen }
            }
            .frame(maxHeight: .infinity)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Text(selectedTab.navigationTitle)
                        .font(Fonts.Inter.font(size: 22.scale, weight: .w700))
                        .foregroundStyle(.white)
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    NavigationLink(value: Route.menu) {
                        Image("Home.Menu")
                            .resizable()
                            .frame(width: 24.scale, height: 24.scale)
                    }
                }
            }
            .animation(.easeInOut, value: selectedTab)
            .navigationBarBackButtonHidden()
            .gradientBackground()
        }
        .fullScreenCover(isPresented: $presentPaygate, content: { PaygateView() })
        .task {
            presentPaygate = !SessionManager().hasActiveSubscriptions()
            if !presentPaygate {
                RequestReview.startRequest()
            }
        }
        .onChange(of: presentPaygate) { value in
            if !value {
                RequestReview.startRequest()
            }
        }
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
