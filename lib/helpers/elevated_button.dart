import 'package:flutter/material.dart';

import 'constants.dart';

class CustomElevatedButton extends StatelessWidget {
  final VoidCallback onPressed;
  final Widget widget;

  const CustomElevatedButton(
      {Key? key, required this.onPressed, required this.widget})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          primary: kPrimaryColor,
          elevation: 3,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(8)),
          ),
        ),
        onPressed: onPressed,
        child: Padding(
          padding: const EdgeInsets.only(
              top: kDefaultPadding / 1.5, bottom: kDefaultPadding / 1.5),
          child: widget,
        ),
      ),
    );
  }
}
