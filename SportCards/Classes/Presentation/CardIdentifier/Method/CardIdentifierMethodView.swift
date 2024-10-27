//
//  CardIdentifierMethodView.swift
//  SportCards
//
//  Created by Vitaliy Zagorodnov on 10.10.2024.
//

import SwiftUI

struct CardIdentifierMethodView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var router: NavigationManager
    @StateObject private var viewModel = CardIdentifierMethodViewModel()
    @State private var presentPaygate: Bool = false
    
    var body: some View {
        VStack(spacing: 0) {
            Text("CardIdentifier.Title".localized)
                .font(Fonts.Inter.font(size: 24.scale, weight: .w700))
                .foregroundStyle(.mono100)
                .padding(.top, 40.scale)
            
            Text("CardIdentifier.Subtitle".localized)
                .font(Fonts.Inter.font(size: 18.scale, weight: .w400))
                .foregroundStyle(.mono100)
                .lineSpacing(10.scale)
                .padding(.top, 24.scale)
                .padding(.bottom, 40.scale)
            
            Button(
                action: {
                    if viewModel.hasActiveSubscriptions() || !viewModel.isScannedRestriction {
                        router.push(to: .scanner)
                    } else {
                        presentPaygate = true
                    }
                },
                label: {
                    VStack(spacing: 16.scale) {
                        Image("Scanner.Scan")
                        Text("CardIdentifier.Action.Scan".localized)
                            .font(Fonts.Inter.font(size: 18.scale, weight: .w700))
                            .foregroundStyle(.mono100)
                    }
                }
            )
            .buttonStyle(ScannerButtonStyle())
            .padding(.bottom, 16.scale)
            
            NavigationLink(value: Route.manualSearch) {
                VStack(spacing: 16.scale) {
                    Image("Scanner.Manual")
                    Text("CardIdentifier.Action.Manual".localized)
                        .font(Fonts.Inter.font(size: 18.scale, weight: .w700))
                        .foregroundStyle(.mono100)
                }
            }
            .buttonStyle(ScannerButtonStyle())
            
            Spacer()
            
            Button(action: dismiss.callAsFunction) {
                Text("CardIdentifier.BackButton")
            }
            .buttonStyle(.button(.secondary))
        }
        .multilineTextAlignment(.center)
        .navigationBarBackButtonHidden()
        .padding(.horizontal, 16.scale)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button(action: dismiss.callAsFunction) {
                    HStack(spacing: 6.scale) {
                        Image("Back")
                        Text("CardIdentifier.BackTitle")
                            .font(Fonts.Inter.font(size: 22.scale, weight: .w700))
                    }
                    .foregroundStyle(.white)
                }
            }
        }
        .gradientBackground()
        .fullScreenCover(isPresented: $presentPaygate, content: { PaygateView() })
    }
}

private struct ScannerButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(.vertical, 30.scale)
            .frame(maxWidth: .infinity)
            .background(configuration.isPressed ? .main400 : .main400.opacity(0.02), in: RoundedRectangle(cornerRadius: 8.scale))
            .overlay {
                RoundedRectangle(cornerRadius: 8.scale)
                    .stroke(.main400, lineWidth: 1.scale)
            }
    }
}

#Preview {
    NavigationStack {
        CardIdentifierMethodView()
    }
}
