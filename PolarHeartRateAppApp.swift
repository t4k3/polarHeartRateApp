//
//  PolarHeartRateAppApp.swift
//  PolarHeartRateApp
//
//  Created by Bt. Ross on 4/8/25.
//

import SwiftUI

@main
struct PolarHeartRateAppApp: App {
    @StateObject private var polarManager = PolarManager.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(polarManager)
        }
    }
}
