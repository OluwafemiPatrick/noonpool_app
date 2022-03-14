import 'package:flutter/material.dart';
import 'package:noonpool/helpers/constants.dart';
import 'package:noonpool/library/intro_views_flutter-2.4.0/lib/Models/page_bubble_view_model.dart';

/// This class contains the UI for page bubble.
class PageBubble extends StatelessWidget {
  //view model
  final PageBubbleViewModel viewModel;

  //Constructor
  const PageBubble({
    Key? key,
    required this.viewModel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(
            left: kDefaultMargin / 4, right: kDefaultMargin / 4),
        child: Container(
          width: 10,
          //This method return in between values according to active percent.
          height: 10,
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(20)),
            //Alpha is used to create fade effect for background color
            color: viewModel.isHollow ? Colors.white24 : kPrimaryColor,
            border: Border.all(
              color: viewModel.isHollow
                  ? kPrimaryColor.withAlpha(
                      (0xFF * (0.1 - viewModel.activePercent)).round())
                  : Colors.white10,
              width: 1.0,
            ), //Border
          ),
          //BoxDecoration
          child: Opacity(
            opacity: viewModel.activePercent,
            child: (viewModel.iconAssetPath != null &&
                    viewModel.iconAssetPath != "")
                // ignore: conflicting_dart_import
                ? Image.asset(
                    viewModel.iconAssetPath!,
                    color: viewModel.iconColor,
                  )
                : Container(),
          ), //opacity
        ), //Container
      ), //Padding
    ); //Container
  }
}
