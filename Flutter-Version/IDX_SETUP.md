# 🚀 Quick Setup Guide for Google IDX

This guide will help you set up and run the Flutter version of AccountabilityApp in Google IDX.

## Step 1: Push to GitHub

```powershell
# In Windows PowerShell
cd "C:\Users\dell\Desktop\ios app\Flutter-Version"

# Initialize git
git init

# Add all files
git add .

# Commit
git commit -m "Initial Flutter version of AccountabilityApp"

# Create main branch
git branch -M main

# Add remote (create repo on GitHub first!)
git remote add origin https://github.com/singhvish1/AccountabilityApp-Flutter.git

# Push
git push -u origin main
```

## Step 2: Import to Google IDX

1. Go to [idx.google.com](https://idx.google.com)
2. Sign in with your Google account
3. Click **"Import Repository"** or **"New Project"**
4. Enter: `https://github.com/singhvish1/AccountabilityApp-Flutter.git`
5. Select **"Flutter"** as the template
6. Click **"Create Workspace"**
7. Wait 2-3 minutes for IDX to set up Flutter

## Step 3: Configure Firebase

### Create Firebase Project

1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Click **"Add project"**
3. Name: `AccountabilityApp-Flutter`
4. Disable Google Analytics (or enable if you want)
5. Click **"Create project"**

### Add Web App

1. In Firebase Console, click the **Web icon** (`</>`)
2. App nickname: `AccountabilityApp Web`
3. Check **"Also set up Firebase Hosting"**
4. Click **"Register app"**
5. Copy the `firebaseConfig` object

### Update firebase_options.dart

In IDX, edit `lib/firebase_options.dart`:

```dart
static const FirebaseOptions web = FirebaseOptions(
  apiKey: 'YOUR_API_KEY',              // ← Paste from Firebase
  appId: 'YOUR_APP_ID',                 // ← Paste from Firebase
  messagingSenderId: 'YOUR_SENDER_ID',  // ← Paste from Firebase
  projectId: 'YOUR_PROJECT_ID',         // ← Paste from Firebase
  authDomain: 'YOUR_PROJECT_ID.firebaseapp.com',
  storageBucket: 'YOUR_PROJECT_ID.appspot.com',
);
```

### Enable Firebase Services

Back in Firebase Console:

1. **Authentication**:
   - Click "Authentication" in sidebar
   - Click "Get started"
   - Click "Email/Password"
   - Enable **Email/Password**
   - Click "Save"

2. **Firestore Database**:
   - Click "Firestore Database" in sidebar
   - Click "Create database"
   - Choose **"Start in test mode"**
   - Select location (us-central recommended)
   - Click "Enable"

3. **Cloud Messaging** (for notifications):
   - Click "Cloud Messaging" in sidebar
   - Click "Get started"

## Step 4: Run in IDX

In the IDX terminal:

```bash
# Install dependencies
flutter pub get

# Run in web browser
flutter run -d web-server --web-port=8080 --web-hostname=0.0.0.0
```

Or click the **"Run"** or **"Preview"** button in IDX!

## Step 5: Test the App

1. You should see the app open in a preview window
2. Click **"Get Started"** to create an account
3. Choose either **Password** or **6-Digit PIN**
4. Create your account
5. You're in! 🎉

## 🐛 Troubleshooting

### Error: "Firebase not initialized"
- Make sure you updated `firebase_options.dart` with your Firebase config
- Run `flutter pub get` again

### Error: "Package not found"
- Run: `flutter pub get`
- Run: `flutter pub upgrade`

### App not loading in browser
- Check IDX terminal for errors
- Try: `flutter clean && flutter pub get`
- Restart the dev server

### Can't sign up/sign in
- Check Firebase Authentication is enabled
- Check browser console (F12) for errors
- Verify Firestore is in test mode

## 📱 Next Steps

### Add More Features
1. Complete the partner invitation system
2. Implement app blocking (platform-specific)
3. Add push notifications
4. Create settings page
5. Add biometric authentication

### Deploy to Production

**Option 1: Firebase Hosting (Web)**
```bash
flutter build web
firebase init hosting
firebase deploy
```

**Option 2: Play Store (Android)**
```bash
flutter build appbundle --release
# Upload to Google Play Console
```

**Option 3: App Store (iOS)**
```bash
flutter build ios --release
# Archive in Xcode and upload to App Store Connect
```

## 🔗 Useful Links

- [Flutter Documentation](https://flutter.dev/docs)
- [Firebase for Flutter](https://firebase.google.com/docs/flutter/setup)
- [Google IDX Docs](https://developers.google.com/idx)
- [Dart Language Tour](https://dart.dev/guides/language/language-tour)

## 💡 Tips for IDX Development

- ✅ Use **Hot Reload**: Press `r` in terminal to reload
- ✅ Use **Hot Restart**: Press `R` in terminal for full restart
- ✅ **Split View**: Open preview and code side-by-side
- ✅ **Flutter DevTools**: Available in IDX for debugging
- ✅ **Git Integration**: Commit changes directly in IDX

## 🎯 What Works in Browser vs Mobile

| Feature | Web (IDX) | iOS/Android |
|---------|-----------|-------------|
| Authentication | ✅ | ✅ |
| UI/UX | ✅ | ✅ |
| Firestore | ✅ | ✅ |
| Push Notifications | ⚠️ Limited | ✅ Full |
| App Blocking | ❌ No | ✅ Yes |
| Biometrics | ❌ No | ✅ Yes |

**Note**: For full app blocking and biometric features, you'll need to test on a real device or emulator.

---

**Happy Coding! 🚀**

Need help? Check the main README.md or open an issue on GitHub.
