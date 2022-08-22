import 'package:flutter/material.dart';

import 'constants.dart';

class CustomOutlinedButton extends StatelessWidget {
  final VoidCallback onPressed;
  final Widget widget;
  final EdgeInsets padding;
  final bool isFullWidth;

  const CustomOutlinedButton({
    Key? key,
    required this.onPressed,
    required this.widget,
    this.isFullWidth = true,
    this.padding = const EdgeInsets.only(
      top: kDefaultPadding / 1.5,
      bottom: kDefaultPadding / 1.5,
    ),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return isFullWidth
        ? SizedBox(
            width: double.infinity,
            child: button(),
          )
        : button();
  }

  OutlinedButton button() {
    return OutlinedButton(
      style: OutlinedButton.styleFrom(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(8),
          ),
        ),
        side: const BorderSide(color: kPrimaryColor, width: 1),
      ),
      onPressed: onPressed,
      child: Padding(
        padding: padding,
        child: widget,
      ),
    );
  }
}
