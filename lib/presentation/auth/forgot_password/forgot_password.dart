import 'package:flutter/material.dart';
import 'package:noonpool/helpers/constants.dart';
import 'package:noonpool/helpers/page_route.dart';
import 'package:noonpool/presentation/auth/forgot_password/forgot_password_confirmation_screen.dart';

import 'forgot_password_stage1.dart';
import 'forgot_password_stage2.dart';
import 'forgot_password_stage3.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  String email = '';

  final pageController = PageController();

  int _pagePosition = 0;

  void onPageChanged(int index) {
    pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 500),
      curve: Curves.linear,
    );

    setState(() {
      _pagePosition = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final bodyText1 = textTheme.bodyText1!;
    return WillPopScope(
      onWillPop: () async {
        if (_pagePosition != 0) {
          onPageChanged(_pagePosition - 1);
          return false;
        } else {
          return true;
        }
      },
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          leading: const BackButton(
            color: Colors.black,
          ),
          title: Text(
            AppLocalizations.of(context)!.forgotPassword,
            style: bodyText1,
          ),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: PageView(
                controller: pageController,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  ForgotPasswordStage1(
                    navigateNext: (email) {
                      setState(() {
                        this.email = email;
                      });
                      onPageChanged(1);
                    },
                  ),
                  ForgotPasswordStage2(
                    email: email,
                    navigateNext: () {
                      onPageChanged(2);
                    },
                  ),
                  ForgotPasswordStage3(
                    email: email,
                    onDone: () {
                      Navigator.of(context).pushReplacement(
                        CustomPageRoute(
                          screen: const ForgotPasswordConfirmationScreen(),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            buildBottomWidget(),
            const SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
    );
  }

  Widget buildBottomWidget() {
    return Container(
      alignment: Alignment.center,
      width: double.infinity,
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 500),
        switchInCurve: Curves.easeIn,
        child: buildIndicators(_pagePosition),
      ),
    );
  }

  Widget buildIndicators(int currentIndex) {
    List<int> indexes = [0, 1, 2];
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: indexes
          .map((index) => AnimatedContainer(
                duration: const Duration(milliseconds: 500),
                margin: const EdgeInsets.only(right: 5),
                height: 8,
                width: (currentIndex == index) ? 50 : 8,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: (currentIndex == index)
                      ? kPrimaryColor
                      : Colors.black.withOpacity(0.2),
                ),
              ))
          .toList(),
    );
  }
}
