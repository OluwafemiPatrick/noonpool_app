import 'package:flutter/material.dart';
import 'package:noonpool/helpers/constants.dart';
import 'package:noonpool/helpers/firebase_util.dart';
import 'package:noonpool/helpers/svg_image.dart';
import 'package:noonpool/model/coin_model.dart';
import 'package:noonpool/presentation/home/widget/home_coin_item.dart';

class HomeTab extends StatefulWidget {
  const HomeTab({Key? key}) : super(key: key);

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
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
          buildAppBar(bodyText1),
          spacer,
          Padding(
            child: Image.asset(
              'assets/images/start_mining.png',
              fit: BoxFit.fitWidth,
              width: double.infinity,
            ),
            padding: const EdgeInsets.only(
                left: kDefaultMargin, right: kDefaultMargin),
          ),
          spacer,
          Padding(
            child: buildRow1(bodyText2),
            padding: const EdgeInsets.only(
                left: kDefaultMargin, right: kDefaultMargin),
          ),
          spacer,
          Padding(
            child: buildRow2(bodyText1, lightText),
            padding: const EdgeInsets.only(
                left: kDefaultMargin, right: kDefaultMargin),
          ),
          spacer,
          ...dummyCoinModel.map(
            (coinModel) =>
                HomeCoinItem(coinModel: coinModel, onPressed: (_) {}),
          ),
        ],
      ),
    );
  }

  Row buildRow2(TextStyle bodyText1, TextStyle lightText) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Coin',
              style: bodyText1,
            ),
            Text(
              'Algorithim',
              style: lightText,
            ),
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Pool Hashrate',
              style: bodyText1,
            ),
            Text(
              'Network Hashrate',
              style: lightText,
            ),
          ],
        ),
      ],
    );
  }

  Row buildRow1(TextStyle bodyText2) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Statistics',
          style: bodyText2.copyWith(fontSize: 20),
        ),
        Container(
          padding: const EdgeInsets.only(
              top: kDefaultMargin / 4,
              left: kDefaultMargin / 2,
              right: kDefaultMargin / 2,
              bottom: kDefaultMargin / 4),
          decoration: BoxDecoration(
              color: kLightPrimaryColor,
              borderRadius: BorderRadius.circular(kDefaultMargin)),
          child: Row(
            children: [
              Text(
                'Sort by default',
                style: bodyText2.copyWith(color: kPrimaryColor),
              ),
              const Icon(
                Icons.arrow_drop_down,
                color: kPrimaryColor,
              )
            ],
          ),
        )
      ],
    );
  }

  AppBar buildAppBar(TextStyle? bodyText1) {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.transparent,
      leading: InkWell(
        onTap: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Menu clicked'),
            ),
          );
        },
        child: const Center(
          child: SvgImage(
              iconLocation: 'assets/icons/menu.svg',
              name: 'menu',
              color: Colors.black),
        ),
      ),
      title: Text(
        sFirebaseAuth.currentUser?.email ?? '',
        style: bodyText1,
      ),
    );
  }
}
