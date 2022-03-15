import 'package:flutter/material.dart';
import 'package:noonpool/helpers/elevated_buton.dart';

import '../../helpers/constants.dart';

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
  final _form = GlobalKey<FormState>();
  final Map<String, dynamic> _initValues = {_email: '', _password: ''};

  @override
  void dispose() {
    _passwordFocusNode.dispose();
    super.dispose();
  }

  void _saveForm() {
    final isValid = _form.currentState?.validate();
    if ((isValid ?? false) == false || _isLoading) {
      return;
    }
    _form.currentState?.save();
    //login user here
    showLoginStatus();
  }

  Future showLoginStatus() async {
    var navigatorState = Navigator.of(context);
    final email = _initValues[_email];
    final password = _initValues[_password];

    setState(() {
      _isLoading = true;
    });

    // final String response = await signIn(email: email, password: password);
    setState(() {
      _isLoading = false;
    });

/*    switch (response) {
      case '--':
      //login successful_proceed
        navigatorState.pushAndRemoveUntil(
            CustomPageRoute(screen: const HomeScreen()), (route) => false);
        break;
      default:
      //error occurred, handle error
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(response)));
        break;
    }*/
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
            key: _form,
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
                buildSignUpButton(bodyText2),
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

  Row buildSignUpButton(TextStyle bodyText2) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Don\'t have an account?',
          style: bodyText2,
        ),
        TextButton(
          onPressed: () {},
          child: const Text(
            'Sign Up',
          ),
          style: TextButton.styleFrom(
            textStyle: bodyText2.copyWith(color: kPrimaryColor),
          ),
        ),
      ],
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
          if (value == null || value.isEmpty) {
            return 'Please provide your email.';
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
}
