class CoinModel {
  final String imageLocation;
  final String coin;
  final String coinSubTitle;
  final String algorithm;
  final double poolHashRate;
  final double networkHashRate;
  final double profit;
  final double price;
  final int id;

  CoinModel(
      {required this.imageLocation,
      required this.coin,
      required this.coinSubTitle,
      required this.id,
      required this.algorithm,
      required this.poolHashRate,
      required this.profit,
      required this.price,
      required this.networkHashRate});
}
