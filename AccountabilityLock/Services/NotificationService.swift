//
//  NotificationService.swift
//  AccountabilityLock
//
//  Handles push notifications
//

import Foundation
import UserNotifications
import FirebaseMessaging
import FirebaseFirestore

class NotificationService {
    static let shared = NotificationService()
    
    private init() {
        setupNotificationCategories()
    }
    
    // MARK: - Setup
    
    private func setupNotificationCategories() {
        // Actions for access request notification
        let approveAction = UNNotificationAction(
            identifier: "APPROVE_ACTION",
            title: "Approve ✅",
            options: [.foreground]
        )
        
        let denyAction = UNNotificationAction(
            identifier: "DENY_ACTION",
            title: "Deny ❌",
            options: [.destructive]
        )
        
        let accessRequestCategory = UNNotificationCategory(
            identifier: "ACCESS_REQUEST",
            actions: [approveAction, denyAction],
            intentIdentifiers: [],
            options: .customDismissAction
        )
        
        UNUserNotificationCenter.current().setNotificationCategories([accessRequestCategory])
    }
    
    // MARK: - Send Notifications
    
    func sendAccessRequestNotification(
        to partnerId: String,
        requestId: String,
        userName: String,
        appName: String,
        reason: String?
    ) async throws {
        // Get partner's FCM token
        let db = Firestore.firestore()
        let userDoc = try await db.collection("users").document(partnerId).getDocument()
        
        guard let fcmToken = userDoc.data()?["fcmToken"] as? String else {
            throw NSError(domain: "NotificationService", code: 404, userInfo: [NSLocalizedDescriptionKey: "Partner FCM token not found"])
        }
        
        // Create notification payload
        var notificationData: [String: Any] = [
            "to": fcmToken,
            "notification": [
                "title": "Access Request from \(userName)",
                "body": "\(userName) is requesting access to \(appName)" + (reason != nil ? " - \(reason!)" : ""),
                "sound": "default",
                "badge": "1"
            ],
            "data": [
                "type": "access_request",
                "requestId": requestId,
                "userName": userName,
                "appName": appName
            ],
            "category": "ACCESS_REQUEST",
            "priority": "high",
            "content_available": true
        ]
        
        if let reason = reason {
            if var notification = notificationData["notification"] as? [String: Any] {
                notification["body"] = "\(userName) is requesting access to \(appName) - \(reason)"
                notificationData["notification"] = notification
            }
        }
        
        // Send via Firebase Cloud Messaging
        // Note: In production, you should use Firebase Cloud Functions to send notifications
        // This is a placeholder for the API call
        try await sendFCMNotification(data: notificationData)
    }
    
    func sendAccessGrantedNotification(to userId: String, duration: Int) async throws {
        let db = Firestore.firestore()
        let userDoc = try await db.collection("users").document(userId).getDocument()
        
        guard let fcmToken = userDoc.data()?["fcmToken"] as? String else { return }
        
        let notificationData: [String: Any] = [
            "to": fcmToken,
            "notification": [
                "title": "Access Granted! ✅",
                "body": "Your accountability partner approved your request for \(duration) minutes",
                "sound": "default",
                "badge": "1"
            ],
            "data": [
                "type": "access_granted",
                "duration": duration
            ],
            "priority": "high"
        ]
        
        try await sendFCMNotification(data: notificationData)
    }
    
    func sendAccessDeniedNotification(to userId: String) async throws {
        let db = Firestore.firestore()
        let userDoc = try await db.collection("users").document(userId).getDocument()
        
        guard let fcmToken = userDoc.data()?["fcmToken"] as? String else { return }
        
        let notificationData: [String: Any] = [
            "to": fcmToken,
            "notification": [
                "title": "Request Denied ❌",
                "body": "Your accountability partner denied your access request",
                "sound": "default"
            ],
            "data": [
                "type": "access_denied"
            ],
            "priority": "high"
        ]
        
        try await sendFCMNotification(data: notificationData)
    }
    
    // MARK: - Local Notifications
    
    func sendLocalNotification(title: String, body: String) {
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = .default
        
        let request = UNNotificationRequest(
            identifier: UUID().uuidString,
            content: content,
            trigger: nil
        )
        
        UNUserNotificationCenter.current().add(request)
    }
    
    // MARK: - Helper Methods
    
    private func sendFCMNotification(data: [String: Any]) async throws {
        // In production, this should be done via Firebase Cloud Functions
        // For now, this is a placeholder
        // You would need to implement a backend service that calls the FCM API
        
        // Example using URLSession:
        guard let url = URL(string: "https://fcm.googleapis.com/fcm/send") else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("key=YOUR_SERVER_KEY", forHTTPHeaderField: "Authorization") // Replace with your Firebase Server Key
        
        request.httpBody = try JSONSerialization.data(withJSONObject: data)
        
        let (_, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            throw NSError(domain: "NotificationService", code: 500, userInfo: [NSLocalizedDescriptionKey: "Failed to send notification"])
        }
    }
}
