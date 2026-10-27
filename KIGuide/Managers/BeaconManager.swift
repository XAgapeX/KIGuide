//
//  BeaconManager.swift
//  KIGuide
//
//  Created by Katarzyna on 25/10/2026.
//

import Foundation
import CoreLocation
import Combine

class BeaconManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    
    @Published var closestBeacon: CLBeacon?
    
    private var locationManager: CLLocationManager?
    
    private let beaconUUID = UUID(uuidString: "UUID")!
    private let beaconIdentifier = "KIGuideRegion"
    
    private var distanceFilter: [String: Double] = [:]
    private let alpha: Double = 0.25

    override init() {
        super.init()
        self.locationManager = CLLocationManager()
        self.locationManager?.delegate = self
        self.locationManager?.requestWhenInUseAuthorization()
    }

    func startScanning() {
        let constraint = CLBeaconIdentityConstraint(uuid: beaconUUID)
        let region = CLBeaconRegion(beaconIdentityConstraint: constraint, identifier: beaconIdentifier)
        
        locationManager?.startMonitoring(for: region)
        locationManager?.startRangingBeacons(satisfying: constraint)
    }
    
    func stopScanning() {
        let constraint = CLBeaconIdentityConstraint(uuid: beaconUUID)
        let region = CLBeaconRegion(beaconIdentityConstraint: constraint, identifier: beaconIdentifier)
        
        locationManager?.stopRangingBeacons(satisfying: constraint)
        locationManager?.stopMonitoring(for: region)
        closestBeacon = nil
    }

    private func key(for beacon: CLBeacon) -> String {
        return "\(beacon.major.intValue)-\(beacon.minor.intValue)"
    }

    func locationManager(_ manager: CLLocationManager, didRange beacons: [CLBeacon], satisfying constraint: CLBeaconIdentityConstraint) {
        
        var smoothedBeacons: [(beacon: CLBeacon, smoothedDistance: Double)] = []
        
        for beacon in beacons {
            let rawDistance = beacon.accuracy
            guard rawDistance > 0 else { continue }
            
            let k = key(for: beacon)
            
            if let oldDistance = distanceFilter[k] {
                let newDistance = alpha * rawDistance + (1 - alpha) * oldDistance
                distanceFilter[k] = newDistance
                smoothedBeacons.append((beacon, newDistance))
            } else {
                distanceFilter[k] = rawDistance
                smoothedBeacons.append((beacon, rawDistance))
            }
        }
        
        smoothedBeacons.sort { $0.smoothedDistance < $1.smoothedDistance }
        
        DispatchQueue.main.async {
            self.closestBeacon = smoothedBeacons.first?.beacon
        }
    }
}
