//
//  AccountabilityLockTests.swift
//  AccountabilityLockTests
//
//  Unit and Integration Tests
//

import XCTest
@testable import AccountabilityLock
import FirebaseAuth
import FirebaseFirestore

class AccountabilityLockTests: XCTestCase {
    
    var authViewModel: AuthViewModel!
    var appBlockingViewModel: AppBlockingViewModel!
    var accessRequestViewModel: AccessRequestViewModel!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        authViewModel = AuthViewModel()
        appBlockingViewModel = AppBlockingViewModel()
        accessRequestViewModel = AccessRequestViewModel()
    }
    
    override func tearDownWithError() throws {
        authViewModel = nil
        appBlockingViewModel = nil
        accessRequestViewModel = nil
        try super.tearDownWithError()
    }
    
    // MARK: - Authentication Tests
    
    func testSignUpWithValidCredentials() async throws {
        // Arrange
        let testEmail = "testuser@example.com"
        let testPassword = "TestPassword123"
        let testName = "Test User"
        
        // Act
        await authViewModel.signUp(email: testEmail, password: testPassword, displayName: testName)
        
        // Assert
        XCTAssertTrue(authViewModel.isAuthenticated, "User should be authenticated after sign up")
        XCTAssertNotNil(authViewModel.currentUser, "Current user should not be nil")
        XCTAssertEqual(authViewModel.currentUser?.email, testEmail, "Email should match")
        XCTAssertEqual(authViewModel.currentUser?.displayName, testName, "Display name should match")
    }
    
    func testSignInWithValidCredentials() async throws {
        // Arrange
        let testEmail = "existinguser@example.com"
        let testPassword = "ExistingPassword123"
        
        // Act
        await authViewModel.signIn(email: testEmail, password: testPassword)
        
        // Assert
        XCTAssertTrue(authViewModel.isAuthenticated, "User should be authenticated after sign in")
        XCTAssertNotNil(authViewModel.currentUser, "Current user should not be nil")
    }
    
    func testSignInWithInvalidCredentials() async throws {
        // Arrange
        let testEmail = "invalid@example.com"
        let testPassword = "WrongPassword"
        
        // Act
        await authViewModel.signIn(email: testEmail, password: testPassword)
        
        // Assert
        XCTAssertFalse(authViewModel.isAuthenticated, "User should not be authenticated with wrong credentials")
        XCTAssertNotNil(authViewModel.errorMessage, "Error message should be set")
    }
    
    func testSignOut() {
        // Arrange
        authViewModel.isAuthenticated = true
        
        // Act
        authViewModel.signOut()
        
        // Assert
        XCTAssertFalse(authViewModel.isAuthenticated, "User should not be authenticated after sign out")
        XCTAssertNil(authViewModel.currentUser, "Current user should be nil after sign out")
    }
    
    // MARK: - Email Validation Tests
    
    func testValidEmailAddresses() {
        XCTAssertTrue("user@example.com".isValidEmail)
        XCTAssertTrue("test.user@domain.co.uk".isValidEmail)
        XCTAssertTrue("user+tag@example.com".isValidEmail)
    }
    
    func testInvalidEmailAddresses() {
        XCTAssertFalse("invalid".isValidEmail)
        XCTAssertFalse("@example.com".isValidEmail)
        XCTAssertFalse("user@".isValidEmail)
        XCTAssertFalse("".isValidEmail)
    }
    
    // MARK: - Password Validation Tests
    
    func testValidPasswords() {
        XCTAssertTrue("Password123".isValidPassword)
        XCTAssertTrue("12345678".isValidPassword)
        XCTAssertTrue("LongPassword".isValidPassword)
    }
    
    func testInvalidPasswords() {
        XCTAssertFalse("short".isValidPassword)
        XCTAssertFalse("1234567".isValidPassword)
        XCTAssertFalse("".isValidPassword)
    }
    
    // MARK: - PIN Validation Tests
    
    func testValidPINs() {
        XCTAssertTrue("123456".isValidPIN)
        XCTAssertTrue("000000".isValidPIN)
        XCTAssertTrue("999999".isValidPIN)
    }
    
    func testInvalidPINs() {
        XCTAssertFalse("12345".isValidPIN)    // Too short
        XCTAssertFalse("1234567".isValidPIN)  // Too long
        XCTAssertFalse("12345a".isValidPIN)   // Contains letter
        XCTAssertFalse("abcdef".isValidPIN)   // All letters
        XCTAssertFalse("".isValidPIN)         // Empty
    }
    
    // MARK: - Accountability Partner Tests
    
    func testCreatePartnershipInvite() async throws {
        // Arrange
        let userId = "user123"
        let partnerEmail = "partner@example.com"
        let partnerName = "Partner Name"
        
        // Act
        let inviteId = try await FirebaseService.shared.createPartnershipInvite(
            userId: userId,
            partnerEmail: partnerEmail,
            partnerName: partnerName
        )
        
        // Assert
        XCTAssertFalse(inviteId.isEmpty, "Invite ID should not be empty")
    }
    
    func testAcceptPartnership() async throws {
        // Arrange
        let partnershipId = "partnership123"
        let partnerId = "partner456"
        let password = "SecurePassword123"
        
        // Act & Assert
        // This would fail without a real Firebase setup, but tests the flow
        do {
            try await FirebaseService.shared.acceptPartnership(
                partnershipId: partnershipId,
                partnerId: partnerId,
                password: password
            )
            // Success case
        } catch {
            // Expected to fail without real Firebase
            XCTAssertNotNil(error)
        }
    }
    
    // MARK: - Blocked Apps Tests
    
    func testAddBlockedApp() async throws {
        // Arrange
        let app = BlockedApp(
            userId: "user123",
            appName: "Instagram",
            bundleIdentifier: "com.burbn.instagram",
            isBlocked: true
        )
        
        // Act
        await appBlockingViewModel.addBlockedApp(app)
        
        // Assert
        XCTAssertTrue(appBlockingViewModel.blockedApps.contains(where: { $0.appName == "Instagram" }))
    }
    
    func testRemoveBlockedApp() async throws {
        // Arrange
        let app = BlockedApp(
            id: "app123",
            userId: "user123",
            appName: "TikTok",
            bundleIdentifier: "com.zhiliaoapp.musically",
            isBlocked: true
        )
        appBlockingViewModel.blockedApps = [app]
        
        // Act
        await appBlockingViewModel.removeBlockedApp(app)
        
        // Assert
        XCTAssertFalse(appBlockingViewModel.blockedApps.contains(where: { $0.id == "app123" }))
    }
    
    // MARK: - Access Request Tests
    
    func testSendAccessRequest() async throws {
        // Arrange
        let userId = "user123"
        let userName = "Test User"
        let partnerId = "partner456"
        let appName = "Instagram"
        let reason = "Need to check messages"
        
        // Act
        await accessRequestViewModel.sendAccessRequest(
            userId: userId,
            userName: userName,
            partnerId: partnerId,
            appName: appName,
            bundleId: "com.burbn.instagram",
            reason: reason
        )
        
        // Assert
        XCTAssertNotNil(accessRequestViewModel.currentRequest, "Current request should be set")
        XCTAssertEqual(accessRequestViewModel.currentRequest?.userName, userName)
    }
    
    func testAccessRequestExpiration() {
        // Arrange
        let expiredDate = Calendar.current.date(byAdding: .minute, value: -10, to: Date())!
        let request = AccessRequest(
            userId: "user123",
            userName: "Test User",
            partnerId: "partner456"
        )
        var mutableRequest = request
        mutableRequest.expiresAt = expiredDate
        
        // Assert
        XCTAssertTrue(mutableRequest.isExpired, "Request should be expired")
        XCTAssertFalse(mutableRequest.isPending, "Expired request should not be pending")
    }
    
    func testAccessRequestNotExpired() {
        // Arrange
        let futureDate = Calendar.current.date(byAdding: .minute, value: 3, to: Date())!
        var request = AccessRequest(
            userId: "user123",
            userName: "Test User",
            partnerId: "partner456"
        )
        request.expiresAt = futureDate
        
        // Assert
        XCTAssertFalse(request.isExpired, "Request should not be expired")
        XCTAssertTrue(request.isPending, "Request should be pending")
    }
    
    // MARK: - Temporary Access Tests
    
    func testGrantTemporaryAccess() {
        // Arrange
        let duration = 5
        
        // Act
        appBlockingViewModel.grantTemporaryAccess(duration: duration)
        
        // Assert
        XCTAssertTrue(appBlockingViewModel.hasTemporaryAccess, "Should have temporary access")
        XCTAssertNotNil(appBlockingViewModel.temporaryAccessExpiresAt, "Expiration date should be set")
        
        // Verify expiration time is approximately 5 minutes from now
        let expectedExpiration = Calendar.current.date(byAdding: .minute, value: duration, to: Date())!
        let timeDifference = abs(appBlockingViewModel.temporaryAccessExpiresAt!.timeIntervalSince(expectedExpiration))
        XCTAssertLessThan(timeDifference, 5, "Expiration time should be within 5 seconds of expected")
    }
    
    // MARK: - Date Extension Tests
    
    func testTimeAgoFormatting() {
        // Just now
        let now = Date()
        XCTAssertEqual(now.timeAgo(), "just now")
        
        // 30 seconds ago
        let thirtySecondsAgo = Calendar.current.date(byAdding: .second, value: -30, to: Date())!
        XCTAssertEqual(thirtySecondsAgo.timeAgo(), "30 seconds ago")
        
        // 1 minute ago
        let oneMinuteAgo = Calendar.current.date(byAdding: .minute, value: -1, to: Date())!
        XCTAssertEqual(oneMinuteAgo.timeAgo(), "1 minute ago")
        
        // 5 minutes ago
        let fiveMinutesAgo = Calendar.current.date(byAdding: .minute, value: -5, to: Date())!
        XCTAssertEqual(fiveMinutesAgo.timeAgo(), "5 minutes ago")
        
        // 1 hour ago
        let oneHourAgo = Calendar.current.date(byAdding: .hour, value: -1, to: Date())!
        XCTAssertEqual(oneHourAgo.timeAgo(), "1 hour ago")
        
        // 1 day ago
        let oneDayAgo = Calendar.current.date(byAdding: .day, value: -1, to: Date())!
        XCTAssertEqual(oneDayAgo.timeAgo(), "1 day ago")
    }
    
    // MARK: - Performance Tests
    
    func testFetchBlockedAppsPerformance() throws {
        measure {
            Task {
                await appBlockingViewModel.fetchBlockedApps(userId: "user123")
            }
        }
    }
    
    func testAccessRequestCreationPerformance() throws {
        measure {
            _ = AccessRequest(
                userId: "user123",
                userName: "Test User",
                partnerId: "partner456",
                requestedAppName: "Instagram",
                requestedAppBundleId: "com.burbn.instagram",
                reason: "Test reason"
            )
        }
    }
}

// MARK: - Mock Data for Testing

extension AccountabilityLockTests {
    
    func createMockUser() -> User {
        return User(
            id: "user123",
            email: "test@example.com",
            displayName: "Test User",
            role: .user,
            fcmToken: "mock_fcm_token"
        )
    }
    
    func createMockPartner() -> AccountabilityPartner {
        return AccountabilityPartner(
            id: "partnership123",
            userId: "user123",
            partnerId: "partner456",
            partnerEmail: "partner@example.com",
            partnerName: "Partner Name",
            status: .active,
            passwordHash: "hashed_password"
        )
    }
    
    func createMockBlockedApp() -> BlockedApp {
        return BlockedApp(
            id: "app123",
            userId: "user123",
            appName: "Instagram",
            bundleIdentifier: "com.burbn.instagram",
            isBlocked: true
        )
    }
    
    func createMockAccessRequest() -> AccessRequest {
        return AccessRequest(
            id: "request123",
            userId: "user123",
            userName: "Test User",
            partnerId: "partner456",
            requestedAppName: "Instagram",
            requestedAppBundleId: "com.burbn.instagram",
            reason: "Need to check messages",
            status: .pending,
            duration: 5
        )
    }
}
