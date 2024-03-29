import 'package:flutter/material.dart';

// View Model for page bubble

class PageBubbleViewModel {
  final String? iconAssetPath;
  final Color? iconColor;
  final bool isHollow;
  final double activePercent;
  final Color bubbleBackgroundColor;
  final Widget? bubbleInner;
  final bool isActive;

  PageBubbleViewModel({
    this.bubbleInner,
    required this.isActive,
    this.iconAssetPath,
    this.iconColor,
    required this.isHollow,
    required this.activePercent,
    this.bubbleBackgroundColor = const Color(0x88FFFFFF),
  });
}
