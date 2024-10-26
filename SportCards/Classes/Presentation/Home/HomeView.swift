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
    
    @State private var presentPaygate: Bool = false
    @State private var searchText: String = ""
    @State private var isLoaded: Bool = false
    
    var body: some View {
        VStack(spacing: 0) {
            content
        }
        .homeSearchable()
        .frame(maxWidth: .infinity)
        .screenState($viewModel.screenState, bottomOffset: 32.scale, tryAgain: viewModel.retry)
        .navigationBarBackButtonHidden()
    }
}

private extension HomeView {
    @ViewBuilder
    private var content: some View {
        List {
            ForEach(viewModel.dataSource) { model in
                switch model {
                case .cardScanner:
                    HomeCardScannerView()
                        .padding(.horizontal, 16.scale)
                case let .sectionTitle(title):
                    Text(title)
                        .font(Fonts.Inter.font(size: 18.scale, weight: .w700))
                        .foregroundStyle(.white)
                        .padding(.top, 24.scale)
                        .padding(.horizontal, 16.scale)
                case let .recommendedCard(card):
                    Button(
                        action: { route.push(to: .cardDescription(id: card.cardId, grade: card.grade, collection: .wishList)) },
                        label: { RecommendedCardView(card: card) }
                    )
                    .padding(.top, 16.scale)
                    .padding(.horizontal, 16.scale)
                case let .allias(items):
                    HomeAliasList(alias: items) {
                        route.push(to: .category($0))
                    }
                    .padding(.leading, 16.scale)
                    .padding(.top, 24.scale)
                case let .priceReport(report):
                    PriceChartView(
                        title: "Chart.Title.Collection".localized,
                        model: report
                    )
                    .padding(.horizontal, 16.scale)
                case let .other(model):
                    Button(
                        action: { route.push(to: .cardDescription(id: model.cardId, grade: model.grade, collection: .wishList)) },
                        label: { OtherCardView(model: model) }
                    )
                    .padding(.top, 16.scale)
                    .padding(.horizontal, 16.scale)
                }
            }
            .listRowInsets(.init(top: 0, leading: 0, bottom: 0, trailing: 0))
            .listRowBackground(Color.clear)
            .listRowSeparator(.hidden)
        }
        .listRowSpacing(0)
        .listStyle(.plain)
        .scrollContentBackground(.hidden)
        .safeAreaInset(edge: .bottom, content: {
            Spacer()
                .frame(height: 32.scale)
        })
        .scrollIndicators(.never)
    }
}

#Preview {
    NavigationStack {
        HomeView()
            .gradientBackground()
    }
}
