//
//  SetupPartnerView.swift
//  AccountabilityLock
//
//  View for setting up accountability partner
//

import SwiftUI

struct SetupPartnerView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @State private var partnerEmail = ""
    @State private var partnerName = ""
    @State private var isLoading = false
    @State private var showSuccess = false
    @State private var errorMessage: String?
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 30) {
                    Spacer()
                        .frame(height: 50)
                    
                    Image(systemName: "person.2.fill")
                        .font(.system(size: 80))
                        .foregroundColor(.blue)
                    
                    VStack(spacing: 10) {
                        Text("Set Up Accountability Partner")
                            .font(.title)
                            .fontWeight(.bold)
                            .multilineTextAlignment(.center)
                        
                        Text("Invite someone you trust to help keep you accountable. They'll be able to set the password and approve your access requests.")
                            .font(.body)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 30)
                    }
                    
                    VStack(alignment: .leading, spacing: 15) {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Partner's Name")
                                .font(.subheadline)
                                .fontWeight(.semibold)
                                .foregroundColor(.secondary)
                            
                            TextField("Enter their name", text: $partnerName)
                                .textContentType(.name)
                                .padding()
                                .background(Color(.secondarySystemBackground))
                                .cornerRadius(10)
                        }
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Partner's Email")
                                .font(.subheadline)
                                .fontWeight(.semibold)
                                .foregroundColor(.secondary)
                            
                            TextField("Enter their email", text: $partnerEmail)
                                .textContentType(.emailAddress)
                                .keyboardType(.emailAddress)
                                .autocapitalization(.none)
                                .padding()
                                .background(Color(.secondarySystemBackground))
                                .cornerRadius(10)
                        }
                    }
                    .padding(.horizontal, 30)
                    .padding(.top, 20)
                    
                    if let error = errorMessage {
                        Text(error)
                            .font(.caption)
                            .foregroundColor(.red)
                            .padding(.horizontal, 30)
                    }
                    
                    VStack(spacing: 15) {
                        Button(action: sendInvite) {
                            if isLoading {
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                            } else {
                                Text("Send Invitation")
                                    .font(.headline)
                                    .foregroundColor(.white)
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .frame(height: 55)
                        .background(isFormValid ? Color.blue : Color.gray)
                        .cornerRadius(15)
                        .disabled(!isFormValid || isLoading)
                        
                        Button(action: { authViewModel.signOut() }) {
                            Text("Sign Out")
                                .font(.subheadline)
                                .foregroundColor(.red)
                        }
                    }
                    .padding(.horizontal, 30)
                    
                    Spacer()
                }
            }
            .alert("Invitation Sent! 🎉", isPresented: $showSuccess) {
                Button("OK") {
                    // Refresh to check partner status
                    Task {
                        await authViewModel.refreshUserData()
                    }
                }
            } message: {
                Text("We've sent an invitation to \(partnerName). They'll receive an email with instructions to accept and set up the accountability partnership.")
            }
        }
    }
    
    var isFormValid: Bool {
        !partnerName.isEmpty && !partnerEmail.isEmpty && partnerEmail.isValidEmail
    }
    
    func sendInvite() {
        guard let userId = authViewModel.currentUser?.id else { return }
        
        isLoading = true
        errorMessage = nil
        
        Task {
            do {
                _ = try await FirebaseService.shared.createPartnershipInvite(
                    userId: userId,
                    partnerEmail: partnerEmail,
                    partnerName: partnerName
                )
                
                isLoading = false
                showSuccess = true
            } catch {
                errorMessage = error.localizedDescription
                isLoading = false
            }
        }
    }
}

#Preview {
    SetupPartnerView()
        .environmentObject(AuthViewModel())
}
