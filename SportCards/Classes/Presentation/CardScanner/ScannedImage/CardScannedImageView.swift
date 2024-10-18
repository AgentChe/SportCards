//
//  CardScannedImageView.swift
//  SportCards
//
//  Created by Vitaliy Zagorodnov on 10.10.2024.
//

import SwiftUI

enum ScannerState {
    case photo
    case grade
    case request
}

struct CardScannedImageView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var router: NavigationManager
    @StateObject private var viewModel: CardScannedImageViewModel
    @State private var currentState: ScannerState = .photo
    @State private var showAlert: Bool = false
    
    init(image: Data) {
        _viewModel = StateObject(wrappedValue: .init(data: image))
    }
    
    var body: some View {
        VStack(spacing: 0) {
            if let image = viewModel.image {
                Image(uiImage: image)
                    .resizable()
                    .clipShape(RoundedRectangle(cornerRadius: 20.scale))
                    .padding(.top, 22.scale)
                    .padding(.horizontal, 16.scale)
            }
            Spacer()
                .frame(maxHeight: 200.scale)
            
        }
        .overlay(alignment: .bottom, content: {
            build(for: currentState)
        })
        .navigationBarBackButtonHidden()
        .gradientBackground()
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button(action: dismiss.callAsFunction, label: { Image("Back") })
            }
        }
        .onReceive(viewModel.$isSuccessScanned, perform: { value in
            guard let value else { return }
            if value {
                currentState = .grade
            } else {
                showAlert = true
            }
        })
        .confirmAlert(isPresented: $showAlert) {
            DetectCardErrorAlert(
                primaryAction: { 
                    showAlert = false
                    router.pop()
                },
                secondaryAction: { showAlert = false }
            )
        }
        .animation(.easeInOut, value: showAlert)
    }
}

private extension CardScannedImageView {
    @ViewBuilder
    func build(for state: ScannerState) -> some View {
        switch state {
        case .photo:
            VStack(spacing: 0) {
                Button(
                    action: { withAnimation { currentState = .request }},
                    label: { Text("CardScanner.Accept".localized) }
                )
                .buttonStyle(.button(.primary))
                
                Button(
                    action: { router.pop() },
                    label: { Text("CardScanner.Retake".localized) }
                )
                .buttonStyle(.button(.secondary))
                .padding(.top, 16.scale)
            }
            .padding(.horizontal, 16.scale)
        case .grade:
            VStack(spacing: 0) {
                ScrollView(.horizontal) {
                    HomeAliasLayout {
                        ForEach(viewModel.grades, id: \.self) { item in
                            Button(
                                action: { viewModel.selectedGrade = item },
                                label: { TagView(item.alias, isSelected: viewModel.selectedGrade == item) }
                            )
                        }
                    }
                    .tagStyle(.checkbox)
                    .padding(.vertical, 20.scale)
                    .padding(.horizontal, 16.scale)
                }
                .scrollIndicators(.never)
                
                Button(
                    action: { router.replacePush(from: .cardDescription) },
                    label: { Text("Continue".localized) }
                )
                .buttonStyle(.button(.primary))
                .padding(.horizontal, 16.scale)
                .disabled( viewModel.selectedGrade == nil)
            }
        case .request:
            VStack(spacing: 0) {
                VStack(spacing: 2.scale) {
                    LoaderView()
                        .foregroundStyle(.main100)
                        .frame(width: 24.scale, height: 24.scale)
                    
                    Text("CardScanner.Progress".localized)
                        .font(Fonts.Inter.font(size: 14.scale, weight: .w400))
                        .foregroundStyle(.white.opacity(0.5))
                }
                .padding(.vertical, 50.scale)
                
                Button(
                    action: { currentState = .grade},
                    label: { Text("Continue".localized) }
                )
                .buttonStyle(.button(.primary))
            }
            .padding(.horizontal, 16.scale)
        }
    }
}

#Preview {
    NavigationStack {
        CardScannedImageView(image: UIImage(named: "pencil")!.pngData()!)
    }
    .environmentObject(NavigationManager())
}
