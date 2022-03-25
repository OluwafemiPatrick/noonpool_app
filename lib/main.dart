import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:noonpool/presentation/splash_screen/splash_screen.dart';

import 'helpers/constants.dart';
import 'helpers/shared_preference_util.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  //lock orientation
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  //init shared preferences
  await AppPreferences.init();
  await Firebase.initializeApp();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var lightTheme = ThemeData(
      colorScheme: ColorScheme.fromSwatch().copyWith(
        primary: kPrimaryColor,
      ),
      canvasColor: Colors.white,
      fontFamily: manrope,
      iconTheme: ThemeData.light().iconTheme.copyWith(color: kTextColor),
      textTheme: ThemeData.light().textTheme.copyWith(
            bodyText1: const TextStyle(
                fontSize: 14, color: kTextColor, fontWeight: FontWeight.w500),
            bodyText2: const TextStyle(fontSize: 12, color: kTextColor),
          ),
    );

    return MaterialApp(
      title: appName,
      debugShowCheckedModeBanner: false,
      theme: lightTheme,
      home: const SplashScreen(),
    );
  }
}
