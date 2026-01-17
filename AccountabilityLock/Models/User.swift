//
//  User.swift
//  AccountabilityLock
//
//  User model
//

import Foundation
import FirebaseFirestore

struct User: Identifiable, Codable {
    @DocumentID var id: String?
    var email: String
    var displayName: String
    var role: UserRole
    var accountabilityPartnerId: String?
    var fcmToken: String?
    var authType: AuthType
    var createdAt: Date
    var updatedAt: Date
    
    enum UserRole: String, Codable {
        case user = "user"
        case partner = "partner"
        case both = "both" // Can be both user and partner for different people
    }
    
    enum AuthType: String, Codable {
        case password = "password"
        case pin = "pin"
    }
    
    init(id: String? = nil,
         email: String,
         displayName: String,
         role: UserRole = .user,
         accountabilityPartnerId: String? = nil,
         fcmToken: String? = nil,
         authType: AuthType = .password) {
        self.id = id
        self.email = email
        self.displayName = displayName
        self.role = role
        self.accountabilityPartnerId = accountabilityPartnerId
        self.fcmToken = fcmToken
        self.authType = authType
        self.createdAt = Date()
        self.updatedAt = Date()
    }
}
