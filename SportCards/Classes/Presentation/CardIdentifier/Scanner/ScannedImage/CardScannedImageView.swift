//
//  CardScannedImageView.swift
//  SportCards
//
//  Created by Vitaliy Zagorodnov on 10.10.2024.
//

import SwiftUI

enum ScannerState {
    case photo
    case grade([String: [String]])
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
            Spacer()
                .background {
                    HStack {
                        Spacer(minLength: 16.scale)
                        if let image = viewModel.image {
                            Image(uiImage: image)
                                .resizable()
                                .aspectRatio(0.72, contentMode: .fill)
                                .clipShape(RoundedRectangle(cornerRadius: 20.scale))
                                .padding(.top, 22.scale)
                        }
                        Spacer(minLength: 16.scale)
                    }
                }
            
            build(for: currentState)
        }
        .gradientBackground()
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button(action: dismiss.callAsFunction) {
                    HStack(spacing: 6.scale) {
                        Image("Back")
                        if case .grade = currentState {
                            Text("CardScanner.GradeTitle")
                                .font(Fonts.Inter.font(size: 22.scale, weight: .w700))
                        }
                    }
                    .foregroundStyle(.white)
                }
            }
        }
        .onReceive(viewModel.$action) { action in
            switch action {
            case let .step(step):
                currentState = step
            case let .details(id, grade):
                router.replacePush(route: .cardDescription(id: id, grade: grade, collection: .scanned), replaced: .scanner)
            case .error:
                showAlert = true
            }
        }
        .confirmAlert(isPresented: $showAlert) {
            DetectCardErrorAlert(
                primaryAction: { 
                    showAlert = false
                    router.pop()
                },
                secondaryAction: {
                    showAlert = false
                    router.replacePush(route: .manualSearch, replaced: .scanner)
                }
            )
        }
        .animation(.spring(), value: showAlert)
        .navigationBarBackButtonHidden()
    }
}

private extension CardScannedImageView {
    @ViewBuilder
    func build(for state: ScannerState) -> some View {
        switch state {
        case .photo:
            VStack(spacing: 0) {
                Button(
                    action: { viewModel.acceptPhoto() },
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
            .padding(.top, 76.scale)
        case let .grade(grades):
            VStack(spacing: 0) {
                let isDisabled = viewModel.selectedGrade == nil
                    ? true
                    : grades[viewModel.selectedGrade ?? ""]?.isEmpty == true
                        ? false
                        : viewModel.selectedLevel == nil
                
                CardScannedCarusel(title: "CardScanner.ScannedImage.GradingService".localized, elements: Array(grades.keys), selected: $viewModel.selectedGrade)
                if let elements = grades[viewModel.selectedGrade ?? ""]  {
                    CardScannedCarusel(title: "CardScanner.ScannedImage.Grade".localized, elements: elements, selected: $viewModel.selectedLevel)
                        .padding(.top, 26.scale)
                } else {
                    Spacer(minLength: 84.scale)
                }
                
                Button(
                    action: { viewModel.acceptGrade() },
                    label: { Text("Continue".localized) }
                )
                .buttonStyle(.button(.primary))
                .padding(.horizontal, 16.scale)
                .padding(.top, 46.scale)
                .disabled(isDisabled)
            }
            .onChange(of: viewModel.selectedGrade) { _ in
                viewModel.selectedLevel = nil
            }
        case .request:
            VStack(spacing: 0) {
                VStack(spacing: 2.scale) {
                    ProgressView()
                        .progressViewStyle(.sportCards)
                        .foregroundStyle(.main100)
                        .frame(width: 24.scale, height: 24.scale)
                    
                    Text("CardScanner.Progress".localized)
                        .font(Fonts.Inter.font(size: 14.scale, weight: .w400))
                        .foregroundStyle(.white.opacity(0.5))
                }
                .padding(.vertical, 50.scale)
                
                Button(
                    action: { },
                    label: { Text("Continue".localized) }
                )
                .buttonStyle(.button(.secondary))
                .disabled(true)
            }
            .padding(.horizontal, 16.scale)
        }
    }
}

private struct CardScannedCarusel: View {
    private let title: String
    private let elements: [String]
    @Binding private var selected: String?
    
    init(title: String, elements: [String], selected: Binding<String?>) {
        self.title = title
        self.elements = elements
        self._selected = selected
    }
    var body: some View {
        VStack(spacing: 22.scale) {
            Text(title)
                .font(Fonts.Inter.font(size: 18.scale, weight: .w700))
                .frame(maxWidth: .infinity, alignment: .leading)
                .foregroundStyle(.white)
                .padding(.top, 10.scale)
                .padding(.horizontal, 16.scale)
            
            ScrollView(.horizontal) {
                HomeAliasLayout {
                    ForEach(elements, id: \.self) { item in
                        Button(
                            action: {
                                withAnimation {
                                    selected = item
                                }
                            },
                            label: { TagView(item, isSelected: selected == item) }
                        )
                    }
                }
                .tagStyle(.checkbox)
                .padding(.horizontal, 16.scale)
            }
            .scrollIndicators(.never)
            .frame(minHeight: 84.scale)
        }
    }
}

#Preview {
    NavigationStack {
        CardScannedImageView(image: UIImage(named: "pencil")!.pngData()!)
    }
    .environmentObject(NavigationManager())
}
