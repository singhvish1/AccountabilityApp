//
//  FirebaseService.swift
//  AccountabilityLock
//
//  Handles all Firebase operations
//

import Foundation
import FirebaseAuth
import FirebaseFirestore
import FirebaseMessaging

class FirebaseService {
    static let shared = FirebaseService()
    private let db = Firestore.firestore()
    
    private init() {}
    
    // MARK: - User Operations
    
    func createUser(user: User) async throws {
        guard let userId = user.id else {
            throw NSError(domain: "FirebaseService", code: 400, userInfo: [NSLocalizedDescriptionKey: "User ID is required"])
        }
        
        try db.collection("users").document(userId).setData(from: user)
    }
    
    func getUser(uid: String) async throws -> User? {
        let document = try await db.collection("users").document(uid).getDocument()
        return try document.data(as: User.self)
    }
    
    func updateFCMToken(token: String) {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        
        db.collection("users").document(userId).updateData([
            "fcmToken": token,
            "updatedAt": FieldValue.serverTimestamp()
        ])
    }
    
    // MARK: - Accountability Partner Operations
    
    func createPartnershipInvite(userId: String, partnerEmail: String, partnerName: String) async throws -> String {
        let inviteToken = UUID().uuidString
        
        let partnership = AccountabilityPartner(
            userId: userId,
            partnerEmail: partnerEmail,
            partnerName: partnerName,
            status: .pending,
            inviteToken: inviteToken
        )
        
        let docRef = try db.collection("partnerships").addDocument(from: partnership)
        
        // Send invitation email (you would integrate with a service like SendGrid)
        // For now, just return the invite token
        
        return docRef.documentID
    }
    
    func acceptPartnership(partnershipId: String, partnerId: String, password: String) async throws {
        let passwordHash = hashPassword(password)
        
        try await db.collection("partnerships").document(partnershipId).updateData([
            "partnerId": partnerId,
            "status": AccountabilityPartner.PartnershipStatus.active.rawValue,
            "passwordHash": passwordHash,
            "acceptedAt": FieldValue.serverTimestamp(),
            "updatedAt": FieldValue.serverTimestamp()
        ])
    }
    
    func getAccountabilityPartner(userId: String) async throws -> AccountabilityPartner? {
        let query = db.collection("partnerships")
            .whereField("userId", isEqualTo: userId)
            .whereField("status", isEqualTo: AccountabilityPartner.PartnershipStatus.active.rawValue)
            .limit(to: 1)
        
        let snapshot = try await query.getDocuments()
        return try snapshot.documents.first?.data(as: AccountabilityPartner.self)
    }
    
    func verifyPassword(userId: String, password: String) async throws -> Bool {
        guard let partnership = try await getAccountabilityPartner(userId: userId),
              let storedHash = partnership.passwordHash else {
            return false
        }
        
        let passwordHash = hashPassword(password)
        return passwordHash == storedHash
    }
    
    // MARK: - Blocked Apps Operations
    
    func getBlockedApps(userId: String) async throws -> [BlockedApp] {
        let query = db.collection("blockedApps")
            .whereField("userId", isEqualTo: userId)
            .whereField("isBlocked", isEqualTo: true)
        
        let snapshot = try await query.getDocuments()
        return try snapshot.documents.compactMap { try $0.data(as: BlockedApp.self) }
    }
    
    func addBlockedApp(_ app: BlockedApp) async throws {
        try db.collection("blockedApps").addDocument(from: app)
    }
    
    func updateBlockedApp(_ app: BlockedApp) async throws {
        guard let appId = app.id else { return }
        try db.collection("blockedApps").document(appId).setData(from: app)
    }
    
    func removeBlockedApp(appId: String) async throws {
        try await db.collection("blockedApps").document(appId).delete()
    }
    
    // MARK: - Access Request Operations
    
    func createAccessRequest(_ request: AccessRequest) async throws -> String {
        let docRef = try db.collection("accessRequests").addDocument(from: request)
        return docRef.documentID
    }
    
    func getAccessRequest(requestId: String) async throws -> AccessRequest? {
        let document = try await db.collection("accessRequests").document(requestId).getDocument()
        return try document.data(as: AccessRequest.self)
    }
    
    func getPendingAccessRequests(partnerId: String) async throws -> [AccessRequest] {
        let query = db.collection("accessRequests")
            .whereField("partnerId", isEqualTo: partnerId)
            .whereField("status", isEqualTo: AccessRequest.RequestStatus.pending.rawValue)
            .order(by: "createdAt", descending: true)
        
        let snapshot = try await query.getDocuments()
        return try snapshot.documents.compactMap { try $0.data(as: AccessRequest.self) }
    }
    
    func getAccessRequestHistory(userId: String) async throws -> [AccessRequest] {
        let query = db.collection("accessRequests")
            .whereField("userId", isEqualTo: userId)
            .order(by: "createdAt", descending: true)
            .limit(to: 50)
        
        let snapshot = try await query.getDocuments()
        return try snapshot.documents.compactMap { try $0.data(as: AccessRequest.self) }
    }
    
    func approveAccessRequest(requestId: String, completion: @escaping (Bool) -> Void = { _ in }) {
        db.collection("accessRequests").document(requestId).updateData([
            "status": AccessRequest.RequestStatus.approved.rawValue,
            "respondedAt": FieldValue.serverTimestamp()
        ]) { error in
            completion(error == nil)
        }
    }
    
    func denyAccessRequest(requestId: String, completion: @escaping (Bool) -> Void = { _ in }) {
        db.collection("accessRequests").document(requestId).updateData([
            "status": AccessRequest.RequestStatus.denied.rawValue,
            "respondedAt": FieldValue.serverTimestamp()
        ]) { error in
            completion(error == nil)
        }
    }
    
    func listenToAccessRequest(requestId: String, completion: @escaping (AccessRequest?) -> Void) {
        db.collection("accessRequests").document(requestId)
            .addSnapshotListener { snapshot, error in
                guard let snapshot = snapshot, error == nil else {
                    completion(nil)
                    return
                }
                
                let request = try? snapshot.data(as: AccessRequest.self)
                completion(request)
            }
    }
    
    // MARK: - Helper Methods
    
    private func hashPassword(_ password: String) -> String {
        // In production, use a proper password hashing library like CryptoKit
        // This is a simplified version for demonstration
        return password.data(using: .utf8)?.base64EncodedString() ?? ""
    }
}
