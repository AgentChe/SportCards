//
//  PriceChartView.swift
//  SportCards
//
//  Created by Vitaliy Zagorodnov on 01.10.2024.
//

import SwiftUI
import Charts

struct PriceChartView: View {
    @StateObject private var viewModel: PriceChartViewModel
    private let title: String
    
    init(title: String, model: PriceReport) {
        self.title = title
        _viewModel = StateObject(wrappedValue: .init(model: model))
    }
    
    var body: some View {
        VStack(spacing: 10.scale) {
            HStack {
                Text(title)
                    .font(Fonts.Inter.font(size: 14.scale, weight: .w400))
                    .foregroundStyle(.white)
                Spacer()
            }
            
            Chart {
                ForEach(viewModel.chartItems, id: \.self) { price in
                    AreaMark(x: .value("Date", price.dateTime), y: .value("Price", price.priceRaw))
                        .interpolationMethod(.catmullRom)
                        .foregroundStyle(
                            LinearGradient(
                                colors: [.main100.opacity(0.4), .main300.opacity(1)],
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )
                    
                    LineMark(x: .value("Date", price.dateTime), y: .value("Price", price.priceRaw))
                        .interpolationMethod(.catmullRom)
                        .foregroundStyle(.main100)
                        .lineStyle(StrokeStyle(lineWidth: 2.scale))
                }
            }
            .chartXAxis(.hidden)
            .chartYAxis(.hidden)
            .chartXScale(domain: viewModel.xScale)
            .chartPlotStyle(content: { content in
                content.frame(height: viewModel.medianModel == nil ? 20.scale : 64.scale)
            })
            .frame(height: 108.scale, alignment: .bottom)
            .background {
                Rectangle()
                    .fill(.main100)
                    .frame(width: 1.scale)
            }
            .chartOverlay(alignment: .top) { proxy in
                VStack(spacing: 0) {
                    toolTypeText
                        .font(Fonts.Inter.font(size: 12.scale, weight: .w700))
                        .foregroundStyle(.white)
                        .padding(.horizontal, 16.scale)
                        .padding(.vertical, 8.scale)
                        .background(.main200, in: Capsule())
                    
                    Triangle()
                        .fill(.main200)
                        .frame(width: 12.scale, height: 6.scale)
                }
            }
            
            HStack {
                ForEach(PriceFilters.allCases, id: \.self) { filter in
                    Button(
                        action: { viewModel.currentFilter = filter },
                        label: {
                            Text(filter.name)
                                .font(Fonts.Inter.font(size: 14.scale, weight: .w400))
                                .foregroundStyle(.mono100)
                                .padding(.horizontal, 16.scale)
                                .padding(.vertical, 8.scale)
                        }
                    )
                    .background(
                        viewModel.currentFilter == filter ? .main100 : .main300,
                        in: Capsule()
                    )
                    .overlay {
                        if viewModel.currentFilter != filter {
                            Capsule()
                                .stroke(.main200, lineWidth: 1.scale)
                        }
                    }
                }
            }
        }
        .padding(EdgeInsets(top: 16.scale, leading: 16.scale, bottom: 13.scale, trailing: 16.scale))
        .background(.main300, in: RoundedRectangle(cornerRadius: 16.scale))
        .overlay {
            RoundedRectangle(cornerRadius: 16.scale)
                .stroke(.main200, lineWidth: 1.scale)
        }
    }
    
    private var toolTypeText: some View {
        viewModel.medianModel.map { model in
            let formatter = DateFormatter()
            formatter.dateFormat = "MMMM d"
            let date = formatter.string(from: model.dateTime)
            
            let image = Image(model.diffPercent <= 0 ? "Down" : "Up")
            let percent = abs(model.diffPercent / 100)
            
            let percentString: Text
            
            if percent != 0.0 {
                percentString = Text("( \(image) \(percent.formatted(.percent)))")
            } else {
                percentString = Text("")
            }
            
            return Text("\(date): \(model.price)") + percentString
        } ?? Text("Chart.Empty".localized)
    }
}

private struct Triangle: Shape {
    func path(in rect: CGRect) -> Path {
        Path { path in
            path.move(to: .init(x: rect.midX, y: rect.maxY))
            path.addLine(to: .init(x: rect.maxX, y: rect.minY))
            path.addLine(to: .init(x: rect.minX, y: rect.minY))
            path.addLine(to: .init(x: rect.midX, y: rect.maxY))
        }
    }
}

#Preview {
    VStack {
        PriceChartView(title: "Chart.Title.Collection".localized, model: .init(today: [], week: [], twoWeek: [], month: []))
            .frame(maxWidth: .infinity)
    }
    .padding(.horizontal, 16.scale)
    .frame(maxHeight: .infinity)
    .background(.black)
}
