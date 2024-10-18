//
//  SearchListView.swift
//  SportCards
//
//  Created by Vitaliy Zagorodnov on 04.10.2024.
//

import SwiftUI

import Combine
final class CardSearchDataSource: RandomAccessCollection, ObservableObject {
    typealias Element = CardDiscover
    typealias Index = Int
    
    @Published var filters: Filters = .init()
    @Published var text: String = ""
    
    @Published private var items: [Element]
    
    private var isLoadingMoreData = false
    private var pageNumber = 1
    private var isEnd: Bool = false
    private var cancellable: AnyCancellable?
    
    private lazy var manager = CardsManager()
    
    init(_ initial: [Element] = []) {
        items = initial
    }
    
    var startIndex: Int {
        items.startIndex
    }
    
    var endIndex: Int {
        items.endIndex
    }
    
    
    func formIndex(after i: inout Int) {
        i += 1
        
        if i >= (items.count - 10) && !isLoadingMoreData && !items.isEmpty {
            loadMoreData()
        }
    }
    
    subscript(position: Int) -> CardDiscover {
        items[position]
    }
    
    private func loadMoreData() {
        guard !isLoadingMoreData, !isEnd else { return }
        isLoadingMoreData = true
        
        cancellable = manager
            .cards(text: text, filters: filters, for: pageNumber + 1)
            .compactMap { $0.success }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] items in
                self?.pageNumber += 1
                self?.isLoadingMoreData = false
                self?.isEnd = items.isEmpty
                self?.items.append(contentsOf: items)
            }
    }
}

struct SearchListView: View {
    @State var isAppear: Bool = false
    var body: some View {
        List {
            ForEach(CardDiscover.mock, id: \.id) { item in
                RecommendedCardView(card: item)
            }
            .listRowInsets(.init(top: 0, leading: 16.scale, bottom: 0, trailing: 16.scale))
            .listRowBackground(isAppear ? .red: Color.black)
            
            HStack {
                Spacer()
                ProgressView()
                Spacer()
            }.listRowBackground(isAppear ? .red: Color.black)
                .onAppear {
                    withAnimation {
                        isAppear = true
                    }
                }
                .onDisappear {
                    isAppear = false
                }
        }
        .listRowSpacing(16.scale)
        .listRowSeparator(.hidden)
        .listStyle(.plain)
        .scrollContentBackground(.hidden)
        .background(.black)
    }
}

#Preview {
    SearchListView()
}
