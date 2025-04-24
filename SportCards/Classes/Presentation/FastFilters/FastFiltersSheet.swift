//
//  FastFiltersSheet.swift
//  SportCards
//
//  Created by Vitaliy Zagorodnov on 22.04.2025.
//

import SwiftUI

struct FastFiltersSheet: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel: FastFiltersSheetViewModel
    @State private var height: CGFloat = .zero
    
    private let type: FastFilterType
    @Binding private var filters: Filters
    
    init(type: FastFilterType, filters: Binding<Filters>) {
        self.type = type
        self._viewModel = StateObject(wrappedValue: .init(for: type, filters: filters.wrappedValue))
        self._filters = filters
    }
    var body: some View {
        VStack(alignment: .leading, spacing: 24.scale) {
            HStack {
                Text(type.title)
                Spacer()
                Button(
                    action: dismiss.callAsFunction,
                    label: { Image("Close") }
                )
                .opacity(0.5)
            }
            
            TagLayout(spacing: 12.scale, alignment: .leading) {
                switch type {
                case .gradingService:
                    gradingService
                case .grade:
                    grade
                case .category:
                    categories
                }
            }
            .tagStyle(.checkbox)
            .disabled(!viewModel.isAvailableGrades)
            .opacity(viewModel.isAvailableGrades ? 1 : 0.4)
            
            Button(
                action: {
                    filters = viewModel.cachedFilters
                    dismiss()
                },
                label: { Text("Select") }
            )
            .buttonStyle(.button(.primary))
            .disabled(!viewModel.isAvailableGrades)
        }
        .padding(.vertical, 24.scale)
        .padding(.horizontal, 16.scale)
        .onGeometryChange(for: CGFloat.self, of: { proxy in
            proxy.size.height
        }, action: { newValue in
            if newValue != height {
                height = newValue
            }
        })
        .presentationDetents([.height(height)])
        .presentationCornerRadius(24.scale)
        .presentationBackground(.main200)
        .task { await viewModel.load()  }
    }
    
    var gradingService: some View {
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
    
    var categories: some View {
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
    
    var grade: some View {
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
}

#Preview {
    FastFiltersSheet(type: .category, filters: .constant(.init()))
}
