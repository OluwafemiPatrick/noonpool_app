import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:noonpool/helpers/elevated_button.dart';
import 'package:noonpool/helpers/network_helper.dart';
import 'package:noonpool/main.dart';
import '../../../helpers/constants.dart';

class ForgotPasswordStage1 extends StatefulWidget {
  final Function(String) navigateNext;
  const ForgotPasswordStage1({
    Key? key,
    required this.navigateNext,
  }) : super(key: key);

  @override
  State<ForgotPasswordStage1> createState() => _ForgotPasswordStage1State();
}

class _ForgotPasswordStage1State extends State<ForgotPasswordStage1> {
  final _emailController = TextEditingController();

  final stage1FormKey = GlobalKey<FormState>();
  bool _isLoading = false;
  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  List<Widget> buildEmailField(TextStyle bodyText2) {
    return [
      const SizedBox(height: 5),
      TextFormField(
        controller: _emailController,
        keyboardType: TextInputType.emailAddress,
        textInputAction: TextInputAction.done,
        style: bodyText2,
        decoration: InputDecoration(
          labelText: AppLocalizations.of(context)!.email,
          hintText: AppLocalizations.of(context)!.pleaseEnterYourEmailAddress,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Colors.red),
          ),
        ),
        validator: (value) {
          bool emailValid = RegExp(
                  r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@+[a-zA-Z0-9]+\.[a-zA-Z]")
              .hasMatch(value ?? "");

          if (value == null || value.isEmpty) {
            return AppLocalizations.of(context)!.pleaseProvideYourEmail;
          } else if (!emailValid) {
            return AppLocalizations.of(context)!.pleaseProvideAValidEmail;
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
      padding: const EdgeInsets.only(left: 10, right: 10),
      child: Form(
        key: stage1FormKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: kDefaultMargin,
              width: double.infinity,
            ),
            Center(
              child: SvgPicture.asset(
                'assets/icons/forgot_password.svg',
                semanticsLabel: 'auth',
                height: 250,
                width: 250,
              ),
            ),
            const SizedBox(
              height: kDefaultMargin,
            ),
            Text(AppLocalizations.of(context)!.emailVerification,
                style: bodyText1.copyWith(
                  fontWeight: FontWeight.bold,
                )),
            const SizedBox(height: (5)),
            Text(
              AppLocalizations.of(context)!
                  .kindlyEnterYourEmailAndWellSendHelpYouRecoverYourPassword,
              style: bodyText2,
            ),
            const SizedBox(height: (20)),
            ...buildEmailField(bodyText2),
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
                      AppLocalizations.of(context)!.submit,
                      style: bodyText2.copyWith(
                        color: Colors.white,
                      ),
                    ),
              onPressed: () async {
                final isValid = stage1FormKey.currentState?.validate();
                if ((isValid ?? false) == false || _isLoading) {
                  return;
                }

                sendOTP();
              },
            ),
          ],
        ),
      ),
    );
  }

  sendOTP() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final String email = _emailController.text.trim();
      await sendUserOTP(
        email: email,
      );
      () {
        MyApp.scaffoldMessengerKey.currentState?.showSnackBar(
          SnackBar(
              content: Text(AppLocalizations.of(context)!
                  .aVerificationOtpHasBeenSentToYourMail)),
        );
      }();
      widget.navigateNext(
        email,
      );
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
