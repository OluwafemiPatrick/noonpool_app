import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:noonpool/helpers/shared_preference_util.dart';
import 'package:noonpool/main.dart';
import 'package:noonpool/helpers/network_helper.dart';
import 'package:noonpool/presentation/pool/widget/pool_statistics_title.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../helpers/constants.dart';
import '../../helpers/svg_image.dart';

class PoolTab extends StatefulWidget {
  const PoolTab({Key? key}) : super(key: key);

  @override
  _PoolTabState createState() => _PoolTabState();
}

class _PoolTabState extends State<PoolTab> {
  final StreamController<int> _poolStatisticsStream = StreamController();
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  List<String> _poolStatisticsTitles(BuildContext context) => [
        AppLocalizations.of(context)!.general,
        AppLocalizations.of(context)!.midEast
      ];

  String _username = '';
  List workerData = [];
  String coin = 'LTC';
  String port1 = '3055', port2 = '3056';
  String miningAdd = 'litecoin.noonpool.com:3055';
  String stratumUrl = 'stratum+tcp://litecoin.noonpool.com:3056';
  String ltcUrl =
      'http://litecoin.noonpool.com:6050/api/v1/Pool-Litecoin-Dogecoin';
  String btcUrl = '';
  String bchUrl = '';
  String dogeUrl =
      'http://litecoin.noonpool.com:6050/api/v1/Pool-Litecoin-Dogecoin';

  @override
  void initState() {
    getUsername();
    super.initState();
  }

