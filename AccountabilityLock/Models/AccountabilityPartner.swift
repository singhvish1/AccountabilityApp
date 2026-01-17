//
//  AccountabilityPartner.swift
//  AccountabilityLock
//
//  Accountability partner relationship model
//

import Foundation
import FirebaseFirestore

struct AccountabilityPartner: Identifiable, Codable {
    @DocumentID var id: String?
    var userId: String // The person being held accountable
    var partnerId: String // The accountability partner
    var partnerEmail: String
    var partnerName: String
    var status: PartnershipStatus
    var passwordHash: String? // Only partner can set this
    var inviteToken: String?
    var createdAt: Date
    var updatedAt: Date
    var acceptedAt: Date?
    
    enum PartnershipStatus: String, Codable {
        case pending = "pending"
        case active = "active"
        case rejected = "rejected"
        case revoked = "revoked"
    }
    
    init(id: String? = nil,
         userId: String,
         partnerId: String = "",
         partnerEmail: String,
         partnerName: String,
         status: PartnershipStatus = .pending,
         passwordHash: String? = nil,
         inviteToken: String? = nil) {
        self.id = id
        self.userId = userId
        self.partnerId = partnerId
        self.partnerEmail = partnerEmail
        self.partnerName = partnerName
        self.status = status
        self.passwordHash = passwordHash
        self.inviteToken = inviteToken
        self.createdAt = Date()
        self.updatedAt = Date()
    }
}
