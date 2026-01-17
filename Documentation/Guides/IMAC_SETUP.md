# Running AccountabilityLock on iMac
## Complete Setup Guide

---

## ✅ **YES! iMac is PERFECT for This Project**

Your iMac is the **ideal** environment for iOS development. This is where you'll:
- Build the app
- Run it in iOS Simulator
- Test on real iPhone/iPad
- Submit to App Store

---

## 🚀 **QUICK START (5 Steps)**

### **Step 1: Open Terminal on iMac**

Press `⌘ + Space`, type "Terminal", press Enter

### **Step 2: Clone Your GitHub Repository**

```bash
# Navigate to where you want the project
cd ~/Documents

# Clone from YOUR GitHub account
git clone https://github.com/singhvish1/AccountabilityApp.git

# Enter the project
cd AccountabilityApp
```

### **Step 3: Install Xcode (if not already installed)**

**Option A: App Store (Recommended)**
1. Open **App Store** on your iMac
2. Search for **"Xcode"**
3. Click **"Get"** or **"Download"** (it's free!)
4. Wait for download (~12-15 GB, takes 30-60 minutes)
5. Once installed, open Xcode
6. Accept the license agreement
7. Let it install additional components

**Option B: Command Line**
```bash
xcode-select --install
```

**Verify Installation:**
```bash
xcode-select -p
# Should output: /Applications/Xcode.app/Contents/Developer
```

### **Step 4: Open Project in Xcode**

```bash
# Make sure you're in the project directory
cd ~/Documents/AccountabilityApp

# Open in Xcode
open AccountabilityLock.xcodeproj
```

**If you don't have .xcodeproj file yet, create it:**
```bash
# Xcode will help you create the project file
# Or you can open Xcode and File > New > Project
```

### **Step 5: Install Firebase SDK**

**In Xcode:**
1. Go to **File** → **Add Package Dependencies**
2. In the search box, paste: 
   ```
   https://github.com/firebase/firebase-ios-sdk.git
   ```
3. Click **"Add Package"**
4. Select version: **10.20.0** or **"Up to Next Major Version"**
5. Click **"Add Package"** again
6. Select these products to add:
   - ✅ **FirebaseAuth**
   - ✅ **FirebaseFirestore**
   - ✅ **FirebaseMessaging**
7. Click **"Add Package"** one more time

---

## 🔧 **DETAILED SETUP**

### **Configure App Signing**

1. In Xcode, select the **project** (top blue icon in navigator)
2. Select **AccountabilityLock** target (under TARGETS)
3. Go to **"Signing & Capabilities"** tab
4. Check **"Automatically manage signing"**
5. Select your **Team** (your Apple ID)
   - If you don't see your Apple ID:
     - Xcode → Settings → Accounts → + → Sign in with Apple ID

### **Add Required Capabilities**

Still in **"Signing & Capabilities"** tab:

1. Click **"+ Capability"** button
2. Add these one by one:
   - **Push Notifications**
   - **Background Modes** → Check "Remote notifications"
   - **App Groups** → Add: `group.com.singhvish1.AccountabilityLock`

### **Add Firebase Configuration**

1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Create a new project or select existing
3. Click **"Add app"** → **iOS** icon
4. **Bundle ID:** `com.singhvish1.AccountabilityLock` (or your chosen ID)
5. **App nickname:** AccountabilityLock
6. Download **`GoogleService-Info.plist`**
7. Drag the file into your Xcode project
8. ✅ Check **"Copy items if needed"**
9. ✅ Make sure **"AccountabilityLock"** target is checked
10. Click **"Finish"**

---

## ▶️ **BUILD AND RUN**

### **Option 1: Run in Simulator (Easier)**

1. At the top of Xcode, click the device selector (next to play button)
2. Select any iPhone simulator (e.g., **"iPhone 15 Pro"**)
3. Press **⌘ + R** (or click the ▶️ play button)
4. Wait for build (first time takes 2-3 minutes)
5. **Simulator launches with your app!** 🎉

### **Option 2: Run on Physical iPhone (Full Features)**

**Connect iPhone:**
1. Connect iPhone to iMac with USB cable
2. Unlock your iPhone
3. If prompted, tap **"Trust This Computer"** on iPhone
4. Enter iPhone passcode

**Select Device:**
1. In Xcode device selector, choose your iPhone
2. Press **⌘ + R**

**First Time Setup:**
1. Build will succeed but app won't launch
2. On iPhone: **Settings** → **General** → **VPN & Device Management**
3. Tap your Apple ID under "Developer App"
4. Tap **"Trust [Your Name]"**
5. Confirm

**Run Again:**
1. Press **⌘ + R** in Xcode
2. App launches on your iPhone! 🎉

---

## 🔥 **FIREBASE SETUP (Required)**

### **1. Create Firebase Project**

1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Click **"Add project"** or **"Create a project"**
3. **Project name:** AccountabilityLock
4. Disable Google Analytics (optional)
5. Click **"Create project"**

### **2. Enable Authentication**

1. In Firebase Console, click **"Build"** → **"Authentication"**
2. Click **"Get started"**
3. Click **"Sign-in method"** tab
4. Click **"Email/Password"**
5. Toggle **"Enable"**
6. Click **"Save"**

### **3. Create Firestore Database**

1. Click **"Build"** → **"Firestore Database"**
2. Click **"Create database"**
3. Select **"Start in test mode"** (for now)
4. Choose a location (nearest to you)
5. Click **"Enable"**

**Add Security Rules:**
1. Click **"Rules"** tab
2. Replace with this:

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

3. Click **"Publish"**

### **4. Enable Cloud Messaging**

1. Click **"Build"** → **"Cloud Messaging"**
2. You'll configure this later for push notifications

---

## 🧪 **TESTING YOUR APP**

### **Test 1: Launch App**
```
✅ App opens without crashes
✅ Welcome screen appears
✅ Onboarding pages work
```

### **Test 2: Sign Up**
```
✅ Fill in name, email, password
✅ Tap "Sign Up"
✅ Account created
✅ Check Firebase Console → Authentication → Users
```

### **Test 3: Setup Partner**
```
✅ Enter partner email and name
✅ Send invitation
✅ Check Firebase Console → Firestore → partnerships collection
```

### **Test 4: Add Blocked Apps**
```
⚠️ Screen Time permission required
✅ Grant permission when prompted
✅ Add Instagram, TikTok, etc.
✅ Apps appear in blocked list
```

### **Test 5: Request Access (Need 2 Devices)**
```
Device 1: Send access request
Device 2: Receive push notification
Device 2: Approve request
Device 1: Receive approval notification
Device 1: Apps unlocked for 5 minutes
```

---

## 🎯 **iMac-SPECIFIC TIPS**

### **Keyboard Shortcuts**
```
⌘ + R          Build and Run
⌘ + B          Build only
⌘ + .          Stop running
⌘ + Shift + K  Clean build folder
⌘ + 0          Show/hide navigator
⌘ + Shift + Y  Show/hide console
```

### **Xcode Preferences** (Recommended Settings)
```
Xcode → Settings (⌘ + ,)
├── Accounts → Add your Apple ID
├── Text Editing → Enable line numbers
├── Navigation → Uses Tab
└── Behaviors → Success sound (optional)
```

### **Simulator Tips**
```
⌘ + Shift + H  Home button
⌘ + Shift + L  Lock screen
⌘ + K          Toggle software keyboard
⌘ + →          Rotate right
⌘ + ←          Rotate left
```

### **Performance on iMac**
```
✅ iMac has plenty of power for iOS development
✅ Simulator runs smoothly
✅ Builds are fast
✅ Can run multiple simulators at once
```

---

## 🐛 **TROUBLESHOOTING**

### **"Command Line Tools Not Found"**
```bash
xcode-select --install
```

### **"No such module 'Firebase'"**
- File → Add Package Dependencies → Add Firebase SDK again
- Clean build folder (⌘ + Shift + K)
- Build again (⌘ + B)

### **"Signing Certificate Error"**
- Xcode → Settings → Accounts → Add Apple ID
- Signing & Capabilities → Select your team
- Check "Automatically manage signing"

### **"GoogleService-Info.plist Not Found"**
- Make sure you dragged it into Xcode
- Check target membership (select file → File Inspector → Target Membership)

### **Simulator Not Showing**
```bash
# Reset simulators
xcrun simctl erase all

# Or in Xcode:
# Device → Erase All Content and Settings
```

### **Build Takes Too Long**
```bash
# Clean derived data
rm -rf ~/Library/Developer/Xcode/DerivedData/*

# In Xcode: Product → Clean Build Folder (⌘ + Shift + K)
```

---

## 📁 **PROJECT LOCATION ON iMAC**

After cloning, your project will be at:
```
~/Documents/AccountabilityApp/
```

**To open it anytime:**
```bash
cd ~/Documents/AccountabilityApp
open AccountabilityLock.xcodeproj
```

**Or double-click** the `.xcodeproj` file in Finder

---

## 🔄 **SYNCING WITH GITHUB (On iMac)**

### **Pull Latest Changes from Windows**
```bash
cd ~/Documents/AccountabilityApp
git pull
```

### **Make Changes and Push**
```bash
# After editing files in Xcode

# See what changed
git status

# Add changes
git add .

# Commit
git commit -m "Fixed notification bug"

# Push to GitHub
git push
```

### **Pull on Windows to Get iMac Changes**
```powershell
cd "C:\Users\dell\Desktop\ios app"
git pull
```

---

## 🎓 **LEARNING RESOURCES**

### **Xcode Basics**
- Apple's Xcode Tutorial: https://developer.apple.com/tutorials/xcode
- SwiftUI Tutorials: https://developer.apple.com/tutorials/swiftui

### **Firebase iOS**
- Firebase iOS Docs: https://firebase.google.com/docs/ios/setup
- Cloud Messaging: https://firebase.google.com/docs/cloud-messaging/ios/client

### **Swift Language**
- Swift Docs: https://docs.swift.org/swift-book/
- 100 Days of SwiftUI: https://www.hackingwithswift.com/100/swiftui

---

## ✅ **COMPLETE CHECKLIST**

### **Installation**
- [ ] Xcode installed on iMac
- [ ] Xcode Command Line Tools installed
- [ ] Apple ID added to Xcode
- [ ] Git configured
- [ ] Repository cloned from GitHub

### **Project Setup**
- [ ] Project opens in Xcode
- [ ] Firebase SDK added via SPM
- [ ] GoogleService-Info.plist added
- [ ] Bundle ID configured
- [ ] Signing configured
- [ ] Required capabilities added

### **Firebase**
- [ ] Firebase project created
- [ ] iOS app added to Firebase
- [ ] Authentication enabled
- [ ] Firestore database created
- [ ] Security rules published
- [ ] Cloud Messaging ready

### **Testing**
- [ ] App builds successfully (⌘ + B)
- [ ] App runs in Simulator (⌘ + R)
- [ ] Sign up works
- [ ] Firebase data syncs
- [ ] All screens navigate properly

### **Ready for Production**
- [ ] Tested on physical iPhone
- [ ] Push notifications work
- [ ] App blocking works
- [ ] Access requests work
- [ ] 5-minute timer works
- [ ] Ready for TestFlight!

---

## 🚀 **NEXT STEPS AFTER SETUP**

1. ✅ **Test all features in Simulator**
2. ✅ **Test on physical iPhone** (need 2 for full test)
3. ✅ **Set up APNs certificates** (for push notifications)
4. ✅ **Create TestFlight builds** (for beta testing)
5. ✅ **Prepare App Store submission**

---

## 💡 **PRO TIPS FOR iMAC DEVELOPMENT**

### **Use Version Control**
```bash
# Commit often
git add .
git commit -m "Descriptive message"
git push
```

### **Use Breakpoints**
- Click line number in Xcode to add breakpoint
- Run app, it pauses at breakpoint
- Inspect variables, step through code

### **Use Live Preview**
- In SwiftUI files, click "Resume" in canvas
- See UI changes in real-time
- No need to rebuild constantly

### **Use Instruments**
- Product → Profile (⌘ + I)
- Monitor memory, CPU, network
- Find performance issues

---

## 🎉 **YOU'RE ALL SET!**

Your iMac is now a complete iOS development environment for AccountabilityLock!

**Start developing:** `open ~/Documents/AccountabilityApp/AccountabilityLock.xcodeproj`

**Need help?** Check out:
- SETUP_GUIDE.md (in project)
- GITHUB_SETUP.md (in project)
- Apple Developer Forums
- Stack Overflow

---

**Happy coding on your iMac! 🚀**
