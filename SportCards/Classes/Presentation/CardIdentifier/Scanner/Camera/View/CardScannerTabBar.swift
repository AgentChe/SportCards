//
//  CardScannerTabBar.swift
//  SportCards
//
//  Created by Vitaliy Zagorodnov on 17.10.2024.
//

import SwiftUI
import PhotosUI

struct CardScannerTabBar: View {
    @Binding private var selectedPhoto: PhotosPickerItem?
    @Binding private var availableCamera: Bool
    private let toggleAction: () -> Void
    private let cameraAction: () -> Void
    
    init(selectedPhoto: Binding<PhotosPickerItem?>, availableCamera: Binding<Bool>, toggleAction: @escaping () -> Void, cameraAction: @escaping () -> Void) {
        self._selectedPhoto = selectedPhoto
        self._availableCamera = availableCamera
        self.toggleAction = toggleAction
        self.cameraAction = cameraAction
    }
    
    var body: some View {
        HStack {
            Button(
                action: toggleAction,
                label: {
                    Image("Scanner.Rotate")
                        .padding(11.scale)
                        .background(.main100, in: Circle())
                }
            )
            Spacer()
            
            PhotosPicker(selection: $selectedPhoto, matching: .images, photoLibrary: .shared()) {
                Image("Scanner.Library")
                    .padding(11.scale)
                    .background(.main100, in: Circle())
            }
        }
        .padding(.init(
            top: 18.scale,
            leading: 54.scale,
            bottom: ScreenSize.isIphoneXFamily ? 36.scale : 16.scale,
            trailing: 54.scale
        ))
        .background(.main300)
        .clipShape(UnevenRoundedRectangle(topLeadingRadius: 24.scale, topTrailingRadius: 24.scale))
        .overlay {
            UnevenRoundedRectangle(topLeadingRadius: 24.scale, topTrailingRadius: 24.scale)
                .stroke(.main200, lineWidth: 1.scale)
        }
        .overlay(cameraActionView, alignment: .top)
    }
}

private extension CardScannerTabBar {
    @ViewBuilder
    var cameraActionView: some View {
        if availableCamera {
            Button(action: cameraAction,
                   label: {
                Image("Home.Scanner")
                    .padding(22.scale)
                    .background(.main100, in: Circle())
            }
            )
            .alignmentGuide(.top, computeValue: { dimension in
                dimension[.top] + 22.scale
            })
        }
    }
}

#Preview {
    CardScannerTabBar(selectedPhoto: .constant(nil), availableCamera: .constant(false), toggleAction: {}, cameraAction: {})
}
