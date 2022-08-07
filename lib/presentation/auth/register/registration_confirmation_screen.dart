import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:noonpool/presentation/auth/register/verify_user_account.dart';

import '../../../helpers/constants.dart';
import '../../../helpers/elevated_button.dart';
import '../../../helpers/firebase_util.dart';
import '../../../helpers/page_route.dart';
import '../../../helpers/text_button.dart';

class RegistrationConfirmationScreen extends StatefulWidget {
  const RegistrationConfirmationScreen({Key? key}) : super(key: key);

  @override
  _RegistrationConfirmationScreenState createState() =>
      _RegistrationConfirmationScreenState();
}

class _RegistrationConfirmationScreenState
    extends State<RegistrationConfirmationScreen> {
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final bodyText2 = textTheme.bodyText2;
    final bodyText1 = textTheme.bodyText1;

    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.all(kDefaultPadding),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Spacer(),
            SvgPicture.asset(
              'assets/icons/Mail.svg',
              semanticsLabel: 'authorize new device',
              height: 280,
              width: 280,
            ),
            const SizedBox(
              height: kDefaultMargin,
            ),
            Text(
              "Verify your mail",
              style: bodyText1,
              textAlign: TextAlign.center,
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              "We have sent a OTP to your mail. Kindly click on proceed when you recieve it.",
              style: bodyText2,
              textAlign: TextAlign.center,
            ),
            const Spacer(),
            CustomElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                  CustomPageRoute(
                    screen: const VerifyUserAccount(),
                  ),
                );
              },
              widget: Text(
                'Verify OTP',
                style: bodyText2!.copyWith(
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(
              height: kDefaultMargin / 2,
            ),
            CustomTextButton(
              onPressed: showResendDialog,
              widget: const Text(
                'Resend OTP',
              ),
            ),
          ],
        ),
      ),
    );
  }

  void showResendDialog() async {
    final textTheme = Theme.of(context).textTheme;
    final bodyText2 = textTheme.bodyText2;
    Dialog dialog = Dialog(
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10))),
      elevation: 5,
      child: Container(
        decoration: BoxDecoration(
            color: Theme.of(context).canvasColor,
            borderRadius: const BorderRadius.all(Radius.circular(15))),
        padding: const EdgeInsets.all(30),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(
              height: 50,
              width: 50,
              child: CircularProgressIndicator.adaptive(
                backgroundColor: Colors.white,
              ),
            ),
            const SizedBox(
              height: 40,
            ),
            Text(
              'Resending Verification, please wait',
              style: bodyText2,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
    showGeneralDialog(
      context: context,
      barrierLabel: "Resend Verification",
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.5),
      transitionDuration: const Duration(milliseconds: 500),
      pageBuilder: (_, __, ___) => dialog,
      transitionBuilder: (_, anim, __, child) => FadeTransition(
        opacity: Tween(begin: 0.0, end: 1.0).animate(anim),
        child: child,
      ),
    );

    final accountDetails =
        (ModalRoute.of(context)!.settings.arguments) as Map<String, String>;
    final String response = await resendVerification(
        email: accountDetails['email'] ?? '',
        password: accountDetails['password'] ?? '');

    Navigator.of(context).pop();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(response),
      ),
    );
  }
}
