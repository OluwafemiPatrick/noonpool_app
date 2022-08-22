import 'dart:convert';

import 'user_details.dart';

class LoginDetails {
  String? status;
  UserDetails? userDetails;

  LoginDetails({this.status, this.userDetails});

  @override
  String toString() {
    return 'LoginDetails(status: $status, userDetails: $userDetails)';
  }

  factory LoginDetails.fromMap(Map<String, dynamic> data) => LoginDetails(
        status: data['status'] as String?,
        userDetails: data['user_details'] == null
            ? null
            : UserDetails.fromMap(data['user_details'] as Map<String, dynamic>),
      );

  Map<String, dynamic> toMap() => {
        'status': status,
        'user_details': userDetails?.toMap(),
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [LoginDetails].
  factory LoginDetails.fromJson(String data) {
    return LoginDetails.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [LoginDetails] to a JSON string.
  String toJson() => json.encode(toMap());
}
