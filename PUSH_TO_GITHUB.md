# Quick GitHub Setup for singhvish1
# AccountabilityLock iOS App

## STEP 1: Create Repository on GitHub.com

1. Open your browser and go to: https://github.com/singhvish1
2. Click the **"+"** button (top right corner)
3. Select **"New repository"**
4. Fill in these details:

```
Repository name: AccountabilityLock
Description: iOS app for accountability-based app blocking with push notifications
Public/Private: Choose Public (recommended for portfolio) or Private
☑️ Do NOT check "Add a README file" (we already have one)
☑️ Do NOT check "Add .gitignore" (we already have one)
☑️ Do NOT check "Choose a license" (we already have one)
```

5. Click **"Create repository"**

---

## STEP 2: Run These Commands (PowerShell)

After creating the repo, GitHub will show you some commands. 
**Instead, use these pre-configured commands:**

### Open PowerShell and navigate to your project:

```powershell
cd "C:\Users\dell\Desktop\ios app"
```

### Check if Git is installed:

```powershell
git --version
```

**If you see an error, install Git first:**
- Download: https://git-scm.com/download/win
- Install with default settings
- Restart PowerShell

### Configure Git (first time only):

```powershell
git config --global user.name "singhvish1"
git config --global user.email "your-email@example.com"
```

**Replace "your-email@example.com" with your actual GitHub email**

### Initialize and push to GitHub:

```powershell
# Initialize git repository
git init

# Add all files
git add .

# Check what will be committed (optional)
git status

# Create first commit
git commit -m "Initial commit: AccountabilityLock iOS app - Accountability-based app blocker with push notifications"

# Set default branch to main
git branch -M main

# Add GitHub as remote (singhvish1 account)
git remote add origin https://github.com/singhvish1/AccountabilityLock.git

# Push to GitHub
git push -u origin main
```

### When prompted for credentials:

```
Username: singhvish1
Password: [Use Personal Access Token - NOT your password]
```

---

## STEP 3: Create GitHub Personal Access Token (if needed)

If git asks for password and rejects it, you need a token:

1. Go to: https://github.com/settings/tokens
2. Click **"Generate new token"** → **"Generate new token (classic)"**
3. Name it: "AccountabilityLock Development"
4. Select scopes:
   - ✅ **repo** (all repo permissions)
5. Click **"Generate token"**
6. **COPY THE TOKEN IMMEDIATELY** (you won't see it again!)
7. Use this token as your password when pushing

---

## STEP 4: Verify Upload

After pushing, go to:
```
https://github.com/singhvish1/AccountabilityLock
```

You should see:
✅ All your Swift files
✅ README.md displayed
✅ Folder structure (Models, Views, Services, etc.)
✅ About 30+ files uploaded

---

## QUICK COPY-PASTE COMMANDS

**All commands in one block (copy and paste):**

```powershell
cd "C:\Users\dell\Desktop\ios app"
git init
git add .
git commit -m "Initial commit: AccountabilityLock iOS app - Accountability-based app blocker with push notifications"
git branch -M main
git remote add origin https://github.com/singhvish1/AccountabilityLock.git
git push -u origin main
```

---

## TROUBLESHOOTING

### Problem: "git: command not found"
**Solution:** Install Git from https://git-scm.com/download/win

### Problem: "Authentication failed"
**Solution:** Use Personal Access Token instead of password (see Step 3)

### Problem: "fatal: remote origin already exists"
**Solution:** Run this first:
```powershell
git remote remove origin
git remote add origin https://github.com/singhvish1/AccountabilityLock.git
```

### Problem: Files not uploading
**Solution:** Check .gitignore didn't exclude them:
```powershell
git status
```

---

## AFTER SUCCESSFUL PUSH

### Make Your Repository Look Professional:

1. **Add Topics** (on GitHub.com):
   - ios
   - swift
   - swiftui
   - firebase
   - accountability
   - app-blocker
   - push-notifications

2. **Add Repository Description**:
   "iOS app for accountability-based app blocking. A trusted partner controls access via push notifications, helping users stay focused."

3. **Add Website** (optional):
   Link to a demo video or documentation

4. **Pin to Profile**:
   Go to your profile → Customize pins → Select AccountabilityLock

---

## FUTURE UPDATES

### When you make changes:

```powershell
cd "C:\Users\dell\Desktop\ios app"

# Check what changed
git status

# Add changes
git add .

# Commit with descriptive message
git commit -m "Added custom blocking schedules feature"

# Push to GitHub
git push
```

---

## YOUR REPOSITORY WILL BE LIVE AT:

🔗 **https://github.com/singhvish1/AccountabilityLock**

---

## NEXT STEPS AFTER UPLOAD:

1. ✅ Share the repo link on your resume/portfolio
2. ✅ Add a nice banner image to README
3. ✅ Create a GitHub Pages site for documentation
4. ✅ Enable GitHub Actions for CI/CD (optional)
5. ✅ Invite collaborators if working with team

---

**Ready? Go create the repo on GitHub.com, then run the PowerShell commands above!** 🚀

Need help with any step? Let me know!
