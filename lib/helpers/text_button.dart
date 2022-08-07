import 'package:flutter/material.dart';

class CustomTextButton extends StatelessWidget {
  final VoidCallback onPressed;
  final Widget widget;
  final bool isFullWidth;

  const CustomTextButton(
      {Key? key,
      required this.onPressed,
      required this.widget,
      this.isFullWidth = true})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final bodyText2 = textTheme.bodyText2;
    return isFullWidth
        ? SizedBox(
            width: double.infinity,
            child: TextButton(
              style: TextButton.styleFrom(textStyle: bodyText2),
              onPressed: onPressed,
              child: widget,
            ),
          )
        : TextButton(
            style: TextButton.styleFrom(textStyle: bodyText2),
            onPressed: onPressed,
            child: widget,
          );
  }
}
