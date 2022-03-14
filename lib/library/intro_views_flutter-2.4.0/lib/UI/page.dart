import 'package:flutter/material.dart';
import 'package:noonpool/helpers/constants.dart';
import 'package:noonpool/library/intro_views_flutter-2.4.0/lib/Models/page_view_model.dart';

/// This is the class which contains the Page UI.
class PageIntro extends StatelessWidget {
  ///page details
  final PageViewModel pageViewModel;

  ///percent visible of page
  final double percentVisible;

  /// [MainAxisAlignment]
  final MainAxisAlignment columnMainAxisAlignment;

  //Constructor
  const PageIntro({
    Key? key,
    required this.pageViewModel,
    this.percentVisible = 1.0,
    this.columnMainAxisAlignment = MainAxisAlignment.spaceAround,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var width = size.width;
    var height = size.height;
    return SizedBox(
      width: double.infinity,
      child: Opacity(
        //Opacity is used to create fade in effect
        opacity: percentVisible,
        child: OrientationBuilder(
            builder: (BuildContext context, Orientation orientation) {
          return orientation == Orientation.portrait
              ? _buildPortraitPage(width, height)
              : Container(); //TODO HANDLE LANDSCAPE
        }), //OrientationBuilder
      ),
    );
  }

  /// when device is Portrait place title, image and body in a column
  Widget _buildPortraitPage(double width, double height) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        _ImagePageTransform(
            percentVisible: percentVisible, pageViewModel: pageViewModel),
        const SizedBox(
          height: kDefaultMargin*1.5,
        ),
        _TitlePageTransform(
          percentVisible: percentVisible,
          pageViewModel: pageViewModel,
        ),
      ],
    );
  }
}

/// Main Image of the Page
class _ImagePageTransform extends StatelessWidget {
  final double percentVisible;

  final PageViewModel pageViewModel;

  const _ImagePageTransform({
    Key? key,
    required this.percentVisible,
    required this.pageViewModel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Transform(
      //Used for vertical transformation
      transform:
          Matrix4.translationValues(0.0, 50.0 * (1 - percentVisible), 0.0),
      child: pageViewModel.mainImage, //Padding
    );
  }
}

/// Title for the Page
class _TitlePageTransform extends StatelessWidget {
  final double percentVisible;

  final PageViewModel pageViewModel;

  const _TitlePageTransform({
    Key? key,
    required this.percentVisible,
    required this.pageViewModel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Transform(
      //Used for vertical transformation
      transform:
          Matrix4.translationValues(0.0, 30.0 * (1 - percentVisible), 0.0),
      child: Padding(
        padding: const EdgeInsets.only(
          bottom: 0.0,
          left: 10.0,
          right: 10.0,
        ),
        child: DefaultTextStyle.merge(
          style: pageViewModel.titleTextStyle,
          child: pageViewModel.title,
        ),
      ), //Padding
    );
  }
}
