//
//  CardDescriptionView.swift
//  SportCards
//
//  Created by Vitaliy Zagorodnov on 18.10.2024.
//

import SwiftUI
import NukeUI

struct CardDescriptionView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel: CardDescriptionViewModel
    @State var showAlert: Bool = false
    @State var selectedTab: DetailsTabItem = .sales
    
    init(id: String, grade: String, collection: CollectionTab) {
        _viewModel = .init(wrappedValue: .init(id: id, grade: grade, collection: collection))
    }
    
    var body: some View {
        VStack {
            Group {
                if let details = viewModel.details {
                    configureContent(model: details)
                        .padding(.top, 14.scale)
                } else {
                    Color.clear
                }
            }
            .screenState($viewModel.screenState, tryAgain: viewModel.retry)
        }
        .frame(maxWidth: .infinity)
        .overlay(footerView, alignment: .bottom)
        .confirmAlert(isPresented: $showAlert) {
            ConfirmDeleteView(
                deleteAction: { 
                    showAlert = false
                    viewModel.removeAction()
                },
                cancelAction: { showAlert = false }
            )
        }
        .animation(.default, value: showAlert)
        .background(.black)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button(action: dismiss.callAsFunction) {
                    HStack(spacing: 6.scale) {
                        Image("Back")
                        Text("CardDetails.Title")
                            .font(Fonts.Inter.font(size: 22.scale, weight: .w700))
                    }
                    .foregroundStyle(.white)
                }
            }
            if viewModel.screenState == .loaded {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: addOrDeleteAction) {
                        Image(viewModel.isAdded ? "CardDetails.Bookmark.Selected" : "CardDetails.Bookmark.Default")
                    }
                }
            }
        }
        .navigationBarBackButtonHidden()
    }
}

private extension CardDescriptionView {
    @ViewBuilder
    var footerView: some View {
        if viewModel.details != nil {
            DetailsFooterView(
                isLoading: $viewModel.isLoading,
                isAdded: $viewModel.isAdded,
                action: addOrDeleteAction
            )
            .padding(.horizontal, 16.scale)
        }
    }
    
    @ViewBuilder
    func configureContent(model: CardDetails) -> some View {
        ScrollView(.vertical) {
            LazyVStack(spacing: 16.scale) {
                LazyImage(source: model.imageURL) { state in
                    if let image = state.image {
                        image
                            .resizingMode(.aspectFill)
                            .clipShape(RoundedRectangle(cornerRadius: 20.scale))
                    } else {
                        RoundedRectangle(cornerRadius: 20.scale)
                            .fill(.main200)
                    }
                }
                .aspectRatio(0.73, contentMode: .fill)
                .padding(EdgeInsets(top: 14.scale, leading: 16.scale, bottom: 0, trailing: 16.scale))
                
                HStack(spacing: 17.scale) {
                    VStack(alignment: .leading, spacing: 6.scale) {
                        Text(model.title)
                            .font(Fonts.Inter.font(size: 28.scale, weight: .w700))
                            .foregroundStyle(.white)
                            .multilineTextAlignment(.leading)
                            .lineSpacing(4.scale)
                        
                        Text(model.subtilte)
                            .font(Fonts.Inter.font(size: 14.scale, weight: .w400))
                            .foregroundStyle(.mono100.opacity(0.5))
                    }
                    
                    Spacer()
                    
                    Text(model.grade)
                        .font(Fonts.Inter.font(size: 14.scale, weight: .w400))
                        .foregroundStyle(.mono100)
                        .padding(EdgeInsets(top: 8.scale, leading: 16.5.scale, bottom: 8.scale, trailing: 16.5.scale))
                        .background(.main200, in: Capsule())
                }
                    .padding(.horizontal, 16.scale)
                
                HStack {
                    VStack(alignment: .leading, spacing: 6.scale) {
                        Text("CardDetails.Approximate")
                            .font(Fonts.Inter.font(size: 14.scale, weight: .w400))
                            .foregroundStyle(.white.opacity(0.5))
                        
                        Text(model.currentPrice)
                            .font(Fonts.Inter.font(size: 22.scale, weight: .w700))
                            .foregroundStyle(.white)
                    }
                    Spacer()
                }
                .padding(.horizontal, 16.scale)
                
                DetailsView(details: model.details)
                    .padding(.horizontal, 16.scale)
                
                PageTabBar(tabs: DetailsTabItem.allCases, selectedTab: $selectedTab)
                configureTabs(model: model)
                    .padding(.horizontal, 16.scale)
            }
            
            Spacer()
                .frame(height: 134.scale)
        }
    }
    
    @ViewBuilder
    func configureTabs(model: CardDetails) -> some View {
        switch selectedTab {
        case .sales:
            if let sale = model.sales {
                SalesView(sale: sale)
            }
        case .parallels:
            if !model.parallels.isEmpty {
                ParallelsView(cards: model.parallels)
            }
        }
    }
    
    func addOrDeleteAction() {
        if viewModel.isAdded {
            showAlert = true
        } else {
            viewModel.addAction()
        }
    }
}

#Preview {
    NavigationStack {
        CardDescriptionView(id: "", grade: "", collection: .scanned)
    }
}

extension CardDetails {
    static let mock = CardDetails(
        cardId: "",
        imageURL: URL(string: "https://kcs.nyc3.cdn.digitaloceanspaces.com/collection_cards/resized_20230816_044312.jpeg"),
        title: "Mew",
        subtilte: "",
        grade: "PSA 7",
        currentPrice: "$7.50",
        currentPriceRaw: 7.5,
        collectionName: "Pokemon Sword & Shield Darkness Ablaze",
        details: [.init(name: "name1", value: "value 1"), .init(name: "name2", value: "value 2"), .init(name: "name3", value: "value 3")],
        parallels: CardDiscover.mock,
//        sales: nil,
        sales: .init(
            date: Date(timeIntervalSince1970: 1658879955),
            currentPrice: "$17.50",
            currentPriceRaw: 17.50,
            numberSales: 10,
            lowPrice: "$5.50",
            lowPriceRaw: 5.5,
            hightPrice: "$37.50",
            hightPriceRaw: 37.5,
            report: .init(today: [], week: [], twoWeek: [], month: [])
        ),
        isFavorite: false)
}
