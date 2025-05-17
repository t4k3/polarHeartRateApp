//
//  Untitled.swift
//  PolarHeartRateApp
//
//  Created by Bt.Ross on 11/05/25.
//

import SwiftUI
import Charts

struct SingleDataChartView: View {
    let title: String
    let data: [ChartDataPoint]
    let yLabel: String
    let yDomain: ClosedRange<Double>

    var body: some View {
        VStack {
            Text(title).font(.title2).padding(.top)

            Chart(data, id: \.timestamp) {
                if yLabel == "Z" {
                    BarMark(
                        x: .value("Time", \.timestamp),
                        y: .value(yLabel, \.value)
                    )
                } else {
                    LineMark(
                        x: .value("Time", \.timestamp),
                        y: .value(yLabel, \.value)
                    )
                }
            }
            .chartYScale(domain: yDomain)
            .padding()
        }
        .padding()
    }
}

// Tipo dati generico per graficare
struct ChartDataPoint: Identifiable {
    let id = UUID()
    var timestamp: Date
    var value: Double
}
