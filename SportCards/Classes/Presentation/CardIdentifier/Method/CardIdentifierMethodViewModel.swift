//
//  CardIdentifierMethodViewModel.swift
//  SportCards
//
//  Created by Vitaliy Zagorodnov on 27.10.2024.
//

import Foundation

final class CardIdentifierMethodViewModel: ObservableObject {
    
    @Published var isScannedRestriction: Bool = false
    
    private lazy var sessionManager = SessionManager()
    private lazy var profileManager: ProfileManagerProtocol = ProfileManager()
    
    init() {
        ProfileManagerMediator.shared.needUpdateCollection
            .filter { $0 == .scanned }
            .mapToVoid()
            .prepend(())
            .map { [weak self] in
                self?.profileManager.isScannedRestriction() ?? false
            }
            .assign(to: &$isScannedRestriction)
    }
    
    func hasActiveSubscriptions() -> Bool {
        sessionManager.hasActiveSubscriptions()
    }
}
