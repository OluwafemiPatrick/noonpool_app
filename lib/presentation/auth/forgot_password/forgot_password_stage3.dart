import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:noonpool/helpers/constants.dart';
import 'package:noonpool/helpers/elevated_button.dart';

class ForgotPasswordStage3 extends StatefulWidget {
  final String email;
  final VoidCallback onDone;

  const ForgotPasswordStage3({
    Key? key,
    required this.email,
    required this.onDone,
  }) : super(key: key);

  @override
  State<ForgotPasswordStage3> createState() => _ForgotPasswordStage3State();
}

class _ForgotPasswordStage3State extends State<ForgotPasswordStage3> {
  final stage3FormKey = GlobalKey<FormState>();
  bool _isPasswordNotVisible = true;
  bool _isLoading = false;
  final _passwordController = TextEditingController();
  final _retypePasswordController = TextEditingController();
  final _retypePasswordFocusNode = FocusNode();
  @override
  void dispose() {
    _passwordController.dispose();
    _retypePasswordController.dispose();
    _retypePasswordFocusNode.dispose();
    super.dispose();
  }

  List<Widget> buildPasswordField(TextStyle bodyText2) {
    return [
      TextFormField(
        controller: _passwordController,
        textInputAction: TextInputAction.next,
        onFieldSubmitted: (_) {
          FocusScope.of(context).requestFocus(_retypePasswordFocusNode);
        },
        obscureText: _isPasswordNotVisible,
        enableSuggestions: !_isPasswordNotVisible,
        autocorrect: !_isPasswordNotVisible,
        style: bodyText2,
        decoration: InputDecoration(
          labelText: "Password",
          hintText: "Enter your password.",
          suffixIcon: IconButton(
            icon: Icon(
              _isPasswordNotVisible ? Icons.visibility : Icons.visibility_off,
              color: Colors.black,
            ),
            onPressed: () {
              setState(() {
                _isPasswordNotVisible = !_isPasswordNotVisible;
              });
            },
          ),
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
          } else if (value.length < 8) {
            return 'Password must be more than 8 letters';
          } else if (value != _retypePasswordController.text) {
            return 'Passwords are not the same';
          }
          return null;
        },
      ),
      const SizedBox(
        height: 10,
      ),
    ];
  }

  List<Widget> buildVerifyPasswordField(TextStyle bodyText2) {
    return [
      TextFormField(
        controller: _retypePasswordController,
        textInputAction: TextInputAction.done,
        focusNode: _retypePasswordFocusNode,
        obscureText: _isPasswordNotVisible,
        enableSuggestions: !_isPasswordNotVisible,
        autocorrect: !_isPasswordNotVisible,
        style: bodyText2,
        decoration: InputDecoration(
          suffixIcon: IconButton(
            icon: Icon(
              _isPasswordNotVisible ? Icons.visibility : Icons.visibility_off,
              color: Colors.black,
            ),
            onPressed: () {
              setState(() {
                _isPasswordNotVisible = !_isPasswordNotVisible;
              });
            },
          ),
          labelText: "Retype Password",
          hintText: "retype your password.",
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
            return 'Please confirm your password';
          } else if (value.length < 8) {
            return 'Password must be more than 8 letters';
          } else if (value != _passwordController.text) {
            return 'Passwords are not the same';
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
        key: stage3FormKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: kDefaultMargin * 2,
              width: double.infinity,
            ),
            Center(
              child: SvgPicture.asset(
                'assets/icons/security.svg',
                semanticsLabel: 'authorize new device',
                height: 250,
                width: 250,
              ),
            ),
            const SizedBox(
              height: kDefaultMargin * 2,
            ),
            Text('Password Change', style: bodyText1),
            const SizedBox(height: (5)),
            Text(
              "Enter a new  password for your account",
              style: bodyText2,
              textAlign: TextAlign.center,
            ),
            const SizedBox(
              height: kDefaultMargin / 2,
            ),
            ...buildPasswordField(bodyText2),
            ...buildVerifyPasswordField(bodyText2),
            const SizedBox(
              height: kDefaultMargin / 2,
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
                      'Reset Password',
                      style: bodyText2.copyWith(color: Colors.white),
                    ),
              onPressed: () async {
                final isValid = stage3FormKey.currentState?.validate();
                if ((isValid ?? false) == false || _isLoading) {
                  return;
                }

                sendResetPasswordLink();
              },
            ),
          ],
        ),
      ),
    );
  }

  sendResetPasswordLink() async {
    setState(() {
      _isLoading = true;
    });

    try {
      /*       final String password = _passwordController.text.trim();
      final String reTypePassword = _retypePasswordController.text.trim();

  final response = await controller.resetPassword(
        email: widget.email,
        password: password,
        reTypePassword: reTypePassword,
      ); */

      () {
        /*   ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              response,
            ),
          ),
        ); */
        widget.onDone();
      }();
    } catch (exception) {
      ScaffoldMessenger.of(context).showSnackBar(
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
