//
//  OnboardingView.swift
//  AccountabilityLock
//
//  Onboarding and authentication screens
//

import SwiftUI

struct OnboardingView: View {
    @State private var currentPage = 0
    @State private var showSignIn = false
    @State private var showSignUp = false
    
    var body: some View {
        ZStack {
            if showSignIn {
                SignInView(showSignIn: $showSignIn, showSignUp: $showSignUp)
            } else if showSignUp {
                SignUpView(showSignIn: $showSignIn, showSignUp: $showSignUp)
            } else {
                WelcomeView(showSignIn: $showSignIn, showSignUp: $showSignUp)
            }
        }
        .animation(.easeInOut, value: showSignIn)
        .animation(.easeInOut, value: showSignUp)
    }
}

struct WelcomeView: View {
    @Binding var showSignIn: Bool
    @Binding var showSignUp: Bool
    @State private var currentPage = 0
    
    let pages: [(icon: String, title: String, description: String)] = [
        ("lock.shield.fill", "Stay Accountable", "Let someone you trust help you stay focused and build better habits"),
        ("bell.badge.fill", "Request Access", "Need to use a blocked app? Send a quick request to your accountability partner"),
        ("checkmark.circle.fill", "Get Temporary Access", "Your partner can approve requests and grant you 5-minute passes when needed")
    ]
    
    var body: some View {
        VStack(spacing: 30) {
            Spacer()
            
            TabView(selection: $currentPage) {
                ForEach(0..<pages.count, id: \.self) { index in
                    VStack(spacing: 30) {
                        Image(systemName: pages[index].icon)
                            .font(.system(size: 100))
                            .foregroundColor(.blue)
                        
                        Text(pages[index].title)
                            .font(.title)
                            .fontWeight(.bold)
                            .multilineTextAlignment(.center)
                        
                        Text(pages[index].description)
                            .font(.body)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 40)
                    }
                    .tag(index)
                }
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            .frame(height: 400)
            
            // Page indicator
            HStack(spacing: 8) {
                ForEach(0..<pages.count, id: \.self) { index in
                    Circle()
                        .fill(currentPage == index ? Color.blue : Color.gray.opacity(0.3))
                        .frame(width: 8, height: 8)
                }
            }
            
            Spacer()
            
            VStack(spacing: 15) {
                Button(action: { showSignUp = true }) {
                    Text("Get Started")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 55)
                        .background(Color.blue)
                        .cornerRadius(15)
                }
                
                Button(action: { showSignIn = true }) {
                    Text("I already have an account")
                        .font(.subheadline)
                        .foregroundColor(.blue)
                }
            }
            .padding(.horizontal, 30)
            .padding(.bottom, 40)
        }
    }
}

struct SignInView: View {
    @Binding var showSignIn: Bool
    @Binding var showSignUp: Bool
    @EnvironmentObject var authViewModel: AuthViewModel
    
    @State private var email = ""
    @State private var password = ""
    @State private var isLoading = false
    
    var body: some View {
        NavigationView {
            VStack(spacing: 25) {
                Spacer()
                
                Image(systemName: "lock.shield.fill")
                    .font(.system(size: 80))
                    .foregroundColor(.blue)
                
                Text("Welcome Back")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                VStack(spacing: 15) {
                    TextField("Email", text: $email)
                        .textContentType(.emailAddress)
                        .keyboardType(.emailAddress)
                        .autocapitalization(.none)
                        .padding()
                        .background(Color(.secondarySystemBackground))
                        .cornerRadius(10)
                    
                    SecureField("Password", text: $password)
                        .textContentType(.password)
                        .padding()
                        .background(Color(.secondarySystemBackground))
                        .cornerRadius(10)
                }
                .padding(.horizontal, 30)
                .padding(.top, 20)
                
                if let errorMessage = authViewModel.errorMessage {
                    Text(errorMessage)
                        .font(.caption)
                        .foregroundColor(.red)
                        .padding(.horizontal, 30)
                }
                
                Button(action: signIn) {
                    if isLoading {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .white))
                    } else {
                        Text("Sign In")
                            .font(.headline)
                            .foregroundColor(.white)
                    }
                }
                .frame(maxWidth: .infinity)
                .frame(height: 55)
                .background(isFormValid ? Color.blue : Color.gray)
                .cornerRadius(15)
                .padding(.horizontal, 30)
                .disabled(!isFormValid || isLoading)
                
                Spacer()
                
                HStack {
                    Text("Don't have an account?")
                        .foregroundColor(.secondary)
                    Button(action: {
                        showSignIn = false
                        showSignUp = true
                    }) {
                        Text("Sign Up")
                            .fontWeight(.semibold)
                            .foregroundColor(.blue)
                    }
                }
                .padding(.bottom, 40)
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: { showSignIn = false }) {
                        Image(systemName: "chevron.left")
                    }
                }
            }
        }
    }
    
    var isFormValid: Bool {
        !email.isEmpty && email.isValidEmail && !password.isEmpty
    }
    
    func signIn() {
        isLoading = true
        Task {
            await authViewModel.signIn(email: email, password: password)
            isLoading = false
        }
    }
}

struct SignUpView: View {
    @Binding var showSignIn: Bool
    @Binding var showSignUp: Bool
    @EnvironmentObject var authViewModel: AuthViewModel
    
