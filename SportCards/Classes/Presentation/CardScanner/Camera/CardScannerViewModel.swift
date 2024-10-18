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

final class CardScannerViewModel: ObservableObject {
    @MainActor @Published var savedImage: Data? = nil
    @Published var viewfinderImage: Image?
    @Published var selectedPhoto: PhotosPickerItem? = nil
    @Published var isFlashOn: Bool = false
    @Published var isShowAlert: Bool = false
    
    private let cameraManager = CameraManager()
    
    init() {
        Task { await handleCameraPreviews() }
        Task { await handleCameraPhotos() }
        handlePhotoLibrary()
        isFlashOn = cameraManager.isFlashOn
    }
    
    deinit {
        stop()
    }
}

extension CardScannerViewModel {
    func start() {
        Task { [cameraManager] in
            let isAuthorized = await cameraManager.isAuthorized
            isShowAlert = !isAuthorized
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
    
    func handlePhotoLibrary() {
        $selectedPhoto
            .delay(for: 0.3, scheduler: DispatchQueue.main)
            .map { item -> AnyPublisher<Data?, Never> in
                Future { promise in
                    item?.loadTransferable(type: Data.self) { promise($0) }
                }
                .replaceError(with: nil)
                .eraseToAnyPublisher()
            }
            .switchToLatest()
            .compactMap { $0 }
            .receive(on: DispatchQueue.main)
            .assign(to: &$savedImage)
    }
}

fileprivate extension CIImage {
    var image: Image? {
        let ciContext = CIContext()
        guard let cgImage = ciContext.createCGImage(self, from: self.extent) else { return nil }
        return Image(decorative: cgImage, scale: 1, orientation: .up)
    }
}
