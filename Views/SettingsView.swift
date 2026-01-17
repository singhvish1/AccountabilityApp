//
//  SettingsView.swift
//  AccountabilityLock
//
//  Settings and profile view
//

import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @State private var showSignOutAlert = false
    @State private var showAbout = false
    
    var body: some View {
        NavigationView {
            List {
                // Profile Section
                Section {
                    HStack {
                        Image(systemName: "person.circle.fill")
                            .font(.system(size: 50))
                            .foregroundColor(.blue)
                        
                        VStack(alignment: .leading, spacing: 5) {
                            Text(authViewModel.currentUser?.displayName ?? "User")
                                .font(.headline)
                            
                            Text(authViewModel.currentUser?.email ?? "")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                    }
                    .padding(.vertical, 10)
                }
                
                // Accountability Partner Section
                Section(header: Text("Accountability Partner")) {
                    NavigationLink(destination: PartnerDetailsView()) {
                        HStack {
                            Image(systemName: "person.2.fill")
                                .foregroundColor(.blue)
                            Text("My Accountability Partner")
                        }
                    }
                    
                    NavigationLink(destination: ChangePartnerView()) {
                        HStack {
                            Image(systemName: "arrow.triangle.2.circlepath")
                                .foregroundColor(.orange)
                            Text("Change Partner")
                        }
                    }
                }
                
                // App Settings
                Section(header: Text("App Settings")) {
                    NavigationLink(destination: NotificationSettingsView()) {
                        HStack {
                            Image(systemName: "bell.fill")
                                .foregroundColor(.blue)
                            Text("Notifications")
                        }
                    }
                    
                    NavigationLink(destination: SecuritySettingsView()) {
                        HStack {
                            Image(systemName: "lock.fill")
                                .foregroundColor(.blue)
                            Text("Security & Privacy")
                        }
                    }
                }
                
                // Support
                Section(header: Text("Support")) {
                    Button(action: { showAbout = true }) {
                        HStack {
                            Image(systemName: "info.circle")
                                .foregroundColor(.blue)
                            Text("About")
                                .foregroundColor(.primary)
                        }
                    }
                    
                    Link(destination: URL(string: "https://github.com")!) {
                        HStack {
                            Image(systemName: "questionmark.circle")
                                .foregroundColor(.blue)
                            Text("Help & Support")
                        }
                    }
                    
                    Link(destination: URL(string: "https://github.com")!) {
                        HStack {
                            Image(systemName: "doc.text")
                                .foregroundColor(.blue)
                            Text("Privacy Policy")
                        }
                    }
                }
                
                // Sign Out
                Section {
                    Button(action: { showSignOutAlert = true }) {
                        HStack {
                            Image(systemName: "rectangle.portrait.and.arrow.right")
                                .foregroundColor(.red)
                            Text("Sign Out")
                                .foregroundColor(.red)
                        }
                    }
                }
            }
            .navigationTitle("Settings")
            .alert("Sign Out?", isPresented: $showSignOutAlert) {
                Button("Cancel", role: .cancel) { }
                Button("Sign Out", role: .destructive) {
                    authViewModel.signOut()
                }
            } message: {
                Text("Are you sure you want to sign out?")
            }
            .sheet(isPresented: $showAbout) {
                AboutView()
            }
        }
    }
}

struct PartnerDetailsView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @State private var partner: AccountabilityPartner?
    @State private var isLoading = true
    
    var body: some View {
        List {
            if isLoading {
                HStack {
                    Spacer()
                    ProgressView()
                    Spacer()
                }
            } else if let partner = partner {
                Section(header: Text("Partner Information")) {
                    HStack {
                        Text("Name")
                            .foregroundColor(.secondary)
                        Spacer()
                        Text(partner.partnerName)
                    }
                    
                    HStack {
                        Text("Email")
                            .foregroundColor(.secondary)
                        Spacer()
                        Text(partner.partnerEmail)
                            .font(.footnote)
                    }
                    
                    HStack {
                        Text("Status")
                            .foregroundColor(.secondary)
                        Spacer()
                        Text(partner.status.rawValue.capitalized)
                            .foregroundColor(.green)
                    }
                    
                    HStack {
                        Text("Since")
                            .foregroundColor(.secondary)
                        Spacer()
                        Text(partner.acceptedAt?.formatted() ?? "Pending")
                    }
                }
            } else {
                Text("No accountability partner found")
                    .foregroundColor(.secondary)
            }
        }
        .navigationTitle("Partner Details")
        .task {
            guard let userId = authViewModel.currentUser?.id else { return }
            partner = try? await FirebaseService.shared.getAccountabilityPartner(userId: userId)
            isLoading = false
        }
    }
}

struct ChangePartnerView: View {
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "person.2.badge.gearshape")
                .font(.system(size: 60))
                .foregroundColor(.orange)
            
            Text("Change Accountability Partner")
                .font(.title2)
                .fontWeight(.bold)
            
            Text("This feature allows you to change your accountability partner. Your current partner will be notified.")
                .font(.body)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
            
            Text("Coming Soon")
                .font(.headline)
                .foregroundColor(.blue)
                .padding(.top, 20)
        }
        .navigationTitle("Change Partner")
    }
}

struct NotificationSettingsView: View {
    @State private var allowNotifications = true
    @State private var soundEnabled = true
    @State private var badgeEnabled = true
    
    var body: some View {
        List {
            Section(header: Text("Push Notifications")) {
                Toggle("Allow Notifications", isOn: $allowNotifications)
                Toggle("Sound", isOn: $soundEnabled)
                Toggle("Badge", isOn: $badgeEnabled)
            }
            
            Section(footer: Text("You'll receive notifications when your accountability partner responds to your requests, or when someone requests access from you.")) {
                EmptyView()
            }
        }
        .navigationTitle("Notifications")
    }
}

struct SecuritySettingsView: View {
    @State private var biometricEnabled = false
    
    var body: some View {
        List {
            Section(header: Text("Authentication")) {
                Toggle("Face ID / Touch ID", isOn: $biometricEnabled)
            }
            
            Section(footer: Text("Use biometric authentication to approve access requests quickly and securely.")) {
                EmptyView()
            }
        }
        .navigationTitle("Security & Privacy")
    }
}

struct AboutView: View {
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 25) {
                    Image(systemName: "lock.shield.fill")
                        .font(.system(size: 80))
                        .foregroundColor(.blue)
                        .padding(.top, 40)
                    
                    Text("AccountabilityLock")
                        .font(.title)
                        .fontWeight(.bold)
                    
                    Text("Version \(Bundle.main.appVersion)")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    
                    Divider()
                        .padding(.horizontal, 40)
                    
                    VStack(alignment: .leading, spacing: 15) {
                        Text("About")
                            .font(.headline)
                        
                        Text("AccountabilityLock is designed to help you build better digital habits through accountability. Someone you trust sets the password and can approve temporary access requests.")
                            .font(.body)
                            .foregroundColor(.secondary)
                    }
                    .padding(.horizontal, 30)
                    
                    Divider()
                        .padding(.horizontal, 40)
                    
                    VStack(spacing: 10) {
                        Text("Made with ❤️")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        
                        Text("© 2026 AccountabilityLock")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    .padding(.bottom, 40)
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        // Dismiss
                    }
                }
            }
        }
    }
}

#Preview {
    SettingsView()
        .environmentObject(AuthViewModel())
}
