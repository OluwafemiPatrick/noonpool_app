import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:noonpool/helpers/svg_image.dart';
import 'package:noonpool/presentation/pool/widget/pool_statistics_title.dart';

import '../../helpers/constants.dart';

class PoolTab extends StatefulWidget {
  const PoolTab({Key? key}) : super(key: key);

  @override
  State<PoolTab> createState() => _PoolTabState();
}

class _PoolTabState extends State<PoolTab> {
  final StreamController<int> _poolStatisticsStream = StreamController();
  final List<String> _poolStatisticsTitles = [
    'General',
    'Nigerian',
    'Mid-East'
  ];

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final bodyText1 = textTheme.bodyText1!;
    final bodyText2 = textTheme.bodyText2!;
    const spacer = SizedBox(
      height: kDefaultMargin,
    );
    const divider = Divider();
    return Scaffold(
      body: ListView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(0),
        children: [
          buildAppBar(bodyText1, bodyText2),
          spacer,
          buildStatistics(bodyText2),
          spacer,
          buildStatisticsItem(),
          spacer,
          ...buildBtcMiningAddress(bodyText2),
          spacer,
          ...buildSmartMiningUrl(bodyText2),
          spacer,
          buildExtraNote(bodyText2),
          spacer,
          divider,
          spacer,
          buildPoolData(bodyText2, spacer),
        ],
      ),
    );
  }

  Container buildPoolData(TextStyle bodyText2, SizedBox spacer) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(kDefaultPadding),
      margin: const EdgeInsets.only(
          left: kDefaultMargin / 2, right: kDefaultMargin / 2),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(kDefaultMargin / 2),
        color: kLightBackgroud,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.max,
            children: [
              Column(
                children: [
                  Text(
                    'All',
                    style: bodyText2.copyWith(
                      fontSize: 20,
                    ),
                  ),
                  const SizedBox(
                    height: kDefaultMargin / 4,
                  ),
                  Text(
                    '0',
                    style: bodyText2.copyWith(
                        fontSize: 24, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
              Column(
                children: [
                  Text(
                    'Online',
                    style: bodyText2.copyWith(
                      fontSize: 20,
                    ),
                  ),
                  const SizedBox(
                    height: kDefaultMargin / 4,
                  ),
                  Text(
                    '0',
                    style: bodyText2.copyWith(
                        fontSize: 24, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
              Column(
                children: [
                  Text(
                    'Offline',
                    style: bodyText2.copyWith(
                      fontSize: 20,
                    ),
                  ),
                  const SizedBox(
                    height: kDefaultMargin / 4,
                  ),
                  Text(
                    '0',
                    style: bodyText2.copyWith(
                        fontSize: 24, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
              Column(
                children: [
                  Text(
                    'Inactive',
                    style: bodyText2.copyWith(
                      fontSize: 20,
                    ),
                  ),
                  const SizedBox(
                    height: kDefaultMargin / 4,
                  ),
                  Text(
                    '0',
                    style: bodyText2.copyWith(
                        fontSize: 24, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ],
          ),
          spacer,
          Container(
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(kDefaultMargin / 4)),
            padding: const EdgeInsets.all(kDefaultMargin / 2),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'WorkerID',
                  style: bodyText2,
                ),
                Text(
                  '10-Min(H/s)',
                  style: bodyText2,
                ),
                Text(
                  '1 -Day(H/s)',
                  style: bodyText2,
                ),
                Text(
                  'Reject Rate',
                  style: bodyText2,
                ),
              ],
            ),
          ),
          spacer,
          spacer,
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
          spacer,
          Text(
            'Learn how to add a miner to start mining',
            style: bodyText2.copyWith(color: kPrimaryColor),
          ),
          spacer,
          spacer,
        ],
      ),
    );
  }

  Padding buildExtraNote(TextStyle bodyText2) {
    return Padding(
      child: Text(
        'Note. Port 25/433 is available too.',
        style: bodyText2.copyWith(color: kLightText),
      ),
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
                'stratum+tcp://btc.noonpool.com:3333',
                style: bodyText2.copyWith(fontSize: 18),
              ),
            ),
            const Icon(
              Icons.copy_rounded,
              color: kPrimaryColor,
            ),
          ],
        ),
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
                'stratum+tcp://bitcoin.noonpool.com:3333',
                style: bodyText2.copyWith(fontSize: 18),
              ),
            ),
            const Icon(
              Icons.copy_rounded,
              color: kPrimaryColor,
            ),
          ],
        ),
        padding:
            const EdgeInsets.only(left: kDefaultMargin, right: kDefaultMargin),
      ),
    ];
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

  Padding buildStatistics(TextStyle bodyText2) {
    return Padding(
      child: Text(
        'Statistics',
        style: bodyText2.copyWith(fontSize: 20),
      ),
      padding:
          const EdgeInsets.only(left: kDefaultMargin, right: kDefaultMargin),
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
                SvgPicture.asset(
                  'assets/coins/btc.svg',
                  height: 25,
                  width: 25,
                ),
                const SizedBox(
                  width: kDefaultMargin / 5,
                ),
                Text(
                  'BTC',
                  style: bodyText2,
                ),
                const Icon(
                  Icons.arrow_drop_down,
                  color: kTextColor,
                )
              ],
            ),
          ),
        ),
        const SizedBox(
          width: kDefaultMargin / 2,
        )
      ],
    );
  }
}
