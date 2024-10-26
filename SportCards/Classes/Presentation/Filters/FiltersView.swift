//
//  FiltersView.swift
//  SportCards
//
//  Created by Vitaliy Zagorodnov on 04.10.2024.
//

import SwiftUI

struct FiltersView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var cacheFilters: Filters
    @Binding private var filters: Filters
    @StateObject private var viewModel = FiltersViewModel()
    
    init(filters: Binding<Filters>) {
        self._filters = filters
        self._cacheFilters = State(initialValue: filters.wrappedValue)
    }
    
    var body: some View {
        VStack(spacing: 0) {
            ScrollView(.vertical) {
                LazyVStack(alignment: .leading, spacing: 24.scale) {
                    Text("Filters.Section.Sorting".localized)
                        .font(Fonts.Inter.font(size: 18.scale, weight: .w700))
                        .foregroundStyle(.white)
                        .padding(.vertical, 10.scale)
                    TagLayout(spacing: 12.scale, alignment: .leading) {
                        ForEach(Filters.SortType.allCases, id: \.self) { item in
                            Button(
                                action: { cacheFilters.price = item },
                                label: { TagView(item.name, isSelected: cacheFilters.price == item) }
                            )
                        }
                    }
                    
                    Text("Filters.Section.Category".localized)
                        .font(Fonts.Inter.font(size: 18.scale, weight: .w700))
                        .foregroundStyle(.white)
                        .padding(.vertical, 10.scale)
                    TagLayout(spacing: 12.scale, alignment: .leading) {
                        ForEach(viewModel.categories, id: \.self) { item in
                            Button(
                                action: { cacheFilters.category = item },
                                label: {
                                    TagView(item.name, isSelected: cacheFilters.category == item)
                                }
                            )
                        }
                    }
                    .tagStyle(.checkbox)
                    
                    Text("Filters.Section.Grade".localized)
                        .font(Fonts.Inter.font(size: 18.scale, weight: .w700))
                        .foregroundStyle(.white)
                        .padding(.vertical, 10.scale)
                    
                    TagLayout(spacing: 12.scale, alignment: .leading) {
                        ForEach(viewModel.grades, id: \.self) { item in
                            Button(
                                action: { cacheFilters.grade = item },
                                label: {
                                    TagView(item.alias, isSelected: cacheFilters.grade == item)
                                }
                            )
                        }
                    }
                    .tagStyle(.checkbox)
                }
            }
            .scrollIndicators(.never)
            .padding(.top, 24.scale)
            
            Button(
                action: {
                    filters = cacheFilters
                    dismiss()
                },
                label: { Text("Filters.Apply") }
            )
            .buttonStyle(.button(.primary))
            
            Button(
                action: { cacheFilters = .init() },
                label: { Text("Filters.Clear") }
            )
            .buttonStyle(.button(.secondary))
            .padding(.top, 16.scale)
            .padding(.bottom, ScreenSize.isIphoneXFamily ? 44.scale : 24.scale)
        }
        .padding(.horizontal, 16.scale)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button(action: dismiss.callAsFunction) {
                    HStack(spacing: 6.scale) {
                        Image("Back")
                        Text("Filters.Title")
                            .font(Fonts.Inter.font(size: 22.scale, weight: .w700))
                    }
                    .foregroundStyle(.white)
                }
            }
        }
        .ignoresSafeArea(edges: [.bottom])
        .navigationBarBackButtonHidden()
        .gradientBackground()
    }
}

#Preview {
    NavigationStack {
        FiltersView(filters: .constant(Filters()))
    }
}
