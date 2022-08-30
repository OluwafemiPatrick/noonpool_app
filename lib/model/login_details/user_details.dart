import 'dart:convert';

class UserDetails {
  String? actCreationDate;
  String? email;
  String? id;
  String? username;
  String? mnemonic;
  bool? verified;

  UserDetails({
    this.actCreationDate,
    this.email,
    this.id,
    this.username,
    this.mnemonic,
    this.verified,
  });

  @override
  String toString() {
    return 'UserDetails(actCreationDate: $actCreationDate, email: $email, id: $id, username: $username, verified: $verified, mnemonic:$mnemonic)';
  }

  factory UserDetails.fromMap(Map<String, dynamic> data) => UserDetails(
        actCreationDate: data['act_creation_date'] as String?,
        email: data['email'] as String?,
        id: data['id'] as String?,
        username: data['username'] as String?,
        mnemonic: data['mnemonic'] as String?,
        verified: data['verified'] as bool?,
      );

  Map<String, dynamic> toMap() => {
        'act_creation_date': actCreationDate,
        'email': email,
        'id': id,
        'username': username,
        'mnemonic': mnemonic,
        'verified': verified,
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [UserDetails].
  factory UserDetails.fromJson(String data) {
    return UserDetails.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [UserDetails] to a JSON string.
  String toJson() => json.encode(toMap());
}
