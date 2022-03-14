import 'dart:async';

import 'package:flutter/material.dart';
import 'package:noonpool/helpers/constants.dart';
import 'package:noonpool/helpers/page_route.dart';
import 'package:noonpool/onboarding/onboarding.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  final Duration _duration = const Duration(milliseconds: 2000);
  Animation<double>? _opacityAnimation;
  AnimationController? _controller;

  @override
  void initState() {
    super.initState();
    setUpAnimation();
  }

  void setUpAnimation() {
    _controller = AnimationController(
      vsync: this,
      duration: _duration,
    );

    // used to fade in the logo
    _opacityAnimation = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller!,
        curve: Curves.easeIn,
      ),
    );

    // on fade in complete make changes to the current screen
    _controller?.addListener(() {
      if (_controller!.isCompleted) {
        startTime();
      }
    });

    // 2 seconds delay before animation starts
    Timer(_duration, () {
      _controller?.forward();
    });
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  void route() {
    Navigator.of(context).push(CustomPageRoute(
      screen: const OnBoardingScreen(),
    ));
  }

  Future startTime() async {
    // timer would allow screen to be navigated
    return Timer(_duration, route);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FadeTransition(
        opacity: _opacityAnimation!,
        child: Center(
          child: Image.asset(
            fullLogoLocation,
            height: 400,
            width: 400,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
