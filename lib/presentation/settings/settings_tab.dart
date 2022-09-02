import 'package:flutter/material.dart';
import 'package:noonpool/helpers/elevated_button.dart';
import 'package:noonpool/helpers/page_route.dart';
import 'package:noonpool/helpers/shared_preference_util.dart';
import 'package:noonpool/presentation/about_us/about_us_screen.dart';
import 'package:noonpool/presentation/announcement/announcement_screen.dart';
import 'package:noonpool/presentation/calculator/calculator_screen.dart';
import 'package:noonpool/presentation/language/language_changer.dart';
import 'package:noonpool/presentation/settings/otp_screen.dart';
import 'package:noonpool/presentation/settings/widget/settings_item.dart';
import 'package:noonpool/presentation/splash_screen/splash_screen.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:noonpool/main.dart';
import '../../helpers/constants.dart';
import 'verify_otp.dart';

class SettingsTab extends StatefulWidget {
  const SettingsTab({Key? key}) : super(key: key);

  @override
  State<SettingsTab> createState() => _SettingsTabState();
}

class _SettingsTabState extends State<SettingsTab> {
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final bodyText1 = textTheme.bodyText1!;
    final bodyText2 = textTheme.bodyText2!;
    const spacer = SizedBox(
      height: kDefaultMargin * 2,
    );
    const divider = Divider();

