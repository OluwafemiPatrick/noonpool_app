import 'package:flutter/material.dart';

import '../../helpers/constants.dart';

class AboutUsScreen extends StatefulWidget {
  const AboutUsScreen({Key? key}) : super(key: key);

  @override
  State<AboutUsScreen> createState() => _AboutUsScreenState();
}

class _AboutUsScreenState extends State<AboutUsScreen> {
  final aboutUs =
      'Noonpool is a company that affords crypto miners the platform that helps them carry out their operations  easily.\n\nWe provide the needed stratum url for miners to utilize in doing their jobs.\n\nWe also have a total of xx coins available for minning. ';
  final missions = [
    'To make the minning process easier and more affordable',
    'To make the minning process easier and more affordable',
    'To make the minning process easier and more affordable',
  ];
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final bodyText1 = textTheme.bodyText1!;
    final bodyText2 = textTheme.bodyText2!;
    const spacer = SizedBox(
      height: kDefaultMargin * 2,
    );

    return Scaffold(
      appBar: buildAppBar(bodyText1, bodyText2),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(0),
        children: [
          Container(
            width: double.infinity,
            margin: const EdgeInsets.all(kDefaultMargin),
            alignment: Alignment.center,
            child: Image.asset(
              'assets/images/mini_logo.png',
              height: 100,
              fit: BoxFit.fitHeight,
            ),
          ),
          Card(
            elevation: 2,
            margin: const EdgeInsets.only(
                left: kDefaultMargin / 2, right: kDefaultMargin / 2),
            child: Padding(
              padding: const EdgeInsets.all(kDefaultPadding / 2),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'About Us',
                    style: bodyText1,
                  ),
                  const SizedBox(
                    height: kDefaultMargin / 2,
                  ),
                  Text(
                    aboutUs,
                    style: bodyText2,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(
            height: kDefaultMargin,
          ),
          Card(
            elevation: 2,
            margin: const EdgeInsets.only(
                left: kDefaultMargin / 2, right: kDefaultMargin / 2),
            child: Padding(
              padding: const EdgeInsets.all(kDefaultPadding / 2),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Our Mission',
                    style: bodyText1,
                  ),
                  const SizedBox(
                    height: kDefaultMargin / 2,
                  ),
                  ...missions
                      .map((mission) => Padding(
                            padding: const EdgeInsets.only(
                                bottom: kDefaultPadding / 4),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Container(
                                  width: 20,
                                  height: 20,
                                  decoration: BoxDecoration(
                                      color: kPrimaryColor,
                                      borderRadius: BorderRadius.circular(20)),
                                ),
                                const SizedBox(
                                  width: kDefaultMargin / 2,
                                ),
                                Expanded(
                                  child: Text(
                                    mission,
                                    style: bodyText2,
                                  ),
                                ),
                              ],
                            ),
                          ))
                      .toList(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  AppBar buildAppBar(TextStyle? bodyText1, TextStyle bodyText2) {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.transparent,
      title: Text(
        'About Us',
        style: bodyText1,
      ),
      leading: const BackButton(
        color: Colors.black,
      ),
    );
  }
}
