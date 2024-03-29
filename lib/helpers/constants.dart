import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
export 'package:flutter_gen/gen_l10n/app_localizations.dart';

const String appName = "NoonPool";
const String manrope = "Manrope";
const double kDefaultPadding = 20.0;
const double kDefaultMargin = 20.0;

const kPrimaryColor = Color.fromRGBO(145, 35, 91, 1);
const kLightPrimaryColor = Color.fromRGBO(235, 215, 225, 1);
const kNavIcons = Color.fromRGBO(79, 79, 79, 1);
const kNavText = Color.fromRGBO(130, 130, 130, 1);
const kLightText = Color.fromRGBO(189, 189, 189, 1);
const kLightBackground = Color.fromRGBO(242, 242, 242, 1);

const kTextColor = Color.fromRGBO(55, 71, 79, 1);

const String logoLocation = "assets/images/mini_logo.png";
const String fullLogoLocation = "assets/images/logo.png";

const String supportEmailAddress = "support@mail.com";

final _numberFormatter = NumberFormat("#,##0.00000", "en_US");

String formatNumber(double number) {
  return _numberFormatter.format(number);
}
