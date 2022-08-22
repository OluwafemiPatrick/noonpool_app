import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:noonpool/helpers/outlined_button.dart';

import 'constants.dart';

class CustomErrorWidget extends StatelessWidget {
  final String error;
  final VoidCallback onRefresh;
  const CustomErrorWidget({
    Key? key,
    required this.error,
    required this.onRefresh,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final bodyText1 = textTheme.bodyText1!;
    final bodyText2 = textTheme.bodyText2!;
    return Padding(
      padding: const EdgeInsets.all(kDefaultPadding / 2),
      child: Column(
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
            const Spacer(flex: 1),
            CustomOutlinedButton(
              onPressed: () {
                onRefresh();
              },
              widget: Text(
                'Refresh',
                style: bodyText2.copyWith(
                  color: kPrimaryColor,
                ),
              ),
            ),
            const Spacer(flex: 2),
          ]),
    );
  }
}
