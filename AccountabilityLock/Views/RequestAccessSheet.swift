//
//  RequestAccessSheet.swift
//  AccountabilityLock
//
//  Sheet for requesting temporary access
//

import SwiftUI

struct RequestAccessSheet: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @StateObject private var viewModel = AccessRequestViewModel()
    @Binding var isPresented: Bool
    var onRequestSent: () -> Void
    
    @State private var selectedApp: String = "All blocked apps"
    @State private var reason = ""
    @State private var isLoading = false
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Request Details")) {
                    Picker("App", selection: $selectedApp) {
                        Text("All blocked apps").tag("All blocked apps")
                        Text("Social Media").tag("Social Media")
                        Text("Games").tag("Games")
                        Text("Entertainment").tag("Entertainment")
                    }
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Reason (Optional)")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        
                        TextEditor(text: $reason)
                            .frame(height: 100)
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color.gray.opacity(0.2), lineWidth: 1)
                            )
                    }
                }
                
                Section {
                    VStack(alignment: .leading, spacing: 10) {
                        HStack {
                            Image(systemName: "clock.fill")
                                .foregroundColor(.blue)
                            Text("Access Duration: 5 minutes")
                                .font(.subheadline)
                        }
                        
                        HStack {
                            Image(systemName: "person.fill")
                                .foregroundColor(.blue)
                            Text("Your partner will be notified")
                                .font(.subheadline)
                        }
                        
                        HStack {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(.green)
                            Text("Instant approval unlocks apps")
                                .font(.subheadline)
                        }
                    }
                    .padding(.vertical, 5)
                }
                
                Section {
                    Button(action: sendRequest) {
                        HStack {
                            Spacer()
                            if isLoading {
                                ProgressView()
                            } else {
                                Text("Send Request")
                                    .fontWeight(.semibold)
                            }
                            Spacer()
                        }
                    }
                    .disabled(isLoading)
                }
            }
            .navigationTitle("Request Access")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        isPresented = false
                    }
                }
            }
        }
    }
    
    func sendRequest() {
        guard let userId = authViewModel.currentUser?.id,
              let userName = authViewModel.currentUser?.displayName else { return }
        
        isLoading = true
        
        Task {
            // Get accountability partner
            if let partner = try? await FirebaseService.shared.getAccountabilityPartner(userId: userId) {
                await viewModel.sendAccessRequest(
                    userId: userId,
                    userName: userName,
                    partnerId: partner.partnerId,
                    appName: selectedApp,
                    bundleId: nil,
                    reason: reason.isEmpty ? nil : reason
                )
                
                isLoading = false
                isPresented = false
                onRequestSent()
            } else {
                isLoading = false
            }
        }
    }
}

#Preview {
    RequestAccessSheet(isPresented: .constant(true), onRequestSent: {})
        .environmentObject(AuthViewModel())
}
