//
//  AccessRequestsView.swift
//  AccountabilityLock
//
//  View for managing access requests (for accountability partners)
//

import SwiftUI

struct AccessRequestsView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @StateObject private var viewModel = AccessRequestViewModel()
    @State private var selectedTab = 0
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Tab Selector
                Picker("View", selection: $selectedTab) {
                    Text("Pending").tag(0)
                    Text("History").tag(1)
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()
                
                if selectedTab == 0 {
                    pendingRequestsView
                } else {
                    historyView
                }
            }
            .navigationTitle("Access Requests")
            .task {
                guard let userId = authViewModel.currentUser?.id else { return }
                await viewModel.fetchPendingRequests(partnerId: userId)
                await viewModel.fetchRequestHistory(userId: userId)
            }
            .refreshable {
                guard let userId = authViewModel.currentUser?.id else { return }
                await viewModel.fetchPendingRequests(partnerId: userId)
                await viewModel.fetchRequestHistory(userId: userId)
            }
        }
    }
    
    var pendingRequestsView: some View {
        Group {
            if viewModel.pendingRequests.isEmpty {
                VStack(spacing: 20) {
                    Image(systemName: "checkmark.circle")
                        .font(.system(size: 60))
                        .foregroundColor(.green)
                    
                    Text("No Pending Requests")
                        .font(.headline)
                    
                    Text("You'll see requests here when someone needs access to their blocked apps")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 40)
                }
                .frame(maxHeight: .infinity)
            } else {
                ScrollView {
                    LazyVStack(spacing: 15) {
                        ForEach(viewModel.pendingRequests) { request in
                            PendingRequestCard(request: request, viewModel: viewModel)
                        }
                    }
                    .padding()
                }
            }
        }
    }
    
    var historyView: some View {
        Group {
            if viewModel.requestHistory.isEmpty {
                VStack(spacing: 20) {
                    Image(systemName: "clock")
                        .font(.system(size: 60))
                        .foregroundColor(.gray)
                    
                    Text("No Request History")
                        .font(.headline)
                    
                    Text("Past requests will appear here")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                .frame(maxHeight: .infinity)
            } else {
                List {
                    ForEach(viewModel.requestHistory) { request in
                        HistoryRequestRow(request: request)
                    }
                }
                .listStyle(PlainListStyle())
            }
        }
    }
}

struct PendingRequestCard: View {
    let request: AccessRequest
    @ObservedObject var viewModel: AccessRequestViewModel
    @State private var showApproveConfirmation = false
    @State private var showDenyConfirmation = false
    @State private var isProcessing = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            HStack {
                VStack(alignment: .leading, spacing: 5) {
                    Text(request.userName)
                        .font(.headline)
                    
                    Text(request.createdAt.timeAgo())
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                Image(systemName: "exclamationmark.circle.fill")
                    .foregroundColor(.orange)
                    .font(.title2)
            }
            
            Divider()
            
            VStack(alignment: .leading, spacing: 10) {
                HStack {
                    Image(systemName: "app.badge")
                        .foregroundColor(.blue)
                    Text(request.requestedAppName ?? "All blocked apps")
                        .font(.subheadline)
                }
                
                HStack {
                    Image(systemName: "clock")
                        .foregroundColor(.blue)
                    Text("\(request.duration) minutes access")
                        .font(.subheadline)
                }
                
                if let reason = request.reason {
                    HStack(alignment: .top) {
                        Image(systemName: "text.quote")
                            .foregroundColor(.blue)
                        Text(reason)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                }
            }
            
            HStack(spacing: 10) {
                Button(action: { showDenyConfirmation = true }) {
                    HStack {
                        Image(systemName: "xmark")
                        Text("Deny")
                    }
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(.red)
                    .frame(maxWidth: .infinity)
                    .frame(height: 44)
                    .background(Color.red.opacity(0.1))
                    .cornerRadius(10)
                }
                .disabled(isProcessing)
                
                Button(action: { showApproveConfirmation = true }) {
                    HStack {
                        Image(systemName: "checkmark")
                        Text("Approve")
                    }
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 44)
                    .background(Color.green)
                    .cornerRadius(10)
                }
                .disabled(isProcessing)
            }
        }
        .padding()
        .background(Color(.secondarySystemBackground))
        .cornerRadius(15)
        .confirmationDialog("Approve Access Request?", isPresented: $showApproveConfirmation) {
            Button("Approve for \(request.duration) minutes", role: .none) {
                approveRequest()
            }
            Button("Cancel", role: .cancel) { }
        } message: {
            Text("\(request.userName) will get temporary access to \(request.requestedAppName ?? "their blocked apps")")
        }
        .confirmationDialog("Deny Access Request?", isPresented: $showDenyConfirmation) {
            Button("Deny", role: .destructive) {
                denyRequest()
            }
            Button("Cancel", role: .cancel) { }
        } message: {
            Text("\(request.userName) will be notified that their request was denied")
        }
    }
    
    func approveRequest() {
        guard let requestId = request.id else { return }
        isProcessing = true
        
        Task {
            await viewModel.approveRequest(requestId: requestId, duration: request.duration)
            isProcessing = false
        }
    }
    
    func denyRequest() {
        guard let requestId = request.id else { return }
        isProcessing = true
        
        Task {
            await viewModel.denyRequest(requestId: requestId)
            isProcessing = false
        }
    }
}

struct HistoryRequestRow: View {
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
                
                Text(request.createdAt.formatted())
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 5) {
                Text(request.status.rawValue.capitalized)
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundColor(statusColor)
                
                if let respondedAt = request.respondedAt {
                    Text(respondedAt.timeFormatted())
                        .font(.caption2)
                        .foregroundColor(.secondary)
                }
            }
        }
        .padding(.vertical, 8)
    }
}

#Preview {
    AccessRequestsView()
        .environmentObject(AuthViewModel())
}
