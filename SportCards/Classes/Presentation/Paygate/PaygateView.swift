//
//  PaygateView.swift
//  SportCards
//
//  Created by Vitaliy Zagorodnov on 29.09.2024.
//

import SwiftUI

struct PaygateView: View {
    @Environment(\.dismiss) private var dismiss
    
    @StateObject private var viewModel = PaygateViewModel()
    var body: some View {
        VStack(spacing: 0) {
            Image("Paygate")
                .padding(.bottom, ScreenSize.isIphoneXFamily ? 35.scale : 24.scale)
            Text("Paygate.Title".localized)
                .multilineTextAlignment(.leading)
                .font(Fonts.Inter.font(size: 24.scale, weight: .w700))
                .foregroundStyle(.white)
                .padding(.bottom, ScreenSize.isIphoneXFamily ? 8.scale : 4.scale)
            
            VStack(alignment: .leading, spacing: 16.scale) {
                HStack(spacing: 10.scale) {
                    Image("Paygate.Check")
                    Text("Paygate.Subtitle1".localized)
                }
                HStack(spacing: 10.scale) {
                    Image("Paygate.Check")
                    Text("Paygate.Subtitle2".localized)
                }
                HStack(spacing: 10.scale) {
                    Image("Paygate.Check")
                    Text("Paygate.Subtitle3".localized)
                }
            }
            .font(Fonts.Inter.font(size: 16.scale, weight: .w400))
            .lineSpacing(10.scale)
            .multilineTextAlignment(.leading)
            .foregroundStyle(.mono100)
            .padding(.bottom, 16.scale)
            
            VStack(spacing: 16.scale) {
                Toggle(isOn: $viewModel.isOnTrial, label: {
                    Text(viewModel.currentProduct.toggleTitle)
                        .font(Fonts.Inter.font(size: 16.scale, weight: .w600))
                        .foregroundStyle(.mono100)
                })
                .tint(.main100)
                .padding(.horizontal, 16.scale)
                .padding(.vertical, ScreenSize.isIphoneXFamily ? 17.5.scale : 14.5.scale)
                .background(.main200, in: RoundedRectangle(cornerRadius: 10.scale))
                
                yearlyProduct
                
                trialProduct
                
            }
            .padding(.bottom, 16.scale)
            
            Button(
                action: {},
                label: { Text(viewModel.currentProduct.actionTitle) }
            )
            .buttonStyle(.button(.primary))
            .padding(.bottom, 12.scale)
            
            Label(viewModel.currentProduct.securityLabel.uppercased(), image: "Security")
                .foregroundStyle(.mono100)
                .padding(.bottom, 16.scale)
            
            HStack(spacing: 12.scale) {
                Link(destination: GlobalDefinitions.termsOfUse) {
                    Text("Paygate.TermsOfUse".localized)
                }
                
                Link(destination: GlobalDefinitions.privacyPolicy) {
                    Text("Paygate.PrivacyPolicy".localized)
                }
                
                Button(action: {}) { Text("Paygate.RestorePurchases".localized) }
            }
            .padding(.horizontal, 30.scale)
            .font(Fonts.Inter.font(size: 12.scale, weight: .w400))
            .foregroundStyle(.mono100)
            .opacity(0.6)
        }
        .animation(.interpolatingSpring(), value: viewModel.currentProduct)
        .ignoresSafeArea()
        .padding(.horizontal, 16.scale)
        .frame(maxHeight: .infinity)
        .background(.black)
        .overlay(alignment: .topTrailing) {
            Button(
                action: dismiss.callAsFunction,
                label: {
                    Image("Close")
                        .padding(10.scale)
                }
            )
        }
    }
    
