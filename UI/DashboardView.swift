//
//  DashboardView.swift
//  PolarHeartRateApp
//
//  Created by Bt.Ross on 11/05/25.
//

import SwiftUI

struct DashboardView: View {
    @EnvironmentObject var polarManager: PolarManager

    var body: some View {
        HStack {
            // Sidebar sinistra
            VStack(alignment: .leading, spacing: 10) {
                Text("Dispositivi").font(.headline)
                Button("Scansione") {
                    polarManager.startScan()
                }

                List {
                    ForEach(polarManager.discoveredDevices, id: \.deviceId) { device in
                        DeviceRowView(deviceId: device.deviceId,
                                      isConnected: polarManager.connectedDevices[device.deviceId] != nil)
                    }
                }
            }
            .frame(width: 300)
            .padding()

            Divider()

            // Dashboard destra
            ScrollView {
                VStack(spacing: 30) {
                    ForEach(Array(polarManager.connectedDevices.values), id: \.deviceId) { athlete in
                        VStack(alignment: .leading, spacing: 10) {
                            HStack {
                                TextField("Nome atleta",
                                          text: Binding(
                                            get: { athlete.athleteName },
                                            set: { polarManager.connectedDevices[athlete.deviceId]?.athleteName = $0 }
                                          ))
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .frame(width: 200)

                                Spacer()
                                Button("Reset") {
                                    polarManager.resetDevice(athlete.deviceId)
                                }
                            }

                            AthleteChartView(athlete: athlete)
                        }
                        .padding()
                        .background(Color(.secondarySystemBackground))
                        .cornerRadius(10)
                    }
                }
                .padding()
            }
        }
    }
}
