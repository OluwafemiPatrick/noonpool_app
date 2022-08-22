import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:noonpool/helpers/outlined_button.dart';
import 'package:noonpool/library/intro_views_flutter-2.4.0/lib/Models/page_view_model.dart';
import 'package:noonpool/library/intro_views_flutter-2.4.0/lib/intro_views_flutter.dart';
import 'package:noonpool/presentation/auth/login/login_sceen.dart';

import '../helpers/constants.dart';
import '../helpers/elevated_button.dart';
import '../helpers/page_route.dart';
import '../presentation/auth/register/register_sceen.dart';

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({Key? key}) : super(key: key);

  @override
  _OnBoardingScreenState createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final bodyText2 = textTheme.bodyText2;

    final pages =
        buildPages(bodyText2!.copyWith(color: kPrimaryColor, fontSize: 16));
    return IntroViewsFlutter(
      pages,
      getStartedButton: buildCreateAccountButton(bodyText2),
      logInButton: buildLoginButton(bodyText2),
      fullTransition: 200.0,
    );
  }

  Widget buildLoginButton(TextStyle bodyText2) {
    return CustomOutlinedButton(
      onPressed: () {
        Navigator.of(context).push(CustomPageRoute(
          screen: const LoginScreen(),
        ));
      },
      widget: Text(
        'Sign In',
        style: bodyText2.copyWith(
            color: kPrimaryColor, fontWeight: FontWeight.w600),
      ),
    );
  }

  Widget buildCreateAccountButton(TextStyle bodyText2) {
    return CustomElevatedButton(
      onPressed: () {
        Navigator.of(context).push(CustomPageRoute(
          screen: const RegisterScreen(),
        ));
      },
      widget: Text(
        'Create Account',
        style: bodyText2.copyWith(color: Colors.white),
      ),
    );
  }

  /// * SETTING THE ONBOARDING PAGES *
  List<PageViewModel> buildPages(TextStyle bodyText2) {
    var defaultSize = MediaQuery.of(context).size.width * 0.6;

    List<PageViewModel> pages = [
      PageViewModel(
        iconColor: kPrimaryColor,
        bubbleBackgroundColor: kPrimaryColor,
        title: Padding(
          padding: const EdgeInsets.only(
              left: kDefaultMargin, right: kDefaultMargin),
          child: Text(
            'View mining profits at a glance',
            overflow: TextOverflow.fade,
            style: bodyText2,
            textAlign: TextAlign.center,
          ),
        ),
        body: Container(),
        mainImage: SvgPicture.asset(
          'assets/onboarding/onboarding_1.svg',
          width: defaultSize + 40,
        ),
      ),
      PageViewModel(
        iconColor: kPrimaryColor,
        bubbleBackgroundColor: kPrimaryColor,
        title: Padding(
          padding: const EdgeInsets.only(
              left: kDefaultMargin, right: kDefaultMargin),
          child: Text(
            'Built in cryptocurrency wallet for managing assets',
            overflow: TextOverflow.fade,
            style: bodyText2,
            textAlign: TextAlign.center,
          ),
        ),
        body: Container(),
        mainImage: SvgPicture.asset(
          'assets/onboarding/onboarding_2.svg',
          width: defaultSize,
        ),
      ),
      PageViewModel(
        iconColor: kPrimaryColor,
        bubbleBackgroundColor: kPrimaryColor,
        title: Padding(
          padding: const EdgeInsets.only(
              left: kDefaultMargin, right: kDefaultMargin),
          child: Text(
            '24/7 stable and secure mining network',
            overflow: TextOverflow.fade,
            style: bodyText2,
            textAlign: TextAlign.center,
          ),
        ),
        body: Container(),
        mainImage: SvgPicture.asset(
          'assets/onboarding/onboarding_3.svg',
          width: defaultSize,
        ),
      ),
    ];

    return pages;
  }
}
