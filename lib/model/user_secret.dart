import 'dart:convert';

class UserSecret {
  bool? isSecret;
  String? secret;
  String? status;
  String? loginKey;

  UserSecret({this.isSecret, this.secret, this.status, this.loginKey});

  factory UserSecret.fromMap(Map<String, dynamic> data) => UserSecret(
        isSecret: data['isSecret'] as bool?,
        secret: data['secret'] as String?,
        loginKey: data['login_key'] as String?,
        status: data['status'] as String?,
      );

  Map<String, dynamic> toMap() => {
        'isSecret': isSecret,
        'secret': secret,
        'status': status,
        'login_key': loginKey,
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [UserSecret].
  factory UserSecret.fromJson(String data) {
    return UserSecret.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [UserSecret] to a JSON string.
  String toJson() => json.encode(toMap());
}
