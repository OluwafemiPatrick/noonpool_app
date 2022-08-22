import 'dart:convert';

class WalletDatum {
  double? balance;
  String? coinName;
  String? coinSymbol;
  double? frozen;
  String? imageUrl;
  double? usdPrice;

  WalletDatum({
    this.balance,
    this.coinName,
    this.coinSymbol,
    this.frozen,
    this.imageUrl,
    this.usdPrice,
  });

  @override
  String toString() {
    return 'Datum(balance: $balance, coinName: $coinName, coinSymbol: $coinSymbol, frozen: $frozen, imageUrl: $imageUrl, usdPrice: $usdPrice)';
  }

  factory WalletDatum.fromMap(Map<String, dynamic> data) => WalletDatum(
        balance: (data['balance'] as num?)?.toDouble(),
        coinName: data['coin_name'] as String?,
        coinSymbol: data['coin_symbol'] as String?,
        frozen: (data['frozen'] as num?)?.toDouble(),
        imageUrl: data['image_url'] as String?,
        usdPrice: (data['usd_price'] as num?)?.toDouble(),
      );

  Map<String, dynamic> toMap() => {
        'balance': balance,
        'coin_name': coinName,
        'coin_symbol': coinSymbol,
        'frozen': frozen,
        'image_url': imageUrl,
        'usd_price': usdPrice,
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [WalletDatum].
  factory WalletDatum.fromJson(String data) {
    return WalletDatum.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [WalletDatum] to a JSON string.
  String toJson() => json.encode(toMap());

  WalletDatum copyWith({
    double? balance,
    String? coinName,
    String? coinSymbol,
    double? frozen,
    String? imageUrl,
    double? usdPrice,
  }) {
    return WalletDatum(
      balance: balance ?? this.balance,
      coinName: coinName ?? this.coinName,
      coinSymbol: coinSymbol ?? this.coinSymbol,
      frozen: frozen ?? this.frozen,
      imageUrl: imageUrl ?? this.imageUrl,
      usdPrice: usdPrice ?? this.usdPrice,
    );
  }
}
