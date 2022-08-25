import 'dart:async';

import 'package:flutter/material.dart';
import 'package:noonpool/helpers/constants.dart';
import 'package:noonpool/helpers/shared_preference_util.dart';
import 'package:noonpool/main.dart';
import 'package:noonpool/model/coin_model/coin_model.dart';
import 'package:noonpool/presentation/home/widget/home_coin_item.dart';
import 'package:noonpool/presentation/home/widget/home_header_item.dart';

import '../../helpers/error_widget.dart';
import '../../helpers/network_helper.dart';

class HomeTab extends StatefulWidget {
  const HomeTab({Key? key}) : super(key: key);

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  bool _isLoading = true;
  bool _hasError = false;
  final List<CoinModel> allCoinData = [];

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, getData);
  }

  getData() async {
    allCoinData.clear();
    setState(() {
      _isLoading = true;
      _hasError = false;
    });
    try {
      final data = await getAllCoinDetails();
      allCoinData.addAll(data);
    } catch (exception) {
      MyApp.scaffoldMessengerKey.currentState
          ?.showSnackBar(SnackBar(content: Text(exception.toString())));
      _hasError = false;
    }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final bodyText1 = textTheme.bodyText1!;
    final bodyText2 = textTheme.bodyText2!;
    final lightText = bodyText2.copyWith(color: kLightText);
    const spacer = SizedBox(
      height: kDefaultMargin / 2,
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
              AppLocalizations.of(context)!.statistics,
              style: bodyText1.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            padding: const EdgeInsets.only(
                left: kDefaultMargin, right: kDefaultMargin),
          ),
          spacer,
          Padding(
            child: buildRow2(bodyText1, lightText),
            padding: const EdgeInsets.only(
              left: kDefaultMargin,
              right: kDefaultMargin,
            ),
          ),
          spacer,
          Expanded(
            child: _isLoading
                ? buildLoadingBody()
                : _hasError
                    ? CustomErrorWidget(
                        error: AppLocalizations.of(context)!
                            .anErrorOccurredWithTheDataFetchPleaseTryAgain,
                        onRefresh: () {
                          getData();
                        })
                    : buildBody(),
          ),
        ],
      ),
    );
  }

  ListView buildBody() {
    return ListView.builder(
      padding: const EdgeInsets.all(0),
      physics: const BouncingScrollPhysics(),
      itemCount: allCoinData.length,
      itemBuilder: (ctx, index) {
        return HomeCoinItem(
          coinModel: allCoinData[index],
        );
      },
    );
  }

  ListView buildLoadingBody() {
    return ListView.builder(
      padding: const EdgeInsets.all(0),
      physics: const BouncingScrollPhysics(),
      itemCount: 10,
      itemBuilder: (ctx, index) {
        return HomeCoinItem(
          shimmerEnabled: true,
          coinModel: CoinModel(),
        );
      },
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
                  AppLocalizations.of(context)!.coin,
                  style: bodyText1,
                ),
                Text(
                  AppLocalizations.of(context)!.algorithm,
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
                  AppLocalizations.of(context)!.price,
                  style: bodyText1,
                ),
                Text(
                  AppLocalizations.of(context)!.miningProfit,
                  style: lightText,
                ),
              ],
            ),
          ),
          Expanded(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
              Text(
                AppLocalizations.of(context)!.difficulty,
                style: bodyText1,
              ),
              Text(
                AppLocalizations.of(context)!.networkHashrate,
                style: lightText,
              ),
            ]),
          ),
        ]);
  }

  AppBar buildAppBar(TextStyle? bodyText1) {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.transparent,
      title: Text(
        AppPreferences.userName,
        style: bodyText1!.copyWith(fontWeight: FontWeight.bold),
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
    var length = 3;
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
    final List<Map<String, String>> viewPagerData = [
      {
        'image': 'assets/onboarding/onboarding_1.svg',
        'title': AppLocalizations.of(context)!.viewMiningProfits,
      },
      {
        'title': AppLocalizations.of(context)!.builtInCryptoCurrencyWallet,
        'image': 'assets/onboarding/onboarding_2.svg'
      },
      {
        'title': AppLocalizations.of(context)!.stableAndSecureMiningNetwork,
        'image': 'assets/onboarding/onboarding_3.svg'
      },
    ];
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
