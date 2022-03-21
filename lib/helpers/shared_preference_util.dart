import 'package:shared_preferences/shared_preferences.dart';

/// DART CLASS TO SAVE DATA TO LOCAL STORAGE
class AppPreferences {
  static SharedPreferences? _preference;

  static Future init() async =>
      _preference = await SharedPreferences.getInstance();

  // on boarding value is true if logged in
  static const _onBoardingKey = 'onBoardingStatus';

  // log in value is true if user logged in successfully
  static const _loginInKey = 'firstNameKey';

  static Future setOnBoardingStatus({required bool status}) async {
    await _preference?.setBool(_onBoardingKey, status);
  }

  static Future setLoginStatus({required bool status}) async {
    await _preference?.setBool(_loginInKey, status);
  }

  static bool get onBoardingStatus =>
      _preference?.getBool(_onBoardingKey) ?? false;

  static bool get loginStatus => _preference?.getBool(_loginInKey) ?? false;
}
