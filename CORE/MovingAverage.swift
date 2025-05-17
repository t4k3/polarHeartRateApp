import Foundation

class MovingAverage {
    static func compute(from data: [HRDataPoint], windowSeconds: Double) -> [HRDataPoint] {
        var result: [HRDataPoint] = []

        for (index, point) in data.enumerated() {
            let windowStart = point.timestamp.addingTimeInterval(-windowSeconds)
            let window = data.filter { $0.timestamp >= windowStart && $0.timestamp <= point.timestamp }

            let average = window.map { $0.value }.reduce(0, +) / max(window.count, 1)
            result.append(HRDataPoint(timestamp: point.timestamp, value: average))
        }
        return result
    }

    static func compute(from data: [RRDataPoint], windowSeconds: Double) -> [RRDataPoint] {
        var result: [RRDataPoint] = []

        for (index, point) in data.enumerated() {
            let windowStart = point.timestamp.addingTimeInterval(-windowSeconds)
            let window = data.filter { $0.timestamp >= windowStart && $0.timestamp <= point.timestamp }

            let average = window.map { $0.value }.reduce(0, +) / Double(max(window.count, 1))
            result.append(RRDataPoint(timestamp: point.timestamp, value: average))
        }
        return result
    }
}

