//
//  MenuView.swift
//  SportCards
//
//  Created by Vitaliy Zagorodnov on 26.10.2024.
//

import SwiftUI

struct MenuView: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack {
            NavigationLink(value: Route.preferences) {
                makeAction("Menu.Preferences".localized)
            }
            
            Divider()
                .background(.main300)
            
            Link(destination: GlobalDefinitions.termsOfUse) {
                makeAction("Menu.TermsOfUse".localized)
            }
            
            Divider()
                .background(.main300)
            
            Link(destination: GlobalDefinitions.privacyPolicy) {
                makeAction("Menu.PrivacyPolicy".localized)
            }
            
            Divider()
                .background(.main300)
            
            Link(destination: GlobalDefinitions.support) {
                makeAction("Menu.Support".localized)
            }
            
            Spacer()
        }
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button(action: dismiss.callAsFunction) {
                    HStack(spacing: 6.scale) {
                        Image("Back")
                        Text("Menu.Title".localized)
                            .font(Fonts.Inter.font(size: 22.scale, weight: .w700))
                    }
                    .foregroundStyle(.white)
                }
            }
        }
        .padding(.top, 10.scale)
        .padding(.horizontal, 16.scale)
        .navigationBarBackButtonHidden()
        .gradientBackground()
    }
    
    @ViewBuilder
    private func makeAction(_ title: String) -> some View {
        Text(title)
            .font(Fonts.Inter.font(size: 16.scale, weight: .w400))
            .foregroundStyle(.white)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.vertical, 24.scale)
    }
}

#Preview {
    NavigationStack {
        MenuView()
    }
}
