//
//  HomeView.swift
//  SportCards
//
//  Created by Vitaliy Zagorodnov on 29.09.2024.
//

import SwiftUI

struct HomeView: View {
    @StateObject private var viewModel = HomeViewModel()
    
    @State private var presentPaygate: Bool = false
    @State private var searchText: String = ""
    @State private var isLoaded: Bool = false
    
    var body: some View {
        ScrollView(.vertical) {
            LazyVStack(alignment: .leading, spacing: 0) {
                SearchView(
                    searchText: $viewModel.searchText,
                    isFocused: $viewModel.searchIsFocused,
                    filters: $viewModel.filters
                )
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
            .padding(.bottom, 32.scale)
        }
        .animation(.easeOut, value: viewModel.dataSource)
        .scrollIndicators(.never)
        .frame(maxHeight: .infinity)
        .navigationBarBackButtonHidden()
        .onViewDidLoad {
            viewModel.makeData()
        }
        
    }
}

struct SearchView: View {
    @Binding var searchText: String
    @Binding var isFocused: Bool
    @Binding var filters: Filters
    
    var body: some View {
        HStack {
            SearchField(searchText: $searchText, isFocused: $isFocused)
            if isFocused {
                NavigationLink(destination: FiltersView(filters: $filters)) {
                    Image("Home.Settings")
                        .frame(width: 50.scale, height: 50.scale)
                        .background(.main300, in: Circle())
                }
                .overlay(alignment: .topTrailing) {
                    if filters.count > 0 {
                        Text("\(filters.count)")
                            .font(Fonts.Inter.font(size: 12.scale, weight: .w700))
                            .foregroundStyle(.white)
                            .padding(4.scale)
                            .background(.main100, in: Circle())
                            .alignmentGuide(.top, computeValue: { dimension in
                                dimension[.top] + 4.scale
                            })
                    }
                }
            }
        }
        .animation(.easeIn, value: isFocused)
    }
}

#Preview {
    HomeView()
        .gradientBackground()
}
