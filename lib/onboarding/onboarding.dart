import 'package:flutter/material.dart';
import 'package:noonpool/helpers/outlined_button.dart';
import 'package:noonpool/library/intro_views_flutter-2.4.0/lib/Models/page_view_model.dart';
import 'package:noonpool/library/intro_views_flutter-2.4.0/lib/intro_views_flutter.dart';

import '../helpers/constants.dart';
import '../helpers/elevated_buton.dart';

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

    final pages = buildPages(bodyText2!);
    return IntroViewsFlutter(
      pages,
      getStartedButton: buildCreateAccountButton(bodyText2),
      logInButton: buildLoginButton(bodyText2),
      fullTransition: 200.0,
    );
  }

  Widget buildLoginButton(TextStyle bodyText2) {
    return CustomOutlinedButton(
      onPressed: () {},
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
    /*    Navigator.of(context).push(CustomPageRoute(
          screen: const RegisterScreen(),
        ));*/
      },
      widget: Text(
        'Create Account',
        style: bodyText2.copyWith(color: Colors.white),
      ),
    );
  }

  /// * SETTING THE ONBOARDING PAGES *
  List<PageViewModel> buildPages(TextStyle bodyText2) {
    final _fontHeaderStyle = bodyText2.copyWith(
        fontSize: 25, fontWeight: FontWeight.w500, letterSpacing: 1.5);

    var _imageAssetSize = 250.0;
    final _fontDescriptionStyle =
        bodyText2.copyWith(fontSize: 15, fontWeight: FontWeight.w400);

    List<PageViewModel> pages = [
/*      PageViewModel(
        iconColor: kDarkGrey,
        bubbleBackgroundColor: kDarkGrey,
        title: Text('', style: _fontHeaderStyle),
        body: Padding(
          padding: const EdgeInsets.only(bottom: kDefaultMargin / 2),
          child: Text(
            'Protect your crypto assets from hackers and scammers',
            overflow: TextOverflow.fade,
            style: _fontDescriptionStyle,
            textAlign: TextAlign.center,
          ),
        ),
        mainImage: Image.asset(
          'assets/icons/onboarding_1.png',
          fit: BoxFit.cover,
          height: _imageAssetSize,
          width: _imageAssetSize,
        ),
      ),
      PageViewModel(
        iconColor: kDarkGrey,
        bubbleBackgroundColor: kDarkGrey,
        title: Text('', style: _fontHeaderStyle),
        body: Padding(
          padding: const EdgeInsets.only(bottom: kDefaultMargin / 2),
          child: Text(
            'Send, buy, receive, and swap crypto and NFT assets',
            overflow: TextOverflow.fade,
            style: _fontDescriptionStyle,
            textAlign: TextAlign.center,
          ),
        ),
        mainImage: Image.asset(
          'assets/icons/onboarding_2.png',
          height: _imageAssetSize,
          fit: BoxFit.cover,
          width: _imageAssetSize,
        ),
      ),
      PageViewModel(
        iconColor: kDarkGrey,
        bubbleBackgroundColor: kDarkGrey,
        title: Text('', style: _fontHeaderStyle),
        body: Padding(
          padding: const EdgeInsets.only(bottom: kDefaultMargin / 2),
          child: Text(
            'Stay updated by checking out verified crypto market news',
            overflow: TextOverflow.fade,
            style: _fontDescriptionStyle,
            textAlign: TextAlign.center,
          ),
        ),
        mainImage: Image.asset(
          'assets/icons/onboarding_3.png',
          height: _imageAssetSize,
          fit: BoxFit.cover,
          width: _imageAssetSize,
        ),
      ),
      PageViewModel(
        iconColor: kDarkGrey,
        bubbleBackgroundColor: kDarkGrey,
        title: Text('', style: _fontHeaderStyle),
        body: Padding(
          padding: const EdgeInsets.only(bottom: kDefaultMargin / 2),
          child: Text(
            'Seamlessly earn interest on crypto assets in your ROAE wallet',
            overflow: TextOverflow.fade,
            style: _fontDescriptionStyle,
            textAlign: TextAlign.center,
          ),
        ),
        mainImage: Image.asset(
          'assets/icons/onboarding_4.png',
          height: _imageAssetSize,
          fit: BoxFit.cover,
          width: _imageAssetSize,
        ),
      ),*/
    ];

    return pages;
  }
}
