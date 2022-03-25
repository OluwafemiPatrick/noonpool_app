class CoinModel {
  final String imageLocation;
  final String coin;
  final String algorithm;
  final String poolHashRate;
  final String networkHashRate;
  final String profit;
  final String price;

  CoinModel(
      {required this.imageLocation,
      required this.coin,
      required this.algorithm,
      required this.poolHashRate,
      required this.profit,
      required this.price,
      required this.networkHashRate});
}

final dummyCoinModel = [
  CoinModel(
      imageLocation: 'assets/coins/btc.svg',
      coin: 'BTC',
      algorithm: 'sha254d',
      poolHashRate: '45.43EH/s',
      profit: '\$ 0.364/T',
      price: '62024.17 USD',
      networkHashRate: '187.88EH/s'),
  CoinModel(
      imageLocation: 'assets/coins/bch.svg',
      coin: 'BCH',
      algorithm: 'sha2544d',
      profit: '\$ 0.364/T',
      price: '62024.17 USD',
      poolHashRate: '11.12EH/s',
      networkHashRate: '105.76EH/s'),
  CoinModel(
      imageLocation: 'assets/coins/ltc.svg',
      coin: 'LTE',
      profit: '\$ 0.364/T',
      price: '62024.17 USD',
      algorithm: 'sha434d',
      poolHashRate: '13.11EH/s',
      networkHashRate: '219.5EH/s'),
  CoinModel(
      imageLocation: 'assets/coins/etc.svg',
      coin: 'ETC',
      profit: '\$ 0.364/T',
      price: '62024.17 USD',
      algorithm: 'sgh554d',
      poolHashRate: '17.14EH/s',
      networkHashRate: '357.76EH/s'),
  CoinModel(
      imageLocation: 'assets/coins/dcr.svg',
      coin: 'DCR',
      profit: '\$ 0.364/T',
      price: '62024.17 USD',
      algorithm: 'shr344d',
      poolHashRate: '16.52EH/s',
      networkHashRate: '749.66EH/s'),
  CoinModel(
      imageLocation: 'assets/coins/zec.svg',
      coin: 'ZEC',
      profit: '\$ 0.364/T',
      price: '62024.17 USD',
      algorithm: 'shr344d',
      poolHashRate: '16.52EH/s',
      networkHashRate: '749.66EH/s'),
  CoinModel(
      imageLocation: 'assets/coins/eth.svg',
      coin: 'ETH',
      profit: '\$ 0.364/T',
      price: '62024.17 USD',
      algorithm: 'shr344d',
      poolHashRate: '16.52EH/s',
      networkHashRate: '749.66EH/s'),
  CoinModel(
      imageLocation: 'assets/coins/dash.svg',
      coin: 'DASH',
      profit: '\$ 0.364/T',
      price: '62024.17 USD',
      algorithm: 'shr344d',
      poolHashRate: '16.52EH/s',
      networkHashRate: '749.66EH/s'),
  CoinModel(
      imageLocation: 'assets/coins/lbc.svg',
      coin: 'LBC',
      profit: '\$ 0.364/T',
      price: '62024.17 USD',
      algorithm: 'shr344d',
      poolHashRate: '16.52EH/s',
      networkHashRate: '749.66EH/s'),
  CoinModel(
      imageLocation: 'assets/coins/hns.svg',
      coin: 'HNS',
      profit: '\$ 0.364/T',
      price: '62024.17 USD',
      algorithm: 'shr344d',
      poolHashRate: '16.52EH/s',
      networkHashRate: '749.66EH/s'),
  CoinModel(
      imageLocation: 'assets/coins/zen.svg',
      coin: 'ZEN',
      profit: '\$ 0.364/T',
      price: '62024.17 USD',
      algorithm: 'shr344d',
      poolHashRate: '16.52EH/s',
      networkHashRate: '749.66EH/s'),
];
