import 'dart:convert';

import 'datum.dart';

class WalletData {
  List<WalletDatum>? data;

  WalletData({this.data});

  @override
  String toString() => 'WalletData(data: $data)';

  factory WalletData.fromMap(Map<String, dynamic> data) => WalletData(
        data: (data['data'] as List<dynamic>?)
            ?.map((e) => WalletDatum.fromMap(e as Map<String, dynamic>))
            .toList(),
      );

  Map<String, dynamic> toMap() => {
        'data': data?.map((e) => e.toMap()).toList(),
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [WalletData].
  factory WalletData.fromJson(String data) {
    return WalletData.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [WalletData] to a JSON string.
  String toJson() => json.encode(toMap());

  WalletData copyWith({
    List<WalletDatum>? data,
  }) {
    return WalletData(
      data: data ?? this.data,
    );
  }
}
