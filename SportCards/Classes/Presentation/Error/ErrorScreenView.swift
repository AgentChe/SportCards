//
//  ErrorScreenView.swift
//  SportCards
//
//  Created by Vitaliy Zagorodnov on 09.10.2024.
//

import SwiftUI

enum ErrorScreenType: Identifiable {
    case internet
    case request
    case appstore
    
    var id: Self { self }
}

struct ErrorStateModifier: ViewModifier {
    @Binding private var errorType: ErrorScreenType?
    private let tryAgain: () -> Void
    
    init(errorType: Binding<ErrorScreenType?>, tryAgain: @escaping () -> Void) {
        self._errorType = errorType
        self.tryAgain = tryAgain
    }
    
    func body(content: Content) -> some View {
        content
            .fullScreenCover(item: $errorType, content: { ErrorScreenView(errorType: $0, tryAgain: tryAgain)})
    }
}

extension View {
    func tryAgain(error: Binding<ErrorScreenType?>, tryAgain: @escaping () -> Void) -> some View {
        modifier(ErrorStateModifier(errorType: error, tryAgain: tryAgain))
    }
}

struct ErrorScreenView: View {
    @Environment(\.dismiss) private var dismiss
    private let errorType: ErrorScreenType
    private let tryAgain: () -> Void
    
    init(errorType: ErrorScreenType, tryAgain: @escaping () -> Void) {
        self.errorType = errorType
        self.tryAgain = tryAgain
    }
    
    var body: some View {
        VStack(spacing: 0) {
            Spacer()
            Image(errorType.imageName)
                .padding(.bottom, 24.scale)
            Text(errorType.title)
                .font(Fonts.Inter.font(size: 22.scale, weight: .w700))
                .foregroundStyle(.mono100)
                .padding(.bottom, 20.scale)
            Text(errorType.subtitle)
                .font(Fonts.Inter.font(size: 16.scale, weight: .w400))
                .foregroundStyle(.mono100.opacity(0.5))
                .lineSpacing(3.scale)
            Spacer()
            
            Button(
                action: {
                    tryAgain()
                    dismiss()
                    
                }, label: { Text("Error.TryAgain".localized) })
                .buttonStyle(.button(.primary))
            
            if errorType == .request {
                Button(action: { }, label: { Text("Error.Support".localized) })
                    .buttonStyle(.button(.secondary))
                    .padding(.top, 16.scale)
            }
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button(action: dismiss.callAsFunction, label: {
                    Image("Close")
                })
            }
        }
        .padding(.horizontal, 28.scale)
        .multilineTextAlignment(.center)
        .gradientBackground()
    }
}

#Preview {
    ErrorScreenView(errorType: .request) {}
}

private extension ErrorScreenType {
    var imageName: String {
        switch self {
        case .internet:
            "Error.Internet"
        case .request:
            "Error.Request"
        case .appstore:
            "Error.Appstore"
        }
    }
    
    var title: String {
        switch self {
        case .internet:
            "Error.Internet.Title".localized
        case .request:
            "Error.Request.Title".localized
        case .appstore:
            "Error.Appstore.Title".localized
        }
    }
    
    var subtitle: String {
        switch self {
        case .internet:
            "Error.Internet.Subtitle".localized
        case .request:
            "Error.Request.Subtitle".localized
        case .appstore:
            "Error.Appstore.Subtitle".localized
        }
    }
}
