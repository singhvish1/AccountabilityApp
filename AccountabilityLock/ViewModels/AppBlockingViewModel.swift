//
//  AppBlockingViewModel.swift
//  AccountabilityLock
//
//  Manages app blocking logic
//

import Foundation
import FamilyControls
import ManagedSettings
import DeviceActivity
import Combine

@MainActor
class AppBlockingViewModel: ObservableObject {
    @Published var blockedApps: [BlockedApp] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var authorizationStatus: AuthorizationStatus = .notDetermined
    @Published var hasTemporaryAccess = false
    @Published var temporaryAccessExpiresAt: Date?
    
    private let center = AuthorizationCenter.shared
    private var cancellables = Set<AnyCancellable>()
    private var temporaryAccessTimer: Timer?
    
    enum AuthorizationStatus {
        case notDetermined
        case denied
        case approved
    }
    
    init() {
        setupNotificationObservers()
    }
    
    deinit {
        temporaryAccessTimer?.invalidate()
    }
    
    // MARK: - Authorization
    
    func requestAuthorization() async {
        do {
            try await center.requestAuthorization(for: .individual)
            
            switch center.authorizationStatus {
            case .approved:
                authorizationStatus = .approved
            case .denied:
                authorizationStatus = .denied
            case .notDetermined:
                authorizationStatus = .notDetermined
            @unknown default:
                authorizationStatus = .notDetermined
            }
        } catch {
            errorMessage = "Failed to request authorization: \(error.localizedDescription)"
            authorizationStatus = .denied
        }
    }
    
    func checkAuthorizationStatus() {
        switch center.authorizationStatus {
        case .approved:
            authorizationStatus = .approved
        case .denied:
            authorizationStatus = .denied
        case .notDetermined:
            authorizationStatus = .notDetermined
        @unknown default:
            authorizationStatus = .notDetermined
        }
    }
    
    // MARK: - Blocked Apps Management
    
    func fetchBlockedApps(userId: String) async {
        isLoading = true
        
        do {
            blockedApps = try await FirebaseService.shared.getBlockedApps(userId: userId)
            await applyBlockingRules()
            isLoading = false
        } catch {
            errorMessage = error.localizedDescription
            isLoading = false
        }
    }
    
    func addBlockedApp(_ app: BlockedApp) async {
        do {
            try await FirebaseService.shared.addBlockedApp(app)
            blockedApps.append(app)
            await applyBlockingRules()
        } catch {
            errorMessage = error.localizedDescription
        }
    }
    
    func removeBlockedApp(_ app: BlockedApp) async {
        guard let appId = app.id else { return }
        
        do {
            try await FirebaseService.shared.removeBlockedApp(appId: appId)
            blockedApps.removeAll { $0.id == appId }
            await applyBlockingRules()
        } catch {
            errorMessage = error.localizedDescription
        }
    }
    
    func updateBlockedApp(_ app: BlockedApp) async {
        do {
            try await FirebaseService.shared.updateBlockedApp(app)
            if let index = blockedApps.firstIndex(where: { $0.id == app.id }) {
                blockedApps[index] = app
            }
            await applyBlockingRules()
        } catch {
            errorMessage = error.localizedDescription
        }
    }
    
    // MARK: - Blocking Rules
    
    private func applyBlockingRules() async {
        guard authorizationStatus == .approved else { return }
        guard !hasTemporaryAccess else { return }
        
        let store = ManagedSettingsStore()
        
        // Create a selection of apps to block
        var selection = FamilyActivitySelection()
        
        // Note: In a real implementation, you would need to map bundle IDs to ApplicationTokens
        // This requires using FamilyActivityPicker to let users select apps
        // For now, this is a placeholder
        
        store.shield.applications = selection.applicationTokens
        store.shield.applicationCategories = .all(except: selection.categoryTokens)
    }
    
    // MARK: - Temporary Access
    
    func grantTemporaryAccess(duration: Int) {
        hasTemporaryAccess = true
        temporaryAccessExpiresAt = Calendar.current.date(byAdding: .minute, value: duration, to: Date())
        
        // Remove blocking temporarily
        let store = ManagedSettingsStore()
        store.shield.applications = nil
        store.shield.applicationCategories = nil
        
        // Set timer to re-enable blocking
        temporaryAccessTimer?.invalidate()
        temporaryAccessTimer = Timer.scheduledTimer(withTimeInterval: TimeInterval(duration * 60), repeats: false) { [weak self] _ in
            Task { @MainActor in
                await self?.revokeTemporaryAccess()
            }
        }
    }
    
    private func revokeTemporaryAccess() async {
        hasTemporaryAccess = false
        temporaryAccessExpiresAt = nil
        await applyBlockingRules()
    }
    
    // MARK: - Notification Observers
    
    private func setupNotificationObservers() {
        NotificationCenter.default.publisher(for: .accessGranted)
            .sink { [weak self] notification in
                Task { @MainActor in
                    if let duration = notification.userInfo?["duration"] as? Int {
                        self?.grantTemporaryAccess(duration: duration)
                    }
                }
            }
            .store(in: &cancellables)
        
        NotificationCenter.default.publisher(for: .accessDenied)
            .sink { [weak self] _ in
                self?.errorMessage = "Your accountability partner denied your access request"
            }
            .store(in: &cancellables)
    }
}
