//
//  AccessRequestViewModel.swift
//  AccountabilityLock
//
//  Manages access requests
//

import Foundation
import Combine

@MainActor
class AccessRequestViewModel: ObservableObject {
    @Published var pendingRequests: [AccessRequest] = []
    @Published var requestHistory: [AccessRequest] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var currentRequest: AccessRequest?
    
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Send Access Request
    
    func sendAccessRequest(
        userId: String,
        userName: String,
        partnerId: String,
        appName: String?,
        bundleId: String?,
        reason: String?
    ) async {
        isLoading = true
        
        let request = AccessRequest(
            userId: userId,
            userName: userName,
            partnerId: partnerId,
            requestedAppName: appName,
            requestedAppBundleId: bundleId,
            reason: reason,
            duration: 5
        )
        
        do {
            let requestId = try await FirebaseService.shared.createAccessRequest(request)
            currentRequest = request
            
            // Send push notification to partner
            try await NotificationService.shared.sendAccessRequestNotification(
                to: partnerId,
                requestId: requestId,
                userName: userName,
                appName: appName ?? "blocked apps",
                reason: reason
            )
            
            isLoading = false
        } catch {
            errorMessage = error.localizedDescription
            isLoading = false
        }
    }
    
    // MARK: - Fetch Requests
    
    func fetchPendingRequests(partnerId: String) async {
        do {
            pendingRequests = try await FirebaseService.shared.getPendingAccessRequests(partnerId: partnerId)
        } catch {
            errorMessage = error.localizedDescription
        }
    }
    
    func fetchRequestHistory(userId: String) async {
        isLoading = true
        
        do {
            requestHistory = try await FirebaseService.shared.getAccessRequestHistory(userId: userId)
            isLoading = false
        } catch {
            errorMessage = error.localizedDescription
            isLoading = false
        }
    }
    
    // MARK: - Respond to Request
    
    func approveRequest(requestId: String, duration: Int = 5) async {
        do {
            try await FirebaseService.shared.approveAccessRequest(requestId: requestId)
            
            // Remove from pending
            pendingRequests.removeAll { $0.id == requestId }
            
            // Send notification to user
            if let request = requestHistory.first(where: { $0.id == requestId }) {
                try await NotificationService.shared.sendAccessGrantedNotification(
                    to: request.userId,
                    duration: duration
                )
            }
        } catch {
            errorMessage = error.localizedDescription
        }
    }
    
    func denyRequest(requestId: String) async {
        do {
            try await FirebaseService.shared.denyAccessRequest(requestId: requestId)
            
            // Remove from pending
            pendingRequests.removeAll { $0.id == requestId }
            
            // Send notification to user
            if let request = requestHistory.first(where: { $0.id == requestId }) {
                try await NotificationService.shared.sendAccessDeniedNotification(
                    to: request.userId
                )
            }
        } catch {
            errorMessage = error.localizedDescription
        }
    }
    
    // MARK: - Real-time Updates
    
    func listenForRequestUpdates(requestId: String) {
        FirebaseService.shared.listenToAccessRequest(requestId: requestId) { [weak self] request in
            guard let self = self, let request = request else { return }
            
            Task { @MainActor in
                self.currentRequest = request
                
                if request.status == .approved {
                    NotificationService.shared.sendLocalNotification(
                        title: "Access Granted! ✅",
                        body: "Your accountability partner approved your request for \(request.duration) minutes"
                    )
                } else if request.status == .denied {
                    NotificationService.shared.sendLocalNotification(
                        title: "Request Denied ❌",
                        body: "Your accountability partner denied your request"
                    )
                }
            }
        }
    }
}
