import 'package:flutter/material.dart';
import '../models/access_request_model.dart';

class AccessRequestProvider with ChangeNotifier {
  List<AccessRequestModel> _requests = [];
  bool _isLoading = false;

  List<AccessRequestModel> get requests => _requests;
  bool get isLoading => _isLoading;
  
  List<AccessRequestModel> get pendingRequests =>
      _requests.where((r) => r.isPending).toList();

  Future<void> loadRequests() async {
    // TODO: Load from Firestore
    notifyListeners();
  }

  Future<void> createRequest(String appName, String reason) async {
    // TODO: Create in Firestore and send notification
    notifyListeners();
  }

  Future<void> approveRequest(String requestId) async {
    // TODO: Update in Firestore
    notifyListeners();
  }

  Future<void> denyRequest(String requestId) async {
    // TODO: Update in Firestore
    notifyListeners();
  }
}