    @State private var name = ""
    @State private var email = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var pin = ""
    @State private var confirmPin = ""
    @State private var authType: User.AuthType = .password
    @State private var isLoading = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 25) {
                    Image(systemName: "person.badge.plus.fill")
                        .font(.system(size: 80))
                        .foregroundColor(.blue)
                        .padding(.top, 50)
                    
                    Text("Create Account")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    
                    VStack(spacing: 15) {
                        TextField("Full Name", text: $name)
                            .textContentType(.name)
                            .padding()
                            .background(Color(.secondarySystemBackground))
                            .cornerRadius(10)
                        
                        TextField("Email", text: $email)
                            .textContentType(.emailAddress)
                            .keyboardType(.emailAddress)
                            .autocapitalization(.none)
                            .padding()
                            .background(Color(.secondarySystemBackground))
                            .cornerRadius(10)
                        
                        // Auth Type Picker
                        Picker("Authentication Type", selection: $authType) {
                            Text("Password").tag(User.AuthType.password)
                            Text("6-Digit PIN").tag(User.AuthType.pin)
                        }
                        .pickerStyle(SegmentedPickerStyle())
                        .padding(.vertical, 10)
                        
                        // Password or PIN fields based on selection
                        if authType == .password {
                            SecureField("Password", text: $password)
                                .textContentType(.newPassword)
                                .padding()
                                .background(Color(.secondarySystemBackground))
                                .cornerRadius(10)
                            
                            SecureField("Confirm Password", text: $confirmPassword)
                                .textContentType(.newPassword)
                                .padding()
                                .background(Color(.secondarySystemBackground))
                                .cornerRadius(10)
                        } else {
                            SecureField("6-Digit PIN", text: $pin)
                                .keyboardType(.numberPad)
                                .textContentType(.newPassword)
                                .padding()
                                .background(Color(.secondarySystemBackground))
                                .cornerRadius(10)
                                .onChange(of: pin) { newValue in
                                    // Limit to 6 digits
                                    if newValue.count > 6 {
                                        pin = String(newValue.prefix(6))
                                    }
                                }
                            
                            SecureField("Confirm PIN", text: $confirmPin)
                                .keyboardType(.numberPad)
                                .textContentType(.newPassword)
                                .padding()
                                .background(Color(.secondarySystemBackground))
                                .cornerRadius(10)
                                .onChange(of: confirmPin) { newValue in
                                    // Limit to 6 digits
                                    if newValue.count > 6 {
                                        confirmPin = String(newValue.prefix(6))
                                    }
                                }
                        }
                    }
                    .padding(.horizontal, 30)
                    .padding(.top, 20)
                    
                    if let errorMessage = authViewModel.errorMessage {
                        Text(errorMessage)
                            .font(.caption)
                            .foregroundColor(.red)
                            .padding(.horizontal, 30)
                    }
                    
                    // Validation messages
                    if authType == .password {
                        if !password.isEmpty && !password.isValidPassword {
                            Text("Password must be at least 8 characters")
                                .font(.caption)
                                .foregroundColor(.orange)
                                .padding(.horizontal, 30)
                        }
                        
                        if !confirmPassword.isEmpty && password != confirmPassword {
                            Text("Passwords do not match")
                                .font(.caption)
                                .foregroundColor(.red)
                                .padding(.horizontal, 30)
                        }
                    } else {
                        if !pin.isEmpty && !pin.isValidPIN {
                            Text("PIN must be exactly 6 digits")
                                .font(.caption)
                                .foregroundColor(.orange)
                                .padding(.horizontal, 30)
                        }
                        
                        if !confirmPin.isEmpty && pin != confirmPin {
                            Text("PINs do not match")
                                .font(.caption)
                                .foregroundColor(.red)
                                .padding(.horizontal, 30)
                        }
                    }
                    
                    Button(action: signUp) {
                        if isLoading {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        } else {
                            Text("Sign Up")
                                .font(.headline)
                                .foregroundColor(.white)
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: 55)
                    .background(isFormValid ? Color.blue : Color.gray)
                    .cornerRadius(15)
                    .padding(.horizontal, 30)
                    .disabled(!isFormValid || isLoading)
                    
                    HStack {
                        Text("Already have an account?")
                            .foregroundColor(.secondary)
                        Button(action: {
                            showSignUp = false
                            showSignIn = true
                        }) {
                            Text("Sign In")
                                .fontWeight(.semibold)
                                .foregroundColor(.blue)
                        }
                    }
                    .padding(.bottom, 40)
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: { showSignUp = false }) {
                        Image(systemName: "chevron.left")
                    }
                }
            }
        }
    }
    
    var isFormValid: Bool {
        let basicValid = !name.isEmpty && !email.isEmpty && email.isValidEmail
        
        if authType == .password {
            return basicValid && !password.isEmpty && password.isValidPassword && password == confirmPassword
        } else {
            return basicValid && !pin.isEmpty && pin.isValidPIN && pin == confirmPin
        }
    }
    
    func signUp() {
        isLoading = true
        Task {
            // Use PIN as password if PIN auth is selected
            let authPassword = authType == .pin ? pin : password
            await authViewModel.signUp(email: email, password: authPassword, displayName: name, authType: authType)
            isLoading = false
        }
    }
}

#Preview {
    OnboardingView()
        .environmentObject(AuthViewModel())
}
