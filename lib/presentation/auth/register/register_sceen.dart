import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:noonpool/helpers/elevated_button.dart';
import 'package:noonpool/helpers/network_helper.dart';
import 'package:noonpool/helpers/text_button.dart';
import 'package:noonpool/presentation/auth/register/registration_confirmation_screen.dart';

import '../../../helpers/constants.dart';
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
  CancelableOperation? cancelableFuture;
  final _emailFocusNode = FocusNode();
  final _passwordFocusNode = FocusNode();
  final _reTypePasswordFocusNode = FocusNode();
  final _formKey = GlobalKey<FormState>();
  final _formKeyName = GlobalKey<FormFieldState>();
  final passwordTextEditingController = TextEditingController(text: "");
  final retypePasswordTextEditingController = TextEditingController(text: "");
  String? errorText;
  final _validCharacters = RegExp(r'^[a-zA-Z0-9]+$');

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

  verifyUserName(String name) async {
    try {
      cancelableFuture?.cancel();
      cancelableFuture = CancelableOperation.fromFuture(checkUsername(name));
      final isAvailiable = await cancelableFuture?.value;
      if (isAvailiable == true) {
        errorText = null;
      } else {
        errorText = 'Username unavailiable';
      }
    } catch (exception) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(exception.toString())));
      errorText = 'Username unavailiable';
    }
    _formKeyName.currentState?.validate();
  }

  Future showRegistrationStatus() async {
    final email = _initValues[_email].trim();
    final name = _initValues[_name].trim();
    final password = _initValues[_password].trim();

    setState(() {
      _isLoading = true;
    });
    try {
      final result = await checkUsername(name);
      if (result) {
        await createUserAccount(
          email: email,
          password: password,
          userName: name,
        );

        Navigator.of(context).pushReplacement(
          CustomPageRoute(
            screen: const RegistrationConfirmationScreen(),
            argument: email,
          ),
        );
      } else {
        showErrorDialog(
            '$name has already been registered, kindly choose a different username');
      }
    } catch (exception) {
      showErrorDialog(exception.toString());
    }
    setState(() {
      _isLoading = false;
    });
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
    final themeData = Theme.of(context);
    final bodyText1 = themeData.textTheme.bodyText1!;
    final bodyText2 = themeData.textTheme.bodyText2!;

    return Scaffold(
      appBar: buildAppBar(bodyText1),
      body: Padding(
        padding: const EdgeInsets.all(kDefaultPadding / 2),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ...buildNameTextField(bodyText2, bodyText1),
                const SizedBox(
                  height: kDefaultMargin / 2,
                ),
                ...buildEmailTextField(bodyText2),
                const SizedBox(
                  height: kDefaultMargin / 2,
                ),
                ...buildPasswordTextField(bodyText2),
                const SizedBox(
                  height: kDefaultMargin / 2,
                ),
                ...buildRetypePasswordTextField(bodyText2),
                const SizedBox(
                  height: kDefaultMargin,
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
        'Sign Up',
        style: bodyText1,
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

  List<Widget> buildNameTextField(TextStyle bodyText2, TextStyle bodyText1) {
    return [
      TextFormField(
        key: _formKeyName,
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
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
          suffixIcon: IconButton(
            icon: const Icon(
              Icons.info_outlined,
              color: kPrimaryColor,
            ),
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (_) {
                    return AlertDialog(
                      contentPadding: const EdgeInsets.all(kDefaultPadding / 2),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      alignment: Alignment.centerRight,
                      title: Text(
                        'Username',
                        style: bodyText1,
                      ),
                      content: Text(
                        'Please enter a unique username; this username will be associated with your account and will be used in the application.',
                        style: bodyText2,
                      ),
                      actions: [
                        CustomTextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          isFullWidth: false,
                          widget: Text(
                            'Okay',
                            style: bodyText2.copyWith(color: kPrimaryColor),
                          ),
                        ),
                      ],
                    );
                  });
            },
          ),
          labelText: "Username",
          hintText: "Please enter your username.",
        ),
        style: bodyText2,
        onFieldSubmitted: (_) {
          FocusScope.of(context).requestFocus(_emailFocusNode);
        },
        onChanged: (text) {
          if (text.isEmpty || text.length < 8) {
            _formKeyName.currentState?.validate();
          } else if (!_validCharacters.hasMatch(text)) {
            _formKeyName.currentState?.validate();
          } else {
            verifyUserName(text);
          }
        },
        validator: (value) {
          if (value == null || value.isEmpty || value.length < 8) {
            return 'Username length must be greater than 8.';
          } else if (!_validCharacters.hasMatch(value)) {
            return 'Username cannot contain spaces or special characters';
          }
          return errorText;
        },
        onSaved: (value) {
          _initValues[_name] = value ?? "";
        },
      ),
    ];
  }

  List<Widget> buildEmailTextField(TextStyle bodyText2) {
    return [
      TextFormField(
        textInputAction: TextInputAction.next,
        focusNode: _emailFocusNode,
        decoration: InputDecoration(
          labelText: "Email",
          hintText: "Please enter your email address",
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
      TextFormField(
        textInputAction: TextInputAction.next,
        obscureText: _isHidden,
        focusNode: _passwordFocusNode,
        controller: passwordTextEditingController,
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
          labelText: "Password",
          hintText: "Enter your password.",
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
      TextFormField(
        textInputAction: TextInputAction.done,
        obscureText: _isHidden,
        focusNode: _reTypePasswordFocusNode,
        controller: retypePasswordTextEditingController,
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
          labelText: "Retype Password",
          hintText: "Retype your password.",
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
