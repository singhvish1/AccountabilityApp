# 🔐 PIN Authentication Guide

AccountabilityApp now supports **6-digit PIN authentication** as an alternative to traditional passwords, making it easier and faster to secure your account.

## 📋 Overview

Users can choose between two authentication methods during sign-up:
- **Password**: Traditional 8+ character password
- **6-Digit PIN**: Quick numeric PIN (exactly 6 digits)

## ✨ Features

### Password Option
- **Requirement**: Minimum 8 characters
- **Allowed**: Letters, numbers, special characters
- **Use Case**: Users who prefer traditional password security
- **Examples**: `Password123`, `MySecurePass2024`

### PIN Option
- **Requirement**: Exactly 6 numeric digits
- **Allowed**: Numbers 0-9 only
- **Use Case**: Quick access, easier to remember
- **Examples**: `123456`, `987654`, `000000`

## 🎯 How It Works

### During Sign-Up

1. **Enter Basic Info**
   - Full name
   - Email address

2. **Choose Authentication Type**
   - Toggle between "Password" and "6-Digit PIN"
   - Interface automatically adjusts

3. **Set Your Credentials**
   - **For Password**: Enter and confirm 8+ character password
   - **For PIN**: Enter and confirm 6-digit numeric PIN

4. **Create Account**
   - System validates your choice
   - Account is created with selected auth type

### During Sign-In

- Use the **same credentials** you set during sign-up
- Enter your password or PIN based on what you chose
- System automatically validates format

## 🔒 Security Considerations

### Password Security
✅ **More Secure** for accounts with sensitive data  
✅ Harder to guess (more combinations)  
✅ Resistant to brute force attacks  
✅ Recommended for shared devices  

### PIN Security
⚠️ **Convenience-focused** but less secure  
⚠️ Only 1,000,000 possible combinations (000000-999999)  
⚠️ Easier to guess or crack  
⚠️ Better suited for personal devices with biometric backup  

### Security Recommendations

1. **Use Password If:**
   - You're using a shared device
   - You store sensitive partner information
   - You want maximum security

2. **Use PIN If:**
   - You have biometric authentication enabled (Face ID/Touch ID)
   - You use a personal device that's always with you
   - You value convenience and quick access
   - You're comfortable with slightly lower security

3. **Best Practices:**
   - ✅ Enable biometric authentication alongside PIN
   - ✅ Don't use obvious PINs like `123456`, `000000`, `111111`
   - ✅ Don't share your PIN with anyone
   - ✅ Use PIN on devices with device-level security (lock screen)
   - ❌ Don't write down your PIN where others can see it
   - ❌ Don't use the same PIN for multiple apps

## 💻 Technical Implementation

### Data Model

```swift
struct User {
    var authType: AuthType  // .password or .pin
    
    enum AuthType: String, Codable {
        case password = "password"
        case pin = "pin"
    }
}
```

### Validation Rules

**Password Validation:**
```swift
var isValidPassword: Bool {
    return count >= 8
}
```

**PIN Validation:**
```swift
var isValidPIN: Bool {
    return count == 6 && allSatisfy { $0.isNumber }
}
```

### Firebase Authentication

Both PINs and passwords use Firebase Authentication:
- PINs are treated as passwords in Firebase
- 6-digit PINs meet Firebase's minimum requirements
- Both are hashed and securely stored

## 🧪 Testing

### Test Cases Included

**Valid PINs:**
- ✅ `123456` - Sequential
- ✅ `000000` - All same
- ✅ `987654` - Reverse sequential

**Invalid PINs:**
- ❌ `12345` - Too short (5 digits)
- ❌ `1234567` - Too long (7 digits)
- ❌ `12345a` - Contains letter
- ❌ `abcdef` - All letters
- ❌ Empty string

## 🎨 User Experience

### Sign-Up Flow

```
1. Enter Name & Email
   ↓
2. Choose Auth Type (Segmented Control)
   ├─→ Password: Show password fields
   └─→ PIN: Show PIN fields (numeric keyboard)
   ↓
3. Enter & Confirm Credentials
   ↓
4. Real-time Validation
   ├─→ Password: "Must be 8+ characters"
   └─→ PIN: "Must be exactly 6 digits"
   ↓
5. Create Account
```

### UI Features

- **Segmented Control**: Easy toggle between Password/PIN
- **Numeric Keyboard**: Automatically shown for PIN entry
- **Character Limiting**: PIN entry limited to 6 digits max
- **Real-time Validation**: Instant feedback on format
- **Matching Verification**: Confirms password/PIN match

## 📱 Screenshots

### Sign-Up with Password
```
┌─────────────────────────┐
│    Create Account       │
│                         │
│  [Password] [6-Digit PIN]  ← Toggle
│                         │
│  Password: ********     │
│  Confirm:  ********     │
│                         │
│  ✓ Must be 8+ chars     │
└─────────────────────────┘
```

### Sign-Up with PIN
```
┌─────────────────────────┐
│    Create Account       │
│                         │
│  [Password] [6-Digit PIN]  ← Toggle
│                         │
│  PIN:      ●●●●●●       │
│  Confirm:  ●●●●●●       │
│                         │
│  ✓ Must be 6 digits     │
└─────────────────────────┘
```

## 🔄 Switching Authentication Methods

### Current Limitations
- Auth type is set during account creation
- Cannot switch between password/PIN after sign-up
- Would require password reset flow to change

### Future Enhancement
Consider adding a "Change Authentication Method" feature in Settings:
1. Verify current credentials
2. Choose new auth type
3. Set new password/PIN
4. Update Firebase and Firestore

## 📊 Statistics

### Possible Combinations

**Password (8 chars, alphanumeric):**
- Lowercase only: 208,827,064,576 combinations
- Mixed case + numbers: 218,340,105,584,896 combinations
- Mixed + special chars: Much higher

**PIN (6 digits):**
- Numeric only: 1,000,000 combinations
- 100,000x less secure than simple 8-char password

### Brute Force Time Estimates

At 1,000 attempts per second:
- **Password**: Years to centuries
- **PIN**: ~16 minutes (1,000,000 / 1,000 / 60)

*Note: Firebase has rate limiting and account lockout protections*

## 🛡️ Firebase Rate Limiting

Firebase Authentication provides built-in protection:
- Automatic rate limiting on failed attempts
- Temporary account lockout after multiple failures
- IP-based blocking for suspicious activity
- This helps protect even 6-digit PINs

## ❓ FAQ

**Q: Which should I choose?**  
A: If you have biometrics enabled, PIN is convenient. Otherwise, use password.

**Q: Can I change my auth type later?**  
A: Not currently. You'd need to create a new account.

**Q: Is my PIN stored securely?**  
A: Yes! Firebase hashes and encrypts all credentials.

**Q: What if I forget my PIN?**  
A: Use the "Forgot Password" flow, which works for both passwords and PINs.

**Q: Can my accountability partner see my PIN?**  
A: No! Your partner never has access to your login credentials.

**Q: Is PIN secure enough?**  
A: For personal devices with biometrics and device lock screen, yes. For shared devices, use password.

## 📚 Related Documentation

- [SETUP_GUIDE.md](SETUP_GUIDE.md) - Complete setup instructions
- [CAMPUS_LAB_SAFETY.md](../Safety/CAMPUS_LAB_SAFETY.md) - Security considerations
- [TEST_RUN.md](TEST_RUN.md) - Testing authentication flows

---

**Version**: 1.0.0  
**Last Updated**: January 17, 2026  
**Author**: [@singhvish1](https://github.com/singhvish1)
