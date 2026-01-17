import 'package:flutter/material.dart';

class AppBlockingProvider with ChangeNotifier {
  List<String> _blockedApps = [];
  bool _isBlocking = false;

  List<String> get blockedApps => _blockedApps;
  bool get isBlocking => _isBlocking;

  Future<void> loadBlockedApps() async {
    // TODO: Load from Firestore
    notifyListeners();
  }

  Future<void> blockApp(String appName) async {
    _blockedApps.add(appName);
    notifyListeners();
  }

  Future<void> unblockApp(String appName) async {
    _blockedApps.remove(appName);
    notifyListeners();
  }
}
