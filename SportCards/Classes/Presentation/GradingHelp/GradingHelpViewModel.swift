//
//  GradingHelpViewModel.swift
//  SportCards
//
//  Created by Vitaliy Zagorodnov on 23.04.2025.
//

import Foundation

final class GradingHelpViewModel: ObservableObject {
    @Published private(set) var items: [GradingHelpItem] = []
    let type: GradingHelpType
    
    private let cardsManager = CardsManager()
    
    init(type: GradingHelpType) {
        self.type = type
    }
}

extension GradingHelpViewModel {
    func load() async {
        cardsManager
            .makeGrades(forceUpdate: false)
            .replaceError(with: nil)
            .map { [type] model -> [GradingHelpItem] in
                guard let model else { return [] }
                switch type {
                case .service:
                    return model.service
                        .compactMap { item in
                            guard item.alias.uppercased() != "ALL" else { return nil }
                            
                            return GradingHelpItem(
                                title: item.alias,
                                description: item.name
                            )
                        }
                case .grade:
                    return model.grade
                        .map { item in
                            return GradingHelpItem(
                                title: item.key,
                                description: item.value
                            )
                        }
                        .sorted { lhs, rhs in
                            let lhsDouble = Double(lhs.title.components(separatedBy: " ").first ?? "") ?? 0
                            let rhsDouble = Double(rhs.title.components(separatedBy: " ").first ?? "") ?? 0
                            
                            return lhsDouble < rhsDouble
                        }
                }
            }
            .receive(on: DispatchQueue.main)
            .assign(to: &$items)
    }
}
