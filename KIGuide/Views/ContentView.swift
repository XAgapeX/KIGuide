//
//  KIGuideApp.swift
//  KIGuide
//
//  Created by Katarzyna na 13/10/2026.
//

import SwiftUI
import CoreLocation

struct ContentView: View {
    @StateObject private var beaconManager = BeaconManager()
    
    var body: some View {
        VStack(spacing: 30) {
            Text("Radar iBeacon")
                .font(.largeTitle)
                .bold()
            
            if let beacon = beaconManager.closestBeacon {
                VStack(spacing: 10) {
                    Image(systemName: "sensor.tag.radiowaves.forward.fill")
                        .font(.system(size: 60))
                        .foregroundColor(.green)
                    
                    Text("Wykryto najbliższy punkt!")
                        .font(.headline)
                        .foregroundColor(.green)
                    
                    Text("Major: \(beacon.major)")
                    Text("Minor: \(beacon.minor)")
                    
                    Text("Odległość: \(String(format: "%.2f", beacon.accuracy)) m")
                        .font(.title2)
                        .padding(.top)
                }
            } else {
                VStack(spacing: 15) {
                    ProgressView()
                    Text("Szukam sygnału...")
                        .foregroundColor(.gray)
                }
            }
        }
        .padding()
        .onAppear {
            beaconManager.startScanning()
        }
        .onDisappear {
            beaconManager.stopScanning()
        }
    }
}
