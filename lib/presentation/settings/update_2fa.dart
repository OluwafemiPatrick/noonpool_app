import 'dart:async';

import 'package:flutter/material.dart';
import 'package:noonpool/helpers/constants.dart';
import 'package:noonpool/helpers/error_widget.dart';
import 'package:noonpool/helpers/network_helper.dart';
import 'package:noonpool/helpers/page_route.dart';
import 'package:noonpool/helpers/shared_preference_util.dart';
import 'package:noonpool/main.dart';
import 'package:noonpool/model/user_secret.dart';
import 'package:noonpool/presentation/main/main_screen.dart';

class Update2FA extends StatefulWidget {
  const Update2FA({
    Key? key,
  }) : super(key: key);

  @override
  State<Update2FA> createState() => _Update2FAState();
}

class _Update2FAState extends State<Update2FA> {
  bool _isLoading = true;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, getData);
  }

  getData() async {
    setState(() {
      _isLoading = true;
      _hasError = false;
    });
    try {
      UserSecret userSecret = await get2FAStatus(id: AppPreferences.userId);
      if (userSecret.isSecret != null) {
        AppPreferences.set2faSecurityStatus(isEnabled: userSecret.isSecret!);
        _hasError = false;
        Navigator.of(context)
            .pushReplacement(CustomPageRoute(screen: const MainScreen()));
      } else {
        _hasError = true;
        throw AppLocalizations.of(context)!.anErrorOccurredPleaseRefreshThePage;
      }
    } catch (exception) {
      MyApp.scaffoldMessengerKey.currentState?.showSnackBar(
        SnackBar(
          content: Text(
            exception.toString(),
          ),
        ),
      );
      _hasError = true;
    }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final bodyText1 = textTheme.bodyText1;
    return Scaffold(
      appBar: buildAppBar(bodyText1),
      body: buildBody(),
    );
  }

  AppBar buildAppBar(TextStyle? bodyText1) {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.transparent,
      automaticallyImplyLeading: false,
      leading: null,
    );
  }

  buildProgressBar() {
    return const Center(
      child: SizedBox(
        height: 50,
        width: 50,
        child: CircularProgressIndicator.adaptive(
          backgroundColor: kLightBackgroud,
        ),
      ),
    );
  }

  Widget buildBody() {
    return _isLoading
        ? buildProgressBar()
        : _hasError
            ? CustomErrorWidget(
                error: AppLocalizations.of(context)!
                    .anErrorOccurredWithTheDataFetchPleaseTryAgain,
                onRefresh: () {
                  getData();
                })
            : const SizedBox();
  }
}
