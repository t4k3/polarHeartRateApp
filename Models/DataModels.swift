//
//  DataModels.swift
//  PolarHeartRateApp
//
//  Created by Bt.Ross on 12/05/25.
//

import Foundation

// Punto dati HR (Heart Rate)
struct HRDataPoint {
    let timestamp: Date
    let value: Int
}

// Punto dati RR (intervallo tra battiti)
struct RRDataPoint {
    let timestamp: Date
    let value: Double
}

// Punto marcato (per salti, ecc.)
struct MarkedPoint {
    let timestamp: Date
    let value: Double
}

// Struttura principale per ogni dispositivo/atleta
struct AthleteData {
    var athleteName: String
    var deviceId: String

    var hrValues: [HRDataPoint] = []
    var rrValues: [RRDataPoint] = []

    var smoothedHR: [HRDataPoint] = []
    var smoothedRR: [RRDataPoint] = []

    var jumpPoints: [MarkedPoint] = []
}
