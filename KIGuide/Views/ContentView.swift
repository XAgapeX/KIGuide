//
//  ContentView.swift
//  KIGuide
//
//  Created by Katarzyna on 13/10/2026.
//

import SwiftUI

struct ContentView: View {
   
    @AppStorage("hasSeenOnboarding") private var hasSeenOnboarding = false
    
    var body: some View {
        Group {
            if hasSeenOnboarding {
                Text("Ekran główny aplikacji (Skaner iBeacon)")
                    .font(.title)
                    .foregroundColor(.gray)
            } else {
                OnboardingScreen(hasSeenOnboarding: $hasSeenOnboarding)
            }
        }
        .animation(.easeInOut, value: hasSeenOnboarding)
    }
}

#Preview {
    ContentView()
}
