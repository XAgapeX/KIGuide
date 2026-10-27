//
//  KIGuideApp.swift
//  KIGuide
//
//  Created by Katarzyna na 13/10/2026.
//

import SwiftUI
import FirebaseCore

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        return true
    }
}

@main
struct KIGuideApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    @AppStorage("hasSeenOnboarding") private var hasSeenOnboarding: Bool = false
    
    @StateObject private var beaconManager = BeaconManager()
    
    var body: some Scene {
        WindowGroup {
            if hasSeenOnboarding {
                ContentView()
                    .environmentObject(beaconManager)
            } else {
                OnboardingScreen(hasSeenOnboarding: $hasSeenOnboarding)
                    .environmentObject(beaconManager)
            }
        }
    }
}
