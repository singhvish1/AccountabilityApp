# Setup Guide for AccountabilityLock

This guide will walk you through setting up your iOS AccountabilityLock app from scratch.

## Prerequisites

- macOS Ventura or later
- Xcode 15.0 or later
- iOS 16.0+ device (physical device recommended for testing)
- Apple Developer account
- Firebase account (free tier works)

## Step 1: Firebase Setup

### 1.1 Create Firebase Project
1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Click "Add project"
3. Name it "AccountabilityLock" and follow the wizard

### 1.2 Add iOS App to Firebase
1. In Firebase Console, click "Add app" > iOS
2. Bundle ID: `com.yourname.AccountabilityLock`
3. Download `GoogleService-Info.plist`

### 1.3 Enable Firebase Services
1. **Authentication**
   - Go to Authentication > Sign-in method
   - Enable Email/Password

2. **Cloud Firestore**
   - Go to Firestore Database
   - Create database in production mode
   - Start with test rules (we'll secure later)

3. **Cloud Messaging**
   - Go to Cloud Messaging
   - No additional setup needed initially

### 1.4 Firestore Security Rules
```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Users can only read/write their own user document
    match /users/{userId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
    
    // Partnerships
    match /partnerships/{partnershipId} {
      allow read: if request.auth != null && 
        (resource.data.userId == request.auth.uid || 
         resource.data.partnerId == request.auth.uid);
      allow create: if request.auth != null;
      allow update: if request.auth != null && 
        (resource.data.userId == request.auth.uid || 
         resource.data.partnerId == request.auth.uid);
    }
    
    // Blocked apps - only owner can access
    match /blockedApps/{appId} {
      allow read, write: if request.auth != null && 
        resource.data.userId == request.auth.uid;
    }
    
    // Access requests
    match /accessRequests/{requestId} {
      allow read: if request.auth != null && 
        (resource.data.userId == request.auth.uid || 
         resource.data.partnerId == request.auth.uid);
      allow create: if request.auth != null;
      allow update: if request.auth != null && 
        resource.data.partnerId == request.auth.uid;
    }
  }
}
```

## Step 2: Xcode Project Setup

### 2.1 Create Xcode Project
1. Open Xcode
2. File > New > Project
3. Choose "App" template
4. Product Name: `AccountabilityLock`
5. Interface: SwiftUI
6. Language: Swift
7. Bundle Identifier: `com.yourname.AccountabilityLock`

### 2.2 Add GoogleService-Info.plist
1. Drag `GoogleService-Info.plist` into your Xcode project
2. Make sure "Copy items if needed" is checked
3. Add to target: AccountabilityLock

### 2.3 Configure Capabilities
1. Select project in navigator
2. Select AccountabilityLock target
3. Go to "Signing & Capabilities"

**Add these capabilities:**
- Push Notifications
- Background Modes (check "Remote notifications")
- Family Controls (for Screen Time API)
- App Groups: `group.com.yourname.AccountabilityLock`

### 2.4 Update Info.plist
Add these keys:
```xml
<key>NSFaceIDUsageDescription</key>
<string>We use Face ID to securely authenticate you when making access requests.</string>

<key>NSUserTrackingUsageDescription</key>
<string>We use Screen Time data to help you manage app usage.</string>

<key>UIBackgroundModes</key>
<array>
    <string>remote-notification</string>
</array>
```

### 2.5 Add Firebase SDK via Swift Package Manager
1. File > Add Package Dependencies
2. Enter: `https://github.com/firebase/firebase-ios-sdk.git`
3. Version: 10.20.0 or later
4. Add packages:
   - FirebaseAuth
   - FirebaseFirestore
   - FirebaseMessaging

## Step 3: Copy Project Files

Copy all the Swift files from this repository into your Xcode project:

```
AccountabilityLock/
├── AccountabilityLockApp.swift
├── AppDelegate.swift
├── ContentView.swift
├── Models/
│   ├── User.swift
│   ├── AccountabilityPartner.swift
│   ├── BlockedApp.swift
│   └── AccessRequest.swift
├── ViewModels/
│   ├── AuthViewModel.swift
│   ├── AppBlockingViewModel.swift
│   └── AccessRequestViewModel.swift
├── Views/
│   ├── OnboardingView.swift
│   ├── SetupPartnerView.swift
│   ├── MainTabView.swift
│   ├── HomeView.swift
│   ├── RequestAccessSheet.swift
│   ├── BlockedAppsView.swift
│   ├── AccessRequestsView.swift
│   └── SettingsView.swift
├── Services/
│   ├── FirebaseService.swift
│   ├── NotificationService.swift
│   └── BiometricAuthService.swift
└── Utils/
    ├── Constants.swift
    └── Extensions.swift
```

## Step 4: Apple Push Notification Setup

### 4.1 Create APNs Key
1. Go to [Apple Developer Portal](https://developer.apple.com/)
2. Certificates, Identifiers & Profiles
3. Keys > + (Create new key)
4. Name: "AccountabilityLock APNs Key"
5. Enable: Apple Push Notifications service (APNs)
6. Download `.p8` file (keep safe!)
7. Note your Key ID and Team ID

### 4.2 Upload APNs Key to Firebase
1. Firebase Console > Project Settings
2. Cloud Messaging tab
3. iOS app configuration
4. Upload APNs Authentication Key (.p8 file)
5. Enter Key ID and Team ID

## Step 5: Test the App

### 5.1 Build and Run
1. Connect iOS device (Simulator has limitations with push notifications)
2. Select your device in Xcode
3. Click Run (⌘R)

### 5.2 Create Test Accounts
1. Sign up with two accounts:
   - Account A: The person being held accountable
   - Account B: The accountability partner

### 5.3 Test Flow
1. Sign in with Account A
2. Invite Account B as accountability partner
3. Sign in with Account B (different device)
4. Accept partnership and set password
5. Back on Account A: Add blocked apps
6. Request access
7. On Account B: Approve/Deny request
8. Verify temporary access works

## Step 6: Known Limitations & Solutions

### Screen Time API Limitations
- **Issue**: iOS Screen Time API has strict limitations
- **Solution**: Consider using Device Management MDM for enterprise use
- **Alternative**: Use local blocking with app URL schemes

### Push Notification Delivery
- **Issue**: Notifications may be delayed
- **Solution**: Use "priority: high" in FCM payload
- **Alternative**: Implement local polling as backup

### Two-Device Requirement
- **Issue**: Requires two physical devices for full testing
- **Solution**: Use TestFlight for beta testing with friends/family

## Step 7: Deployment Checklist

Before submitting to App Store:

- [ ] Update Firebase rules to production mode
- [ ] Add proper error handling
- [ ] Implement analytics (optional)
- [ ] Create App Store screenshots
- [ ] Write App Store description
- [ ] Set up TestFlight beta testing
- [ ] Review Apple's Screen Time API guidelines
- [ ] Ensure privacy policy is complete
- [ ] Test on multiple devices
- [ ] Add crash reporting (Firebase Crashlytics)

## Troubleshooting

### Firebase Connection Issues
```swift
// Add debug logging in AppDelegate
FirebaseConfiguration.shared.setLoggerLevel(.debug)
```

### Push Notifications Not Working
1. Check APNs certificate is uploaded to Firebase
2. Verify device token is being registered
3. Check notification permissions are granted
4. Test with Firebase Console > Cloud Messaging

### Screen Time API Not Working
1. Ensure Family Controls capability is enabled
2. Request authorization before using API
3. Test on physical device (won't work in Simulator)

## Next Steps

1. Customize the UI to match your design preferences
2. Add more blocking options (time-based, location-based)
3. Implement analytics to track usage patterns
4. Add social features (multiple accountability partners)
5. Create widget for quick access requests
6. Add Siri Shortcuts integration

## Support

For issues or questions:
- Check Firebase Console logs
- Review Xcode console output
- Test on physical devices
- Refer to Apple's FamilyControls documentation

## License

MIT License - See LICENSE file for details
