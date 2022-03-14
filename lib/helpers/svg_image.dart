import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class SvgImage extends StatelessWidget {
  final String iconLocation;
  final String name;
  final double size;
  final Color color;

  const SvgImage(
      {required this.iconLocation,
      required this.name,
      this.size = 20,
      required this.color,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool isDark = MediaQuery.of(context).platformBrightness == Brightness.dark;

    return SvgPicture.asset(iconLocation,
        semanticsLabel: name, height: size, width: size, color: color);
  }
}
