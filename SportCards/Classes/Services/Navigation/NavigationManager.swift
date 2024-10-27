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
    case cardDescription(id: String, grade: String, collection: CollectionTab)
    case manualSearch
    case category(CardCategory)
    case menu
    case preferences
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
        case .category:
            "category"
        case .menu:
            "menu"
        case .preferences:
            "preferences"
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
        let range = index...path.count - 1
        
        var transaction = Transaction(animation: .none)
        transaction.disablesAnimations = true
        
        withTransaction(transaction) {
            path.replaceSubrange(range, with: [route])
        }
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
                    case let .cardDescription(id, grade, collection):
                        CardDescriptionView(id: id, grade: grade, collection: collection)
                    case .manualSearch:
                        ManualCardSearchView()
                    case let .category(category):
                        CategoryListView(category: category)
                    case .menu:
                        MenuView()
                    case .preferences:
                        PreferencesView()
                    }
                }
        }
        .environmentObject(router)
    }
}
