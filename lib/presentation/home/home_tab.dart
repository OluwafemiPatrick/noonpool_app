import 'dart:async';

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:noonpool/helpers/constants.dart';
import 'package:noonpool/helpers/firebase_util.dart';
import 'package:noonpool/model/coin_model.dart';
import 'package:noonpool/presentation/home/widget/home_coin_item.dart';
import 'package:noonpool/presentation/home/widget/home_header_item.dart';

import '../../helpers/error_widget.dart';

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
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: [
          buildAppBar(bodyText1),
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
          Expanded(
            child: FutureBuilder<List<CoinModel>>(
                future: getAllCoinDetails(),
                builder: (ctx, asyncDataSnapshot) {
                  if (asyncDataSnapshot.hasError) {
                    // show error
                    final error = asyncDataSnapshot.error.toString();
                    return CustomErrorWidget(
                        error: error,
                        onRefresh: () {
                          setState(() {});
                        });
                  } else {
                    if (asyncDataSnapshot.hasData) {
                      List<CoinModel> allData = asyncDataSnapshot.data ?? [];
                      return ListView.builder(
                        padding: const EdgeInsets.all(0),
                        physics: const BouncingScrollPhysics(),
                        itemCount: allData.length,
                        itemBuilder: (ctx, index) {
                          return HomeCoinItem(coinModel: allData[index]);
                        },
                      );
                    } else {
                      //  loading progress bar
                      return Center(
                        child: Lottie.asset(
                          'assets/lottie/loading.json',
                          width: 100,
                          animate: true,
                          reverse: true,
                          repeat: true,
                          height: 100,
                          fit: BoxFit.contain,
                        ),
                      );
                    }
                  }
                }),
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
        Expanded(
          child: Column(
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
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
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
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                'Difficulty',
                style: bodyText1,
              ),
              Text(
                'Network Hashrate',
                style: lightText,
              ),
            ],
          ),
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
      height: 130,
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
