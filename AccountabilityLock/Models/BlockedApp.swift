//
//  BlockedApp.swift
//  AccountabilityLock
//
//  Model for apps to be blocked
//

import Foundation
import FirebaseFirestore

struct BlockedApp: Identifiable, Codable {
    @DocumentID var id: String?
    var userId: String
    var appName: String
    var bundleIdentifier: String
    var isBlocked: Bool
    var blockSchedule: BlockSchedule?
    var iconData: Data? // App icon image data
    var createdAt: Date
    var updatedAt: Date
    
    init(id: String? = nil,
         userId: String,
         appName: String,
         bundleIdentifier: String,
         isBlocked: Bool = true,
         blockSchedule: BlockSchedule? = nil,
         iconData: Data? = nil) {
        self.id = id
        self.userId = userId
        self.appName = appName
        self.bundleIdentifier = bundleIdentifier
        self.isBlocked = isBlocked
        self.blockSchedule = blockSchedule
        self.iconData = iconData
        self.createdAt = Date()
        self.updatedAt = Date()
    }
}

struct BlockSchedule: Codable {
    var startTime: String // HH:mm format
    var endTime: String // HH:mm format
    var days: [Int] // 0 = Sunday, 1 = Monday, etc.
    var isAllDay: Bool
    
    init(startTime: String = "00:00",
         endTime: String = "23:59",
         days: [Int] = [0, 1, 2, 3, 4, 5, 6],
         isAllDay: Bool = true) {
        self.startTime = startTime
        self.endTime = endTime
        self.days = days
        self.isAllDay = isAllDay
    }
}

// Common apps for blocking
extension BlockedApp {
    static let commonApps = [
        ("Instagram", "com.burbn.instagram"),
        ("TikTok", "com.zhiliaoapp.musically"),
        ("Facebook", "com.facebook.Facebook"),
        ("Twitter/X", "com.atebits.Tweetie2"),
        ("YouTube", "com.google.ios.youtube"),
        ("Snapchat", "com.toyopagroup.picaboo"),
        ("Reddit", "com.reddit.Reddit"),
        ("WhatsApp", "net.whatsapp.WhatsApp"),
        ("Telegram", "ph.telegra.Telegraph"),
        ("Discord", "com.hammerandchisel.discord"),
        ("Twitch", "tv.twitch"),
        ("Netflix", "com.netflix.Netflix"),
        ("Gaming Apps", "games.*")
    ]
}
