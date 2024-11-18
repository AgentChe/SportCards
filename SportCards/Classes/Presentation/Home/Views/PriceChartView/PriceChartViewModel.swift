//
//  PriceChartViewModel.swift
//  SportCards
//
//  Created by Vitaliy Zagorodnov on 02.10.2024.
//

import Foundation
import Combine

class PriceChartViewModel: ObservableObject {
    @Published var currentFilter: PriceFilters = .today
    @Published var xScale: ClosedRange<Date> = (.now)...(.now + 10)
    @Published var chartItems: [PriceReport.Item] = []
    @Published var medianModel: PriceReport.Item? = nil
    
    private var cancellable: Set<AnyCancellable> = []
    
    init(model: PriceReport) {
        let emptyItems: [PriceReport.Item] = [
            .init(dateTime: .now, price: "", priceRaw: 1, diffPercent: 0),
            .init(dateTime: .now + 10, price: "", priceRaw: 1, diffPercent: 0),
        ]
        
        let filtered = $currentFilter
            .removeDuplicates()
            .map { filter in
                switch filter {
                case .today:
                    model.today
                case .week:
                    model.week
                case .twoWeek:
                    model.twoWeek
                case .month:
                    model.month
                }
            }
            .prepend(model.today)
            .shareReplay(1)
        
        let currentItems = filtered
            .map { $0.count > 1 ? $0 : emptyItems }
            .shareReplay(1)
        
        currentItems
            .prepend(emptyItems)
            .assign(to: &$chartItems)
        
        currentItems
            .prepend(emptyItems)
            .compactMap { items -> ClosedRange<Date>? in
                let sorted = items.sorted(by: { $0.dateTime < $1.dateTime })
                guard let first = sorted.first, let last = sorted.last else { return nil }
                return first.dateTime...last.dateTime
            }
            .assign(to: &$xScale)
        
        filtered
            .map { items in
                items.count > 1 ? items.last : nil
            }
            .assign(to: &$medianModel)
    }
}
