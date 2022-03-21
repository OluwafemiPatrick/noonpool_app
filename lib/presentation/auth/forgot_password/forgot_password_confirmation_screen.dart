import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../helpers/constants.dart';
import '../../../helpers/elevated_buton.dart';
import '../../../helpers/page_route.dart';
import '../login/login_sceen.dart';

class ForgotPasswordConfirmationScreen extends StatefulWidget {
  const ForgotPasswordConfirmationScreen({Key? key}) : super(key: key);

  @override
  _ForgotPasswordConfirmationScreenState createState() =>
      _ForgotPasswordConfirmationScreenState();
}

class _ForgotPasswordConfirmationScreenState
    extends State<ForgotPasswordConfirmationScreen> {
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final bodyText2 = textTheme.bodyText2;

    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.all(kDefaultPadding),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Spacer(),
            SvgPicture.asset(
              'assets/icons/forgot_password_3.svg',
              height: 300,
              width: 300,
            ),
            const SizedBox(
              height: kDefaultMargin,
            ),
            Text(
              "A password reset link has been sent to your mail",
              style: bodyText2,
              textAlign: TextAlign.center,
            ),
            const Spacer(),
            CustomElevatedButton(
              onPressed: () {
                Navigator.of(context).pushAndRemoveUntil(
                    CustomPageRoute(
                      screen: const LoginScreen(),
                    ),
                    (route) => route.isFirst);
              },
              widget: Text(
                'Sign In',
                style: bodyText2!.copyWith(color: Colors.white),
              ),
            )
          ],
        ),
      ),
    );
  }
}
