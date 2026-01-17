import 'package:flutter/material.dart';

/// App-wide constants and configuration
class AppColors {
  static const Color primary = Color(0xFF007AFF);
  static const Color secondary = Color(0xFF5AC8FA);
  static const Color success = Color(0xFF34C759);
  static const Color warning = Color(0xFFFF9500);
  static const Color error = Color(0xFFFF3B30);
  static const Color background = Color(0xFFF2F2F7);
  static const Color cardBackground = Colors.white;
}

class AppConstants {
  static const String appName = 'Accountability App';
  static const int temporaryAccessDuration = 5; // minutes
  static const int minPasswordLength = 8;
  static const int pinLength = 6;
}

class FirestoreCollections {
  static const String users = 'users';
  static const String partners = 'accountability_partners';
  static const String blockedApps = 'blocked_apps';
  static const String accessRequests = 'access_requests';
}
