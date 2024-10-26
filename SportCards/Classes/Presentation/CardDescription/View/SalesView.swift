//
//  SalesView.swift
//  SportCards
//
//  Created by Vitaliy Zagorodnov on 23.10.2024.
//

import SwiftUI

struct SalesView: View {
    let sale: CardDetails.Sale
    
    var body: some View {
        VStack(spacing: 24.scale) {
            HStack {
                Text("CardDetails.LastSold".localized)
                Spacer()
                Text("CardDetails.Date".localized)
            }
            .font(Fonts.Inter.font(size: 14.scale, weight: .w400))
            .foregroundStyle(.white.opacity(0.5))
            
            HStack {
                Text(sale.currentPrice)
                Spacer()
                Text(sale.formattedDate)
            }
            .font(Fonts.Inter.font(size: 22.scale, weight: .w700))
            .foregroundStyle(.white)
            .padding(.top, 6.scale)
            
            VStack(spacing: 6.scale) {
                configureLine(name: "CardDetails.NumberSales".localized, value: sale.numberSales.map { "\($0)"} ?? "N/A")
                configureLine(name: "CardDetails.LowestPrice".localized, value: sale.lowPrice ?? "N/A")
                configureLine(name: "CardDetails.HighestPrice".localized, value: sale.hightPrice ?? "N/A")
            }
            .font(Fonts.Inter.font(size: 14.scale, weight: .w400))
            .foregroundStyle(.white)
            
            if let report = sale.report {
                PriceChartView(
                    title: "CardDetails.Report".localized,
                    model: report
                )
            }
        }
    }
    
    @ViewBuilder func configureLine(name: String, value: String) -> some View {
        HStack {
            Text(name)
            Spacer()
            Text(value)
        }
        .padding(.vertical, 10.scale)
        .padding(.horizontal, 18.scale)
        .background(.main300, in: RoundedRectangle(cornerRadius: 8.scale))
    }

}

private extension CardDetails.Sale {
    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM dd, YYYY"
        return formatter.string(from: date)
    }
}

//#Preview {
//    ScrollView(.vertical) {
//        SalesView()
//    }
//    .background(.black)
//}
