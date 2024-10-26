//
//  CardScannedImageViewModel.swift
//  SportCards
//
//  Created by Vitaliy Zagorodnov on 17.10.2024.
//

import Foundation
import UIKit
import Combine

enum Action {
    case step(ScannerState)
    case details(_ id: String, _ grade: String)
    case error
}

final class CardScannedImageViewModel: ObservableObject {
    @Published private(set) var grades: [String] = []
    @Published var selectedGrade: String? = nil
    @Published var image: UIImage? = nil
    @Published var action: Action = .step(.photo)
    
    private lazy var cardsManager = CardsManager()
    
    private let acceptPhotoSubject = PassthroughSubject<Void, Never>()
    private let acceptGradeSubject = PassthroughSubject<Void, Never>()
    
    init(data: Data) {
        let image = UIImage(data: data)
        self.image = image
        
        acceptPhotoSubject
            .prefix(1)
            .compactMap { [weak self] _ -> AnyPublisher<Action, Never>? in
                guard let self, let image else { return nil }
                
                return cardsManager
                    .upload(image: image)
                    .compactMap { [weak self] response -> AnyPublisher<Action, Never>? in
                        guard let self else { return nil }
                        guard let response else { return Just(Action.error).eraseToAnyPublisher() }
                        
                        return acceptGradeSubject
                            .map { _ in Action.details(response.cardId, self.selectedGrade ?? "")}
                            .prepend(.step(.grade(response.grades)))
                            .eraseToAnyPublisher()
                    }
                    .switchToLatest()
                    .prepend(.step(.request))
                    .eraseToAnyPublisher()
            }
            .switchToLatest()
            .assign(to: &$action)
    }
    
    func acceptPhoto() {
        acceptPhotoSubject.send(())
    }
    
    func acceptGrade() {
        acceptGradeSubject.send(())
    }
}
