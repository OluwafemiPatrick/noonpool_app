class CoinModel {
  final String imageLocation;
  final String coin;
  final String algorithm;
  final String poolHashRate;
  final String networkHashRate;

  CoinModel(
      {required this.imageLocation,
      required this.coin,
      required this.algorithm,
      required this.poolHashRate,
      required this.networkHashRate});
}

final dummyCoinModel = [
  CoinModel(
      imageLocation: 'assets/coins/btc.svg',
      coin: 'BTC',
      algorithm: 'sha254d',
      poolHashRate: '45.43EH/s',
      networkHashRate: '187.88EH/s'),
  CoinModel(
      imageLocation: 'assets/coins/bch.svg',
      coin: 'BCH',
      algorithm: 'sha2544d',
      poolHashRate: '11.12EH/s',
      networkHashRate: '105.76EH/s'),
  CoinModel(
      imageLocation: 'assets/coins/ltc.svg',
      coin: 'LTE',
      algorithm: 'sha434d',
      poolHashRate: '13.11EH/s',
      networkHashRate: '219.5EH/s'),
  CoinModel(
      imageLocation: 'assets/coins/eth.svg',
      coin: 'ETC',
      algorithm: 'sgh554d',
      poolHashRate: '17.14EH/s',
      networkHashRate: '357.76EH/s'),
  CoinModel(
      imageLocation: 'assets/coins/dcr.svg',
      coin: 'DCR',
      algorithm: 'shr344d',
      poolHashRate: '16.52EH/s',
      networkHashRate: '749.66EH/s'),
  CoinModel(
      imageLocation: 'assets/coins/btc.svg',
      coin: 'BTC',
      algorithm: 'sha254d',
      poolHashRate: '45.43EH/s',
      networkHashRate: '187.88EH/s'),
  CoinModel(
      imageLocation: 'assets/coins/bch.svg',
      coin: 'BCH',
      algorithm: 'sha2544d',
      poolHashRate: '11.12EH/s',
      networkHashRate: '105.76EH/s'),
  CoinModel(
      imageLocation: 'assets/coins/ltc.svg',
      coin: 'LTE',
      algorithm: 'sha434d',
      poolHashRate: '13.11EH/s',
      networkHashRate: '219.5EH/s'),
  CoinModel(
      imageLocation: 'assets/coins/eth.svg',
      coin: 'ETC',
      algorithm: 'sgh554d',
      poolHashRate: '17.14EH/s',
      networkHashRate: '357.76EH/s'),
  CoinModel(
      imageLocation: 'assets/coins/dcr.svg',
      coin: 'DCR',
      algorithm: 'shr344d',
      poolHashRate: '16.52EH/s',
      networkHashRate: '749.66EH/s'),
];
