//
//  AccountabilityLockApp.swift
//  AccountabilityLock
//
//  Created on 1/17/2026
//

import SwiftUI
import FirebaseCore
import UserNotifications

@main
struct AccountabilityLockApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @StateObject private var authViewModel = AuthViewModel()
    
    init() {
        // Configure Firebase
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(authViewModel)
        }
    }
}
