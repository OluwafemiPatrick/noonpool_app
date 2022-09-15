import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:noonpool/helpers/constants.dart';
import 'package:noonpool/helpers/elevated_button.dart';
import 'package:noonpool/helpers/network_helper.dart';
import 'package:pinput/pinput.dart';
import 'package:noonpool/main.dart';

class ChangePasswordStage1 extends StatefulWidget {
  final VoidCallback navigateNext;
  final String email;
  const ChangePasswordStage1(
      {Key? key, required this.navigateNext, required this.email})
      : super(key: key);

  @override
  State<ChangePasswordStage1> createState() => _ChangePasswordStage1State();
}

class _ChangePasswordStage1State extends State<ChangePasswordStage1> {
  final stage2FormKey = GlobalKey<FormState>();
  final _otpFieldController = TextEditingController();
  bool _isLoading = false;
  @override
  void dispose() {
    _otpFieldController.dispose();
    super.dispose();
  }

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
      border: Border.all(
        color: kPrimaryColor,
      ),
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
        focusedPinTheme: focusedPinTheme,
        submittedPinTheme: submittedPinTheme,
        errorTextStyle: bodyText2.copyWith(
          color: Colors.red,
        ),
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        controller: _otpFieldController,
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
      const SizedBox(
        height: 10,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final bodyText2 = textTheme.bodyText2!;
    final bodyText1 = textTheme.bodyText1!;
    return SingleChildScrollView(
      padding: const EdgeInsets.all(kDefaultPadding / 2),
      child: Form(
        key: stage2FormKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: kDefaultMargin * 2,
              width: double.infinity,
            ),
            Center(
              child: SvgPicture.asset(
                'assets/icons/Mail.svg',
                semanticsLabel: 'authorize new device',
                height: 280,
                width: 280,
              ),
            ),
            const SizedBox(
              height: kDefaultMargin * 2,
            ),
            Text(AppLocalizations.of(context)!.otpVerification,
                style: bodyText1.copyWith(
                  fontWeight: FontWeight.bold,
                )),
            const SizedBox(height: (5)),
            Text(
              AppLocalizations.of(context)!.enterTheOtpThatWasSentToYourAccount,
              style: bodyText2,
              textAlign: TextAlign.center,
            ),
            const SizedBox(
              height: (20),
              width: double.infinity,
            ),
            ...buildOTPField(bodyText2),
            const SizedBox(
              height: 10,
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
                      AppLocalizations.of(context)!.verify,
                      style: bodyText2.copyWith(color: Colors.white),
                    ),
              onPressed: () {
                final isValid = stage2FormKey.currentState?.validate();
                if ((isValid ?? false) == false || _isLoading) {
                  return;
                }

                verifyOtp();
              },
            ),
          ],
        ),
      ),
    );
  }

  verifyOtp() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final code = _otpFieldController.text.trim();
      await verifyUserOTP(
        email: widget.email,
        code: code,
      );
      widget.navigateNext();
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
  }
}