    @ViewBuilder private var yearlyProduct: some View {
        Button(action: {
            viewModel.isOnTrial = false
        }, label: {
            HStack(spacing: 0) {
                VStack(alignment: .leading, spacing: 4.scale) {
                    Text("Yearly")
                        .font(Fonts.Inter.font(size: 14.scale, weight: .w400))
                    Text("$39.99/year")
                        .font(Fonts.Inter.font(size: 16.scale, weight: .w600))
                }
                
                Spacer()
                
                VStack(alignment: .leading, spacing: 4.scale) {
                    Text("$0.96")
                        .font(Fonts.Inter.font(size: 16.scale, weight: .w400))
                    Text("per week")
                        .font(Fonts.Inter.font(size: 14.scale, weight: .w400))
                }
                .padding(.trailing, 40.scale)
                
                Image(viewModel.currentProduct == .yearly ? "Radiobutton.Selected" : "Radiobutton.Default")
            }
        })
        .foregroundStyle(.mono100)
        .padding(.horizontal, 16.scale)
        .padding(.vertical, ScreenSize.isIphoneXFamily ? 12.scale : 8.scale)
        .background(.main200, in: RoundedRectangle(cornerRadius: 10.scale))
        .overlay {
            if viewModel.currentProduct == .yearly {
                RoundedRectangle(cornerRadius: 10.scale)
                    .stroke(.main100, lineWidth: 2.scale)
            }
        }
        .overlay(alignment: .topTrailing) {
            Text("Paygate.BestOffer")
                .font(Fonts.Inter.font(size: 12.scale, weight: .w500))
                .foregroundStyle(.mono100)
                .padding(.horizontal, 8.scale)
                .padding(.vertical, 4.5.scale)
                .background(viewModel.currentProduct == .yearly ? .main100 : .main200, in: RoundedRectangle(cornerRadius: 10.scale))
                .overlay {
                    RoundedRectangle(cornerRadius: 10.scale)
                        .stroke(lineWidth: 1.scale)
                        .fill(viewModel.currentProduct == .yearly ? .main100 : .bestOfferBorder)
                }
                .alignmentGuide(.top) { $0[VerticalAlignment.center] }
                .alignmentGuide(.trailing, computeValue: { $0[.trailing] + 8.scale })
        }
    }
    
    @ViewBuilder private var trialProduct: some View {
        Button(action: {
            viewModel.isOnTrial = true
        }, label: {
            HStack(spacing: 0) {
                Text("3-day free trial".uppercased())
                    .font(Fonts.Inter.font(size: 16.scale, weight: .w600))
                
                Spacer()
                
                VStack(alignment: .leading, spacing: 4.scale) {
                    Text("$6.96")
                        .font(Fonts.Inter.font(size: 16.scale, weight: .w600))
                    Text("per week")
                        .font(Fonts.Inter.font(size: 14.scale, weight: .w400))
                }
                .padding(.trailing, 40.scale)
                
                
                Image(viewModel.currentProduct == .trial ? "Radiobutton.Selected" : "Radiobutton.Default")
            }
        })
        .foregroundStyle(.mono100)
        .padding(.horizontal, 16.scale)
        .padding(.vertical, ScreenSize.isIphoneXFamily ? 12.scale : 8.scale)
        .background(.main200, in: RoundedRectangle(cornerRadius: 10.scale))
        .overlay {
            if viewModel.currentProduct == .trial {
                RoundedRectangle(cornerRadius: 10.scale)
                    .stroke(.main100, lineWidth: 2.scale)
            }
        }
    }
}

#Preview {
    PaygateView()
}

private extension PaygateProduct {
    var toggleTitle: String {
        switch self {
        case .trial:
            "Paygate.Trial.Toggle".localized
        case .yearly:
            "Paygate.Yearly.Toggle".localized
        }
    }
    
    var actionTitle: String {
        switch self {
        case .trial:
            "Paygate.Trial.Action".localized
        case .yearly:
            "Paygate.Yearly.Action".localized
        }
    }
    
    var securityLabel: String {
        switch self {
        case .trial:
            "Paygate.Trial.Security".localized
        case .yearly:
            "Paygate.Yearly.Security".localized
        }
    }
}
