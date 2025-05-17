//
//  AccelerometerManager.swift
//  PolarHeartRateApp
//
//  Created by Bt.Ross on 11/05/25.
//

// MARK: - AccelerometerManager.swift

import Foundation

class AccelerometerManager {
    var jumpThresholdZ: Double = 1.9
    var minJumpIntervalMs: Int = 400

    private var lastJumpTime: Date = .distantPast

    func processZ(_ z: Double, deviceId: String, polarManager: PolarManager) {
        let now = Date()
        let interval = now.timeIntervalSince(lastJumpTime)
        if z > jumpThresholdZ && interval > Double(minJumpIntervalMs) / 1000.0 {
            lastJumpTime = now
            let jump = MarkedPoint(timestamp: now, label: "Jump", value: z)
            polarManager.connectedDevices[deviceId]?.jumpPoints.append(jump)
        }
    }
}
