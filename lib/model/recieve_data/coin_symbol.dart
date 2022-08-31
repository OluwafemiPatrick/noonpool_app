import 'dart:convert';

class CoinInfo {
  String? address;
  String? name;

  CoinInfo({this.address, this.name});

  factory CoinInfo.fromMap(Map<String, dynamic> data) => CoinInfo(
        address: data['address'] as String?,
        name: data['name'] as String?,
      );

  Map<String, dynamic> toMap() => {
        'address': address,
        'name': name,
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [CoinInfo].
  factory CoinInfo.fromJson(String data) {
    return CoinInfo.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [CoinInfo] to a JSON string.
  String toJson() => json.encode(toMap());
}
