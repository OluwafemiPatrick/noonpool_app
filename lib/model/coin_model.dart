class CoinModel {
  final String imageLocation;
  final String coin;
  final String coinSubTitle;
  final String algorithm;
  final double difficulty;
  final double networkHashRate;
  final double profit;
  final double price;
  final double reward;
  final int id;

  CoinModel(
      {required this.imageLocation,
      required this.coin,
      required this.coinSubTitle,
      required this.id,
      required this.algorithm,
      required this.difficulty,
      required this.reward,
      required this.profit,
      required this.price,
      required this.networkHashRate});
}
