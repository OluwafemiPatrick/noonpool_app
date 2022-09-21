import 'package:flutter/material.dart';
import 'package:noonpool/helpers/elevated_button.dart';
import 'package:noonpool/helpers/network_helper.dart';
import 'package:noonpool/helpers/outlined_button.dart';
import 'package:noonpool/presentation/auth/forgot_password/forgot_password.dart';
import 'package:noonpool/presentation/auth/register/register_sceen.dart';

import 'package:noonpool/main.dart';
import 'package:noonpool/presentation/language/language_changer.dart';
import 'package:noonpool/presentation/settings/verify_otp.dart';
import '../../../helpers/constants.dart';
import '../../../helpers/page_route.dart';
import '../../../helpers/shared_preference_util.dart';
import '../../main/main_screen.dart';
import '../register/verify_user_account.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  static const _email = "email";
  static const _password = "password";
  bool _isHidden = true;
  bool _isLoading = false;

  final _passwordFocusNode = FocusNode();
  final _formKey = GlobalKey<FormState>();
  final Map<String, dynamic> _initValues = {_email: '', _password: ''};

  @override
  void dispose() {
    _passwordFocusNode.dispose();
    super.dispose();
  }

  void _saveForm() {
    final isValid = _formKey.currentState?.validate();
    if ((isValid ?? false) == false || _isLoading) {
      return;
    }
    _formKey.currentState?.save();
    showLoginStatus();
  }

  Future showLoginStatus() async {
    final email = _initValues[_email].trim();
    final password = _initValues[_password].trim();

    setState(() {
      _isLoading = true;
    });

    try {
      final loginDetails = await signInToUserAccount(
        email: email,
        password: password,
      );

      if (loginDetails.userDetails == null ||
          loginDetails.userDetails!.verified == null ||
          loginDetails.userDetails!.id == null) {
        MyApp.scaffoldMessengerKey.currentState?.showSnackBar(SnackBar(
            content: Text(
                AppLocalizations.of(context)!.anErrorOccurredWhileLogginIn)));
        return;
      }

      if (loginDetails.userDetails!.verified!) {
        proceed() {
          AppPreferences.setUserName(
              username: loginDetails.userDetails?.username ?? '');
          AppPreferences.setUserLoginData(
              id: loginDetails.userDetails?.id ?? '',
              email: loginDetails.userDetails?.email ?? '',
              currentLoginKey: loginDetails.userDetails?.loginKey ?? '');
          AppPreferences.setLoginStatus(status: true);
          AppPreferences.setOnBoardingStatus(status: true);
          AppPreferences.set2faSecurityStatus(
            isEnabled: loginDetails.userDetails!.g2FAEnabled ?? false,
          );

          Navigator.of(context).pushAndRemoveUntil(
            CustomPageRoute(
              screen: const MainScreen(),
            ),
            (route) => false,
          );
        }

        if (loginDetails.userDetails!.g2FAEnabled == true) {
          Navigator.of(context).push(
            CustomPageRoute(
              screen: VerifyOtp(
                backEnaled: false,
                onNext: (_) => proceed(),
                id: loginDetails.userDetails!.id ?? '',
              ),
            ),
          );
        } else {
          proceed();
        }
      } else {
        showVerificationDialog();
      }
    } catch (exception) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(exception.toString())));
    }
    setState(() {
      _isLoading = false;
    });
  }

  void showVerificationDialog() {
    //show verification status
    final textTheme = Theme.of(context).textTheme;
    final bodyText2 = textTheme.bodyText2;
    Dialog dialog = Dialog(
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(5))),
      elevation: 5,
      child: Container(
        decoration: BoxDecoration(
            color: Theme.of(context).canvasColor,
            borderRadius: const BorderRadius.all(Radius.circular(8))),
        padding: const EdgeInsets.all(kDefaultMargin / 2),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.error,
              color: Colors.red,
              size: 150,
            ),
            const SizedBox(
              height: kDefaultMargin,
            ),
            Text(
              AppLocalizations.of(context)!.emailNotVerifiedClickToVerify,
              style: bodyText2,
              textAlign: TextAlign.center,
            ),
            const SizedBox(
              height: kDefaultMargin,
            ),
            CustomOutlinedButton(
              onPressed: () {
                Navigator.of(context).pop();
                showResendDialog();
              },
              widget: Text(
                AppLocalizations.of(context)!.resendVerificatoinLink,
                style: bodyText2!.copyWith(
                  color: kPrimaryColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
    showGeneralDialog(
      context: context,
      barrierLabel: "Verification Dialog",
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.5),
      transitionDuration: const Duration(milliseconds: 500),
      pageBuilder: (_, __, ___) => dialog,
      transitionBuilder: (_, anim, __, child) => FadeTransition(
        opacity: Tween(begin: 0.0, end: 1.0).animate(anim),
        child: child,
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
              AppLocalizations.of(context)!.resendVerificatoinLink,
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
      barrierDismissible: false,
      barrierColor: Colors.black.withOpacity(0.5),
      transitionDuration: const Duration(milliseconds: 500),
      pageBuilder: (_, __, ___) => dialog,
      transitionBuilder: (_, anim, __, child) => FadeTransition(
        opacity: Tween(begin: 0.0, end: 1.0).animate(anim),
        child: child,
      ),
    );

    final email = _initValues[_email].trim();

    try {
      await sendUserOTP(email: email);

      Navigator.of(context).pop();
      MyApp.scaffoldMessengerKey.currentState?.showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!.aNewOtpHasBeenSentToMail),
        ),
      );
      Navigator.of(context).push(
        CustomPageRoute(
          screen: const VerifyUserAccount(),
          argument: email,
        ),
      );
    } catch (exception) {
      Navigator.of(context).pop();
      MyApp.scaffoldMessengerKey.currentState?.showSnackBar(
        SnackBar(
          content: Text(exception.toString()),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    final bodyText1 = themeData.textTheme.bodyText1!;
    final bodyText2 = themeData.textTheme.bodyText2!;

    return Scaffold(
      appBar: buildAppBar(bodyText1),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(kDefaultPadding / 2),
          child: SingleChildScrollView(
              child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: kDefaultMargin,
                ),
                ...buildEmailTextField(bodyText2),
                const SizedBox(
                  height: kDefaultMargin / 2,
                ),
                ...buildPasswordTextField(bodyText2),
                const SizedBox(
                  height: kDefaultMargin * 2,
                ),
                buildSignInButton(bodyText2),
                const SizedBox(
                  height: kDefaultMargin / 2,
                ),
                buildForgotPassword(bodyText2),
                const SizedBox(
                  height: kDefaultMargin / 2,
                ),
                buildRegisterButton(bodyText2),
                const SizedBox(
                  height: kDefaultMargin / 2,
                ),
                buildLanuguageButton(bodyText2),
              ],
            ),
          )),
        ),
      ),
    );
  }

  Container buildLanuguageButton(TextStyle bodyText2) {
    return Container(
      alignment: Alignment.center,
      child: TextButton(
        onPressed: () {
          Navigator.of(context).push(CustomPageRoute(
            screen: const LanguageChanger(),
          ));
        },
        child: Text(
          AppLocalizations.of(context)!.language,
        ),
        style: TextButton.styleFrom(
          textStyle: bodyText2,
        ),
      ),
    );
  }

  AppBar buildAppBar(TextStyle bodyText1) {
    return AppBar(
      leading: const BackButton(
        color: Colors.black,
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      title: Text(
        AppLocalizations.of(context)!.signIn,
        style: bodyText1,
      ),
    );
  }

  CustomElevatedButton buildSignInButton(TextStyle bodyText2) {
    return CustomElevatedButton(
      onPressed: () {
        _saveForm();
      },
      widget: _isLoading
          ? const SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator.adaptive(
                backgroundColor: Colors.white,
              ),
            )
          : Text(
              AppLocalizations.of(context)!.signIn,
              style: bodyText2.copyWith(color: Colors.white),
            ),
    );
  }

  List<Widget> buildEmailTextField(TextStyle bodyText2) {
    return [
      TextFormField(
        textInputAction: TextInputAction.next,
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
        style: bodyText2,
        onFieldSubmitted: (_) {
          FocusScope.of(context).requestFocus(_passwordFocusNode);
        },
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
        onSaved: (value) {
          _initValues[_email] = value ?? "";
        },
      ),
    ];
  }

  List<Widget> buildPasswordTextField(TextStyle bodyText2) {
    return [
      TextFormField(
        textInputAction: TextInputAction.done,
        obscureText: _isHidden,
        focusNode: _passwordFocusNode,
        enableSuggestions: !_isHidden,
        autocorrect: !_isHidden,
        style: bodyText2,
        decoration: InputDecoration(
          suffixIcon: IconButton(
            icon: Icon(
              _isHidden ? Icons.visibility : Icons.visibility_off,
              color: kPrimaryColor,
            ),
            onPressed: () {
              setState(() {
                _isHidden = !_isHidden;
              });
            },
          ),
          labelText: AppLocalizations.of(context)!.password,
          hintText: AppLocalizations.of(context)!.enterYourPassword,
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
        keyboardType: TextInputType.visiblePassword,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return AppLocalizations.of(context)!.pleaseProvideYourPassword;
          } else if (value.length < 8) {
            return AppLocalizations.of(context)!.passwordMustBeMoreThan8Letters;
          }
          return null;
        },
        onSaved: (value) {
          _initValues[_password] = value ?? "";
        },
      ),
    ];
  }

  Widget buildForgotPassword(TextStyle bodyText2) {
    return Container(
      alignment: Alignment.center,
      child: TextButton(
        onPressed: () {
          Navigator.of(context).push(
            CustomPageRoute(screen: const ForgotPasswordScreen()),
          );
        },
        child: Text(
          AppLocalizations.of(context)!.forgotYourPassword,
        ),
        style: TextButton.styleFrom(
          textStyle: bodyText2,
        ),
      ),
    );
  }

  Widget buildRegisterButton(TextStyle bodyText2) {
    return InkWell(
      splashColor: Colors.transparent,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            Text(
              AppLocalizations.of(context)!.dontHaveAnAccount,
              style: bodyText2,
            ),
            const SizedBox(
              width: kDefaultMargin / 4,
            ),
            Text(
              AppLocalizations.of(context)!.signUp,
              style: bodyText2.copyWith(color: kPrimaryColor),
            ),
          ],
        ),
      ),
      onTap: () {
        Navigator.of(context)
            .push(CustomPageRoute(screen: const RegisterScreen()));
      },
    );
  }
}
