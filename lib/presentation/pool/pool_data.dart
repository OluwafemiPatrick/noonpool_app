import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:noonpool/helpers/network_helper.dart';
import 'package:noonpool/presentation/pool/widget/pool_statistics_title.dart';
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
  final List<String> _poolStatisticsTitles = ['General', 'Mid-East'];

  String _username = '';
  List workerData = [];

  @override
  void initState() {
    getUsername();
    super.initState();
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
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildStatisticsItem(),
            spacer,
            ...buildBtcMiningAddress(bodyText2),
            spacer,
            ...buildSmartMiningUrl(bodyText2),
            spacer,
            buildExtraNote(bodyText2),
            spacer,
            buildStatistics(bodyText2, _username),
            const SizedBox(height: 10.0,),
            Expanded(child: buildPoolData(bodyText2, spacer)),
          ]),
      ),
    );
  }


  AppBar buildAppBar(TextStyle? bodyText1, TextStyle bodyText2) {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.transparent,
      title: Text(
        'Pool',
        style: bodyText1,
      ),
      actions: [
        Center(
          child: Container(
            padding: const EdgeInsets.all(kDefaultMargin / 4),
            decoration: BoxDecoration(
                color: kLightBackgroud,
                borderRadius: BorderRadius.circular(kDefaultMargin)),
            child: Row(
              children: [
                const SizedBox(
                  width: kDefaultMargin,
                ),
                Text(
                  'BTC',
                  style: bodyText2,
                ),
                const Icon(
                  Icons.arrow_drop_down,
                  color: kTextColor,
                )
              ]),
          ),
        ),
        const SizedBox(
          width: kDefaultMargin / 2,
        )
      ],
    );
  }


  void onPoolStatisticsTitleClicked(int position) {
    _poolStatisticsStream.add(position);
    //todo work on changing data
  }

  Padding buildStatisticsItem() {
    return Padding(
      child: PoolStatisticsTitle(
          titles: _poolStatisticsTitles,
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
          'BTC Mining Address',
          style: bodyText2.copyWith(color: kLightText),
        ),
        padding: const EdgeInsets.only(left: kDefaultMargin, right: kDefaultMargin),
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
                  'bitcoin.noonpool.com:3004',
                  style: bodyText2.copyWith(fontSize: 14),
                ),
              ),
              GestureDetector(
                child: const Icon(
                  Icons.copy_rounded,
                  color: kPrimaryColor,
                ),
                onTap: () {
                  Clipboard.setData(const ClipboardData(
                      text: 'bitcoin.noonpool.com:3004')).then((_) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text("address copied to clipboard")));
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
          'Smart Minting URL',
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
                'stratum+tcp://bitcoin.noonpool.com:3004',
                style: bodyText2.copyWith(fontSize: 14),
              ),
            ),
            GestureDetector(
              child: const Icon(
                Icons.copy_rounded,
                color: kPrimaryColor,
              ),
              onTap: () {
                Clipboard.setData(const ClipboardData(
                    text: 'stratum+tcp://bitcoin.noonpool.com:3004')).then((_) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text("address copied to clipboard")));
                });
              },
            ),
          ],
        ),
        padding: const EdgeInsets.only(left: kDefaultMargin, right: kDefaultMargin),
      ),
    ];
  }

  Padding buildExtraNote(TextStyle bodyText2) {
    return Padding(
      child: Text(
        'Note. Ports 3003 is also available.',
        style: bodyText2.copyWith(color: kLightText),
      ),
      padding: const EdgeInsets.only(left: kDefaultMargin, right: kDefaultMargin),
    );
  }

  Padding buildStatistics(TextStyle bodyText2, String workerName) {
    return Padding(
      child: Text(
        'Statistics -> $workerName',
        style: bodyText2.copyWith(fontSize: 18),
      ),
      padding: const EdgeInsets.only(left: kDefaultMargin, right: kDefaultMargin),
    );
  }

  Container buildPoolData(TextStyle bodyText2, SizedBox spacer) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: kDefaultPadding),
      margin: const EdgeInsets.only(left: kDefaultMargin / 2, right: kDefaultMargin / 2, bottom: 10.0),
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
                    Text(
                      'All miners',
                      style: bodyText2.copyWith(
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(
                      height: kDefaultMargin / 4,
                    ),
                    Text(
                      workerData.isNotEmpty ? workerData.length.toString() : '0',
                      style: bodyText2.copyWith(
                          fontSize: 15, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
                Column(
                  children: [
                    Text(
                      'Paid earnings',
                      style: bodyText2.copyWith(
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(
                      height: kDefaultMargin / 4,
                    ),
                    Text(
                      workerData.isNotEmpty ? workerData[0]['paidEarning'] : '0',
                      style: bodyText2.copyWith(
                          fontSize: 15, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
                Column(
                  children: [
                    Text(
                      'Unpaid earnings',
                      style: bodyText2.copyWith(
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(
                      height: kDefaultMargin / 4,
                    ),
                    Text(
                      workerData.isNotEmpty ? workerData[0]['unpaidEarning'] : '0',
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
            decoration: const BoxDecoration(color: Colors.white,),
            padding: const EdgeInsets.symmetric(vertical: kDefaultMargin / 2, horizontal: kDefaultMargin / 2),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    'WorkerID',
                    style: bodyText2,
                  ),
                ),
                Expanded(
                  child: Text(
                    'Hashrate',
                    style: bodyText2,
                    textAlign: TextAlign.center,
                  ),
                ),
                Expanded(
                  child: Text(
                    'Valid Shares',
                    style: bodyText2,
                    textAlign: TextAlign.center,
                  ),
                ),
                Expanded(
                  child: Text(
                    'Invalid Shares',
                    style: bodyText2,
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12.0),
          if (workerData.isNotEmpty) Expanded(
            child: ListView.builder(
                    itemCount: 2,
                    physics: const ScrollPhysics(),
                    itemBuilder: (_, index) {
                      return displayWorkerData(
                        workerData[index]['workerId'],
                        workerData[index]['hashrate'],
                        workerData[index]['sharesValid'],
                        workerData[index]['sharesInvalid'],
                      );
                    },
                  ),
          ) else noWorkerData(bodyText2)
        ],
      ),
    );
  }

  Widget displayWorkerData (String workerId, hashrate, sharesValid, sharesInvalid) {
    final textTheme = Theme.of(context).textTheme;
    final bodyText2 = textTheme.bodyText2!;
    String _workerId, _hashrate, _validS, _inValidS;

    // format worker_id into proper name
    var split = workerId.split('.');
    if (split.length<4 && split.length>1) {
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
            child: Text(_workerId,
              style: bodyText2,
            ),
          ),
          Expanded(
            child: Text(_hashrate,
              style: bodyText2,
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            child: Text(sharesValid=='null' ? '0' : sharesValid,
              style: bodyText2,
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            child: Text(sharesInvalid=='null' ? '0' : sharesInvalid,
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
      height: 240.0,
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
            'No worker data',
            style: bodyText2,
          ),
          const Spacer(),
        ],
      ),
    );
  }

  getUsername() async {

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? name = prefs.getString('username');

    if (name != null) {
      List result = await fetchWorkerData(name);

      setState(() {
        _username = name;
        workerData = result;
      });
    }




  }


}
