# Package.swift
# Swift Package Manager dependencies

// swift-tools-version:5.9
import PackageDescription

let package = Package(
    name: "AccountabilityLock",
    platforms: [
        .iOS(.v16)
    ],
    products: [
        .library(
            name: "AccountabilityLock",
            targets: ["AccountabilityLock"])
    ],
    dependencies: [
        .package(url: "https://github.com/firebase/firebase-ios-sdk.git", from: "10.20.0")
    ],
    targets: [
        .target(
            name: "AccountabilityLock",
            dependencies: [
                .product(name: "FirebaseAuth", package: "firebase-ios-sdk"),
                .product(name: "FirebaseFirestore", package: "firebase-ios-sdk"),
                .product(name: "FirebaseMessaging", package: "firebase-ios-sdk")
            ])
    ]
)
