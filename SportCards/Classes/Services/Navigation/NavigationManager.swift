//
//  NavigationManager.swift
//  SportCards
//
//  Created by Vitaliy Zagorodnov on 16.10.2024.
//

import Foundation
import SwiftUI

enum Route {
    case cardIdetifier
    case scanner
    case scannedImage(Data)
    case filters(Binding<Filters>)
    case cardDescription
    case manualSearch
}

extension Route: Identifiable, Hashable {
    var id: String {
        switch self {
        case .cardIdetifier:
            "cardIdetifier"
        case .scanner:
            "scanner"
        case .scannedImage:
            "scannedImage"
        case .filters:
            "filters"
        case .cardDescription:
            "cardDescription"
        case .manualSearch:
            "manualSearch"
        }
    }
    
    static func ==(lhs: Self, rhs: Self) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

final class NavigationManager: ObservableObject {
    @Published var path: [Route] = []
    
    func push(to route: Route) {
        path.append(route)
    }
    
    func pop(to route: Route? = nil) {
        if let route, let index = path.lastIndex(where: { $0 == route }) {
            path = Array(path.prefix(upTo: index + 1))
        } else {
            path.removeLast()
        }
    }
    
    func replacePush(from route: Route) {
        let index = path.count - 1
        path[index] = route
    }
    
    func replacePush(route: Route, replaced: Route) {
        guard let index = path.lastIndex(of: replaced) else { return }
        path.removeLast(path.count - index)
        path.append(route)
        
    }
}

struct RootNavigationStack<Content: View>: View {
    @StateObject private var router = NavigationManager()
    private let content: Content
    
    init(@ViewBuilder _ root: () -> Content) {
        content = root()
    }
    
    var body: some View {
        NavigationStack(path: $router.path) {
            content
                .navigationDestination(for: Route.self) { route in
                    switch route {
                    case .cardIdetifier:
                        CardIdentifierMethodView()
                    case .scanner:
                        CardScannerView()
                    case let .scannedImage(data):
                        CardScannedImageView(image: data)
                    case let .filters(filters):
                        FiltersView(filters: filters)
                    case .cardDescription:
                        CardDescriptionView()
                    case .manualSearch:
                        ManualCardSearchView()
                    }
                }
        }
        .environmentObject(router)
    }
}
