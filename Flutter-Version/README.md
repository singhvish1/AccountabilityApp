# AccountabilityApp - Flutter Edition

**Cross-platform accountability app blocker** built with Flutter. Works on iOS, Android, and Web!

> 🎯 **This is the Flutter/Dart version** of the iOS Swift app. Import this into **Google IDX** for easy cloud-based development!

## 🌟 Features

- 🔐 **Dual Authentication**: Password (8+ chars) or 6-digit PIN
- 👥 **Accountability Partner System**: Partner controls app access
- 📱 **App Blocking**: Block distracting apps with partner approval needed
- 🔔 **Push Notifications**: Real-time access request notifications
- ⏱️ **Temporary Access**: 5-minute timed access grants
- 🔒 **Biometric Auth**: Face ID, Touch ID, Fingerprint support
- 📊 **Dashboard**: Track requests, blocks, and partner activity

## 🚀 Quick Start with Google IDX

### Step 1: Push to GitHub
```bash
cd "C:\Users\dell\Desktop\ios app\Flutter-Version"
git init
git add .
git commit -m "Initial Flutter version of AccountabilityApp"
git branch -M main
git remote add origin https://github.com/singhvish1/AccountabilityApp-Flutter.git
git push -u origin main
```

### Step 2: Import to Google IDX
1. Go to [idx.google.com](https://idx.google.com)
2. Click **"Import Repository"**
3. Enter: `https://github.com/singhvish1/AccountabilityApp-Flutter.git`
4. Select **Flutter** template
5. Click **"Create Workspace"**
6. Wait for setup (IDX will install Flutter automatically)
7. Click **"Preview"** button → App runs in browser!

### Step 3: Test & Develop
```bash
# In IDX terminal
flutter pub get        # Install dependencies
flutter run -d web     # Run in browser
flutter run -d chrome  # Run in Chrome
```

## 📱 Platform Support

| Platform | Status | Notes |
|----------|--------|-------|
| 🌐 Web | ✅ **Best for IDX** | Full UI testing in browser |
| 🤖 Android | ✅ Full Support | Deploy to Play Store |
| 🍎 iOS | ✅ Full Support | Deploy to App Store |
| 💻 Desktop | ⚠️ Partial | Windows/Mac/Linux |

## 🛠️ Tech Stack

- **Framework**: Flutter 3.19+
- **Language**: Dart 3.3+
- **Backend**: Firebase (Auth, Firestore, Cloud Messaging)
- **State Management**: Provider pattern
- **Authentication**: Firebase Auth + Local Auth
- **UI**: Material Design 3

## 🔧 Setup Instructions

### Prerequisites
- Google IDX account (free) OR Flutter installed locally
- Firebase account (free)

### Firebase Setup
1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Create project: "AccountabilityApp"
3. Add Web app
4. Copy Firebase config
5. Paste into `lib/firebase_options.dart`
6. Enable Authentication (Email/Password)
7. Enable Firestore Database
8. Enable Cloud Messaging

### Running Locally (Optional)
```bash
# Install Flutter: https://flutter.dev/docs/get-started/install

flutter pub get
flutter run
```

## 📂 Project Structure

```
lib/
├── main.dart                    # App entry point
├── models/                      # Data models
│   ├── user_model.dart
│   ├── partner_model.dart
│   ├── blocked_app_model.dart
│   └── access_request_model.dart
├── providers/                   # State management
│   ├── auth_provider.dart
│   ├── app_blocking_provider.dart
│   └── access_request_provider.dart
├── screens/                     # UI screens
│   ├── onboarding_screen.dart
│   ├── home_screen.dart
│   ├── blocked_apps_screen.dart
│   ├── access_requests_screen.dart
│   └── settings_screen.dart
├── services/                    # Business logic
│   ├── firebase_service.dart
│   └── notification_service.dart
├── widgets/                     # Reusable widgets
│   ├── custom_button.dart
│   └── stat_card.dart
└── utils/                       # Utilities
    ├── constants.dart
    └── validators.dart
```

## 🧪 Testing

```bash
flutter test
flutter test --coverage
```

## 📦 Build & Deploy

### Web (for IDX demo)
```bash
flutter build web
# Deploy to Firebase Hosting or Netlify
```

### Android APK
```bash
flutter build apk --release
```

### iOS (requires Mac)
```bash
flutter build ios --release
```

## 🎯 Why Flutter for IDX?

✅ **Works in Browser**: Test without phone  
✅ **Hot Reload**: See changes instantly  
✅ **Cross-Platform**: Build for iOS + Android + Web  
✅ **No Mac Needed**: Develop on any computer  
✅ **Free Hosting**: Deploy to Firebase/Netlify  
✅ **Cloud Development**: Code from anywhere  

## 🔗 Related Projects

- **Original iOS Version**: [AccountabilityApp](https://github.com/singhvish1/AccountabilityApp)
- Uses Swift + SwiftUI
- iOS/Mac only

## 📄 License

MIT License

---

**Built with ❤️ using Flutter**  
**Author**: [@singhvish1](https://github.com/singhvish1)  
**Date**: January 17, 2026
