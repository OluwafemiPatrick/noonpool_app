import 'dart:convert';

import 'coin_symbol.dart';

class RecieveData {
  CoinInfo? coinInfo;
  String? balance;
  String? privateKey;
  String? publicKey;
  String? status;
  String? userId;

  RecieveData({
    this.coinInfo,
    this.balance,
    this.privateKey,
    this.publicKey,
    this.status,
    this.userId,
  });

  factory RecieveData.fromMap(Map<String, dynamic> data, String coinSymol) =>
      RecieveData(
        coinInfo: data[coinSymol.toUpperCase()] == null
            ? null
            : CoinInfo.fromMap(
                data[coinSymol.toUpperCase()] as Map<String, dynamic>),
        balance: data['balance'] as String?,
        privateKey: data['private_key'] as String?,
        publicKey: data['public_key'] as String?,
        status: data['status'] as String?,
        userId: data['user_id'] as String?,
      );

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [RecieveData].
  factory RecieveData.fromJson(String data, String coinSymbol) {
    return RecieveData.fromMap(
      json.decode(data) as Map<String, dynamic>,
      coinSymbol,
    );
  }
}
