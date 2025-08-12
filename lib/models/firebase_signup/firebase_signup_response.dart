import 'user.dart';

class FirebaseSignupResponse {
  FirebaseSignupResponse({
    this.message,
    this.status,
    this.user,
  });

  factory FirebaseSignupResponse.fromJson(Map<String, dynamic> json) {
    return FirebaseSignupResponse(
      message: json['message'] as String?,
      status: json['Status'] as String?,
      user: json['user'] != null
          ? User.fromJson(json['user'] as Map<String, dynamic>)
          : null,
    );
  }

  final String? message;
  final String? status;
  final User? user;

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'Status': status,
      'user': user?.toJson(),
    };
  }

  /// Check if the response indicates success
  bool get isSuccess => status?.toUpperCase() == 'SUCCESS';

  /// Get a safe message with fallback
  String get safeMessage => message ?? 'Unknown response';

  @override
  String toString() {
    return 'FirebaseSignupResponse(message: $message, status: $status, user: $user)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is FirebaseSignupResponse &&
        other.message == message &&
        other.status == status &&
        other.user == user;
  }

  @override
  int get hashCode => Object.hash(message, status, user);
}
