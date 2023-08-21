import 'dart:async';
import 'package:flutter/material.dart';
import 'package:noonpool/helpers/constants.dart';
import 'package:noonpool/presentation/home/home_tab.dart';
import 'package:noonpool/presentation/pool/pool_data.dart';
import 'package:noonpool/presentation/settings/settings_tab.dart';
import 'package:noonpool/presentation/wallet/wallet_screen.dart';

import '../../helpers/bottom_app_bar.dart';

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


  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      _positionStream.add(0);
    });
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
