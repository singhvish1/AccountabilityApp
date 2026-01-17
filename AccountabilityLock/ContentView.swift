//
//  ContentView.swift
//  AccountabilityLock
//
//  Main navigation view
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    
    var body: some View {
        Group {
            if authViewModel.isLoading {
                LoadingView()
            } else if authViewModel.isAuthenticated {
                if authViewModel.hasAccountabilityPartner {
                    MainTabView()
                } else {
                    SetupPartnerView()
                }
            } else {
                OnboardingView()
            }
        }
    }
}

struct LoadingView: View {
    var body: some View {
        ZStack {
            Color(.systemBackground)
                .ignoresSafeArea()
            
            VStack(spacing: 20) {
                Image(systemName: "lock.shield.fill")
                    .font(.system(size: 80))
                    .foregroundColor(.blue)
                
                Text("AccountabilityLock")
                    .font(.title)
                    .fontWeight(.bold)
                
                ProgressView()
                    .scaleEffect(1.5)
            }
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(AuthViewModel())
}
