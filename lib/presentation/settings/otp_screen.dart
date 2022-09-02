import 'dart:async';

import 'package:flutter/material.dart';
import 'package:noonpool/helpers/constants.dart';
import 'package:noonpool/helpers/elevated_button.dart';
import 'package:noonpool/helpers/shared_preference_util.dart';
import 'package:noonpool/main.dart';
import 'package:otp/otp.dart';
import 'package:pinput/pinput.dart';
import 'package:qr_flutter/qr_flutter.dart';

class OtpScreen extends StatefulWidget {
  final bool isFromLogin;
  final VoidCallback? onNext;
  const OtpScreen({
    Key? key,
    this.isFromLogin = false,
    this.onNext,
  }) : super(key: key);

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
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
      body: buildBody(bodyText2),
    );
  }

  AppBar buildAppBar(TextStyle? bodyText1) {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.transparent,
      title: Text(
        AppLocalizations.of(context)!.enableAuthentication,
        style: bodyText1?.copyWith(fontWeight: FontWeight.bold),
      ),
      leading: const BackButton(
        color: Colors.black,
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

  Widget buildBody(TextStyle? bodyText2) {
    return Padding(
      padding: const EdgeInsets.only(top: 10, left: 20, right: 20),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              AppLocalizations.of(context)!
                  .pleaseDownloadTheApplicationGoogleAuthenticatorOnYourMobileDeviceAndScanTheCode,
              textAlign: TextAlign.center,
              style: bodyText2,
            ),
            const SizedBox(
              height: 10,
            ),
            buildQrCode(bodyText2),
            const SizedBox(
              height: 20,
            ),
            Text(
              AppLocalizations.of(context)!
                  .pleaseEnterTheGeneratedCodeBelowANewCodeWillBeGeneratedAutomaticallyEvery30Seconds,
              textAlign: TextAlign.center,
              style: bodyText2,
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
                AppLocalizations.of(context)!.enable2fa,
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
                  MyApp.scaffoldMessengerKey.currentState?.showSnackBar(
                      SnackBar(
                          content: Text(AppLocalizations.of(context)!
                              .enabledSuccessfully)));
                  //todo update settings to true on the backend ;
                  AppPreferences.set2faSecurity(isEnabled: true);
                  Navigator.pop(context);
                  if (widget.isFromLogin) {
                    widget.onNext!();
                  }
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

  Card buildQrCode(TextStyle? bodyText2) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.all(20),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            QrImage(
              data:
                  'otpauth://totp/com.noonpool.app?Algorithm=SHA1&digits=6&secret=JBSWY3DPEHPK3PXP&issuer=Noonpool&period=30',
              version: QrVersions.auto,
              size: 250,
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              '',
              textAlign: TextAlign.center,
              style: bodyText2,
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
