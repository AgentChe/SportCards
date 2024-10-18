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
            
            CardScannerTabBar(
                selectedPhoto: $viewModel.selectedPhoto,
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
            }
        }
        .onAppear { viewModel.start() }
        .onDisappear { viewModel.stop() }
        .alert(
            "CardScanner.CameraAlert.Title".localized,
            isPresented: $viewModel.isShowAlert,
            actions: {
                Button("Cancel".localized, role: .cancel) { viewModel.isShowAlert = false }
                if let url = URL(string: UIApplication.openSettingsURLString) {
                    Link("Ok".localized, destination: url)
                }
            }, 
            message: { Text("CardScanner.CameraAlert.Message".localized) }
        )

    }
    
    @State private var currentGrade: Grade? = nil
}

#Preview {
    NavigationStack {
        CardScannerView()
    }
    .environmentObject(NavigationManager())
}
