import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../helpers/constants.dart';

class CalculatorTab extends StatefulWidget {
  const CalculatorTab({Key? key}) : super(key: key);

  @override
  State<CalculatorTab> createState() => _CalculatorTabState();
}

class _CalculatorTabState extends State<CalculatorTab> {
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final bodyText1 = textTheme.bodyText1!;
    final bodyText2 = textTheme.bodyText2!;
    final lightText = bodyText2.copyWith(color: kLightText);
    const spacer = SizedBox(
      height: kDefaultMargin,
    );
    return Scaffold(
      body: ListView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(0),
        children: [
          buildAppBar(bodyText1, bodyText2),
          spacer,
          Card(
            elevation: 1,
            margin: const EdgeInsets.only(
                left: kDefaultMargin, right: kDefaultMargin),
            color: kLightBackgroud,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: Padding(
              padding: const EdgeInsets.all(kDefaultPadding / 2),
              child: Text(
                'The result is the theoretical PPS+ mining yield based on the set difficulty and the average miner fees in the past 7 days',
                style: bodyText2.copyWith(color: kPrimaryColor),
              ),
            ),
          ),
          spacer,
          Padding(
            child: Text(
              'Difficulty',
              style: bodyText2,
            ),
            padding: const EdgeInsets.only(left: kDefaultMargin),
          ),
          const SizedBox(
            height: kDefaultMargin / 4,
          ),
          Card(
            elevation: 1,
            margin: const EdgeInsets.only(
                left: kDefaultMargin, right: kDefaultMargin),
            color: kLightBackgroud,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: Padding(
              padding: const EdgeInsets.all(kDefaultPadding / 2),
              child: Text(
                '21659344833264.85',
                style: bodyText2,
              ),
            ),
          ),
          spacer,
          Padding(
            child: Text(
              'Price',
              style: bodyText2,
            ),
            padding: const EdgeInsets.only(left: kDefaultMargin),
          ),
          const SizedBox(
            height: kDefaultMargin / 4,
          ),
          Row(
            children: [
              Card(
                elevation: 1,
                margin: const EdgeInsets.only(left: kDefaultMargin),
                color: kLightBackgroud,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(kDefaultPadding / 2),
                  child: Text(
                    '63118.64',
                    style: bodyText2,
                  ),
                ),
              ),
              const Spacer(),
              Container(
                margin: const EdgeInsets.only(right: kDefaultMargin),
                padding: const EdgeInsets.all(kDefaultPadding / 4),
                decoration: BoxDecoration(
                    border: Border.all(width: 3, color: kLightBackgroud),
                    borderRadius: BorderRadius.circular(10)),
                child: Row(
                  children: [
                    Text(
                      'USD/BTC',
                      style: bodyText2,
                    ),
                    const Icon(
                      Icons.arrow_drop_down,
                      color: kTextColor,
                    )
                  ],
                ),
              )
            ],
          ),
          spacer,
          Padding(
            child: Text(
              'PPS Fee Rate',
              style: bodyText2,
            ),
            padding: const EdgeInsets.only(left: kDefaultMargin),
          ),
          const SizedBox(
            height: kDefaultMargin / 4,
          ),
          Card(
            elevation: 1,
            margin: const EdgeInsets.only(
                left: kDefaultMargin, right: kDefaultMargin),
            color: kLightBackgroud,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: Padding(
              padding: const EdgeInsets.all(kDefaultPadding / 2),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '4',
                    style: bodyText2,
                  ),
                  const Icon(
                    Icons.percent_rounded,
                    color: kTextColor,
                  )
                ],
              ),
            ),
          ),
          spacer,
          Padding(
            child: Text(
              'Valid Hashrate',
              style: bodyText2,
            ),
            padding: const EdgeInsets.only(left: kDefaultMargin),
          ),
          const SizedBox(
            height: kDefaultMargin / 4,
          ),
          Card(
            elevation: 1,
            margin: const EdgeInsets.only(
                left: kDefaultMargin, right: kDefaultMargin),
            color: kLightBackgroud,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: Padding(
              padding: const EdgeInsets.all(kDefaultPadding / 2),
              child: Text(
                '1',
                style: bodyText2,
              ),
            ),
          ),
          spacer,
          const Divider(),
          spacer,
          Padding(
            child: Text(
              'EST. Daily Yield',
              style: bodyText2,
            ),
            padding: const EdgeInsets.only(
                left: kDefaultPadding, right: kDefaultPadding),
          ),
          const SizedBox(
            height: kDefaultMargin / 4,
          ),
          Padding(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '0.00000565',
                  style: bodyText1.copyWith(fontSize: 25),
                ),
                const SizedBox(
                  width: kDefaultMargin / 5,
                ),
                Text(
                  'BTC',
                  style: bodyText2,
                ),
                const Spacer(),
                Text(
                  '= \$ 0.3566',
                  style: bodyText2.copyWith(color: kPrimaryColor),
                ),
              ],
            ),
            padding: const EdgeInsets.only(
                left: kDefaultPadding, right: kDefaultPadding),
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
        'Profit Calculator',
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
