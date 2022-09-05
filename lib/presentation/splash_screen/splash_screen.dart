import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:noonpool/helpers/constants.dart';
import 'package:noonpool/helpers/locale_cubit.dart';
import 'package:noonpool/helpers/page_route.dart';
import 'package:noonpool/onboarding/onboarding.dart';
import 'package:noonpool/presentation/settings/verify_otp.dart';

import '../../helpers/shared_preference_util.dart';
import '../auth/login/login_sceen.dart';
import '../main/main_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  final Duration _duration = const Duration(seconds: 2);
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
    final currentLocaleLanguageCode = AppPreferences.currentLocaleLanguageCode;
    if (currentLocaleLanguageCode == AppPreferences.defaultLocaleLanguageCode) {
      BlocProvider.of<LocaleCubit>(context).updateCurrentLocale(null);
    } else {
      appLocales(context).forEach((element) {
        if (element.locale != null &&
            element.locale!.languageCode == currentLocaleLanguageCode) {
          BlocProvider.of<LocaleCubit>(context)
              .updateCurrentLocale(element.locale);
        }
      });
    }

    final navigatorState = Navigator.of(context);
    if (AppPreferences.onBoardingStatus) {
      if (AppPreferences.loginStatus) {
        if (AppPreferences.get2faSecurityEnabled) {
          navigatorState.push(
            CustomPageRoute(
              screen: VerifyOtp(
                id: AppPreferences.userId,
                backEnaled: false,
                onNext: (_) {
                  Navigator.of(context).pushReplacement(
                      CustomPageRoute(screen: const MainScreen()));
                },
              ),
            ),
          );
        } else {
          navigatorState
              .pushReplacement(CustomPageRoute(screen: const MainScreen()));
        }

        // user has been previously logged in, redirect to the main page
      } else {
        AppPreferences.setLoginStatus(status: false);

        navigatorState.pushReplacement(CustomPageRoute(
            screen:
                const LoginScreen())); // user has seen the onboarding screen, redirect to the login screen
      }
    } else {
      AppPreferences.setLoginStatus(status: false);
      AppPreferences.setOnBoardingStatus(status: false);

      navigatorState.pushReplacement(CustomPageRoute(
          screen:
              const OnBoardingScreen())); //user has not see the onboarding screen
    }
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
            width: MediaQuery.of(context).size.width * 0.7,
          ),
        ),
      ),
    );
  }
}
