# AccountabilityLock - iOS App Blocker

An iOS app that provides accountability-based app blocking. A trusted accountability partner (parent/friend) sets the password, and you can request temporary 5-minute passes through push notifications.

## Features

- 🔒 **App Lock System** - Block access to distracting apps
- 👥 **Accountability Partner** - Someone else controls the password
- 📱 **Push Notifications** - Request temporary access via Duo-style authentication
- ⏱️ **Timed Access** - Get 5-minute passes when approved
- 🔐 **Secure** - Password managed by accountability partner only

## Technical Stack

- **Platform**: iOS 16.0+
- **Language**: Swift 5.9+
- **UI Framework**: SwiftUI
- **Backend**: Firebase (Authentication, Cloud Messaging, Firestore)
- **Local Storage**: UserDefaults, Keychain
- **Notifications**: Apple Push Notification Service (APNs)

## Project Structure

```
AccountabilityLock/
├── App/
│   ├── AccountabilityLockApp.swift
│   └── AppDelegate.swift
├── Models/
│   ├── User.swift
│   ├── AccountabilityPartner.swift
│   ├── BlockedApp.swift
│   └── AccessRequest.swift
├── Views/
│   ├── Onboarding/
│   ├── Home/
│   ├── AppSelection/
│   └── AccessRequest/
├── ViewModels/
│   ├── AuthViewModel.swift
│   ├── AppBlockingViewModel.swift
│   └── AccessRequestViewModel.swift
├── Services/
│   ├── FirebaseService.swift
│   ├── NotificationService.swift
│   ├── AppBlockingService.swift
│   └── BiometricAuthService.swift
└── Utils/
    ├── Constants.swift
    └── Extensions.swift
```

## Setup Instructions

1. **Prerequisites**
   - Xcode 15.0 or later
   - iOS 16.0+ device or simulator
   - Firebase account
   - Apple Developer account (for push notifications)

2. **Firebase Setup**
   - Create a Firebase project
   - Add iOS app to Firebase
   - Download `GoogleService-Info.plist`
   - Enable Firebase Authentication
   - Enable Cloud Firestore
   - Enable Cloud Messaging

3. **Xcode Setup**
   - Open `AccountabilityLock.xcodeproj`
   - Add `GoogleService-Info.plist` to the project
   - Enable Push Notifications capability
   - Enable Background Modes (Remote notifications)
   - Configure App Groups (for Screen Time API)

4. **Install Dependencies**
   ```
   // Using Swift Package Manager
   - Firebase iOS SDK
   - FirebaseAuth
   - FirebaseFirestore
   - FirebaseMessaging
   ```

## How It Works

1. **Initial Setup**
   - User installs the app
   - User invites an accountability partner via email/phone
   - Partner accepts and sets up the master password
   - User selects apps to block

2. **App Blocking**
   - Uses Screen Time API (FamilyControls framework)
   - Blocks selected apps during configured times
   - Requires password (only partner knows) to unblock

3. **Access Requests**
   - User taps "Request Access" button
   - Push notification sent to accountability partner
   - Partner approves/denies from their device
   - If approved, user gets 5-minute temporary access

## Important Notes

- **Screen Time API Limitations**: The Screen Time API requires user consent and has restrictions
- **App Review**: Apple reviews apps using Screen Time API carefully
- **Privacy**: This app is designed for accountability, not surveillance
- **Two Devices**: Requires two iOS devices (user + accountability partner)

## Privacy & Ethics

This app is designed to:
- Help users build better habits through accountability
- Support voluntary self-restriction
- Promote healthy digital wellbeing

This app is NOT intended for:
- Surveillance or monitoring
- Parental control of minors without consent
- Unauthorized device control

## License

MIT License - See LICENSE file for details
