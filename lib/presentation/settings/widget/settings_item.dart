import 'package:flutter/material.dart';

import '../../../helpers/constants.dart';
import '../../../helpers/svg_image.dart';

class SettingsItem extends StatelessWidget {
  final String title;
  final String iconLocation;
  final VoidCallback onPressed;

  const SettingsItem(
      {Key? key,
      required this.onPressed,
      required this.title,
      required this.iconLocation})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    final bodyText2 = textTheme.bodyText2!;
    return InkWell(
      onTap: onPressed,
      child: Padding(
        padding: const EdgeInsets.all(kDefaultMargin / 4),
        child: Row(
          children: [
            Container(
              width: 40,
              alignment: Alignment.center,
              height: 40,
              clipBehavior: Clip.antiAliasWithSaveLayer,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(40),
                color: kLightBackgroud,
              ),
              child: SvgImage(
                  iconLocation: iconLocation,
                  name: title,
                  color: kPrimaryColor),
            ),
            const SizedBox(width: kDefaultMargin / 4),
            Expanded(
              child: Text(title, style: bodyText2),
            ),
            const SizedBox(width: kDefaultMargin / 4),
            const Icon(Icons.navigate_next, color: kPrimaryColor)
          ],
        ),
      ),
    );
  }
}

class SettingsItem2 extends StatelessWidget {
  final String title;
  final IconData iconLocation;
  final Function(bool) onPressed;
  final bool value;

  const SettingsItem2(
      {Key? key,
      required this.onPressed,
      required this.title,
      required this.value,
      required this.iconLocation})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    final bodyText2 = textTheme.bodyText2!;
    return InkWell(
      splashColor: Colors.transparent,
      onTap: () => onPressed(!value),
      child: Padding(
        padding: const EdgeInsets.all(kDefaultMargin / 4),
        child: Row(
          children: [
            Container(
              width: 40,
              alignment: Alignment.center,
              height: 40,
              clipBehavior: Clip.antiAliasWithSaveLayer,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(40),
                color: kLightBackgroud,
              ),
              child: Icon(iconLocation, color: kPrimaryColor),
            ),
            const SizedBox(width: kDefaultMargin / 4),
            Expanded(
              child: Text(title, style: bodyText2),
            ),
            const SizedBox(width: kDefaultMargin / 4),
            Switch.adaptive(
              value: value,
              onChanged: onPressed,
              activeColor: kPrimaryColor,
            )
          ],
        ),
      ),
    );
  }
}
