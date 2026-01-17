import 'package:cloud_firestore/cloud_firestore.dart';

enum RequestStatus { pending, approved, denied, expired }

class AccessRequestModel {
  final String id;
  final String userId;
  final String partnerId;
  final String appName;
  final String reason;
  final RequestStatus status;
  final DateTime requestedAt;
  final DateTime? respondedAt;
  final DateTime? expiresAt;

  AccessRequestModel({
    required this.id,
    required this.userId,
    required this.partnerId,
    required this.appName,
    this.reason = '',
    this.status = RequestStatus.pending,
    DateTime? requestedAt,
    this.respondedAt,
    this.expiresAt,
  }) : requestedAt = requestedAt ?? DateTime.now();

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'partnerId': partnerId,
      'appName': appName,
      'reason': reason,
      'status': status.name,
      'requestedAt': Timestamp.fromDate(requestedAt),
      'respondedAt': respondedAt != null ? Timestamp.fromDate(respondedAt!) : null,
      'expiresAt': expiresAt != null ? Timestamp.fromDate(expiresAt!) : null,
    };
  }

  factory AccessRequestModel.fromMap(Map<String, dynamic> map, String documentId) {
    return AccessRequestModel(
      id: documentId,
      userId: map['userId'] ?? '',
      partnerId: map['partnerId'] ?? '',
      appName: map['appName'] ?? '',
      reason: map['reason'] ?? '',
      status: RequestStatus.values.firstWhere(
        (e) => e.name == map['status'],
        orElse: () => RequestStatus.pending,
      ),
      requestedAt: (map['requestedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      respondedAt: (map['respondedAt'] as Timestamp?)?.toDate(),
      expiresAt: (map['expiresAt'] as Timestamp?)?.toDate(),
    );
  }

  AccessRequestModel copyWith({
    RequestStatus? status,
    DateTime? respondedAt,
    DateTime? expiresAt,
  }) {
    return AccessRequestModel(
      id: id,
      userId: userId,
      partnerId: partnerId,
      appName: appName,
      reason: reason,
      status: status ?? this.status,
      requestedAt: requestedAt,
      respondedAt: respondedAt ?? this.respondedAt,
      expiresAt: expiresAt ?? this.expiresAt,
    );
  }

  bool get isExpired {
    if (expiresAt == null) return false;
    return DateTime.now().isAfter(expiresAt!);
  }

  bool get isPending => status == RequestStatus.pending;
  bool get isApproved => status == RequestStatus.approved;
  bool get isDenied => status == RequestStatus.denied;
}
