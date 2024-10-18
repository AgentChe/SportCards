//
//  TagView.swift
//  SportCards
//
//  Created by Vitaliy Zagorodnov on 04.10.2024.
//

import SwiftUI

struct TagStyleConfiguration {
    @Binding var isSelected: Bool
    let label: Text
}

protocol TagStyle {
    associatedtype Body: View
    typealias Configuration = TagStyleConfiguration
    @ViewBuilder func makeBody(configuration: Configuration) -> Body
    
}

struct TagView: View {
    @Environment(\.tagStyle) private var style
    @Binding private var isSelected: Bool
    private var text: String
    
    init(_ text: String, isSelected: Binding<Bool> = .constant(false)) {
        self.text = text
        self._isSelected = isSelected
    }
    
    init(_ text: String, isSelected: Bool = false) {
        self.text = text
        self._isSelected = .constant(isSelected)
    }
    
    var body: some View {
        let configuration = TagStyleConfiguration(isSelected: $isSelected, label: Text(text))
        
        AnyView(style.makeBody(configuration: configuration))
    }
}

struct DefaultTagStyle: TagStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(Fonts.Inter.font(size: 14.scale, weight: .w400))
            .foregroundStyle(Appearance.mono100)
            .padding(.vertical, 8.scale)
            .padding(.horizontal, 14.scale)
            .background(configuration.isSelected ? .main100 : .main300, in: Capsule())
            .overlay {
                if !configuration.isSelected {
                    Capsule()
                        .stroke(.main200, lineWidth: 1.scale)
                }
            }
    }
}

struct CheckboxTagStyle: TagStyle {
    func makeBody(configuration: Configuration) -> some View {
        HStack(spacing: 6.scale) {
            Image(configuration.isSelected ? "Checkbox.Selected" : "Checkbox.Default")
                .resizable()
                .frame(width: 24.scale, height: 24.scale)
                .padding(.vertical, 8.scale)
            
            configuration.label
                .font(Fonts.Inter.font(size: 14.scale, weight: .w400))
                .foregroundStyle(Appearance.mono100)
        }
        .padding(.leading, 8.scale)
        .padding(.trailing, 14.scale)
        .background(.main300, in: Capsule())
        .overlay {
            Capsule()
                .stroke(.main200, lineWidth: 1.scale)
        }
    }
}

extension TagStyle where Self == CheckboxTagStyle {
    static var checkbox: Self { .init() }
}

extension TagStyle where Self == DefaultTagStyle {
    static var `default`: Self { .init() }
}

struct TagStyleKey: EnvironmentKey {
    static var defaultValue: any TagStyle = .default
}

extension EnvironmentValues {
    var tagStyle: any TagStyle {
        get { self[TagStyleKey.self] }
        set { self[TagStyleKey.self] = newValue }
    }
}

extension View {
    func tagStyle(_ style: some TagStyle) -> some View {
        environment(\.tagStyle, style)
    }
}

#Preview {
    VStack {
        TagView("Tag1", isSelected: true)
        TagView("Tag2", isSelected: true)
        Group {
            TagView("Tag3", isSelected: true)
            TagView("Tag4", isSelected: true)
        }.tagStyle(.checkbox)
    }
}
