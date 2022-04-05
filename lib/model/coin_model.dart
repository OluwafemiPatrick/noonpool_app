class CoinModel {
  final String imageLocation;
  final String coin;
  final String coinName;
  final String algorithm;
  final String poolHashRate;
  final String networkHashRate;
  final String profit;
  final String price;
  final int id;

  CoinModel(
      {required this.imageLocation,
      required this.coin,
      required this.coinName,
      required this.id,
      required this.algorithm,
      required this.poolHashRate,
      required this.profit,
      required this.price,
      required this.networkHashRate});
}
