import 'package:flutter/material.dart';

import 'constants.dart';

class CustomOutlinedButton extends StatelessWidget {
  final VoidCallback onPressed;
  final Widget widget;

  const CustomOutlinedButton(
      {Key? key, required this.onPressed, required this.widget})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: kPrimaryColor, width: 1),
        ),
        onPressed: onPressed,
        child: Padding(
          padding: const EdgeInsets.only(
              top: kDefaultPadding, bottom: kDefaultPadding),
          child: widget,
        ),
      ),
    );
  }
}
