import 'package:flutter/material.dart';
import 'package:noonpool/helpers/elevated_button.dart';
import 'package:noonpool/helpers/network_helper.dart';
import 'package:noonpool/presentation/auth/register/register_sceen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../helpers/constants.dart';
import '../../../helpers/firebase_util.dart';
import '../../../helpers/page_route.dart';
import '../../../helpers/shared_preference_util.dart';
import '../../main/main_screen.dart';
import '../forgot_password/forgot_password.dart';

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
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final email = _initValues[_email].trim();
    final password = _initValues[_password].trim();

    setState(() {
      _isLoading = true;
    });

    final String response = await signIn(email: email, password: password);

    switch (response) {
      case successful:
        var result = await getHomepageData(sFirebaseAuth.currentUser!.uid);
        prefs.setString('username', result['username']);

        AppPreferences.setLoginStatus(status: true);
        AppPreferences.setOnBoardingStatus(status: true);
        Navigator.of(context).pushAndRemoveUntil(
          CustomPageRoute(screen: const MainScreen()),
          (route) => false,
        );
        break;
      case 'account_unverified':
        sFirebaseAuth.signOut();
        showVerificationDialog();
        break;
      default:
        //error occurred, handle error
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(response)));
        break;
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
            const Icon(
              Icons.error,
              color: Colors.red,
              size: 100,
            ),
            const SizedBox(
              height: kDefaultMargin,
            ),
            Text(
              'Email not verified, kindly verify through the link in your mail or click the resend verification button',
              style: bodyText2,
              textAlign: TextAlign.center,
            ),
            const SizedBox(
              height: kDefaultMargin,
            ),
            CustomElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                showResendDialog();
              },
              widget: Text(
                'Resend Verification Link',
                style: bodyText2!.copyWith(
                  color: Colors.white,
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
      barrierDismissible: false,
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
    // resend verification email
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

    final email = _initValues[_email].trim();
    final password = _initValues[_password].trim();

    final String response =
        await resendVerification(email: email, password: password);

    Navigator.of(context).pop();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(response),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var themeData = Theme.of(context);
    var bodyText1 = themeData.textTheme.bodyText1!;
    var bodyText2 = themeData.textTheme.bodyText2!;

    return Scaffold(
      appBar: buildAppBar(bodyText1),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(kDefaultPadding),
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
                  height: kDefaultMargin,
                ),
                ...buildPasswordTextField(bodyText2),
                const SizedBox(
                  height: kDefaultMargin / 2,
                ),
                buildForgotPasswordButton(bodyText2),
                const SizedBox(
                  height: kDefaultMargin,
                ),
                buildSignInButton(bodyText2),
                const SizedBox(
                  height: kDefaultMargin / 2,
                ),
                buildForgotPassword(bodyText2),
                const SizedBox(
                  height: kDefaultMargin / 2,
                ),
                buildRegisterButton(bodyText2)
              ],
            ),
          )),
        ),
      ),
    );
  }

  AppBar buildAppBar(TextStyle bodyText1) {
    return AppBar(
      leading: IconButton(
        icon: const Icon(
          Icons.arrow_back_rounded,
          color: Colors.black,
        ),
        onPressed: () {
          Navigator.of(context).pop();
        },
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      title: Text(
        'Sign In',
        style: bodyText1.copyWith(fontSize: 20),
      ),
    );
  }

  TextButton buildForgotPasswordButton(TextStyle bodyText2) {
    return TextButton(
      onPressed: () {},
      child: const Text(
        'Forgot your Password?',
      ),
      style: TextButton.styleFrom(
        textStyle: bodyText2.copyWith(color: kPrimaryColor),
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
              'Sign In',
              style: bodyText2.copyWith(color: Colors.white),
            ),
    );
  }

  List<Widget> buildEmailTextField(TextStyle bodyText2) {
    return [
      SizedBox(
        width: double.infinity,
        child: Text(
          'Email',
          style: bodyText2.copyWith(
              fontWeight: FontWeight.w500, color: kPrimaryColor),
        ),
      ),
      TextFormField(
        textInputAction: TextInputAction.next,
        decoration: const InputDecoration(
          hintText: "Please enter your email address",
        ),
        style: bodyText2.copyWith(fontSize: 16),
        onFieldSubmitted: (_) {
          FocusScope.of(context).requestFocus(_passwordFocusNode);
        },
        validator: (value) {
          bool emailValid = RegExp(
                  r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@+[a-zA-Z0-9]+\.[a-zA-Z]")
              .hasMatch(value ?? "");
          if (value == null || value.isEmpty) {
            return 'Please provide your email.';
          } else if (!emailValid) {
            return 'Please enter a valid email';
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
      SizedBox(
        width: double.infinity,
        child: Text(
          'Password',
          style: bodyText2.copyWith(
              fontWeight: FontWeight.w500, color: kPrimaryColor),
        ),
      ),
      TextFormField(
        textInputAction: TextInputAction.done,
        obscureText: _isHidden,
        focusNode: _passwordFocusNode,
        enableSuggestions: !_isHidden,
        autocorrect: !_isHidden,
        style: bodyText2.copyWith(fontSize: 16),
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
          hintText: "Enter your password.",
        ),
        keyboardType: TextInputType.visiblePassword,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please provide  your password';
          } else if (value.length < 6) {
            return 'Password must be more than 6 letters';
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
        child: const Text(
          'Forgot your Password?',
        ),
        style: TextButton.styleFrom(
          textStyle: bodyText2,
        ),
      ),
    );
  }

  Widget buildRegisterButton(TextStyle bodyText2) {
    return InkWell(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          Text(
            "Don't have an account?",
            style: bodyText2,
          ),
          const SizedBox(
            width: kDefaultMargin / 4,
          ),
          Text(
            "Sign Up",
            style: bodyText2.copyWith(color: kPrimaryColor),
          ),
        ],
      ),
      onTap: () {
        Navigator.of(context)
            .push(CustomPageRoute(screen: const RegisterScreen()));
      },
    );
  }
}
