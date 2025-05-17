import Foundation
import CoreBluetooth
import PolarBleSdk
import RxSwift
import UIKit

class PolarManager: ObservableObject {
    static let shared = PolarManager()
    
    private let polarApi = PolarBleApiDefaultImpl.polarImplementation(
        DispatchQueue.main,
        features: [.feature_hr, .feature_acc]
    )

    @Published var connectedDevices: [String: AthleteData] = [:]
    @Published var discoveredDevices: [PolarDeviceInfo] = []

    private var disposables: [String: DisposeBag] = [:]
    var smoothingWindowInSeconds: Double = 15

    init() {
        polarApi.observer = self
    }

    func startScan() {
        polarApi.searchForDevice()
    }

    func connectToDevice(_ deviceId: String) {
        try? polarApi.connectToDevice(deviceId)
    }

    func disconnectFromDevice(_ deviceId: String) {
        try? polarApi.disconnectFromDevice(deviceId)
        connectedDevices.removeValue(forKey: deviceId)
        disposables.removeValue(forKey: deviceId)
    }

    func resetDevice(_ deviceId: String) {
        guard var data = connectedDevices[deviceId] else { return }
        data.hrValues.removeAll()
        data.rrValues.removeAll()
        data.jumpPoints.removeAll()
        data.smoothedHR.removeAll()
        data.smoothedRR.removeAll()
        connectedDevices[deviceId] = data
    }

    private func addHRData(_ deviceId: String, value: Int) {
        let point = HRDataPoint(timestamp: Date(), value: value)
        connectedDevices[deviceId]?.hrValues.append(point)
        connectedDevices[deviceId]?.smoothedHR = MovingAverage.compute(
            from: connectedDevices[deviceId]!.hrValues,
            windowSeconds: smoothingWindowInSeconds
        )
    }

    private func addRRData(_ deviceId: String, rrMs: UInt16) {
        let point = RRDataPoint(timestamp: Date(), value: Double(rrMs))
        connectedDevices[deviceId]?.rrValues.append(point)
        connectedDevices[deviceId]?.smoothedRR = MovingAverage.compute(
            from: connectedDevices[deviceId]!.rrValues,
            windowSeconds: smoothingWindowInSeconds
        )
    }

    private func processAccelerometer(deviceId: String, z: Double) {
        let point = MarkedPoint(timestamp: Date(), value: z)
        connectedDevices[deviceId]?.jumpPoints.append(point)
    }
}

// MARK: - PolarBleApiObserver
extension PolarManager: PolarBleApiObserver {
    func blePowerStateChanged(_ powerOn: Bool) {
        print("BLE power state changed: \(powerOn ? "ON" : "OFF")")
    }

    func deviceConnected(_ identifier: PolarDeviceInfo) {
        print("Connected to \(identifier.deviceId)")
        let deviceId = identifier.deviceId
        connectedDevices[deviceId] = AthleteData(athleteName: "", deviceId: deviceId)
        disposables[deviceId] = DisposeBag()

        // HR Stream
        let hrStream = polarApi.startHrStreaming(deviceId)
        hrStream.subscribe(onNext: { samples in
            for sample in samples {
                self.addHRData(deviceId, value: Int(sample.hr))
                for rr in sample.rrsMs {
                    self.addRRData(deviceId, rrMs: UInt16(rr))
                }
            }
        }).disposed(by: disposables[deviceId]!)

        // ACC Stream
        polarApi.requestStreamSettings(deviceId, feature: .acc)
            .subscribe(onSuccess: { settings in
                self.polarApi.startAccStreaming(deviceId, settings: settings)
                    .subscribe(onNext: { accSamples in
                        for sample in accSamples {
                            let z = Double(sample.z)
                            self.processAccelerometer(deviceId: deviceId, z: z)
                        }
                    }, onError: { error in
                        print("ACC streaming error: \(error)")
                    }).disposed(by: self.disposables[deviceId]!)
            }, onFailure: { error in
                print("ACC settings error: \(error)")
            }).disposed(by: disposables[deviceId]!)
    }

    func deviceConnecting(_ identifier: PolarDeviceInfo) {
        print("Connecting to \(identifier.deviceId)")
    }

    func deviceDisconnected(_ identifier: PolarDeviceInfo, pairingError: Bool) {
        print("Disconnected from \(identifier.deviceId), pairingError: \(pairingError)")
        let deviceId = identifier.deviceId
        connectedDevices.removeValue(forKey: deviceId)
        disposables.removeValue(forKey: deviceId)
    }

    func disInformationReceived(_ identifier: PolarDeviceInfo, uuid: CBUUID, value: String) {
        print("DIS received: \(uuid) = \(value)")
    }

    func batteryLevelReceived(_ identifier: PolarDeviceInfo, level: UInt) {
        print("Battery level for \(identifier.deviceId): \(level)%")
    }

    func hrFeatureReady(_ identifier: PolarDeviceInfo) {
        print("HR feature ready for \(identifier.deviceId)")
    }

    func sdkModeFeatureAvailable(_ identifier: PolarDeviceInfo) {
        print("SDK Mode available for \(identifier.deviceId)")
    }
}

