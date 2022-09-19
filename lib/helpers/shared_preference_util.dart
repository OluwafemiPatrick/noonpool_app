// ignore_for_file: constant_identifier_names

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
  static const _2faSecurityEnabled = '2faSecurityEnabled';
  static const _usernameKey = 'username';
  static const _localeLanguageCodeKey = 'localeLanguageCode';
  static const defaultLocaleLanguageCode = '---';
  static const _idKey = 'id';
  static const _emailKey = 'email';
  static const _currentLoginKey = 'currentLogin';
  static Future setOnBoardingStatus({required bool status}) async {
    await _preference?.setBool(_onBoardingKey, status);
  }

  static Future set2faSecurityStatus({required bool isEnabled}) async {
    await _preference?.setBool(_2faSecurityEnabled, isEnabled);
  }

  static Future setLocaleLanguageCode(
      {required String localeLanguageCode}) async {
    await _preference?.setString(_localeLanguageCodeKey, localeLanguageCode);
  }

  static Future setUserName({required String username}) async {
    await _preference?.setString(
      _usernameKey,
      username,
    );
  }

  static Future setUserLoginData(
      {required String id,
      required String email,
      required String currentLoginKey}) async {
    await _preference?.setString(
      _idKey,
      id,
    );
    await _preference?.setString(
      _emailKey,
      email,
    );
    await _preference?.setString(
      _currentLoginKey,
      currentLoginKey,
    );
  }

  static Future setLoginStatus({required bool status}) async {
    await _preference?.setBool(_loginInKey, status);
    if (!status) {
      await setUserName(username: '');
      await setUserLoginData(id: "", email: '', currentLoginKey: '');
      await set2faSecurityStatus(isEnabled: false);
    }
  }

  static String get currentLoginKey =>
      _preference?.getString(_currentLoginKey) ?? '';
  static bool get onBoardingStatus =>
      _preference?.getBool(_onBoardingKey) ?? false;
  static bool get get2faSecurityEnabled =>
      _preference?.getBool(_2faSecurityEnabled) ?? false;

  static bool get loginStatus => _preference?.getBool(_loginInKey) ?? false;
  static String get userId => _preference?.getString(_idKey) ?? '';
  static String get userEmail => _preference?.getString(_emailKey) ?? '';
  static String get currentLocaleLanguageCode =>
      _preference?.getString(_localeLanguageCodeKey) ??
      defaultLocaleLanguageCode; // --- represents system default
  static String get userName => _preference?.getString(_usernameKey) ?? '';
}
