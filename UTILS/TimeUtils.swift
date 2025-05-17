//
//  TimeUtils.swift
//  PolarHeartRateApp
//
//  Created by Bt.Ross on 11/05/25.
//

import Foundation

class TimeUtils {
    static func timeAgo(from date: Date) -> String {
        let interval = Date().timeIntervalSince(date)
        let minutes = Int(interval / 60)
        let seconds = Int(interval) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }

    static func formatted(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm:ss.SSS"
        return formatter.string(from: date)
    }

    static func secondsBetween(_ start: Date, _ end: Date) -> Double {
        return end.timeIntervalSince(start)
    }
}
