//
//  BiometricAuthService.swift
//  AccountabilityLock
//
//  Handles biometric authentication (Face ID / Touch ID)
//

import Foundation
import LocalAuthentication

class BiometricAuthService {
    static let shared = BiometricAuthService()
    
    private init() {}
    
    enum BiometricType {
        case none
        case touchID
        case faceID
    }
    
    var biometricType: BiometricType {
        let context = LAContext()
        var error: NSError?
        
        guard context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) else {
            return .none
        }
        
        switch context.biometryType {
        case .touchID:
            return .touchID
        case .faceID:
            return .faceID
        default:
            return .none
        }
    }
    
    var isBiometricAvailable: Bool {
        return biometricType != .none
    }
    
    func authenticate(reason: String = "Authenticate to continue") async throws -> Bool {
        let context = LAContext()
        var error: NSError?
        
        guard context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) else {
            throw error ?? NSError(domain: "BiometricAuth", code: 1, userInfo: [NSLocalizedDescriptionKey: "Biometric authentication not available"])
        }
        
        return try await withCheckedThrowingContinuation { continuation in
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, error in
                if let error = error {
                    continuation.resume(throwing: error)
                } else {
                    continuation.resume(returning: success)
                }
            }
        }
    }
    
    func authenticateWithDevicePasscode(reason: String = "Authenticate to continue") async throws -> Bool {
        let context = LAContext()
        
        return try await withCheckedThrowingContinuation { continuation in
            context.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: reason) { success, error in
                if let error = error {
                    continuation.resume(throwing: error)
                } else {
                    continuation.resume(returning: success)
                }
            }
        }
    }
}
