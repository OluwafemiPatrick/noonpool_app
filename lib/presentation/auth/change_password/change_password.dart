import 'package:flutter/material.dart';
import 'package:noonpool/helpers/constants.dart';
import 'package:noonpool/helpers/error_widget.dart';
import 'package:noonpool/helpers/network_helper.dart';
import 'package:noonpool/helpers/page_route.dart';
import 'package:noonpool/helpers/shared_preference_util.dart';
import 'package:noonpool/main.dart';
import 'package:noonpool/presentation/auth/change_password/change_password_confirmation_screen.dart';

import 'change_password_stage1.dart';
import 'change_password_stage2.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({Key? key}) : super(key: key);

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final pageController = PageController();
  bool _isLoading = true;
  bool _hasError = false;
  int _pagePosition = 0;

  getData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      await sendUserOTP(
        email: AppPreferences.userEmail,
      );
      () {
        MyApp.scaffoldMessengerKey.currentState?.showSnackBar(
          SnackBar(
              content: Text(AppLocalizations.of(context)!
                  .aVerificationOtpHasBeenSentToYourMail)),
        );
      }();
      _hasError = false;
    } catch (exception) {
      _hasError = true;
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
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, getData);
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
            AppLocalizations.of(context)!.changePassword,
            style: bodyText1,
          ),
        ),
        body: _isLoading
            ? const Center(
                child: SizedBox(
                  height: 50,
                  width: 50,
                  child: CircularProgressIndicator.adaptive(
                    backgroundColor: Colors.white,
                  ),
                ),
              )
            : _hasError
                ? CustomErrorWidget(
                    error: AppLocalizations.of(context)!
                        .anErrorOccurredPleaseRefreshThePage,
                    onRefresh: getData,
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: PageView(
                          controller: pageController,
                          physics: const NeverScrollableScrollPhysics(),
                          children: [
                            ChangePasswordStage1(
                              email: AppPreferences.userEmail,
                              navigateNext: () {
                                onPageChanged(1);
                              },
                            ),
                            ChangePasswordStage2(
                              email: AppPreferences.userEmail,
                              onDone: () {
                                Navigator.of(context).pushReplacement(
                                  CustomPageRoute(
                                    screen:
                                        const ChangePasswordConfirmationScreen(),
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
    List<int> indexes = [
      0,
      1,
    ];
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
