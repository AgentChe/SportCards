//
//  CardScannedImageViewModel.swift
//  SportCards
//
//  Created by Vitaliy Zagorodnov on 17.10.2024.
//

import Foundation
import UIKit

final class CardScannedImageViewModel: ObservableObject {
    @Published private(set) var grades: [Grade] = []
    @Published var selectedGrade: Grade? = nil
    @Published var image: UIImage? = nil
    @Published var isSuccessScanned: Bool? = nil
    
    private lazy var cardsManager = CardsManager()
    
    init(data: Data) {
        cardsManager
            .makeGrades(forceUpdate: false)
            .replaceError(with: [])
            .receive(on: DispatchQueue.main)
            .assign(to: &$grades)
        
        image = UIImage(data: data)
    }
}
