import SwiftUI
import Charts

struct ChartStyle {
    static func hrChartStyle(_ data: [ChartDataPoint]) -> some View {
        Chart(data) {
            LineMark(
                x: .value("Time", $0.timestamp),
                y: .value("HR", $0.value)
            )
        }
    }

    static func rrChartStyle(_ data: [ChartDataPoint]) -> some View {
        Chart(data) {
            LineMark(
                x: .value("Time", $0.timestamp),
                y: .value("RR", $0.value)
            )
        }
    }

    static func jumpChartStyle(_ data: [ChartDataPoint]) -> some View {
        Chart(data) {
            BarMark(
                x: .value("Time", $0.timestamp),
                y: .value("Z", $0.value)
            )
        }
    }
}

