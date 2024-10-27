//
//  CardScannerViewModel.swift
//  SportCards
//
//  Created by Vitaliy Zagorodnov on 11.10.2024.
//

import Foundation
import SwiftUI
import PhotosUI
import Combine

enum CameraState {
    case available
    case disable
    case notDetermined
}

final class CardScannerViewModel: ObservableObject {
    @MainActor @Published var savedImage: Data? = nil
    @Published var viewfinderImage: Image?
    @Published var selectedPhoto: PhotosPickerItem? = nil
    @Published var isFlashOn: Bool = false
    @Published var cameraState: CameraState = .notDetermined
    @Published var isAvailableCamera: Bool = false
    
    private let cameraManager = CameraManager()
    
    init() {
        Task { await handleCameraPreviews() }
        Task { await handleCameraPhotos() }
        Task { await handlePhotoLibrary() }
        isFlashOn = cameraManager.isFlashOn
        $cameraState
            .map { $0 == .available }
            .receive(on: DispatchQueue.main)
            .assign(to: &$isAvailableCamera)
    }
    
    deinit {
        stop()
    }
}

extension CardScannerViewModel {
    func start() {
        Task { @MainActor [cameraManager] in
            let isAuthorized = await cameraManager.isAuthorized
            cameraState = isAuthorized ? .available : .disable
            guard isAuthorized else { return }
            await cameraManager.start()
        }
    }
    
    func stop() {
        cameraManager.stop()
    }
    
    func takePhoto() {
        cameraManager.takePhoto()
    }
    
    func switchCaptureDevice() {
        cameraManager.switchCaptureDevice()
    }
    
    func toogleFlash() {
        isFlashOn.toggle()
        cameraManager.isFlashOn.toggle()
    }
}

private extension CardScannerViewModel {
    
    func handleCameraPreviews() async {
        let imageStream = cameraManager.previewStream
            .map { $0.image }
        
        for await image in imageStream {
            Task { @MainActor in
                viewfinderImage = image
            }
        }
    }
    
    func handleCameraPhotos() async {
        let unpackedPhotoStream = cameraManager.photoStream
            .compactMap { $0.fileDataRepresentation() }
        
        for await photoData in unpackedPhotoStream {
            Task { @MainActor in
                savedImage = photoData
            }
        }
    }
    
    func handlePhotoLibrary() async {
        for await item in $selectedPhoto.values {
            Task {
                try? await Task.sleep(for: .milliseconds(500))
                let data = try? await item?.loadTransferable(type: Data.self)
                await MainActor.run { [weak self] in
                    self?.savedImage = data
                }
            }
        }
    }
}

fileprivate extension CIImage {
    var image: Image? {
        let ciContext = CIContext()
        guard let cgImage = ciContext.createCGImage(self, from: self.extent) else { return nil }
        return Image(decorative: cgImage, scale: 1, orientation: .up)
    }
}
