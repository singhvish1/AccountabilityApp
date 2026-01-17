# GitHub + Xcode Setup Guide
## Complete Step-by-Step Instructions

---

## 📋 PREREQUISITES

Before you start, make sure you have:
- ✅ Windows PC (where your project currently is)
- ✅ Mac computer (to build and run the iOS app)
- ✅ GitHub account (create free at github.com)
- ✅ Git installed on both computers

---

## PART 1: UPLOAD TO GITHUB (On Windows)

### Step 1: Install Git on Windows (if not already installed)

**Download Git:**
```
https://git-scm.com/download/win
```

**Install with default settings, then restart PowerShell**

### Step 2: Configure Git (First Time Only)

Open PowerShell in your project folder and run:

```powershell
cd "C:\Users\dell\Desktop\ios app"

git config --global user.name "Your Name"
git config --global user.email "your.email@example.com"
```

### Step 3: Initialize Git Repository

```powershell
# Initialize git
git init

# Check what files will be added
git status
```

You should see all your Swift files listed in green.

### Step 4: Add All Files

```powershell
# Add all files to staging
git add .

# Verify files are staged
git status
```

### Step 5: Create First Commit

```powershell
git commit -m "Initial commit: AccountabilityLock iOS app with Firebase integration"
```

### Step 6: Create GitHub Repository

**Go to GitHub.com and:**
1. Click the **"+"** icon (top right)
2. Select **"New repository"**
3. Fill in:
   - **Repository name:** `AccountabilityLock`
   - **Description:** "iOS app for accountability-based app blocking"
   - **Visibility:** Public or Private (your choice)
   - **DON'T** initialize with README (we already have one)
4. Click **"Create repository"**

### Step 7: Connect to GitHub

GitHub will show you commands. Use these (replace YOUR_USERNAME):

```powershell
# Set main as default branch
git branch -M main

# Add GitHub as remote
git remote add origin https://github.com/YOUR_USERNAME/AccountabilityLock.git

# Push to GitHub
git push -u origin main
```

**If asked for credentials:**
- Username: Your GitHub username
- Password: Use a **Personal Access Token** (not your password)

**To create token:**
1. GitHub.com → Settings → Developer settings → Personal access tokens → Tokens (classic)
2. Generate new token → Select "repo" scope → Generate
3. Copy token and use as password

### Step 8: Verify Upload

Go to your GitHub repository URL:
```
https://github.com/YOUR_USERNAME/AccountabilityLock
```

You should see all your files! 🎉

---

## PART 2: CLONE ON MAC & BUILD

### Step 9: Clone Repository on Mac

Open Terminal on your Mac:

```bash
# Navigate to where you want the project
cd ~/Documents/

# Clone from GitHub
git clone https://github.com/YOUR_USERNAME/AccountabilityLock.git

# Enter the project
cd AccountabilityLock
```

### Step 10: Install Xcode (if not already installed)

1. Open **App Store** on Mac
2. Search for **"Xcode"**
3. Click **"Get"** or **"Install"**
4. Wait (it's ~12GB, takes 30-60 minutes)
5. Open Xcode once to accept license

### Step 11: Install Firebase SDK

**Open Terminal in project folder:**

```bash
cd ~/Documents/AccountabilityLock

# Open Xcode
open AccountabilityLock.xcodeproj
```

**In Xcode:**
1. File → Add Package Dependencies
2. Enter URL: `https://github.com/firebase/firebase-ios-sdk.git`
3. Version: 10.20.0 or later
4. Click "Add Package"
5. Select these products:
   - ✅ FirebaseAuth
   - ✅ FirebaseFirestore
   - ✅ FirebaseMessaging
6. Click "Add Package" again

### Step 12: Add Firebase Configuration

**You need GoogleService-Info.plist from Firebase:**

1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Create project or select existing
3. Add iOS app
4. Bundle ID: `com.yourname.AccountabilityLock`
5. Download `GoogleService-Info.plist`
6. Drag file into Xcode project
7. ✅ Check "Copy items if needed"
8. ✅ Check "AccountabilityLock" target

### Step 13: Configure Signing

**In Xcode:**
1. Select project in navigator (top blue icon)
2. Select **AccountabilityLock** target
3. Go to **"Signing & Capabilities"** tab
4. Check **"Automatically manage signing"**
5. Select your **Team** (Apple ID)
6. Xcode will create Bundle ID automatically

### Step 14: Add Required Capabilities

**Still in "Signing & Capabilities":**

Click **"+ Capability"** and add:
- Push Notifications
- Background Modes → Check "Remote notifications"
- App Groups → Add group: `group.com.yourname.AccountabilityLock`

### Step 15: Build and Run!

**Connect iPhone or use Simulator:**

**For Simulator:**
1. Top bar → Select "iPhone 15 Pro" (or any iPhone)
2. Press ⌘R or click ▶️ Play button
3. Wait for build (first time takes 2-3 minutes)
4. App launches in Simulator! 🎉

**For Physical iPhone:**
1. Connect iPhone via USB
2. Unlock iPhone
3. Trust computer if prompted
4. Top bar → Select your iPhone
5. Press ⌘R
6. On iPhone: Settings → General → VPN & Device Management → Trust developer
7. Run again
8. App launches on your iPhone! 🎉

---

## PART 3: MAKING CHANGES & UPDATING

### On Windows (Edit Code)

```powershell
cd "C:\Users\dell\Desktop\ios app"

# Make your changes to Swift files

# Check what changed
git status

# Add changes
git add .

# Commit with message
git commit -m "Added new feature: custom blocking schedules"

# Push to GitHub
git push
```

### On Mac (Pull Latest Changes)

```bash
cd ~/Documents/AccountabilityLock

# Get latest code
git pull

# Build and run in Xcode
# Press ⌘R
```

---

## 🔥 FIREBASE SETUP (Required for App to Work)

### Step 1: Create Firebase Project

1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Click "Add project"
3. Name: "AccountabilityLock"
4. Disable Google Analytics (optional)
5. Click "Create project"

### Step 2: Add iOS App

1. Click iOS icon
2. Bundle ID: `com.yourname.AccountabilityLock`
3. Download `GoogleService-Info.plist`
4. Add to Xcode (as described above)

### Step 3: Enable Authentication

1. Build → Authentication
2. Get Started
3. Sign-in method → Email/Password → Enable
4. Save

### Step 4: Create Firestore Database

1. Build → Firestore Database
2. Create database
3. Start in **test mode** (for now)
4. Select location (nearest to you)
5. Enable

### Step 5: Add Security Rules

Click "Rules" tab and paste:

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /users/{userId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
    
    match /partnerships/{partnershipId} {
      allow read, write: if request.auth != null;
    }
    
    match /blockedApps/{appId} {
      allow read, write: if request.auth != null;
    }
    
    match /accessRequests/{requestId} {
      allow read, write: if request.auth != null;
    }
  }
}
```

Click **"Publish"**

### Step 6: Enable Cloud Messaging

1. Build → Cloud Messaging
2. No additional setup needed initially

### Step 7: Upload APNs Key (For Push Notifications)

**Create APNs Key:**
1. Go to [Apple Developer](https://developer.apple.com/)
2. Certificates, Identifiers & Profiles
3. Keys → + (Create new)
4. Name: "AccountabilityLock Push"
5. Enable: Apple Push Notifications service
6. Continue → Register → Download `.p8` file
7. Note: Key ID and Team ID

**Upload to Firebase:**
1. Firebase Console → Project Settings
2. Cloud Messaging tab
3. iOS app configuration
4. Upload APNs Authentication Key
5. Enter Key ID and Team ID
6. Upload

---

## 🎯 TESTING YOUR APP

### Test Authentication

1. Run app in Simulator
2. Tap "Get Started"
3. Fill in sign up form
4. Tap "Sign Up"
5. Check Firebase Console → Authentication → Users
6. You should see new user! ✅

### Test Firestore

1. In app, complete onboarding
2. Add accountability partner
3. Check Firebase Console → Firestore Database
4. You should see `partnerships` collection! ✅

### Test Push Notifications

**Note:** Push notifications don't work in Simulator, need physical device!

1. Build on physical iPhone
2. Send access request
3. Check second device for notification
4. Approve/Deny
5. First device should receive response! ✅

---

## 📱 GITHUB WORKFLOW

### Daily Development Workflow

**On Windows (Write Code):**
```powershell
# Morning: Get latest code
git pull

