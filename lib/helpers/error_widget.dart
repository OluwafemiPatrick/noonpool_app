import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class CustomErrorWidget extends StatelessWidget {
  final String error;
  final VoidCallback onRefresh;
  const CustomErrorWidget(
      {Key? key, required this.error, required this.onRefresh})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final bodyText1 = textTheme.bodyText1!;
    return Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(
            width: double.infinity,
          ),
          const Spacer(flex: 1),
          Lottie.asset(
            'assets/lottie/error.json',
            width: 200,
            animate: true,
            reverse: true,
            repeat: true,
            height: 200,
            fit: BoxFit.contain,
          ),
          Text(
            error,
            style: bodyText1,
          ),
          const Spacer(flex: 2),
        ]);
  }
}
