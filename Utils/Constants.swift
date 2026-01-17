//
//  Constants.swift
//  AccountabilityLock
//
//  App-wide constants
//

import Foundation
import SwiftUI

enum AppConstants {
    // App Info
    static let appName = "AccountabilityLock"
    static let appVersion = "1.0.0"
    
    // Access Request
    static let defaultAccessDuration = 5 // minutes
    static let maxAccessDuration = 15 // minutes
    static let requestExpirationTime = 5 // minutes
    
    // Colors
    struct Colors {
        static let primary = Color.blue
        static let secondary = Color.gray
        static let success = Color.green
        static let warning = Color.orange
        static let danger = Color.red
        static let background = Color(.systemBackground)
        static let secondaryBackground = Color(.secondarySystemBackground)
    }
    
    // Notification Categories
    struct NotificationCategories {
        static let accessRequest = "ACCESS_REQUEST"
    }
    
    // Notification Actions
    struct NotificationActions {
        static let approve = "APPROVE_ACTION"
        static let deny = "DENY_ACTION"
    }
    
    // UserDefaults Keys
    struct UserDefaultsKeys {
        static let fcmToken = "fcmToken"
        static let hasCompletedOnboarding = "hasCompletedOnboarding"
        static let isFirstLaunch = "isFirstLaunch"
    }
    
    // Error Messages
    struct ErrorMessages {
        static let generic = "An error occurred. Please try again."
        static let networkError = "Network connection error. Please check your internet connection."
        static let authError = "Authentication failed. Please try again."
        static let permissionDenied = "Permission denied. Please enable permissions in Settings."
    }
}

// MARK: - User Defaults Extension

extension UserDefaults {
    var hasCompletedOnboarding: Bool {
        get { bool(forKey: AppConstants.UserDefaultsKeys.hasCompletedOnboarding) }
        set { set(newValue, forKey: AppConstants.UserDefaultsKeys.hasCompletedOnboarding) }
    }
    
    var isFirstLaunch: Bool {
        get { 
            if object(forKey: AppConstants.UserDefaultsKeys.isFirstLaunch) == nil {
                return true
            }
            return bool(forKey: AppConstants.UserDefaultsKeys.isFirstLaunch)
        }
        set { set(newValue, forKey: AppConstants.UserDefaultsKeys.isFirstLaunch) }
    }
}
