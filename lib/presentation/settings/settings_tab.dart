import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:noonpool/helpers/elevated_button.dart';
import 'package:noonpool/helpers/firebase_util.dart';
import 'package:noonpool/helpers/page_route.dart';
import 'package:noonpool/helpers/shared_preference_util.dart';
import 'package:noonpool/presentation/about_us/about_us_screen.dart';
import 'package:noonpool/presentation/announcement/announcement_screen.dart';
import 'package:noonpool/presentation/auth/login/login_sceen.dart';
import 'package:noonpool/presentation/settings/widget/settings_item.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../helpers/constants.dart';

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
          'Sign Out',
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
              'Sign out?',
              style: bodyText1,
            ),
            content: Text(
              'Do you wish to sign out of this device',
              style: bodyText2,
            ),
            contentPadding: const EdgeInsets.all(kDefaultMargin / 2),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(
                  'Cancel',
                  style: bodyText2,
                ),
              ),
              TextButton(
                onPressed: () async {
                  sFirebaseAuth.signOut();
                  AppPreferences.setLoginStatus(status: false);
                  Navigator.of(context).push(
                    CustomPageRoute(
                      screen: const LoginScreen(),
                    ),
                  );
                },
                child: Text(
                  'Sign Out',
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
          buildLanguageItem()
        ],
      ),
    );
  }

  SettingsItem buildLanguageItem() {
    return SettingsItem(
        onPressed: showLanguageDialog,
        title: 'Language',
        iconLocation: 'assets/icons/language.svg');
  }

  SettingsItem buildHelpCenterItem() {
    return SettingsItem(
        onPressed: () {
          launch(_emailLaunchFunction());
          // ScaffoldMessenger.of(context).showSnackBar(
          //     const SnackBar(content: Text('Help Center pressed')));
        },
        title: 'Help Center',
        iconLocation: 'assets/icons/help.svg');
  }

  SettingsItem buildAboutItem() {
    return SettingsItem(
        onPressed: () {
          Navigator.of(context)
              .push(CustomPageRoute(screen: const AboutUsScreen()));
        },
        title: 'About NoonPool',
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
        children: [buildAnnouncementItem(), divider, buildChangePasswordItem()],
      ),
    );
  }

  SettingsItem buildChangePasswordItem() {
    return SettingsItem(
        onPressed: showChangePasswordDialog,
        title: 'Change Password',
        iconLocation: 'assets/icons/security.svg');
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
              'Change Password',
              style: bodyText1,
            ),
            contentPadding: const EdgeInsets.all(kDefaultMargin / 2),
            content: Text(
              'Do you want a link to change your password for your current account? ',
              style: bodyText2,
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(
                  'Cancel',
                  style: bodyText2,
                ),
              ),
              TextButton(
                onPressed: changePassword,
                child: Text(
                  'Yes',
                  style: bodyText2.copyWith(color: kPrimaryColor),
                ),
              ),
            ],
          );
        });
  }

  changePassword() async {
    try {
      var email = sFirebaseAuth.currentUser?.email ?? '';
      await forgotPassword(email: email);
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
              'An email with a link to change your password has been sent to your account.'),
        ),
      );
    } catch (exception) {
      ScaffoldMessenger.of(context).showSnackBar(
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
        title: 'Announcement',
        iconLocation: 'assets/icons/announcement.svg');
  }

  AppBar buildAppBar(TextStyle? bodyText1, TextStyle bodyText2) {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.transparent,
      title: Text(
        'Settings',
        style: bodyText1,
      ),
    );
  }

  void showLanguageDialog() async {
    final textTheme = Theme.of(context).textTheme;
    final bodyText1 = textTheme.bodyText1!;
    final bodyText2 = textTheme.bodyText2!;

    var height = MediaQuery.of(context).size.height;

    Dialog dialog = Dialog(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(10),
        ),
      ),
      elevation: 5,
      child: Container(
        clipBehavior: Clip.antiAliasWithSaveLayer,
        padding: const EdgeInsets.only(
            top: kDefaultPadding,
            bottom: kDefaultPadding,
            left: kDefaultPadding,
            right: kDefaultPadding),
        decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(10))),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Lottie.asset('assets/lottie/language.json',
                width: 260,
                animate: true,
                reverse: true,
                repeat: true,
                height: 240,
                fit: BoxFit.fitWidth,
                alignment: Alignment.center),
            const SizedBox(
              height: kDefaultMargin,
            ),
            Text(
              'Language',
              style: bodyText1,
            ),
            const SizedBox(
              height: kDefaultMargin / 2,
            ),
            const Divider(),
            ListTile(
              contentPadding: const EdgeInsets.all(0),
              trailing: Checkbox(
                value: true,
                onChanged: (bool? value) {},
              ),
              title: Text(
                'English',
                style: bodyText2,
              ),
            ),
            const Divider(),
          ],
        ),
      ),
    );
    showGeneralDialog(
      context: context,
      barrierLabel: "Announcement Dialog",
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
