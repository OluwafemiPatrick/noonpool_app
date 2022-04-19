import 'package:flutter/material.dart';
import 'package:noonpool/helpers/elevated_button.dart';
import 'package:noonpool/helpers/network_helper.dart';
import 'package:noonpool/presentation/auth/register/registration_confirmation_screen.dart';

import '../../../helpers/constants.dart';
import '../../../helpers/firebase_util.dart';
import '../../../helpers/page_route.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  static const _email = "email";
  static const _name = "name";
  static const _password = "password";
  static const _retypePassword = "retypePassword";
  bool _isHidden = true;
  bool _isLoading = false;

  final _emailFocusNode = FocusNode();
  final _passwordFocusNode = FocusNode();
  final _reTypePasswordFocusNode = FocusNode();
  final _formKey = GlobalKey<FormState>();
  final passwordTextEditingController = TextEditingController(text: "");
  final retypePasswordTextEditingController = TextEditingController(text: "");

  final  _validCharacters = RegExp(r'^[a-zA-Z0-9]+$');


  final Map<String, dynamic> _initValues = {
    _email: '',
    _name: '',
    _password: '',
    _retypePassword: ''
  };

  @override
  void initState() {
    super.initState();
    passwordTextEditingController.addListener(() {
      _initValues[_password] = passwordTextEditingController.text;
    });
    retypePasswordTextEditingController.addListener(() {
      _initValues[_retypePassword] = retypePasswordTextEditingController.text;
    });
  }

  @override
  void dispose() {
    _passwordFocusNode.dispose();
    _reTypePasswordFocusNode.dispose();
    _emailFocusNode.dispose();
    passwordTextEditingController.dispose();
    retypePasswordTextEditingController.dispose();
    super.dispose();
  }

  void _saveForm() {
    final isValid = _formKey.currentState?.validate();
    if ((isValid ?? false) == false || _isLoading) {
      return;
    }
    _formKey.currentState?.save();
    showRegistrationStatus();
  }

  Future showRegistrationStatus() async {
    final email = _initValues[_email].trim();
    final name = _initValues[_name].trim();
    final password = _initValues[_password].trim();

    //if is loading the text changes to a progress bar
    setState(() {
      _isLoading = true;
    });

   var result = await checkUsername(name);
    if (result == true) {

      final String response = await signUp(email: email, password: password, name: name);

      setState(() {
        _isLoading = false;
      });

      switch (response) {
        case successful:
          final Map<String, String> data = {'email': email, 'password': password};
          Navigator.of(context).pushReplacement(
            CustomPageRoute(
                screen: const RegistrationConfirmationScreen(), argument: data),
          );
          break;
        default:
          showErrorDialog(response);
          break;
      }
    }
    else {
      // throw an error message
      showErrorDialog('$name has already been registered, kindly choose a different username');
      setState(() {
        _isLoading = false;
      });
    }

  }

  void showErrorDialog(String error) {
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
              size: 180,
            ),
            const SizedBox(
              height: 40,
            ),
            Text(
              error,
              style: bodyText2,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
    showGeneralDialog(
      context: context,
      barrierLabel: "Error",
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
                    height: kDefaultMargin * 2,
                  ),
                  ...buildNameTextField(bodyText2),
                  const SizedBox(
                    height: kDefaultMargin,
                  ),
                  ...buildEmailTextField(bodyText2),
                  const SizedBox(
                    height: kDefaultMargin,
                  ),
                  ...buildPasswordTextField(bodyText2),
                  const SizedBox(
                    height: kDefaultMargin,
                  ),
                  ...buildRetypePasswordTextField(bodyText2),
                  const SizedBox(
                    height: kDefaultMargin * 5,
                  ),
                  buildSignUpButton(bodyText2),
                  const SizedBox(
                    height: kDefaultMargin / 2,
                  ),
                ],
              ),
            ),
          ),
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
        'Sign Up',
        style: bodyText1.copyWith(fontSize: 20),
      ),
    );
  }

  CustomElevatedButton buildSignUpButton(TextStyle bodyText2) {
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
              'Sign Up',
              style: bodyText2.copyWith(color: Colors.white),
            ),
    );
  }

  List<Widget> buildNameTextField(TextStyle bodyText2) {
    return [
      SizedBox(
        width: double.infinity,
        child: Text(
          'Username',
          style: bodyText2.copyWith(
              fontWeight: FontWeight.w500, color: kPrimaryColor),
        ),
      ),
      TextFormField(
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
          suffixIcon: IconButton(
            icon: const Icon(
              Icons.info_outlined,
              color: kPrimaryColor,
            ),
            onPressed: () {},
          ),
          hintText: "Please enter your name.",
        ),
        style: bodyText2.copyWith(fontSize: 16),
        onFieldSubmitted: (_) {
          FocusScope.of(context).requestFocus(_emailFocusNode);
        },
        validator: (value) {
          if (value == null || value.isEmpty || value.length < 8) {
            return 'Kindly create a unique username.';
          }
          if (!_validCharacters.hasMatch(value)){
            return 'Username cannot contain spaces or special characters';
          }
          return null;
        },
        onSaved: (value) {
          _initValues[_name] = value ?? "";
        },
      ),
    ];
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
        focusNode: _emailFocusNode,
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
        textInputAction: TextInputAction.next,
        obscureText: _isHidden,
        focusNode: _passwordFocusNode,
        controller: passwordTextEditingController,
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
          } else if (value != _initValues[_retypePassword]) {
            return 'Passwords are not the  same';
          } else if (value.length < 8) {
            return 'Password must be more than 8 letters';
          }
          return null;
        },
        onFieldSubmitted: (_) {
          FocusScope.of(context).requestFocus(_reTypePasswordFocusNode);
        },
      ),
    ];
  }

  List<Widget> buildRetypePasswordTextField(TextStyle bodyText2) {
    return [
      SizedBox(
        width: double.infinity,
        child: Text(
          'Retype Password',
          style: bodyText2.copyWith(
              fontWeight: FontWeight.w500, color: kPrimaryColor),
        ),
      ),
      TextFormField(
        textInputAction: TextInputAction.done,
        obscureText: _isHidden,
        focusNode: _reTypePasswordFocusNode,
        controller: retypePasswordTextEditingController,
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
          hintText: "Retype your password.",
        ),
        keyboardType: TextInputType.visiblePassword,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please provide  your password';
          } else if (value != _initValues[_password]) {
            return 'Passwords are not the  same';
          } else if (value.length < 8) {
            return 'Password must be more than 8 letters';
          }
          return null;
        },
      ),
    ];
  }
}
