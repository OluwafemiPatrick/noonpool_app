import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:noonpool/helpers/constants.dart';
import 'package:noonpool/helpers/elevated_button.dart';
import 'package:noonpool/helpers/network_helper.dart';
import 'package:noonpool/helpers/page_route.dart';
import 'package:noonpool/helpers/text_button.dart';
import 'package:pinput/pinput.dart';
import 'package:noonpool/main.dart';
import '../login/login_sceen.dart';

class VerifyUserAccount extends StatefulWidget {
  const VerifyUserAccount({
    Key? key,
  }) : super(key: key);

  @override
  _VerifyUserAccountState createState() => _VerifyUserAccountState();
}

class _VerifyUserAccountState extends State<VerifyUserAccount> {
  bool _isLoading = false;
  final otpFieldController = TextEditingController(text: "");
  final _formKey = GlobalKey<FormState>();

  List<Widget> buildOTPField(TextStyle bodyText2) {
    final defaultPinTheme = PinTheme(
      width: 56,
      height: 56,
      textStyle: const TextStyle(
          fontSize: 20,
          color: Color.fromRGBO(30, 60, 87, 1),
          fontWeight: FontWeight.w600),
      decoration: BoxDecoration(
        border: Border.all(color: const Color.fromRGBO(234, 239, 243, 1)),
        borderRadius: BorderRadius.circular(20),
      ),
    );

    final focusedPinTheme = defaultPinTheme.copyDecorationWith(
      border: Border.all(color: kPrimaryColor),
      borderRadius: BorderRadius.circular(8),
    );

    final submittedPinTheme = defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration?.copyWith(
        color: const Color.fromRGBO(234, 239, 243, 1),
      ),
    );
    final errorPinTheme = defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration?.copyWith(
        border: Border.all(color: Colors.red),
      ),
    );

    return [
      Pinput(
        defaultPinTheme: defaultPinTheme,
        errorPinTheme: errorPinTheme,
        errorTextStyle: bodyText2.copyWith(
          color: Colors.red,
        ),
        focusedPinTheme: focusedPinTheme,
        submittedPinTheme: submittedPinTheme,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        controller: otpFieldController,
        pinputAutovalidateMode: PinputAutovalidateMode.onSubmit,
        showCursor: true,
        validator: (s) {
          if (s == null || s.isEmpty) {
            return "Please enter the pin you recieved";
          } else if (s.trim().length < 4) {
            return "Please enter the complete pin";
          }
          return null;
        },
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final bodyText2 = textTheme.bodyText2!;
    final bodyText1 = textTheme.bodyText1!;
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(left: 10, right: 10),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Spacer(),
                SvgPicture.asset(
                  'assets/icons/Mail.svg',
                  height: 250,
                  width: 250,
                  fit: BoxFit.contain,
                ),
                const SizedBox(
                  height: kDefaultMargin,
                ),
                Align(
                  alignment: Alignment.center,
                  child: Text(
                    "Please enter the OTP that was sent to your account.",
                    style: bodyText1,
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(
                  height: kDefaultMargin,
                ),
                ...buildOTPField(bodyText2),
                const SizedBox(
                  height: kDefaultMargin * 2,
                ),
                CustomElevatedButton(
                  widget: _isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator.adaptive(
                            backgroundColor: Colors.white,
                          ),
                        )
                      : Text(
                          'Verify OTP',
                          style: bodyText2.copyWith(color: Colors.white),
                        ),
                  onPressed: () async {
                    final isValid = _formKey.currentState?.validate();
                    if ((isValid ?? false) == false || _isLoading) {
                      return;
                    }
                    setState(() {
                      _isLoading = true;
                    });
                    try {
                      final email = ((ModalRoute.of(context)
                              ?.settings
                              .arguments) as String?) ??
                          '';
                      final code = otpFieldController.text.trim();
                      await verifyUserOTP(
                        email: email,
                        code: code,
                      );
                      MyApp.scaffoldMessengerKey.currentState?.showSnackBar(
                        const SnackBar(
                          content: Text(
                            "Your account has been verified, please proceed to login.",
                          ),
                        ),
                      );
                      Navigator.of(context).pushAndRemoveUntil(
                          CustomPageRoute(
                            screen: const LoginScreen(),
                          ),
                          (route) => route.isFirst);
                    } catch (exception) {
                      MyApp.scaffoldMessengerKey.currentState?.showSnackBar(
                        SnackBar(
                          content: Text(
                            exception.toString(),
                          ),
                        ),
                      );
                    }
                    setState(() {
                      _isLoading = false;
                    });
                  },
                ),
                const SizedBox(
                  height: kDefaultMargin / 2,
                ),
                SizedBox(
                  child: CustomTextButton(
                    onPressed: showResendDialog,
                    widget: const Text(
                      'Resend OTP',
                    ),
                  ),
                ),
                const Spacer(),
              ],
            ),
          ),
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
            borderRadius: const BorderRadius.all(Radius.circular(10))),
        padding: const EdgeInsets.all(10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(
              height: 40,
              width: 40,
              child: CircularProgressIndicator.adaptive(
                backgroundColor: Colors.white,
              ),
            ),
            const SizedBox(
              height: 20,
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

    try {
      final email =
          ((ModalRoute.of(context)?.settings.arguments) as String?) ?? '';

      await sendUserOTP(
        email: email,
      );
      Navigator.of(context).pop();
      ScaffoldMessenger.maybeOf(context)?.showSnackBar(
        const SnackBar(
          content: Text(
            'A new OTP has been sent to your account',
          ),
        ),
      );
    } catch (exception) {
      Navigator.of(context).pop();
      ScaffoldMessenger.maybeOf(context)?.showSnackBar(
        SnackBar(
          content: Text(
            exception.toString(),
          ),
        ),
      );
      //
    }
  }
}
