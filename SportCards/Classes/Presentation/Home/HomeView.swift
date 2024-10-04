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
    @StateObject private var viewModel = HomeViewModel()
    
    @State private var path: [Route] = []
    @State private var presentPaygate: Bool = false
    @State private var searchText: String = ""
    @State private var isLoaded: Bool = false
    
    var body: some View {
        ScrollView(.vertical) {
            LazyVStack(alignment: .leading, spacing: 0) {
                HStack {
                    SearchField(searchText: $viewModel.searchText)
                    
                    Button(action: {}) {
                        Image("Home.Settings")
                            .frame(width: 50.scale, height: 50.scale)
                            .background(.main300, in: Circle())
                    }
                    .overlay(alignment: .topTrailing) {
                        Text("3")
                            .font(Fonts.Inter.font(size: 12.scale, weight: .w700))
                            .foregroundStyle(.white)
                            .padding(4.scale)
                            .background(.main100, in: Circle())
                            .alignmentGuide(.top, computeValue: { dimension in
                                dimension[.top] + 4.scale
                            })
                    }
                    
                }
                .padding(.top, 14.scale)
                .padding(.horizontal, 16.scale)
                
                ForEach(viewModel.dataSource) { model in
                    switch model {
                    case .cardScanner:
                        HomeCardScannerView()
                            .padding(.top, 24.scale)
                            .padding(.horizontal, 16.scale)
                    case let .sectionTitle(title):
                        Text(title)
                            .font(Fonts.Inter.font(size: 18.scale, weight: .w700))
                            .foregroundStyle(.white)
                            .padding(.top, 24.scale)
                            .padding(.horizontal, 16.scale)
                    case let .recommendedCard(card):
                        RecommendedCardView(card: card)
                            .padding(.top, 16.scale)
                            .padding(.horizontal, 16.scale)
                    case let .allias(items):
                        HomeAliasList(alias: items)
                            .padding(.leading, 16.scale)
                            .padding(.top, 24.scale)
                    case let .priceReport(report):
                        PriceChartView(
                            title: "Chart.Title.Collection".localized,
                            model: report
                        )
                        .padding(.top, 24.scale)
                        .padding(.horizontal, 16.scale)
                    case let .other(model):
                        OtherCardView(model: model)
                            .padding(.top, 16.scale)
                            .padding(.horizontal, 16.scale)
                    }
                }
            }
            .padding(.bottom, 22.scale)
        }
        .animation(.easeOut, value: viewModel.dataSource)
        .scrollIndicators(.never)
        .frame(maxHeight: .infinity)
        .background(.black)
        .navigationBarBackButtonHidden()
        .task { viewModel.makeData() }
    }
}

#Preview {
    HomeView()
}
