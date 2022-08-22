import 'dart:convert';

class CoinModel {
  int? id;
  String? algo;
  String? coinLogo;
  String? coinName;
  String? coinSymbol;
  double? difficulty;
  double? netHashrate;
  double? price;
  double? profit;
  double? reward;

  CoinModel({
    this.id,
    this.algo,
    this.coinLogo,
    this.coinName,
    this.coinSymbol,
    this.difficulty,
    this.netHashrate,
    this.price,
    this.profit,
    this.reward,
  });

  @override
  String toString() {
    return 'CoinModel(id: $id, algo: $algo, coinLogo: $coinLogo, coinName: $coinName, coinSymbol: $coinSymbol, difficulty: $difficulty, netHashrate: $netHashrate, price: $price, profit: $profit, reward: $reward)';
  }

  factory CoinModel.fromMap(Map<String, dynamic> data) => CoinModel(
        id: data['_id'] as int?,
        algo: data['algo'] as String?,
        coinLogo: data['coin_logo'] as String?,
        coinName: data['coin_name'] as String?,
        coinSymbol: data['coin_symbol'] as String?,
        difficulty: (data['difficulty'] as num?)?.toDouble(),
        netHashrate: (data['net_hashrate'] as num?)?.toDouble(),
        price: (data['price'] as num?)?.toDouble(),
        profit: (data['profit'] as num?)?.toDouble(),
        reward: (data['reward'] as num?)?.toDouble(),
      );

  Map<String, dynamic> toMap() => {
        '_id': id,
        'algo': algo,
        'coin_logo': coinLogo,
        'coin_name': coinName,
        'coin_symbol': coinSymbol,
        'difficulty': difficulty,
        'net_hashrate': netHashrate,
        'price': price,
        'profit': profit,
        'reward': reward,
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [CoinModel].
  factory CoinModel.fromJson(String data) {
    return CoinModel.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [CoinModel] to a JSON string.
  String toJson() => json.encode(toMap());

  CoinModel copyWith({
    int? id,
    String? algo,
    String? coinLogo,
    String? coinName,
    String? coinSymbol,
    double? difficulty,
    double? netHashrate,
    double? price,
    double? profit,
    double? reward,
  }) {
    return CoinModel(
      id: id ?? this.id,
      algo: algo ?? this.algo,
      coinLogo: coinLogo ?? this.coinLogo,
      coinName: coinName ?? this.coinName,
      coinSymbol: coinSymbol ?? this.coinSymbol,
      difficulty: difficulty ?? this.difficulty,
      netHashrate: netHashrate ?? this.netHashrate,
      price: price ?? this.price,
      profit: profit ?? this.profit,
      reward: reward ?? this.reward,
    );
  }
}
