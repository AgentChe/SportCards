//
//  HomeView.swift
//  SportCards
//
//  Created by Vitaliy Zagorodnov on 29.09.2024.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject private var route: NavigationManager
    @StateObject private var viewModel = HomeViewModel()
    
    var body: some View {
        content
            .homeSearchable()
            .frame(maxWidth: .infinity)
            .navigationBarBackButtonHidden()
    }
}

private extension HomeView {
    var content: some View {
        ScrollView(.vertical) {
            LazyVStack(alignment: .leading, spacing: 0) {
                ForEach(viewModel.dataSource) { model in
                    switch model {
                    case .cardScanner:
                        NavigationLink(value: Route.scanner) {
                            HomeCardScannerView()
                        }
                        .padding(.horizontal, 16.scale)
                    case let .sectionTitle(title):
                        Text(title)
                            .font(Fonts.Inter.font(size: 18.scale, weight: .w700))
                            .foregroundStyle(.white)
                            .padding(.top, 24.scale)
                            .padding(.horizontal, 16.scale)
                    case let .recommendedCard(card):
                        NavigationLink(value: Route.cardDescription(id: card.cardId, grade: card.grade, collection: .wishList)) {
                            RecommendedCardView(card: card)
                        }
                        .padding([.top, .horizontal], 16.scale)
                    case let .allias(items):
                        HomeAliasList(alias: items) { route.push(to: .category($0)) }
                            .padding(.leading, 16.scale)
                            .padding(.top, 24.scale)
                    case let .priceReport(report):
                        PriceChartView(title: "Chart.Title.Collection".localized,  model: report)
                            .padding(.horizontal, 16.scale)
                    case let .other(model):
                        NavigationLink(value: Route.cardDescription(id: model.cardId, grade: model.grade, collection: .wishList)) {
                            OtherCardView(model: model)
                        }
                        .padding([.top, .horizontal], 16.scale)
                    }
                }
            }
        }
        .scrollContentBackground(.hidden)
        .safeAreaInset(edge: .bottom, content: {
            Spacer()
                .frame(height: 32.scale)
        })
        .scrollIndicators(.never)
        .screenState($viewModel.screenState, bottomOffset: 32.scale, tryAgain: viewModel.retry)
    }
}

#Preview {
    NavigationStack {
        HomeView()
            .gradientBackground()
    }
}
