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
    private let alias: [Alias]
    
    init(alias: [Alias], filters: Binding<Filters>) {
        self.alias = alias
        self._filters = filters
        self._cacheFilters = State(initialValue: filters.wrappedValue)
    }
    
    var body: some View {
        VStack(spacing: 0) {
            ScrollView(.vertical) {
                LazyVStack(alignment: .leading, spacing: 24.scale) {
                    Text("Filters.Section.Sorting")
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
                    
                    Text("Filters.Section.Category")
                        .font(Fonts.Inter.font(size: 18.scale, weight: .w700))
                        .foregroundStyle(.white)
                        .padding(.vertical, 10.scale)
                    TagLayout(spacing: 12.scale, alignment: .leading) {
                        ForEach(alias, id: \.self) { item in
                            Button(
                                action: {
                                    if cacheFilters.category.contains(item) {
                                        cacheFilters.category.remove(item)
                                    } else {
                                        cacheFilters.category.insert(item)
                                    }
                                },
                                label: {
                                    TagView(item.name, isSelected: cacheFilters.category.contains(item))
                                }
                            )
                        }
                    }
                    .tagStyle(.checkbox)
                    
                    Text("Filters.Section.Grade")
                        .font(Fonts.Inter.font(size: 18.scale, weight: .w700))
                        .foregroundStyle(.white)
                        .padding(.vertical, 10.scale)
                    
                    TagLayout(spacing: 12.scale, alignment: .leading) {
                        ForEach(Grade.allCases, id: \.self) { item in
                            Button(
                                action: { 
                                    if cacheFilters.grade.contains(item) {
                                        cacheFilters.grade.remove(item)
                                    } else {
                                        cacheFilters.grade.insert(item)
                                    }
                                },
                                label: {
                                    TagView(item.shortName, isSelected: cacheFilters.grade.contains(item))
                                }
                            )
                        }
                    }
                    .tagStyle(.checkbox)
                }
            }
            .scrollIndicators(.never)
            
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
        .navigationBarBackButtonHidden()
        .ignoresSafeArea(edges: [.bottom])
        .padding(.horizontal, 16.scale)
        .background(.black)
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
    }
}

#Preview {
    NavigationStack {
        FiltersView(
            alias: [Alias(alias: "all", name: "All"), Alias(alias: "mma", name: "MMA"), Alias(alias: "football", name: "Football")],
            filters: .constant(Filters())
        )
    }
}
