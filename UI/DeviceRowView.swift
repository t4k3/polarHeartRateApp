//
//  Untitled.swift
//  PolarHeartRateApp
//
//  Created by Bt.Ross on 11/05/25.
//

import SwiftUI

struct DeviceRowView: View {
    @EnvironmentObject var polarManager: PolarManager

    let deviceId: String
    let isConnected: Bool

    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(deviceId).font(.caption).foregroundColor(.gray)
            }

            Spacer()

            if isConnected {
                Button("Disconnetti") {
                    polarManager.disconnectFromDevice(deviceId)
                }
                .buttonStyle(.bordered)
            } else {
                Button("Connetti") {
                    polarManager.connectToDevice(deviceId)
                }
                .buttonStyle(.borderedProminent)
            }
        }
        .padding(.vertical, 4)
    }
}
