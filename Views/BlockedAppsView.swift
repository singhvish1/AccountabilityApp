//
//  BlockedAppsView.swift
//  AccountabilityLock
//
//  View for managing blocked apps
//

import SwiftUI
import FamilyControls

struct BlockedAppsView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @StateObject private var viewModel = AppBlockingViewModel()
    @State private var showAddAppSheet = false
    @State private var showAuthorizationAlert = false
    
    var body: some View {
        NavigationView {
            Group {
                if viewModel.authorizationStatus == .notDetermined {
                    PermissionRequestView(viewModel: viewModel)
                } else if viewModel.authorizationStatus == .denied {
                    PermissionDeniedView()
                } else {
                    blockedAppsList
                }
            }
            .navigationTitle("Blocked Apps")
            .toolbar {
                if viewModel.authorizationStatus == .approved {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button(action: { showAddAppSheet = true }) {
                            Image(systemName: "plus")
                        }
                    }
                }
            }
            .sheet(isPresented: $showAddAppSheet) {
                AddBlockedAppSheet(viewModel: viewModel, isPresented: $showAddAppSheet)
            }
            .task {
                viewModel.checkAuthorizationStatus()
                if viewModel.authorizationStatus == .approved,
                   let userId = authViewModel.currentUser?.id {
                    await viewModel.fetchBlockedApps(userId: userId)
                }
            }
        }
    }
    
    var blockedAppsList: some View {
        List {
            if viewModel.blockedApps.isEmpty {
                VStack(spacing: 20) {
                    Image(systemName: "app.badge.checkmark")
                        .font(.system(size: 60))
                        .foregroundColor(.gray)
                    
                    Text("No Blocked Apps")
                        .font(.headline)
                    
                    Text("Tap the + button to add apps you want to block")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                }
                .frame(maxWidth: .infinity)
                .padding()
                .listRowBackground(Color.clear)
            } else {
                ForEach(viewModel.blockedApps) { app in
                    BlockedAppRow(app: app, viewModel: viewModel)
                }
                .onDelete(perform: deleteApps)
            }
        }
    }
    
    func deleteApps(at offsets: IndexSet) {
        for index in offsets {
            let app = viewModel.blockedApps[index]
            Task {
                await viewModel.removeBlockedApp(app)
            }
        }
    }
}

struct PermissionRequestView: View {
    @ObservedObject var viewModel: AppBlockingViewModel
    
    var body: some View {
        VStack(spacing: 30) {
            Image(systemName: "lock.shield.fill")
                .font(.system(size: 80))
                .foregroundColor(.blue)
            
            Text("Screen Time Permission Required")
                .font(.title2)
                .fontWeight(.bold)
                .multilineTextAlignment(.center)
            
            Text("To block apps, we need access to Screen Time settings. This allows us to restrict app usage on your device.")
                .font(.body)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
            
            Button(action: {
                Task {
                    await viewModel.requestAuthorization()
                }
            }) {
                Text("Grant Permission")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 55)
                    .background(Color.blue)
                    .cornerRadius(15)
            }
            .padding(.horizontal, 40)
        }
    }
}

struct PermissionDeniedView: View {
    var body: some View {
        VStack(spacing: 30) {
            Image(systemName: "exclamationmark.triangle.fill")
                .font(.system(size: 80))
                .foregroundColor(.orange)
            
            Text("Permission Denied")
                .font(.title2)
                .fontWeight(.bold)
            
            Text("Screen Time permission is required to block apps. Please enable it in Settings.")
                .font(.body)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
            
            Button(action: {
                if let url = URL(string: UIApplication.openSettingsURLString) {
                    UIApplication.shared.open(url)
                }
            }) {
                Text("Open Settings")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 55)
                    .background(Color.blue)
                    .cornerRadius(15)
            }
            .padding(.horizontal, 40)
        }
    }
}

struct BlockedAppRow: View {
    let app: BlockedApp
    @ObservedObject var viewModel: AppBlockingViewModel
    
    var body: some View {
        HStack {
            Image(systemName: "app.fill")
                .font(.title2)
                .foregroundColor(.blue)
                .frame(width: 40, height: 40)
                .background(Color.blue.opacity(0.1))
                .cornerRadius(8)
            
            VStack(alignment: .leading, spacing: 5) {
                Text(app.appName)
                    .font(.headline)
                
                Text(app.bundleIdentifier)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            if app.isBlocked {
                Image(systemName: "lock.fill")
                    .foregroundColor(.red)
            }
        }
    }
}

struct AddBlockedAppSheet: View {
    @ObservedObject var viewModel: AppBlockingViewModel
    @Binding var isPresented: Bool
    @EnvironmentObject var authViewModel: AuthViewModel
    @State private var searchText = ""
    
    var body: some View {
        NavigationView {
            List {
                Section(header: Text("Common Apps")) {
                    ForEach(BlockedApp.commonApps, id: \.1) { appInfo in
                        Button(action: {
                            addApp(name: appInfo.0, bundleId: appInfo.1)
                        }) {
                            HStack {
                                Image(systemName: "app.fill")
                                    .foregroundColor(.blue)
                                
                                Text(appInfo.0)
                                    .foregroundColor(.primary)
                                
                                Spacer()
                                
                                Image(systemName: "plus.circle.fill")
                                    .foregroundColor(.blue)
                            }
                        }
                    }
                }
            }
            .navigationTitle("Add Blocked App")
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
    
    func addApp(name: String, bundleId: String) {
        guard let userId = authViewModel.currentUser?.id else { return }
        
        let app = BlockedApp(
            userId: userId,
            appName: name,
            bundleIdentifier: bundleId,
            isBlocked: true
        )
        
        Task {
            await viewModel.addBlockedApp(app)
            isPresented = false
        }
    }
}

#Preview {
    BlockedAppsView()
        .environmentObject(AuthViewModel())
}
