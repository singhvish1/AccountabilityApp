# Project Structure

This document describes the organization of the AccountabilityApp project.

## 📁 Directory Structure

```
AccountabilityApp/
│
├── AccountabilityLock/              # Main iOS App Source Code
│   ├── AccountabilityLockApp.swift  # App entry point
│   ├── AppDelegate.swift            # App lifecycle & push notifications
│   ├── ContentView.swift            # Root view
│   ├── Info.plist                   # App configuration
│   │
│   ├── Models/                      # Data Models
│   │   ├── User.swift
│   │   ├── AccountabilityPartner.swift
│   │   ├── BlockedApp.swift
│   │   └── AccessRequest.swift
│   │
│   ├── Views/                       # SwiftUI Views
│   │   ├── OnboardingView.swift
│   │   ├── SetupPartnerView.swift
│   │   ├── MainTabView.swift
│   │   ├── HomeView.swift
│   │   ├── RequestAccessSheet.swift
│   │   ├── BlockedAppsView.swift
│   │   ├── AccessRequestsView.swift
│   │   └── SettingsView.swift
│   │
│   ├── ViewModels/                  # Business Logic Layer
│   │   ├── AuthViewModel.swift
│   │   ├── AppBlockingViewModel.swift
│   │   └── AccessRequestViewModel.swift
│   │
│   ├── Services/                    # Core Services
│   │   ├── FirebaseService.swift
│   │   ├── NotificationService.swift
│   │   └── BiometricAuthService.swift
│   │
│   └── Utils/                       # Utilities & Extensions
│       ├── Constants.swift
│       └── Extensions.swift
│
├── Tests/                           # Unit & Integration Tests
│   └── AccountabilityLockTests.swift
│
├── Documentation/                   # Project Documentation
│   ├── Guides/                      # Setup & Usage Guides
│   │   ├── SETUP_GUIDE.md          # Complete setup instructions
│   │   ├── TEST_RUN.md             # Testing guide
│   │   ├── DEMO_SCRIPT.md          # Demo walkthrough
│   │   ├── GITHUB_SETUP.md         # GitHub integration
│   │   ├── IMAC_SETUP.md           # iMac deployment guide
│   │   ├── PUSH_TO_GITHUB.md       # Git workflow
│   │   └── DEPLOYMENT_OPTIONS.md   # Deployment strategies
│   │
│   ├── Safety/                      # Security & Privacy
│   │   └── CAMPUS_LAB_SAFETY.md    # Campus computer safety guide
│   │
│   └── Scripts/                     # Automation Scripts
│       └── setup-github.bat         # Windows Git setup script
│
├── .github/                         # GitHub Configuration
│   └── ISSUE_TEMPLATE/
│       ├── bug_report.md
│       └── feature_request.md
│
├── AccountabilityLock.xcodeproj/    # Xcode Project File
├── Package.swift                    # Swift Package Manager
│
├── .gitignore                       # Git ignore rules
├── LICENSE                          # MIT License
├── CONTRIBUTING.md                  # Contribution guidelines
├── README.md                        # Project overview
└── PROJECT_STRUCTURE.md             # This file
```

## 🎯 Key Folders Explained

### AccountabilityLock/
The main application source code following MVVM architecture:
- **Models**: Data structures that represent app entities
- **Views**: SwiftUI user interface components
- **ViewModels**: Business logic that connects Views and Services
- **Services**: Core functionality (Firebase, Notifications, Biometrics)
- **Utils**: Helper functions, extensions, and constants

### Tests/
Comprehensive test suite with 64+ test cases covering:
- Authentication flows
- App blocking logic
- Access request workflows
- Edge cases and error handling

### Documentation/
All project documentation organized by purpose:
- **Guides**: Step-by-step instructions for setup, testing, and deployment
- **Safety**: Privacy and security considerations
- **Scripts**: Automation tools for development workflow

### .github/
GitHub-specific configuration:
- Issue templates for bug reports and feature requests
- Future: CI/CD workflows, pull request templates

## 🚀 Quick Navigation

### Getting Started
1. Read [README.md](README.md) for project overview
2. Follow [Documentation/Guides/SETUP_GUIDE.md](Documentation/Guides/SETUP_GUIDE.md) for setup
3. Review [Documentation/Guides/IMAC_SETUP.md](Documentation/Guides/IMAC_SETUP.md) for Mac deployment

### Development
- Source code: `AccountabilityLock/`
- Tests: `Tests/`
- Package dependencies: `Package.swift`

### Documentation
- All guides: `Documentation/Guides/`
- Safety info: `Documentation/Safety/`
- Scripts: `Documentation/Scripts/`

### Contributing
1. Read [CONTRIBUTING.md](CONTRIBUTING.md)
2. Check [LICENSE](LICENSE)
3. Use GitHub issue templates in `.github/`

## 📝 File Naming Conventions

- **Swift Files**: PascalCase (e.g., `HomeView.swift`, `AuthViewModel.swift`)
- **Documentation**: SCREAMING_SNAKE_CASE (e.g., `SETUP_GUIDE.md`, `README.md`)
- **Folders**: PascalCase for code, lowercase for config (e.g., `Models/`, `.github/`)

## 🔧 Architecture Pattern

This project follows **MVVM (Model-View-ViewModel)** architecture:

```
View ←→ ViewModel ←→ Service ←→ Model
```

- **Views**: SwiftUI components (user interface)
- **ViewModels**: @Published properties and business logic
- **Services**: Firebase, notifications, biometric authentication
- **Models**: Data structures with Codable/Identifiable conformance

## 📦 Dependencies

Managed via Swift Package Manager (`Package.swift`):
- **Firebase SDK**: Authentication, Firestore, Cloud Messaging
- **LocalAuthentication**: Face ID / Touch ID
- **FamilyControls**: Screen Time API for app blocking

## 🎓 Learning Path

1. **Beginner**: Start with `Models/` to understand data structures
2. **Intermediate**: Explore `Views/` to see SwiftUI components
3. **Advanced**: Study `ViewModels/` and `Services/` for business logic
4. **Expert**: Review `Tests/` to understand test coverage

## 📚 Additional Resources

- [Apple Developer Documentation](https://developer.apple.com/documentation/)
- [SwiftUI Tutorials](https://developer.apple.com/tutorials/swiftui)
- [Firebase iOS Documentation](https://firebase.google.com/docs/ios/setup)
- [Screen Time API Guide](https://developer.apple.com/documentation/familycontrols)

---

**Last Updated**: January 17, 2026  
**Version**: 1.0.0  
**Maintainer**: [@singhvish1](https://github.com/singhvish1)
