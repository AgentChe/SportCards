//
//  CardScannerView.swift
//  SportCards
//
//  Created by Vitaliy Zagorodnov on 10.10.2024.
//

import SwiftUI

struct CardScannerView: View {
    @StateObject private var viewModel = CardScannerViewModel()
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var router: NavigationManager
    
    var body: some View {
        VStack(spacing: 0) {
            
            configureCameraArea()
            
            CardScannerTabBar(
                selectedPhoto: $viewModel.selectedPhoto, 
                availableCamera: $viewModel.isAvailableCamera,
                toggleAction: { viewModel.switchCaptureDevice() },
                cameraAction: { viewModel.takePhoto() }
            )
        }
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button(
                    action: dismiss.callAsFunction,
                    label: { Image("Scanner.Back") }
                )
            }
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button(
                    action: { viewModel.toogleFlash() },
                    label: { Image(viewModel.isFlashOn ? "Scanner.Flash.On": "Scanner.Flash.Off") }
                )
            }
        }
        .navigationBarBackButtonHidden()
        .ignoresSafeArea(edges: [.bottom])
        .gradientBackground()
        .onReceive(viewModel.$savedImage) { image in
            if let image {
                router.push(to: .scannedImage(image))
                viewModel.selectedPhoto = nil
            }
        }
        .onAppear { viewModel.start() }
        .onDisappear { viewModel.stop() }
    }
}

private extension CardScannerView {
    @ViewBuilder
    func configureCameraArea() -> some View {
        switch viewModel.cameraState {
        case .available:
            CameraView(image: $viewModel.viewfinderImage)
                .clipShape(RoundedRectangle(cornerRadius: 20.scale))
                .padding(.top, 22.scale)
                .padding(.horizontal, 16.scale)
            
            Text("CardScanner.Subtitle")
                .font(Fonts.Inter.font(size: 14.scale, weight: .w400))
                .foregroundStyle(.white.opacity(0.5))
                .padding(.init(top: 34.scale, leading: 16.scale, bottom: 58.scale, trailing: 16.scale))
                .multilineTextAlignment(.center)
                .lineSpacing(2.scale)
        case .disable:
            VStack(spacing: 16.scale) {
                Spacer()
                Text("CardScanner.PermissionProblem.Title".localized)
                    .font(Fonts.Inter.font(size: 22.scale, weight: .w700))
                    .foregroundStyle(.white)
                
                Text("CardScanner.PermissionProblem.SubTitle")
                    .font(Fonts.Inter.font(size: 16.scale, weight: .w400))
                    .lineSpacing(4.scale)
                    .foregroundStyle(.white.opacity(0.5))
                
                if let url = URL(string: UIApplication.openSettingsURLString) {
                    Link(destination: url) {
                        Text("CardScanner.PermissionProblem.Button".localized)
                    }
                    .buttonStyle(.button(.primary))
                    .padding(.top, 20.scale)
                }
                Spacer()
            }
            .padding(.horizontal, 32.scale)
            .multilineTextAlignment(.center)
        case .notDetermined:
            Spacer()
        }
    }
}

#Preview {
    NavigationStack {
        CardScannerView()
    }
    .environmentObject(NavigationManager())
}
