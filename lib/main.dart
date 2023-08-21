///
/// Written & Developed by Oluwafemi Patrick
/// Copyright @ Jan 2022
/// oopatrickk@gmail.com
///


import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:noonpool/helpers/locale_cubit.dart';
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
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
  ));
  //init shared preferences
  await AppPreferences.init();

  runApp(
    BlocProvider(
      create: (context) => LocaleCubit(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  // declare as global
  static GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();

  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final lightTheme = ThemeData(
      colorScheme: ColorScheme.fromSwatch().copyWith(
        primary: kPrimaryColor,
      ),
      canvasColor: Colors.white,
      fontFamily: manrope,
      iconTheme: ThemeData.light().iconTheme.copyWith(color: kTextColor),
      textTheme: ThemeData.light().textTheme.copyWith(
            bodyLarge: const TextStyle(fontSize: 15, color: kTextColor, fontWeight: FontWeight.w500),
            bodyMedium: const TextStyle(fontSize: 13, color: kTextColor),
          ),
    );

    return BlocBuilder<LocaleCubit, Locale?>(
      builder: (context, locale) {
        return MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          locale: locale, // NEW
          localeResolutionCallback: (locale, supportedLocales) {
            if (supportedLocales.contains(locale)) {
              return locale;
            }
            // default language
            return const Locale('en');
          },
          title: appName,
          debugShowCheckedModeBanner: false,
          theme: lightTheme,
          scaffoldMessengerKey: scaffoldMessengerKey,
          home: const SplashScreen(),
        );
      },
    );
  }
}
