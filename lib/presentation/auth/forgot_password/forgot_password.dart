import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../helpers/constants.dart';
import '../../../helpers/elevated_button.dart';
import '../../../helpers/firebase_util.dart';
import '../../../helpers/page_route.dart';
import 'forgot_password_confirmation_screen.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({Key? key}) : super(key: key);

  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();

  bool _isLoading = false;
  String email = "";

  void _saveForm() {
    final isValid = _formKey.currentState?.validate();
    if ((isValid ?? false) == false || _isLoading) {
      return;
    }
    _formKey.currentState?.save();
    showForgotPasswordStatus();
  }

  Future showForgotPasswordStatus() async {
    setState(() {
      _isLoading = true;
    });

    String response = await forgotPassword(email: email.trim());
    switch (response) {
      case successful:
        Navigator.of(context).push(
          CustomPageRoute(
            screen: const ForgotPasswordConfirmationScreen(),
          ),
        );
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(),
      body: buildBody(),
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.transparent,
      leading: const BackButton(
        color: Colors.black,
      ),
    );
  }

  Widget buildBody() {
    final textTheme = Theme.of(context).textTheme;
    final bodyText2 = textTheme.bodyText2!;
    return SingleChildScrollView(
      child: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(kDefaultPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Having trouble signing in?',
                  style: bodyText2.copyWith(
                      fontSize: 22, fontWeight: FontWeight.w500),
                ),
              ),
              const SizedBox(
                height: kDefaultMargin * 2,
              ),
              SvgPicture.asset(
                'assets/icons/forgot_password.svg',
                semanticsLabel: 'auth',
                height: 250,
                width: 250,
              ),
              const SizedBox(
                height: kDefaultMargin / 2,
              ),
              Container(
                width: double.infinity,
                alignment: Alignment.center,
                child: Text(
                  'It’s okay. We all forget things at a point or another.\nJust enter your email and we’ll send you a link to get you started on the way back into your account.',
                  style: bodyText2,
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(
                height: kDefaultMargin * 2,
              ),
              ...buildEmailField(bodyText2),
              const SizedBox(
                height: kDefaultMargin * 2,
              ),
              buildSignIn(bodyText2),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildSignIn(TextStyle bodyText2) {
    return CustomElevatedButton(
      onPressed: _saveForm,
      widget: _isLoading
          ? const SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator.adaptive(
                backgroundColor: Colors.white,
              ),
            )
          : Text(
              'Submit',
              style: bodyText2.copyWith(
                color: Colors.white,
              ),
            ),
    );
  }

  List buildEmailField(TextStyle bodyText2) {
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
          email = value ?? "";
        },
      ),
    ];
  }
}
