import 'package:flutter/material.dart';
import 'package:noonpool/helpers/elevated_button.dart';
import 'package:noonpool/helpers/firebase_util.dart';
import 'package:noonpool/helpers/page_route.dart';
import 'package:noonpool/helpers/shared_preference_util.dart';
import 'package:noonpool/presentation/auth/login/login_sceen.dart';
import 'package:noonpool/presentation/settings/widget/settings_item.dart';

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
        onPressed: () {
          ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text('Language pressed')));
        },
        title: 'Language',
        iconLocation: 'assets/icons/language.svg');
  }

  SettingsItem buildHelpCenterItem() {
    return SettingsItem(
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Help Center pressed')));
        },
        title: 'Help Center',
        iconLocation: 'assets/icons/help.svg');
  }

  SettingsItem buildAboutItem() {
    return SettingsItem(
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('About NoonPool pressed')));
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
        children: [buildAnnouncementItem(), divider, buildSecurityCenterItem()],
      ),
    );
  }

  SettingsItem buildSecurityCenterItem() {
    return SettingsItem(
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Security Center pressed')));
        },
        title: 'Security Center',
        iconLocation: 'assets/icons/security.svg');
  }

  SettingsItem buildAnnouncementItem() {
    return SettingsItem(
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Announcement pressed')));
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
}
