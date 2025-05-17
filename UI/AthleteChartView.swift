//
//  AthleteChartView.swift
//  PolarHeartRateApp
//
//  Created by Bt.Ross on 11/05/25.
//

import SwiftUI
import Charts

struct AthleteChartView: View {
    var athlete: AthleteData

    var body: some View {
        VStack(alignment: .leading) {
            Text(athlete.athleteName.isEmpty ? athlete.deviceId : athlete.athleteName)
                .font(.headline)

            // HR Chart
            Chart(athlete.smoothedHR, id: \.timestamp) {
                LineMark(
                    x: .value("Time", \.timestamp),
                    y: .value("HR", \.value)
                )
            }
            .frame(height: 100)
            .chartYScale(domain: 40...200)

            // RR Chart
            Chart(athlete.smoothedRR, id: \.timestamp) {
                LineMark(
                    x: .value("Time", \.timestamp),
                    y: .value("RR", \.value)
                )
            }
            .frame(height: 100)
            .chartYScale(domain: 0...2000)

            // Jumps Chart
            Chart(athlete.jumpPoints, id: \.timestamp) {
                BarMark(
                    x: .value("Time", \.timestamp),
                    y: .value("Z", \.value)
                )
            }
            .frame(height: 80)
            .chartYScale(domain: 0...5)
        }
    }
}
