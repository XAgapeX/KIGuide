//
//  OnboardingScreen.swift
//  KIGuide
//
//  Created by Katarzyna on 13/10/2026.
//

import SwiftUI
import CoreLocation

struct OnboardingScreen: View {
    @Binding var hasSeenOnboarding: Bool
    
    @AppStorage("isDarkMode") private var isDarkMode = false
    @AppStorage("appLanguage") private var appLanguage = "pl"
    
    @State private var locationManager = CLLocationManager()
    
    var body: some View {
        ZStack {
            LinearGradient(
                colors: [
                    Color("MainBlue"),
                    isDarkMode ? Color.black : Color.white
                ],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            VStack(spacing: 0) {
                HStack(spacing: 20) {
                    Spacer()
                    
                    Button(action: {
                        withAnimation {
                            appLanguage = appLanguage == "pl" ? "en" : "pl"
                        }
                    }) {
                        HStack(spacing: 4) {
                            Image(systemName: "globe")
                            Text(appLanguage.uppercased())
                                .font(.headline)
                        }
                        .foregroundColor(.white)
                    }
                    
                    Button(action: {
                        withAnimation {
                            isDarkMode.toggle()
                        }
                    }) {
                        Image(systemName: isDarkMode ? "sun.max.fill" : "moon.fill")
                            .font(.title2)
                            .foregroundColor(.white)
                    }
                }
                .padding(.horizontal, 24)
                .padding(.top, 16)
                
                Spacer().frame(height: 20)
                
                VStack(spacing: 8) {
                    Text("INTERAKTYWNY PRZEWODNIK")
                        .font(.headline)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .tracking(1.5)
                    
                    Text("Odkrywaj w AR")
                        .font(.system(size: 42, weight: .bold, design: .default))
                        .foregroundColor(.white)
                }
                .padding(.horizontal)
                
                Spacer()
                
                VStack(spacing: 32) {
                    Text("Witaj w wirtualnym przewodniku po Katedrze Informatyki!")
                        .font(.body)
                        .multilineTextAlignment(.center)
                        .foregroundColor(isDarkMode ? .white : Color("MainBlue"))
                        .padding(.horizontal, 32)
                    
                    Button(action: {
                        requestPermissionsAndProceed()
                    }) {
                        Text("Rozpocznij zwiedzanie")
                            .font(.title3)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(Color("MainBlue"))
                            .cornerRadius(12)
                    }
                    .padding(.horizontal, 24)
                    .padding(.bottom, 40)
                }
            }
            .frame(maxWidth: 600)
        }
        .preferredColorScheme(isDarkMode ? .dark : .light)
        .environment(\.locale, Locale(identifier: appLanguage))
    }
    
    private func requestPermissionsAndProceed() {
        locationManager.requestWhenInUseAuthorization()
        
        withAnimation {
            hasSeenOnboarding = true
        }
    }
}

#Preview {
    OnboardingScreen(hasSeenOnboarding: .constant(false))
}
