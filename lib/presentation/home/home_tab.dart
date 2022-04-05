import 'dart:async';

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:noonpool/helpers/constants.dart';
import 'package:noonpool/helpers/firebase_util.dart';
import 'package:noonpool/model/coin_model.dart';
import 'package:noonpool/presentation/home/widget/home_coin_item.dart';
import 'package:noonpool/presentation/home/widget/home_header_item.dart';

import '../../helpers/page_route.dart';
import '../coin/coin_screen.dart';

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
          const Padding(
            child: _HomeHeader(),
            padding:
                EdgeInsets.only(left: kDefaultMargin, right: kDefaultMargin),
          ),
          spacer,
          Padding(
            child: Text(
              'Statistics',
              style: bodyText2.copyWith(fontSize: 20),
            ),
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
          FutureBuilder<List<CoinModel>>(
              future: getAllCoinDetails(),
              builder: (ctx, asyncDataSnapshot) {
                if (asyncDataSnapshot.hasError) {
                  // show error
                  final error = asyncDataSnapshot.error.toString();
                  return Column(mainAxisSize: MainAxisSize.min, children: [
                    const SizedBox(
                      height: kDefaultMargin,
                    ),
                    Lottie.asset(
                      'assets/lottie/error.json',
                      width: 280,
                      animate: true,
                      reverse: true,
                      repeat: true,
                      height: 280,
                      fit: BoxFit.contain,
                    ),
                    Text(
                      'Fetching data, please wait',
                      style: bodyText2,
                    ),
                    const SizedBox(
                      height: kDefaultMargin * 2,
                    ),
                  ]);
                } else {
                  if (asyncDataSnapshot.hasData) {
                    List<CoinModel> allData = asyncDataSnapshot.data ?? [];
                    return ListView.builder(
                      padding: const EdgeInsets.all(0),
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: allData.length,
                      itemBuilder: (ctx, index) {
                        return HomeCoinItem(
                            coinModel: allData[index],
                            onPressed: onCoinPressed);
                      },
                    );
                  } else {
                    //  loading progress bar
                    return Column(mainAxisSize: MainAxisSize.min, children: [
                      const SizedBox(
                        height: kDefaultMargin,
                      ),
                      Lottie.asset(
                        'assets/lottie/loading.json',
                        width: 280,
                        animate: true,
                        reverse: true,
                        repeat: true,
                        height: 280,
                        fit: BoxFit.contain,
                      ),
                      Text(
                        'Fetching data, please wait',
                        style: bodyText2,
                      ),
                      const SizedBox(
                        height: kDefaultMargin * 2,
                      ),
                    ]);
                  }
                }
              }),
        ],
      ),
    );
  }

  void onCoinPressed(CoinModel coinModel) {
    Navigator.of(context).push(
      CustomPageRoute(screen: const CoinScreen(), argument: coinModel),
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
              'Algorithm',
              style: lightText,
            ),
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Profit',
              style: bodyText1,
            ),
            Text(
              'Price',
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

  AppBar buildAppBar(TextStyle? bodyText1) {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.transparent,
      title: Text(
        sFirebaseAuth.currentUser?.email ?? '',
        style: bodyText1,
      ),
    );
  }
}

class _HomeHeader extends StatefulWidget {
  const _HomeHeader({Key? key}) : super(key: key);

  @override
  State<_HomeHeader> createState() => _HomeHeaderState();
}

class _HomeHeaderState extends State<_HomeHeader> {
  final List<Map<String, String>> viewPagerData = [
    {
      'image': 'assets/onboarding/onboarding_1.svg',
      'title': 'View mining profits at a glance'
    },
    {
      'title': 'Built in cryptocurrency wallet for managing assets',
      'image': 'assets/onboarding/onboarding_2.svg'
    },
    {
      'title': '24/7 stable and secure mining network',
      'image': 'assets/onboarding/onboarding_3.svg'
    },
  ];
  Timer? _timer;
  final PageController _pageController = PageController();
  final duration = const Duration(seconds: 4);

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      updateCurrentPage();
    });
  }

  void updateCurrentPage() {
    var length = viewPagerData.length;
    var page = _pageController.page;
    if (page == null) {
      return;
    }

    if (page == length - 1) {
      _pageController.animateToPage(0,
          duration: duration, curve: Curves.bounceInOut);
    } else {
      _pageController.animateToPage(page.toInt() + 1,
          duration: duration, curve: Curves.bounceInOut);
    }
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var width = size.width;

    return SizedBox(
      width: width,
      height: 200,
      child: PageView.builder(
          controller: _pageController,
          scrollDirection: Axis.horizontal,
          itemCount: viewPagerData.length,
          itemBuilder: (context, index) {
            final String title = (viewPagerData[index])['title'] ?? '';
            final String imageLocation = (viewPagerData[index])['image'] ?? '';
            return HomeHeaderItem(title: title, imageLocation: imageLocation);
          }),
    );
  }
}
