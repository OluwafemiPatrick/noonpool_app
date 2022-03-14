import 'dart:core';

import 'package:flutter/material.dart';

class CustomPageRoute extends PageRouteBuilder {
  CustomPageRoute({required Widget screen, Object? argument})
      : super(
            pageBuilder: (_, __, ___) => screen,
            transitionsBuilder: _transition,
            transitionDuration: const Duration(milliseconds: 1000),
            settings: RouteSettings(arguments: argument));

  static Widget _transition(_, Animation<double> animation, __, Widget widget) {
    return Opacity(
      opacity: animation.value,
      child: widget,
    );
  }
}
