//
//  AppDelegate.swift
//  AccountabilityLock
//
//  Handles app lifecycle and push notifications
//

import UIKit
import FirebaseCore
import FirebaseMessaging
import UserNotifications

class AppDelegate: NSObject, UIApplicationDelegate, UNUserNotificationCenterDelegate, MessagingDelegate {
    
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        
        // Request notification permissions
        UNUserNotificationCenter.current().delegate = self
        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        UNUserNotificationCenter.current().requestAuthorization(
            options: authOptions,
            completionHandler: { granted, error in
                if granted {
                    DispatchQueue.main.async {
                        application.registerForRemoteNotifications()
                    }
                }
            }
        )
        
        // Set Firebase Messaging delegate
        Messaging.messaging().delegate = self
        
        return true
    }
    
    // MARK: - Remote Notifications
    
    func application(_ application: UIApplication,
                     didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Messaging.messaging().apnsToken = deviceToken
    }
    
    func application(_ application: UIApplication,
                     didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Failed to register for remote notifications: \(error.localizedDescription)")
    }
    
    // MARK: - UNUserNotificationCenterDelegate
    
    // Handle notification when app is in foreground
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        let userInfo = notification.request.content.userInfo
        print("Received notification in foreground: \(userInfo)")
        
        // Show notification even when app is in foreground
        completionHandler([[.banner, .sound, .badge]])
    }
    
    // Handle notification tap
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        
        // Handle different notification types
        if let notificationType = userInfo["type"] as? String {
            switch notificationType {
            case "access_request":
                handleAccessRequestNotification(userInfo: userInfo, actionId: response.actionIdentifier)
            case "access_granted":
                handleAccessGrantedNotification(userInfo: userInfo)
            case "access_denied":
                handleAccessDeniedNotification(userInfo: userInfo)
            default:
                break
            }
        }
        
        completionHandler()
    }
    
    // MARK: - MessagingDelegate
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        print("Firebase registration token: \(String(describing: fcmToken))")
        
        // Store FCM token for this device
        if let token = fcmToken {
            UserDefaults.standard.set(token, forKey: "fcmToken")
            
            // Send token to server if user is authenticated
            FirebaseService.shared.updateFCMToken(token: token)
        }
    }
    
    // MARK: - Notification Handlers
    
    private func handleAccessRequestNotification(userInfo: [AnyHashable: Any], actionId: String) {
        guard let requestId = userInfo["requestId"] as? String else { return }
        
        if actionId == "APPROVE_ACTION" {
            // Approve the access request
            FirebaseService.shared.approveAccessRequest(requestId: requestId) { success in
                if success {
                    NotificationService.shared.sendLocalNotification(
                        title: "Access Granted",
                        body: "You approved the access request"
                    )
                }
            }
        } else if actionId == "DENY_ACTION" {
            // Deny the access request
            FirebaseService.shared.denyAccessRequest(requestId: requestId) { success in
                if success {
                    NotificationService.shared.sendLocalNotification(
                        title: "Access Denied",
                        body: "You denied the access request"
                    )
                }
            }
        }
    }
    
    private func handleAccessGrantedNotification(userInfo: [AnyHashable: Any]) {
        // Handle when partner grants access
        NotificationCenter.default.post(name: .accessGranted, object: nil, userInfo: userInfo)
    }
    
    private func handleAccessDeniedNotification(userInfo: [AnyHashable: Any]) {
        // Handle when partner denies access
        NotificationCenter.default.post(name: .accessDenied, object: nil, userInfo: userInfo)
    }
}

// MARK: - Notification Names

extension Notification.Name {
    static let accessGranted = Notification.Name("accessGranted")
    static let accessDenied = Notification.Name("accessDenied")
}
