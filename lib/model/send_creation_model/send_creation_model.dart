import 'dart:convert';

import 'message.dart';

class SendCreationModel {
  Message? message;

  SendCreationModel({this.message});

  @override
  String toString() => 'SendCreationModel(message: $message)';

  factory SendCreationModel.fromMap(Map<String, dynamic> data) {
    return SendCreationModel(
      message: data['message'] == null
          ? null
          : Message.fromMap(data['message'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toMap() => {
        'message': message?.toMap(),
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [SendCreationModel].
  factory SendCreationModel.fromJson(String data) {
    return SendCreationModel.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [SendCreationModel] to a JSON string.
  String toJson() => json.encode(toMap());

  SendCreationModel copyWith({
    Message? message,
  }) {
    return SendCreationModel(
      message: message ?? this.message,
    );
  }
}
