import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:noonpool/helpers/constants.dart';
import 'package:noonpool/presentation/home/home_tab.dart';
import 'package:noonpool/presentation/pool/pool_data.dart';
import 'package:noonpool/presentation/settings/settings_tab.dart';
import 'package:noonpool/presentation/wallet/wallet_screen.dart';

import '../../helpers/bottom_app_bar.dart';
import '../../helpers/elevated_button.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final StreamController<int> _positionStream = StreamController();
  final PageController _mainPageViewController = PageController();

  final List<Widget> _pages = [
    const HomeTab(),
    const PoolTab(),
    const WalletTab(),
    const SettingsTab(),
  ];

  static bool hasLoadedNoInternet = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      // initial position of the stream is home
      _positionStream.add(0);

      if (!hasLoadedNoInternet) {
        hasLoadedNoInternet = !hasLoadedNoInternet;
        checkConnection();
      }
    });
  }

  void checkConnection() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult != ConnectivityResult.mobile &&
        connectivityResult != ConnectivityResult.wifi &&
        connectivityResult != ConnectivityResult.mobile) {
      showNetworkDialog();
    }
  }

  void showNetworkDialog() {
    var theme = Theme.of(context).textTheme;
    var bodyText2 = theme.bodyText2;

    Dialog dialog = Dialog(
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10))),
      elevation: 5,
      child: SingleChildScrollView(
        child: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).canvasColor,
            borderRadius: const BorderRadius.all(
              Radius.circular(15),
            ),
          ),
          padding: const EdgeInsets.all(10),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Lottie.asset(
                'assets/lottie/no_internet.json',
                width: 280,
                animate: true,
                reverse: true,
                repeat: true,
                height: 280,
                fit: BoxFit.contain,
              ),
              Text(
                AppLocalizations.of(context)!
                    .pleaseConnectToAnInternetConnectionToLoadData,
                style: bodyText2,
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 8,
              ),
              CustomElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  widget: Text(
                    AppLocalizations.of(context)!.okay,
                    style: bodyText2!.copyWith(
                      color: Colors.white,
                    ),
                  )),
            ],
          ),
        ),
      ),
    );

    showGeneralDialog(
      context: context,
      barrierLabel: "Network Connection Dialog",
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.5),
      transitionDuration: const Duration(milliseconds: 500),
      pageBuilder: (_, __, ___) => dialog,
      transitionBuilder: (_, anim, __, child) => FadeTransition(
        opacity: Tween(begin: 0.0, end: 1.0).animate(anim),
        child: child,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> bottomNavItems = [
      {
        "title": AppLocalizations.of(context)!.home,
        "icon": 'assets/icons/home.svg'
      },
      {
        "title": AppLocalizations.of(context)!.pool,
        "icon": 'assets/icons/pool.svg'
      },
      {
        "title": AppLocalizations.of(context)!.wallet,
        "icon": 'assets/icons/wallet.svg'
      },
      {
        "title": AppLocalizations.of(context)!.settings,
        "icon": 'assets/icons/settings.svg'
      },
    ];

    return Scaffold(
      body: PageView(
        controller: _mainPageViewController,
        physics: const NeverScrollableScrollPhysics(),
        children: _pages,
      ),
      bottomNavigationBar: CustomBottomAppBar(
          onBottomNavBarClicked: onBottomNavBarClicked,
          bottomNavItems: bottomNavItems,
          positionStream: _positionStream.stream),
    );
  }

  void onBottomNavBarClicked(int position) {
    _positionStream.add(position);
    _mainPageViewController.animateToPage(position,
        duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
  }
}
