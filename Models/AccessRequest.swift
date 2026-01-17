//
//  AccessRequest.swift
//  AccountabilityLock
//
//  Model for temporary access requests
//

import Foundation
import FirebaseFirestore

struct AccessRequest: Identifiable, Codable {
    @DocumentID var id: String?
    var userId: String
    var userName: String
    var partnerId: String
    var requestedAppName: String?
    var requestedAppBundleId: String?
    var reason: String?
    var status: RequestStatus
    var duration: Int // Duration in minutes (default 5)
    var expiresAt: Date?
    var createdAt: Date
    var respondedAt: Date?
    
    enum RequestStatus: String, Codable {
        case pending = "pending"
        case approved = "approved"
        case denied = "denied"
        case expired = "expired"
        case used = "used"
    }
    
    init(id: String? = nil,
         userId: String,
         userName: String,
         partnerId: String,
         requestedAppName: String? = nil,
         requestedAppBundleId: String? = nil,
         reason: String? = nil,
         status: RequestStatus = .pending,
         duration: Int = 5) {
        self.id = id
        self.userId = userId
        self.userName = userName
        self.partnerId = partnerId
        self.requestedAppName = requestedAppName
        self.requestedAppBundleId = requestedAppBundleId
        self.reason = reason
        self.status = status
        self.duration = duration
        self.createdAt = Date()
        
        // Set expiration time for pending requests (e.g., 5 minutes)
        if status == .pending {
            self.expiresAt = Calendar.current.date(byAdding: .minute, value: 5, to: Date())
        }
    }
    
    var isExpired: Bool {
        guard let expiresAt = expiresAt else { return false }
        return Date() > expiresAt
    }
    
    var isPending: Bool {
        return status == .pending && !isExpired
    }
}
