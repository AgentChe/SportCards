//
//  FiltersView.swift
//  SportCards
//
//  Created by Vitaliy Zagorodnov on 04.10.2024.
//

import SwiftUI

struct FiltersView: View {
    @EnvironmentObject private var route: NavigationManager
    @Environment(\.dismiss) private var dismiss
    @Binding private var filters: Filters
    @StateObject private var viewModel: FiltersViewModel
    
    init(filters: Binding<Filters>) {
        self._filters = filters
        self._viewModel = StateObject(wrappedValue: .init(filters: filters.wrappedValue))
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
                                action: {
                                    viewModel.priceAction(for: item)
                                },
                                label: {
                                    TagView(
                                        item.name,
                                        isSelected: viewModel.cachedFilters.price == item
                                    )
                                }
                            )
                        }
                    }
                    
                    HStack(alignment: .center, spacing: 6.scale) {
                        Text("Filters.Section.GradingService".localized)
                            .font(Fonts.Inter.font(size: 18.scale, weight: .w700))
                            .foregroundStyle(.white)
                            .padding(.vertical, 10.scale)
                        
                        Button(
                            action: {
                                route.push(to: .gradingHelp(.service))
                            },
                            label: {
                                Image("Help")
                                    .resizable()
                                    .frame(width: 24.scale, height: 24.scale)
                            }
                        )
                    }
                    
                    TagLayout(spacing: 12.scale, alignment: .leading) {
                        ForEach(viewModel.gradingService, id: \.self) { item in
                            Button(
                                action: {
                                    viewModel.gradeServiceAction(for: item)
                                },
                                label: {
                                    TagView(
                                        item.alias,
                                        isSelected: viewModel.cachedFilters.gradeService.contains(item)
                                    )
                                }
                            )
                        }
                    }
                    .tagStyle(.checkbox)
                    
                    HStack(alignment: .center, spacing: 6.scale) {
                        Text("Filters.Section.Grade".localized)
                            .font(Fonts.Inter.font(size: 18.scale, weight: .w700))
                            .foregroundStyle(.white)
                            .padding(.vertical, 10.scale)
                        
                        Button(
                            action: {
                                route.push(to: .gradingHelp(.grade))
                            },
                            label: {
                                Image("Help")
                                    .resizable()
                                    .frame(width: 24.scale, height: 24.scale)
                            }
                        )
                    }
                    .opacity(viewModel.isAvailableGrades ? 1 : 0.4)
                    
                    TagLayout(spacing: 12.scale, alignment: .leading) {
                        ForEach(viewModel.grades, id: \.self) { item in
                            Button(
                                action: {
                                    viewModel.gradeValueAction(for: item)
                                },
                                label: {
                                    TagView(
                                        item,
                                        isSelected: viewModel.cachedFilters.gradeValues.contains(item)
                                    )
                                }
                            )
                        }
                    }
                    .animation(.easeInOut, value: viewModel.grades)
                    .tagStyle(.checkbox)
                    .disabled(!viewModel.isAvailableGrades)
                    .opacity(viewModel.isAvailableGrades ? 1 : 0.4)
                    
                    Text("Filters.Section.Category".localized)
                        .font(Fonts.Inter.font(size: 18.scale, weight: .w700))
                        .foregroundStyle(.white)
                        .padding(.vertical, 10.scale)
                    
                    TagLayout(spacing: 12.scale, alignment: .leading) {
                        ForEach(viewModel.categories, id: \.self) { item in
                            Button(
                                action: {
                                    viewModel.categoryAction(for: item)
                                },
                                label: {
                                    TagView(
                                        item.name,
                                        isSelected: viewModel.cachedFilters.category.contains(item)
                                    )
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
                    filters = viewModel.cachedFilters
                    dismiss()
                },
                label: { Text("Filters.Apply") }
            )
            .buttonStyle(.button(.primary))
            
            Button(
                action: {
                    viewModel.cachedFilters = .init()
                    filters = viewModel.cachedFilters
                },
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
        .task { await viewModel.load() }
    }
}

#Preview {
    NavigationStack {
        FiltersView(filters: .constant(Filters()))
    }
}
