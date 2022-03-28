import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:noonpool/model/coin_model.dart';

import '../../helpers/constants.dart';

class CoinScreen extends StatefulWidget {
  const CoinScreen({Key? key}) : super(key: key);

  @override
  State<CoinScreen> createState() => _CoinScreenState();
}

class _CoinScreenState extends State<CoinScreen> {
  @override
  Widget build(BuildContext context) {
    final coinModel = ModalRoute.of(context)?.settings.arguments as CoinModel;
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
          buildAppBar(bodyText1, coinModel),
          spacer,
          buildHashrateTitle(bodyText2),
          spacer,
          buildFirstItem(bodyText2),
          spacer,
          divider,
          spacer,
          buildPoolData(bodyText2),
          spacer,
          Container(
            margin: const EdgeInsets.only(
                left: kDefaultMargin, right: kDefaultMargin),
            decoration: BoxDecoration(
              color: kLightBackgroud,
              borderRadius: BorderRadius.circular(kDefaultMargin / 2),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(kDefaultMargin / 2),
                  child: Text(
                    'Mining Output',
                    style: bodyText2.copyWith(fontSize: 20),
                  ),
                ),
                divider,
                Padding(
                  padding: const EdgeInsets.all(kDefaultMargin / 2),
                  child: buildRow1(bodyText2),
                ),
                divider,
                Padding(
                  padding: const EdgeInsets.all(kDefaultMargin / 2),
                  child: buildRow2(bodyText2),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Row buildRow2(TextStyle bodyText2) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          children: [
            Text(
              'Total Orphaned',
              style: bodyText2.copyWith(color: kLightText),
            ),
            const SizedBox(
              height: kDefaultMargin / 2,
            ),
            Text(
              '11',
              style:
                  bodyText2.copyWith(fontSize: 20, fontWeight: FontWeight.w500),
            )
          ],
        ),
        Column(
          children: [
            Text(
              'Orphan rate',
              style: bodyText2.copyWith(color: kLightText),
            ),
            const SizedBox(
              height: kDefaultMargin / 2,
            ),
            Text(
              '0.04%',
              style:
                  bodyText2.copyWith(fontSize: 20, fontWeight: FontWeight.w500),
            )
          ],
        ),
      ],
    );
  }

  Row buildRow1(TextStyle bodyText2) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          children: [
            Text(
              'Total Coin',
              style: bodyText2.copyWith(color: kLightText),
            ),
            const SizedBox(
              height: kDefaultMargin / 2,
            ),
            Text(
              '292444',
              style:
                  bodyText2.copyWith(fontSize: 20, fontWeight: FontWeight.w500),
            )
          ],
        ),
        Column(
          children: [
            Text(
              'Total Coin',
              style: bodyText2.copyWith(color: kLightText),
            ),
            const SizedBox(
              height: kDefaultMargin / 2,
            ),
            Text(
              '2956444',
              style:
                  bodyText2.copyWith(fontSize: 20, fontWeight: FontWeight.w500),
            )
          ],
        ),
      ],
    );
  }

  Padding buildPoolData(TextStyle bodyText2) {
    return Padding(
      child: Text(
        'Pool Data',
        style: bodyText2.copyWith(fontSize: 20),
      ),
      padding:
          const EdgeInsets.only(left: kDefaultMargin, right: kDefaultMargin),
    );
  }

  Padding buildFirstItem(TextStyle bodyText2) {
    return Padding(
      child: Row(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: kPrimaryColor,
                borderRadius: BorderRadius.circular(kDefaultMargin),
              ),
              padding: const EdgeInsets.all(kDefaultMargin),
              child: Column(
                children: [
                  Text(
                    'Network Hastrate',
                    style: bodyText2.copyWith(color: Colors.white),
                  ),
                  const SizedBox(
                    height: kDefaultMargin / 2,
                  ),
                  Text(
                    '207.64 H/s',
                    style: bodyText2.copyWith(color: Colors.white),
                  )
                ],
              ),
            ),
          ),
          const SizedBox(width: kDefaultMargin / 2),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(kDefaultMargin),
              child: Column(
                children: [
                  Text(
                    'Pool Hastrate',
                    style: bodyText2,
                  ),
                  const SizedBox(
                    height: kDefaultMargin / 2,
                  ),
                  Text(
                    '207.64 H/s',
                    style: bodyText2.copyWith(color: Colors.black),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
      padding:
          const EdgeInsets.only(left: kDefaultMargin, right: kDefaultMargin),
    );
  }

  Padding buildHashrateTitle(TextStyle bodyText2) {
    return Padding(
      child: Text(
        '30-day Hashrate Trend',
        style: bodyText2.copyWith(fontSize: 20),
      ),
      padding:
          const EdgeInsets.only(left: kDefaultMargin, right: kDefaultMargin),
    );
  }

  AppBar buildAppBar(TextStyle? bodyText1, CoinModel coinModel) {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.transparent,
      leading: const BackButton(
        color: Colors.black,
      ),
      title: Container(
        alignment: Alignment.centerLeft,
        child: Row(
          children: [
            SvgPicture.asset(
              coinModel.imageLocation,
              height: 30,
              width: 30,
            ),
            const SizedBox(
              width: kDefaultMargin / 4,
            ),
            Text(
              coinModel.coin,
              style: bodyText1,
            ),
          ],
        ),
      ),
    );
  }
}
