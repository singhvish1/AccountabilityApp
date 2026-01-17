//
//  HomeView.swift
//  AccountabilityLock
//
//  Main home screen with quick access request
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @StateObject private var appBlockingViewModel = AppBlockingViewModel()
    @StateObject private var accessRequestViewModel = AccessRequestViewModel()
    @State private var showRequestSheet = false
    @State private var showSuccessAlert = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 25) {
                    // Header
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Hello, \(authViewModel.currentUser?.displayName ?? "User")! 👋")
                            .font(.title)
                            .fontWeight(.bold)
                        
                        if appBlockingViewModel.hasTemporaryAccess,
                           let expiresAt = appBlockingViewModel.temporaryAccessExpiresAt {
                            HStack {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundColor(.green)
                                Text("Access granted until \(expiresAt.timeFormatted())")
                                    .font(.subheadline)
                                    .foregroundColor(.green)
                            }
                            .padding()
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(Color.green.opacity(0.1))
                            .cornerRadius(10)
                        } else {
                            Text("Your apps are currently locked")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)
                    .padding(.top, 20)
                    
                    // Quick Stats
                    HStack(spacing: 15) {
                        StatCard(
                            icon: "lock.fill",
                            title: "\(appBlockingViewModel.blockedApps.count)",
                            subtitle: "Blocked Apps",
                            color: .blue
                        )
                        
                        StatCard(
                            icon: "clock.fill",
                            title: appBlockingViewModel.hasTemporaryAccess ? "Active" : "Locked",
                            subtitle: "Status",
                            color: appBlockingViewModel.hasTemporaryAccess ? .green : .orange
                        )
                    }
                    .padding(.horizontal)
                    
                    // Request Access Button
                    VStack(spacing: 15) {
                        Button(action: { showRequestSheet = true }) {
                            HStack {
                                Image(systemName: "hand.raised.fill")
                                    .font(.title2)
                                
                                VStack(alignment: .leading, spacing: 5) {
                                    Text("Need Access?")
                                        .font(.headline)
                                    Text("Request temporary access from your partner")
                                        .font(.caption)
                                }
                                
                                Spacer()
                                
                                Image(systemName: "chevron.right")
                            }
                            .foregroundColor(.white)
                            .padding()
                            .background(
                                LinearGradient(
                                    colors: [.blue, .blue.opacity(0.8)],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .cornerRadius(15)
                        }
                        .disabled(appBlockingViewModel.hasTemporaryAccess)
                        .opacity(appBlockingViewModel.hasTemporaryAccess ? 0.5 : 1.0)
                    }
                    .padding(.horizontal)
                    
                    // Recent Requests
                    VStack(alignment: .leading, spacing: 15) {
                        Text("Recent Requests")
                            .font(.headline)
                            .padding(.horizontal)
                        
                        if accessRequestViewModel.requestHistory.isEmpty {
                            VStack(spacing: 10) {
                                Image(systemName: "tray")
                                    .font(.system(size: 50))
                                    .foregroundColor(.gray)
                                Text("No requests yet")
                                    .foregroundColor(.secondary)
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 40)
                        } else {
                            ForEach(accessRequestViewModel.requestHistory.prefix(5)) { request in
                                RequestHistoryRow(request: request)
                            }
                        }
                    }
                    .padding(.top, 10)
                }
            }
            .navigationTitle("AccountabilityLock")
            .sheet(isPresented: $showRequestSheet) {
                RequestAccessSheet(
                    isPresented: $showRequestSheet,
                    onRequestSent: {
                        showSuccessAlert = true
                    }
                )
            }
            .alert("Request Sent! 📤", isPresented: $showSuccessAlert) {
                Button("OK", role: .cancel) { }
            } message: {
                Text("Your accountability partner will be notified and can approve or deny your request.")
            }
            .task {
                guard let userId = authViewModel.currentUser?.id else { return }
                await appBlockingViewModel.fetchBlockedApps(userId: userId)
                await accessRequestViewModel.fetchRequestHistory(userId: userId)
            }
        }
    }
}

struct StatCard: View {
    let icon: String
    let title: String
    let subtitle: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 10) {
            Image(systemName: icon)
                .font(.title)
                .foregroundColor(color)
            
            Text(title)
                .font(.title2)
                .fontWeight(.bold)
            
            Text(subtitle)
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color(.secondarySystemBackground))
        .cornerRadius(15)
    }
}

struct RequestHistoryRow: View {
    let request: AccessRequest
    
    var statusIcon: String {
        switch request.status {
        case .approved: return "checkmark.circle.fill"
        case .denied: return "xmark.circle.fill"
        case .pending: return "clock.fill"
        case .expired: return "exclamationmark.triangle.fill"
        case .used: return "checkmark.circle"
        }
    }
    
    var statusColor: Color {
        switch request.status {
        case .approved: return .green
        case .denied: return .red
        case .pending: return .orange
        case .expired: return .gray
        case .used: return .blue
        }
    }
    
    var body: some View {
        HStack {
            Image(systemName: statusIcon)
                .foregroundColor(statusColor)
                .font(.title3)
            
            VStack(alignment: .leading, spacing: 5) {
                Text(request.requestedAppName ?? "All blocked apps")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                
                Text(request.createdAt.timeAgo())
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            Text(request.status.rawValue.capitalized)
                .font(.caption)
                .fontWeight(.semibold)
                .foregroundColor(statusColor)
                .padding(.horizontal, 10)
                .padding(.vertical, 5)
                .background(statusColor.opacity(0.2))
                .cornerRadius(8)
        }
        .padding()
        .background(Color(.secondarySystemBackground))
        .cornerRadius(10)
        .padding(.horizontal)
    }
}

#Preview {
    HomeView()
        .environmentObject(AuthViewModel())
}
