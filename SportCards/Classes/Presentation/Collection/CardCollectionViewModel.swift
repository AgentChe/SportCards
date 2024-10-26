//
//  CardCollectionViewModel.swift
//  SportCards
//
//  Created by Vitaliy Zagorodnov on 26.10.2024.
//

import Foundation
import Combine

final class CardCollectionViewModel: ObservableObject {
    @Published var isAvailable: Bool = false
    @Published var screenState: ScreenState = .loading
    
    private lazy var profileManager: ProfileManagerProtocol = ProfileManager()
    private var cancellable: AnyCancellable? = nil
    
    init() {
        makeData()
    }
    
    func makeData() {
        screenState = .loading
        
        cancellable = profileManager
            .collectionsAvailable()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                switch result {
                case .success(let success):
                    self?.isAvailable = success
                    self?.screenState = .loaded
                case .failure(let failure):
                    self?.screenState = .error
                }
            }
    }
}