  void _onRefresh() async {
    await Future.delayed(Duration.zero, getUsername).then((value) {
      _refreshController.refreshCompleted();
    });
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final bodyText1 = textTheme.bodyText1!;
    final bodyText2 = textTheme.bodyText2!;
    const spacer = SizedBox(
      height: kDefaultMargin,
    );
    return Scaffold(
      appBar: buildAppBar(bodyText1, bodyText2),
      body: SmartRefresher(
        enablePullDown: true,
        header: const WaterDropHeader(waterDropColor: kPrimaryColor),
        controller: _refreshController,
        onRefresh: _onRefresh,
        child: SingleChildScrollView(
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              buildStatisticsItem(),
              spacer,
              ...buildBtcMiningAddress(bodyText2),
              spacer,
              ...buildSmartMiningUrl(bodyText2),
              spacer,
              buildExtraNote(bodyText2),
              spacer,
              Padding(
                child: Text(
                  'Mining Profit -> ',
                  style: bodyText1,
                ),
                padding: const EdgeInsets.only(
                    left: kDefaultMargin, right: kDefaultMargin),
              ),
              const SizedBox(height: 10.0),
              buildMiningProfitData(bodyText2, spacer),
              spacer,
              Padding(
                child: Text(
                  'Hashrate Trend -> ',
                  style: bodyText1,
                ),
                padding: const EdgeInsets.only(
                    left: kDefaultMargin, right: kDefaultMargin),
              ),
              const SizedBox(height: 10.0),
              buildHashrateTrend(bodyText2, spacer),
              spacer,
              buildStatistics(bodyText1, _username),
              const SizedBox(height: 10.0),
              buildPoolData(bodyText2, spacer),
            ]),
          ),
        ),
      ),
    );
  }

  Container buildMiningProfitData(TextStyle bodyText2, SizedBox spacer) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
          vertical: kDefaultPadding, horizontal: kDefaultPadding / 2),
      margin: const EdgeInsets.only(
        left: kDefaultMargin / 2,
        right: kDefaultMargin / 2,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(kDefaultMargin / 2),
        color: kLightBackgroud,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("24H Profit", style: bodyText2),
          const SizedBox(
            height: kDefaultMargin / 4,
          ),
          Text(
            '0 $coin',
            style:
                bodyText2.copyWith(fontSize: 15, fontWeight: FontWeight.w500),
          ),
          spacer,
          Text(
            "Cummulative Earnings",
            style: bodyText2,
          ),
          const SizedBox(
            height: kDefaultMargin / 4,
          ),
          Text(
            '0 $coin',
            style:
                bodyText2.copyWith(fontSize: 15, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  Container buildHashrateTrend(TextStyle bodyText2, SizedBox spacer) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
          vertical: kDefaultPadding, horizontal: kDefaultPadding),
      margin: const EdgeInsets.only(
        left: kDefaultMargin / 2,
        right: kDefaultMargin / 2,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(kDefaultMargin / 2),
        color: kLightBackgroud,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.max,
        children: [
          Column(
            children: [
              Text("10 Min", style: bodyText2),
              const SizedBox(
                height: kDefaultMargin / 4,
              ),
              Text(
                '0 H/s',
                style: bodyText2.copyWith(
                    fontSize: 15, fontWeight: FontWeight.w500),
              ),
            ],
          ),
          Column(
            children: [
              Text("1 hour", style: bodyText2),
              const SizedBox(
                height: kDefaultMargin / 4,
              ),
              Text(
                '0 H/s',
                style: bodyText2.copyWith(
                    fontSize: 15, fontWeight: FontWeight.w500),
              ),
            ],
          ),
          Column(
            children: [
              Text(
                "1 Day",
                style: bodyText2,
              ),
              const SizedBox(
                height: kDefaultMargin / 4,
              ),
              Text(
                '0 H/s',
                style: bodyText2.copyWith(
                    fontSize: 15, fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ],
      ),
    );
  }

  AppBar buildAppBar(TextStyle? bodyText1, TextStyle bodyText2) {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.transparent,
      title: Text(
        AppLocalizations.of(context)!.pool,
        style: bodyText1,
      ),
      actions: [
        Container(
          alignment: Alignment.center,
          child: Container(
            padding: const EdgeInsets.all(kDefaultMargin / 4),
            decoration: BoxDecoration(
              color: kLightBackgroud,
              borderRadius: BorderRadius.circular(kDefaultMargin / 2),
            ),
            child: Row(children: [
              const SizedBox(width: kDefaultMargin),
              Text(coin, style: bodyText2),
              dropDown(bodyText2),
            ]),
          ),
        ),
        const SizedBox(
          width: kDefaultMargin / 2,
        )
      ],
    );
  }

  Widget dropDown(TextStyle bodyText2) {
    List<String> _coinList = ['LTC', 'BTC', 'DOGE', 'BCH'];
    String? _selected;
    return SizedBox(
      height: 30,
      child: DropdownButton<String>(
        underline: Container(),
        itemHeight: null,
        value: _selected,
        icon: const Icon(
          Icons.arrow_drop_down_sharp,
          color: kPrimaryColor,
        ),
        items: _coinList.map((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(
              value,
              style: bodyText2,
            ),
          );
        }).toList(),
        onChanged: (newValue) {
          _selected = newValue.toString();
          if (_selected == 'LTC') {
            setState(() {
              workerData = [];
              coin = _selected!;
              port1 = '3055';
              port2 = '3056';
              miningAdd = 'litecoin.noonpool.com:3055';
              stratumUrl = 'stratum+tcp://litecoin.noonpool.com:3055';
            });
            initState();
          }
          if (_selected == 'BTC') {
            setState(() {
              workerData = [];
              coin = _selected!;
              port1 = '0';
              port2 = '0';
              miningAdd = AppLocalizations.of(context)!.coinNotAvailable;
              stratumUrl = AppLocalizations.of(context)!.coinNotAvailable;
            });
            initState();
          }
          if (_selected == 'DOGE') {
            setState(() {
              workerData = [];
              coin = _selected!;
              port1 = '3055';
              port2 = '3056';
              miningAdd = 'litecoin.noonpool.com:3055';
              stratumUrl = 'stratum+tcp://litecoin.noonpool.com:3055';
            });
            initState();
          }
          if (_selected == 'BCH') {
            setState(() {
              workerData = [];
              coin = _selected!;
              port1 = '0';
              port2 = '0';
              miningAdd = AppLocalizations.of(context)!.coinNotAvailable;
              stratumUrl = AppLocalizations.of(context)!.coinNotAvailable;
            });
            initState();
          }
        },
      ),
    );
  }

  void onPoolStatisticsTitleClicked(int position) {
    _poolStatisticsStream.add(position);
    //todo work on changing data
  }

  Padding buildStatisticsItem() {
    return Padding(
      child: PoolStatisticsTitle(
          titles: _poolStatisticsTitles(context),
          onTitleClicked: onPoolStatisticsTitleClicked,
          positionStream: _poolStatisticsStream.stream),
      padding:
          const EdgeInsets.only(left: kDefaultMargin, right: kDefaultMargin),
    );
  }

  List<Widget> buildBtcMiningAddress(TextStyle bodyText2) {
    return [
      Padding(
        child: Text(
          '$coin ${AppLocalizations.of(context)!.miningAddress}',
          style: bodyText2.copyWith(color: kLightText),
        ),
        padding:
            const EdgeInsets.only(left: kDefaultMargin, right: kDefaultMargin),
      ),
      const SizedBox(height: kDefaultMargin / 4),
      Padding(
        child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  miningAdd,
                  style: bodyText2.copyWith(fontSize: 14),
                ),
              ),
              GestureDetector(
                child: const Icon(
                  Icons.copy_rounded,
                  color: kPrimaryColor,
                ),
                onTap: () {
                  Clipboard.setData(ClipboardData(text: miningAdd)).then((_) {
                    MyApp.scaffoldMessengerKey.currentState?.showSnackBar(
                        SnackBar(
                            content: Text(AppLocalizations.of(context)!
                                .addressCopiedToClipboard)));
                  });
                },
              ),
            ]),
        padding:
            const EdgeInsets.only(left: kDefaultMargin, right: kDefaultMargin),
      ),
    ];
  }

  List<Widget> buildSmartMiningUrl(TextStyle bodyText2) {
    return [
      Padding(
        child: Text(
          AppLocalizations.of(context)!.smartMintingUrl,
          style: bodyText2.copyWith(color: kLightText),
        ),
        padding:
            const EdgeInsets.only(left: kDefaultMargin, right: kDefaultMargin),
      ),
      const SizedBox(
        height: kDefaultMargin / 4,
      ),
      Padding(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                stratumUrl,
                style: bodyText2.copyWith(fontSize: 14),
              ),
            ),
            GestureDetector(
              child: const Icon(
                Icons.copy_rounded,
                color: kPrimaryColor,
              ),
              onTap: () {
                Clipboard.setData(ClipboardData(text: stratumUrl)).then((_) {
                  MyApp.scaffoldMessengerKey.currentState?.showSnackBar(
                      SnackBar(
                          content: Text(AppLocalizations.of(context)!
                              .addressCopiedToClipboard)));
                });
              },
            ),
          ],
        ),
        padding:
            const EdgeInsets.only(left: kDefaultMargin, right: kDefaultMargin),
      ),
    ];
  }

  Padding buildExtraNote(TextStyle bodyText2) {
    return Padding(
      child: Text(
        'Note. Port $port2 is also available.',
        style: bodyText2.copyWith(color: kLightText),
      ),
      padding:
          const EdgeInsets.only(left: kDefaultMargin, right: kDefaultMargin),
    );
  }

  Padding buildStatistics(TextStyle bodyText1, String workerName) {
    return Padding(
      child: Text(
        'Statistics -> $workerName',
        style: bodyText1,
      ),
      padding:
          const EdgeInsets.only(left: kDefaultMargin, right: kDefaultMargin),
    );
  }

  Container buildPoolData(TextStyle bodyText2, SizedBox spacer) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: kDefaultPadding),
      margin: const EdgeInsets.only(
          left: kDefaultMargin / 2, right: kDefaultMargin / 2, bottom: 10.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(kDefaultMargin / 2),
        color: kLightBackgroud,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.max,
              children: [
                Column(
                  children: [
                    Text(AppLocalizations.of(context)!.allMiners,
                        style: bodyText2),
                    const SizedBox(
                      height: kDefaultMargin / 4,
                    ),
                    Text(
                      workerData.isNotEmpty
                          ? workerData.length.toString()
                          : '0',
                      style: bodyText2.copyWith(
                          fontSize: 15, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
                Column(
                  children: [
                    Text(AppLocalizations.of(context)!.paidEarnings,
                        style: bodyText2),
                    const SizedBox(
                      height: kDefaultMargin / 4,
                    ),
                    Text(
                      workerData.isNotEmpty
                          ? workerData[0]['paidEarning']
                          : '0',
                      style: bodyText2.copyWith(
                          fontSize: 15, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
                Column(
                  children: [
                    Text(
                      AppLocalizations.of(context)!.unpaidEarnings,
                      style: bodyText2,
                    ),
                    const SizedBox(
                      height: kDefaultMargin / 4,
                    ),
                    Text(
                      workerData.isNotEmpty
                          ? workerData[0]['unpaidEarning']
                          : '0',
                      style: bodyText2.copyWith(
                          fontSize: 15, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ],
            ),
          ),
          spacer,
          Container(
            width: MediaQuery.of(context).size.width,
            decoration: const BoxDecoration(
              color: Colors.white,
            ),
            padding: const EdgeInsets.symmetric(
                vertical: kDefaultMargin / 2, horizontal: kDefaultMargin / 2),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    AppLocalizations.of(context)!.workerid,
                    style: bodyText2,
                  ),
                ),
                Expanded(
                  child: Text(
                    AppLocalizations.of(context)!.hashrate,
                    style: bodyText2,
                    textAlign: TextAlign.center,
                  ),
                ),
                Expanded(
                  child: Text(
                    AppLocalizations.of(context)!.validShares,
                    style: bodyText2,
                    textAlign: TextAlign.center,
                  ),
                ),
                Expanded(
                  child: Text(
                    AppLocalizations.of(context)!.invalidShares,
                    style: bodyText2,
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12.0),
          if (workerData.isNotEmpty)
            ListView.builder(
              itemCount: workerData.length,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (_, index) {
                return displayWorkerData(
                  workerData[index]['workerId'],
                  workerData[index]['hashrate'],
                  workerData[index]['sharesValid'],
                  workerData[index]['sharesInvalid'],
                );
              },
            )
          else
            noWorkerData(bodyText2)
        ],
      ),
    );
  }

  Widget displayWorkerData(
      String workerId, hashrate, sharesValid, sharesInvalid) {
    final textTheme = Theme.of(context).textTheme;
    final bodyText2 = textTheme.bodyText2!;
    String _workerId, _hashrate;

    // format worker_id into proper name
    var split = workerId.split('.');
    if (split.length == 2) {
      var s1 = split[1];
      _workerId = s1;
    } else if (split.length == 3) {
      var s1 = split[1];
      var s2 = split[2];
      _workerId = "$s1.$s2";
    } else {
      _workerId = workerId;
    }

    // remove decimal figures from hashrate
    var rate = double.parse(hashrate);
    _hashrate = rate.toStringAsFixed(0);

    return Container(
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.symmetric(horizontal: kDefaultMargin / 2),
      margin: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        children: [
          Expanded(
            child: Text(
              _workerId,
              style: bodyText2,
            ),
          ),
          Expanded(
            child: Text(
              _hashrate,
              style: bodyText2,
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            child: Text(
              sharesValid == 'null' ? '0' : sharesValid,
              style: bodyText2,
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            child: Text(
              sharesInvalid == 'null' ? '0' : sharesInvalid,
              style: bodyText2,
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  Widget noWorkerData(TextStyle bodyText2) {
    return SizedBox(
      height: 250.0,
      child: Column(
        children: [
          const Spacer(),
          const SvgImage(
            iconLocation: 'assets/icons/no_worker_data.svg',
            name: 'no worker data',
            color: kPrimaryColor,
            size: 100,
          ),
          const SizedBox(
            height: kDefaultMargin / 2,
          ),
          Text(
            AppLocalizations.of(context)!.noWorkerData,
            style: bodyText2,
          ),
          const Spacer(),
        ],
      ),
    );
  }

  getUsername() async {
    String? name = AppPreferences.userName;

    String? poolUrl;
    if (coin == 'LTC') {
      setState(() => poolUrl = ltcUrl);
    }
    if (coin == 'BTC') {
      setState(() => poolUrl = btcUrl);
    }
    if (coin == 'BCH') {
      setState(() => poolUrl = bchUrl);
    }
    if (coin == 'DOGE') {
      setState(() => poolUrl = dogeUrl);
    }

    List result = await fetchWorkerData(name, poolUrl);

    setState(() {
      _username = name;
      workerData = result;
    });
  }
}
