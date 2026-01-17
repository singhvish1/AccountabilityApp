//
//  MainTabView.swift
//  AccountabilityLock
//
//  Main tab navigation
//

import SwiftUI

struct MainTabView: View {
    @State private var selectedTab = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            HomeView()
                .tabItem {
                    Label("Home", systemImage: "house.fill")
                }
                .tag(0)
            
            BlockedAppsView()
                .tabItem {
                    Label("Apps", systemImage: "app.badge")
                }
                .tag(1)
            
            AccessRequestsView()
                .tabItem {
                    Label("Requests", systemImage: "bell.fill")
                }
                .tag(2)
            
            SettingsView()
                .tabItem {
                    Label("Settings", systemImage: "gearshape.fill")
                }
                .tag(3)
        }
    }
}

#Preview {
    MainTabView()
        .environmentObject(AuthViewModel())
}