    return Scaffold(
      body: ListView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(0),
        children: [
          buildAppBar(bodyText1, bodyText2),
          spacer,
          buildFirstCard(divider),
          spacer,
          buildSecondCard(divider),
          spacer,
          buildLogoutButton(bodyText2)
        ],
      ),
    );
  }

  Padding buildLogoutButton(TextStyle bodyText2) {
    return Padding(
      padding: const EdgeInsets.all(kDefaultMargin / 2),
      child: CustomElevatedButton(
        onPressed: () => showLogoutDialog(),
        widget: Text(
          AppLocalizations.of(context)!.signOut,
          style: bodyText2.copyWith(color: Colors.white),
        ),
      ),
    );
  }

  void showLogoutDialog() async {
    TextTheme textTheme = Theme.of(context).textTheme;
    final bodyText1 = textTheme.bodyText1!.copyWith(fontSize: 20);
    final bodyText2 = textTheme.bodyText2!.copyWith(fontSize: 16);
    showDialog(
        context: context,
        builder: (ctx) {
          return AlertDialog(
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(10),
              ),
            ),
            title: Text(
              AppLocalizations.of(context)!.signOut,
              style: bodyText1,
            ),
            content: Text(
              AppLocalizations.of(context)!.doYouWishToSignOutOfThisDevice,
              style: bodyText2,
            ),
            contentPadding: const EdgeInsets.all(kDefaultMargin / 2),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(
                  AppLocalizations.of(context)!.cancel,
                  style: bodyText2,
                ),
              ),
              TextButton(
                onPressed: () async {
                  AppPreferences.setLoginStatus(status: false);
                  Navigator.of(context).pushAndRemoveUntil(
                    CustomPageRoute(
                      screen: const SplashScreen(),
                    ),
                    (_) => false,
                  );
                },
                child: Text(
                  AppLocalizations.of(context)!.signOut,
                  style: bodyText2.copyWith(color: kPrimaryColor),
                ),
              ),
            ],
          );
        });
  }

  Card buildSecondCard(Divider divider) {
    return Card(
      margin: const EdgeInsets.only(
          left: kDefaultMargin / 2, right: kDefaultMargin / 2),
      elevation: 2,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          buildAboutItem(),
          divider,
          buildHelpCenterItem(),
          divider,
          buildLanguageItem(),
          divider,
          build2faSecurity()
        ],
      ),
    );
  }

  SettingsItem buildLanguageItem() {
    return SettingsItem(
        onPressed: () {
          Navigator.of(context)
              .push(CustomPageRoute(screen: const LanguageChanger()));
        },
        title: AppLocalizations.of(context)!.language,
        iconLocation: 'assets/icons/language.svg');
  }

  SettingsItem2 build2faSecurity() {
    return SettingsItem2(
      value: AppPreferences.get2faSecurity,
      onPressed: (newValue) async {
        if (newValue) {
          // set the auth
          await Navigator.of(context)
              .push(CustomPageRoute(screen: const OtpScreen()));
          setState(() {});
        } else {
          await Navigator.of(context).push(CustomPageRoute(screen: VerifyOtp(
            onNext: () {
              // call the backend to  update user status
              AppPreferences.set2faSecurity(isEnabled: newValue);
              MyApp.scaffoldMessengerKey.currentState?.showSnackBar(SnackBar(
                  content: Text(AppLocalizations.of(context)!.authTurnedOff)));
            },
          )));
          setState(() {});
        }
      },
      title: AppLocalizations.of(context)!.twoFactorAuthentication,
      iconLocation: Icons.security_rounded,
    );
  }

  SettingsItem buildHelpCenterItem() {
    return SettingsItem(
        onPressed: () {
          launch(_emailLaunchFunction());
        },
        title: AppLocalizations.of(context)!.helpCenter,
        iconLocation: 'assets/icons/help.svg');
  }

  SettingsItem buildAboutItem() {
    return SettingsItem(
        onPressed: () {
          Navigator.of(context)
              .push(CustomPageRoute(screen: const AboutUsScreen()));
        },
        title: AppLocalizations.of(context)!.aboutNoonpool,
        iconLocation: 'assets/icons/about.svg');
  }

  Card buildFirstCard(Divider divider) {
    return Card(
      margin: const EdgeInsets.only(
          left: kDefaultMargin / 2, right: kDefaultMargin / 2),
      elevation: 2,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          buildAnnouncementItem(),
          divider,
          buildChangePasswordItem(),
          divider,
          buildCalculator(),
        ],
      ),
    );
  }

  SettingsItem buildChangePasswordItem() {
    return SettingsItem(
        onPressed: showChangePasswordDialog,
        title: AppLocalizations.of(context)!.changePassword,
        iconLocation: 'assets/icons/security.svg');
  }

  SettingsItem buildCalculator() {
    return SettingsItem(
        onPressed: () {
          Navigator.of(context).push(
            CustomPageRoute(
              screen: const CalculatorScreen(),
            ),
          );
        },
        title: AppLocalizations.of(context)!.calculator,
        iconLocation: 'assets/icons/calculator.svg');
  }

  void showChangePasswordDialog() async {
    TextTheme textTheme = Theme.of(context).textTheme;
    final bodyText1 = textTheme.bodyText1!;
    final bodyText2 = textTheme.bodyText2!;
    showDialog(
        context: context,
        builder: (ctx) {
          return AlertDialog(
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(10),
              ),
            ),
            title: Text(
              AppLocalizations.of(context)!.changePassword,
              style: bodyText1,
            ),
            contentPadding: const EdgeInsets.all(kDefaultMargin / 2),
            content: Text(
              AppLocalizations.of(context)!
                  .doYouWantALinkToChangeYourPasswordForYourCurrentAccount,
              style: bodyText2,
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(
                  AppLocalizations.of(context)!.cancel,
                  style: bodyText2,
                ),
              ),
              TextButton(
                onPressed: changePassword,
                child: Text(
                  AppLocalizations.of(context)!.yes,
                  style: bodyText2.copyWith(color: kPrimaryColor),
                ),
              ),
            ],
          );
        });
  }

  changePassword() async {
    try {
      // await forgotPassword(email: email);
      Navigator.of(context).pop();
      MyApp.scaffoldMessengerKey.currentState?.showSnackBar(
        SnackBar(
          content: Text(
            AppLocalizations.of(context)!
                .anEmailWithALinkToChangeYourPasswordHasBeenSentToYourAccount,
          ),
        ),
      );
    } catch (exception) {
      MyApp.scaffoldMessengerKey.currentState?.showSnackBar(
        SnackBar(
          content: Text(exception.toString()),
        ),
      );
    }
  }

  SettingsItem buildAnnouncementItem() {
    return SettingsItem(
        onPressed: () {
          Navigator.of(context)
              .push(CustomPageRoute(screen: const AnnouncementScreen()));
        },
        title: AppLocalizations.of(context)!.announcement,
        iconLocation: 'assets/icons/announcement.svg');
  }

  AppBar buildAppBar(TextStyle? bodyText1, TextStyle bodyText2) {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.transparent,
      title: Text(
        AppLocalizations.of(context)!.settings,
        style: bodyText1,
      ),
    );
  }

  _emailLaunchFunction() {
    Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: supportEmailAddress,
      query: _encodeQueryParameters(
          <String, String>{'subject': 'Customer Support: NoonPool App'}),
    );
    return emailLaunchUri.toString();
  }

  String _encodeQueryParameters(Map<String, String> params) {
    return params.entries
        .map((e) =>
            '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
        .join('&');
  }
}
