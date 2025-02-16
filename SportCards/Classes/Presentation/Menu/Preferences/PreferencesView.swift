//
//  PreferencesView.swift
//  SportCards
//
//  Created by Vitaliy Zagorodnov on 26.10.2024.
//

import SwiftUI

struct PreferencesView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel = PreferencesViewModel()
    
    var body: some View {
        VStack(spacing: 0) {
            Group {
                ScrollView(.vertical) {
                    LazyVStack(alignment: .leading, spacing: 24.scale) {
                        Text("Preferences.Category".localized)
                            .font(Fonts.Inter.font(size: 18.scale, weight: .w700))
                            .foregroundStyle(.white)
                            .padding(.vertical, 10.scale)
                        
                        TagLayout(spacing: 12.scale, alignment: .leading) {
                            ForEach(viewModel.categories, id: \.self) { item in
                                Button(
                                    action: { viewModel.currentCategory = item },
                                    label: {
                                        TagView(item.name, isSelected: viewModel.currentCategory == item)
                                    }
                                )
                            }
                        }
                        .tagStyle(.checkbox)
                        
                        Text("Preferences.Grade".localized)
                            .font(Fonts.Inter.font(size: 18.scale, weight: .w700))
                            .foregroundStyle(.white)
                            .padding(.vertical, 10.scale)
                        
                        TagLayout(spacing: 12.scale, alignment: .leading) {
                            ForEach(viewModel.grades, id: \.self) { item in
                                Button(
                                    action: { viewModel.currentGrade = item },
                                    label: {
                                        TagView(item.alias, isSelected: viewModel.currentGrade == item)
                                    }
                                )
                            }
                        }
                        .tagStyle(.checkbox)
                    }
                    .padding(.horizontal, 16.scale)
                }
                .scrollIndicators(.never)
                
                Button(action: viewModel.apply) {
                    HStack {
                        if viewModel.isLoading {
                            ProgressView()
                                .progressViewStyle(.sportCards)
                                .frame(width: 20.scale, height: 20.scale)
                        }
                        Text("Preferences.Apply".localized)
                    }
                }
                .disabled(viewModel.isLoading)
                .buttonStyle(.button(.primary))
            }
            .screenState($viewModel.screenState, tryAgain: viewModel.retry)
        }
        .navigationBarBackButtonHidden()
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button(action: dismiss.callAsFunction) {
                    HStack(spacing: 6.scale) {
                        Image("Back")
                        Text("Preferences.Title".localized)
                            .font(Fonts.Inter.font(size: 22.scale, weight: .w700))
                    }
                    .foregroundStyle(.white)
                }
            }
        }
        .padding(.top, 10.scale)
        .gradientBackground()
    }
}

#Preview {
    PreferencesView()
}
