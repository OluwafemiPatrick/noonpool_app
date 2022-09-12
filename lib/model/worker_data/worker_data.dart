import 'dart:convert';

import 'package:collection/collection.dart';

import 'data.dart';

class WorkerData {
  Data? data;

  WorkerData({this.data});

  @override
  String toString() => 'WorkerData(data: $data)';

  factory WorkerData.fromMap(Map<String, dynamic> data) => WorkerData(
        data: data['data'] == null
            ? null
            : Data.fromMap(data['data'] as Map<String, dynamic>),
      );

  Map<String, dynamic> toMap() => {
        'data': data?.toMap(),
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [WorkerData].
  factory WorkerData.fromJson(String data) {
    return WorkerData.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [WorkerData] to a JSON string.
  String toJson() => json.encode(toMap());

  WorkerData copyWith({
    Data? data,
  }) {
    return WorkerData(
      data: data ?? this.data,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    if (other is! WorkerData) return false;
    final mapEquals = const DeepCollectionEquality().equals;
    return mapEquals(other.toMap(), toMap());
  }

  @override
  int get hashCode => data.hashCode;

}
