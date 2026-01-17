//
//  AuthViewModel.swift
//  AccountabilityLock
//
//  Handles authentication state
//

import Foundation
import FirebaseAuth
import FirebaseFirestore
import Combine

@MainActor
class AuthViewModel: ObservableObject {
    @Published var isAuthenticated = false
    @Published var currentUser: User?
    @Published var isLoading = true
    @Published var errorMessage: String?
    @Published var hasAccountabilityPartner = false
    
    private var authStateListener: AuthStateDidChangeListenerHandle?
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        setupAuthStateListener()
    }
    
    deinit {
        if let listener = authStateListener {
            Auth.auth().removeStateDidChangeListener(listener)
        }
    }
    
    private func setupAuthStateListener() {
        authStateListener = Auth.auth().addStateDidChangeListener { [weak self] _, user in
            Task { @MainActor in
                if let user = user {
                    await self?.fetchUserData(uid: user.uid)
                } else {
                    self?.isAuthenticated = false
                    self?.currentUser = nil
                    self?.isLoading = false
                }
            }
        }
    }
    
    func signUp(email: String, password: String, displayName: String, authType: User.AuthType = .password) async {
        isLoading = true
        errorMessage = nil
        
        do {
            let result = try await Auth.auth().createUser(withEmail: email, password: password)
            
            // Create user document in Firestore
            let newUser = User(
                id: result.user.uid,
                email: email,
                displayName: displayName,
                role: .user,
                authType: authType
            )
            
            try await FirebaseService.shared.createUser(user: newUser)
            
            // Update display name
            let changeRequest = result.user.createProfileChangeRequest()
            changeRequest.displayName = displayName
            try await changeRequest.commitChanges()
            
            await fetchUserData(uid: result.user.uid)
        } catch {
            errorMessage = error.localizedDescription
            isLoading = false
        }
    }
    
    func signIn(email: String, password: String) async {
        isLoading = true
        errorMessage = nil
        
        do {
            let result = try await Auth.auth().signIn(withEmail: email, password: password)
            await fetchUserData(uid: result.user.uid)
        } catch {
            errorMessage = error.localizedDescription
            isLoading = false
        }
    }
    
    func signOut() {
        do {
            try Auth.auth().signOut()
            isAuthenticated = false
            currentUser = nil
            hasAccountabilityPartner = false
        } catch {
            errorMessage = error.localizedDescription
        }
    }
    
    private func fetchUserData(uid: String) async {
        do {
            if let user = try await FirebaseService.shared.getUser(uid: uid) {
                self.currentUser = user
                self.isAuthenticated = true
                
                // Check if user has accountability partner
                await checkAccountabilityPartner()
                
                // Update FCM token if available
                if let fcmToken = UserDefaults.standard.string(forKey: "fcmToken") {
                    FirebaseService.shared.updateFCMToken(token: fcmToken)
                }
            }
            isLoading = false
        } catch {
            errorMessage = error.localizedDescription
            isLoading = false
        }
    }
    
    private func checkAccountabilityPartner() async {
        guard let userId = currentUser?.id else { return }
        
        do {
            let partner = try await FirebaseService.shared.getAccountabilityPartner(userId: userId)
            hasAccountabilityPartner = partner?.status == .active
        } catch {
            hasAccountabilityPartner = false
        }
    }
    
    func refreshUserData() async {
        guard let uid = currentUser?.id else { return }
        await fetchUserData(uid: uid)
    }
}
