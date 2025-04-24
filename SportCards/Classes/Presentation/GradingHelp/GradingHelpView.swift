//
//  GradingHelpView.swift
//  SportCards
//
//  Created by Vitaliy Zagorodnov on 23.04.2025.
//

import SwiftUI

struct GradingHelpView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel: GradingHelpViewModel
    @State private var selected: GradingHelpItem?
    
    init(type: GradingHelpType) {
        self._viewModel = StateObject(wrappedValue: .init(type: type))
    }
    
    var body: some View {
        ScrollView(.vertical) {
            LazyVStack(spacing: 16.scale) {
                ForEach(viewModel.items, id: \.self) { item in
                    Button(
                        action: {
                            withAnimation {
                                selected = selected == item ? nil : item
                            }
                        },
                        label: {
                            HelpItemView(item: item, isSelected: selected == item)
                        }
                    )
                }
            }
            .padding(.horizontal, 26.scale)
        }
        .padding(.top, 12.scale)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button(action: dismiss.callAsFunction) {
                    HStack(spacing: 6.scale) {
                        Image("Back")
                        Text(viewModel.type.title)
                            .font(Fonts.Inter.font(size: 22.scale, weight: .w700))
                    }
                    .foregroundStyle(.white)
                }
            }
        }
        .navigationBarBackButtonHidden()
        .gradientBackground()
        .task {
            await viewModel.load()
        }
    }
}

private struct HelpItemView: View {
    var item: GradingHelpItem
    var isSelected: Bool
    
    var body: some View {
        HStack(spacing: 15.scale) {
            VStack(alignment: .leading, spacing: 10.scale) {
                Text(item.title)
                    .font(Fonts.Inter.font(size: 14.scale, weight: .w700))
                    .lineSpacing(8.scale)
                if isSelected {
                    Text(item.description)
                        .font(Fonts.Inter.font(size: 14.scale, weight: .w400))
                        .lineSpacing(8.scale)
                }
            }
            .multilineTextAlignment(.leading)
            .foregroundStyle(Appearance.mono100)
            
            Spacer()
            
            Image("ArrowDown")
                .resizable()
                .frame(width: 24.scale, height: 24.scale)
                .rotationEffect(isSelected ? .degrees(-180) : .degrees(0), anchor: .center)
        }
        .padding(16.scale)
        .background(isSelected ? .main400 : .clear)
        .clipShape(RoundedRectangle(cornerRadius: 12.scale))
        .overlay {
            RoundedRectangle(cornerRadius: 12.scale)
                .stroke(.main200, lineWidth: 1.scale)
        }
    }
}
