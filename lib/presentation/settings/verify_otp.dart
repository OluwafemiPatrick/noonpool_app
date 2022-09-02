import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:noonpool/helpers/constants.dart';
import 'package:noonpool/helpers/elevated_button.dart';
import 'package:noonpool/main.dart';
import 'package:otp/otp.dart';
import 'package:pinput/pinput.dart';

class VerifyOtp extends StatefulWidget {
  final VoidCallback onNext;
  final bool backEnaled;
  const VerifyOtp({
    Key? key,
    required this.onNext,
    this.backEnaled = true,
  }) : super(key: key);

  @override
  State<VerifyOtp> createState() => _VerifyOtpState();
}

class _VerifyOtpState extends State<VerifyOtp> {
  final otpFieldController = TextEditingController(text: "");
  final _formKey = GlobalKey<FormState>();
  late StreamSubscription _twoFASubscription;
  dynamic _currentOtp;
  final otpStream = Stream<dynamic>.periodic(
    const Duration(seconds: 0),
    (val) => OTP.generateTOTPCodeString(
        'JBSWY3DPEHPK3PXP', DateTime.now().millisecondsSinceEpoch,
        length: 6, interval: 30, algorithm: Algorithm.SHA1, isGoogle: true),
  ).asBroadcastStream();
  @override
  void initState() {
    _twoFASubscription = otpStream.listen((event) {
      _currentOtp = event;
    });
    super.initState();
  }

  @override
  void dispose() {
    _twoFASubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final bodyText2 = textTheme.bodyText2;
    final bodyText1 = textTheme.bodyText1;
    return Scaffold(
      appBar: buildAppBar(bodyText1),
      body: buildBody(bodyText2, bodyText1),
    );
  }

  AppBar buildAppBar(TextStyle? bodyText1) {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.transparent,
      title: Text(
        AppLocalizations.of(context)!.verifyCode,
        style: bodyText1?.copyWith(fontWeight: FontWeight.bold),
      ),
      leading: widget.backEnaled
          ? const BackButton(
              color: Colors.black,
            )
          : const SizedBox(
              width: 0,
              height: 0,
            ),
    );
  }

  buildProgressBar() {
    return const Center(
      child: SizedBox(
        height: 50,
        width: 50,
        child: CircularProgressIndicator.adaptive(
          backgroundColor: kLightBackgroud,
        ),
      ),
    );
  }

  Widget buildBody(TextStyle? bodyText2, TextStyle? bodyText1) {
    return Padding(
      padding: const EdgeInsets.only(top: 10, left: 20, right: 20),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(
              height: 20,
            ),
            SvgPicture.asset(
              'assets/icons/security.svg',
              height: 250,
              width: 250,
            ),
            Text(
              AppLocalizations.of(context)!
                  .toProceedPleaseEnterTheCodeFromTheGoogleAuthenticatorApplication,
              textAlign: TextAlign.center,
              style: bodyText1,
            ),
            const SizedBox(
              height: 20,
            ),
            buildOTPField(bodyText2!),
            const SizedBox(
              height: 20,
            ),
            CustomElevatedButton(
              widget: Text(
                AppLocalizations.of(context)!.verify,
                style: bodyText2.copyWith(
                  color: Colors.white,
                ),
              ),
              onPressed: () async {
                final isValid = _formKey.currentState?.validate();
                if ((isValid ?? false) == false) {
                  return;
                }

                final otp = otpFieldController.text.trim();

                if (otp == _currentOtp) {
                  Navigator.pop(context);
                  widget.onNext();
                } else {
                  MyApp.scaffoldMessengerKey.currentState?.showSnackBar(
                      SnackBar(
                          content: Text(AppLocalizations.of(context)!
                              .theCodeEnteredDoesNotMatch)));
                }
              },
            ),
            const SizedBox(
              height: 30,
            ),
          ],
        ),
      ),
    );
  }

  Widget buildOTPField(TextStyle bodyText2) {
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

    return Form(
      key: _formKey,
      child: Pinput(
        length: 6,
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
            return AppLocalizations.of(context)!.pleaseEnterThePinYouRecieved;
          } else if (s.trim().length < 4) {
            return AppLocalizations.of(context)!.pleaseEnterTheCompletePin;
          }
          return null;
        },
      ),
    );
  }
}