# Write code...

# Evening: Upload changes
git add .
git commit -m "Describe what you changed"
git push
```

**On Mac (Test Code):**
```bash
# Get latest from GitHub
git pull

# Open in Xcode
open AccountabilityLock.xcodeproj

# Build and test (⌘R)
```

### Branching for Features

```bash
# Create feature branch
git checkout -b feature/new-schedule-ui

# Make changes...

# Commit changes
git add .
git commit -m "Added custom schedule UI"

# Push branch
git push -u origin feature/new-schedule-ui

# On GitHub: Create Pull Request

# After review: Merge to main
```

---

## 🐛 TROUBLESHOOTING

### Issue: "xcrun: error: SDK not found"
**Solution:** Install Xcode Command Line Tools
```bash
xcode-select --install
```

### Issue: "No signing certificate"
**Solution:** In Xcode, Signing & Capabilities → Check "Automatically manage signing"

### Issue: "Module 'Firebase' not found"
**Solution:** File → Add Package Dependencies → Add Firebase SDK again

### Issue: Git asks for password every time
**Solution:** Use SSH instead of HTTPS
```bash
git remote set-url origin git@github.com:YOUR_USERNAME/AccountabilityLock.git
```

### Issue: Can't push to GitHub
**Solution:** Use Personal Access Token instead of password

### Issue: Merge conflicts
**Solution:**
```bash
# See conflicts
git status

# Edit conflicting files
# Look for <<<<<<< HEAD markers
# Fix manually

# Mark as resolved
git add .
git commit -m "Resolved conflicts"
git push
```

---

## 🎉 SUCCESS CHECKLIST

- [ ] Git installed on Windows
- [ ] Repository created on GitHub
- [ ] Code pushed to GitHub
- [ ] Xcode installed on Mac
- [ ] Project cloned on Mac
- [ ] Firebase SDK added
- [ ] GoogleService-Info.plist added
- [ ] Signing configured
- [ ] App builds in Xcode
- [ ] App runs in Simulator
- [ ] Firebase Authentication works
- [ ] Firestore saves data
- [ ] Push notifications work (physical device)

---

## 📚 USEFUL COMMANDS

```bash
# Check current status
git status

# See commit history
git log --oneline

# See what changed
git diff

# Undo last commit (keep changes)
git reset --soft HEAD~1

# Discard all local changes
git reset --hard HEAD

# Update from GitHub
git pull

# Push to GitHub
git push

# Create branch
git checkout -b branch-name

# Switch branch
git checkout main

# List branches
git branch

# Delete branch
git branch -d branch-name
```

---

## 🚀 NEXT STEPS

1. ✅ Upload to GitHub (Part 1)
2. ✅ Build on Mac (Part 2)
3. ✅ Setup Firebase (Part 3)
4. ✅ Test all features
5. 🎯 Invite beta testers via TestFlight
6. 🎯 Submit to App Store

---

**Need help? Open an issue on GitHub or check CONTRIBUTING.md**

Good luck! 🍀
