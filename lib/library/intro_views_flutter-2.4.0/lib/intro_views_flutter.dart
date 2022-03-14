library intro_views_flutter;

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:noonpool/helpers/constants.dart';
import 'package:noonpool/library/intro_views_flutter-2.4.0/lib/Animation_Gesture/animated_page_dragger.dart';
import 'package:noonpool/library/intro_views_flutter-2.4.0/lib/Animation_Gesture/page_dragger.dart';
import 'package:noonpool/library/intro_views_flutter-2.4.0/lib/Animation_Gesture/page_reveal.dart';
import 'package:noonpool/library/intro_views_flutter-2.4.0/lib/Constants/constants.dart';
import 'package:noonpool/library/intro_views_flutter-2.4.0/lib/Models/page_view_model.dart';
import 'package:noonpool/library/intro_views_flutter-2.4.0/lib/Models/slide_update_model.dart';
import 'package:noonpool/library/intro_views_flutter-2.4.0/lib/UI/page.dart';
import 'package:noonpool/library/intro_views_flutter-2.4.0/lib/UI/pager_indicator.dart';

import 'Models/pager_indicator_view_model.dart';

/// This is the IntroViewsFlutter widget of app which is a stateful widget as its state is dynamic and updates asynchronously.
class IntroViewsFlutter extends StatefulWidget {
  /// List of [PageViewModel] to display
  final List<PageViewModel> pages;

  final Widget getStartedButton;
  final Widget logInButton;

  /// [MainAxisAlignment] for [PageViewModel] page column aligment
  /// default [MainAxisAligment.spaceAround]
  ///
  /// portrait view wraps around  [title] [body] [mainImage]
  ///
  /// landscape view wraps around [title] [body]
  final MainAxisAlignment columnMainAxisAlignment;

  /// ajust how how much the user most drag for a full page transition
  ///
  /// default to 300.0
  final double fullTransition;

  const IntroViewsFlutter(
    this.pages, {
    Key? key,
    required this.logInButton,
    required this.getStartedButton,
    this.columnMainAxisAlignment = MainAxisAlignment.spaceAround,
    this.fullTransition = FULL_TARNSITION_PX,
  }) : super(key: key);

  @override
  _IntroViewsFlutterState createState() => _IntroViewsFlutterState();
}

/// State of above widget.
/// It extends the TickerProviderStateMixin as it is used for animation control (vsync).

class _IntroViewsFlutterState extends State<IntroViewsFlutter>
    with TickerProviderStateMixin {
  late StreamController<SlideUpdate>
      // ignore: close_sinks
      slideUpdateStream; //Stream controller is used to get all the updates when user slides across screen.

  late AnimatedPageDragger
      animatedPageDragger; //When user stops dragging then by using this page automatically drags.

  int activePageIndex = 0; //active page index
  int nextPageIndex = 0; //next page index
  SlideDirection slideDirection = SlideDirection.none; //slide direction
  double slidePercent = 0.0; //slide percentage (0.0 to 1.0)
  late StreamSubscription<SlideUpdate> slideUpdateStream$;

  @override
  void initState() {
    //Stream Controller initialization
    slideUpdateStream = StreamController<SlideUpdate>();
    //listening to updates of stream controller
    slideUpdateStream$ = slideUpdateStream.stream.listen((SlideUpdate event) {
      setState(() {
        //setState is used to change the values dynamically

        //if the user is dragging then
        if (event.updateType == UpdateType.dragging) {
          slideDirection = event.direction;
          slidePercent = event.slidePercent;

          //conditions on slide direction
          if (slideDirection == SlideDirection.leftToRight) {
            nextPageIndex = activePageIndex - 1;
          } else if (slideDirection == SlideDirection.rightToLeft) {
            nextPageIndex = activePageIndex + 1;
          } else {
            nextPageIndex = activePageIndex;
          }
        }
        //if the user has done dragging
        else if (event.updateType == UpdateType.doneDragging) {
          //Auto completion of event using Animated page dragger.
          if (slidePercent > 0.5) {
            animatedPageDragger = AnimatedPageDragger(
              slideDirection: slideDirection,
              transitionGoal: TransitionGoal.open,
              //we have to animate the open page reveal
              slidePercent: slidePercent,
              slideUpdateStream: slideUpdateStream,
              vsync: this,
            );
          } else {
            animatedPageDragger = AnimatedPageDragger(
              slideDirection: slideDirection,
              transitionGoal: TransitionGoal.close,
              //we have to close the page reveal
              slidePercent: slidePercent,
              slideUpdateStream: slideUpdateStream,
              vsync: this,
            );
            //also next page is active page
            nextPageIndex = activePageIndex;
          }
          //Run the animation
          animatedPageDragger.run();
        }
        //when animating
        else if (event.updateType == UpdateType.animating) {
          slideDirection = event.direction;
          slidePercent = event.slidePercent;
        }
        //done animating
        else if (event.updateType == UpdateType.doneAnimating) {
          activePageIndex = nextPageIndex;

          slideDirection = SlideDirection.none;
          slidePercent = 0.0;

          //disposing the animation controller
          // animatedPageDragger?.dispose();
        }
      });
    });

    super.initState();
  }

  @override
  void dispose() {
    slideUpdateStream$.cancel();
    animatedPageDragger.dispose();
    slideUpdateStream.close();
    super.dispose();
  }

  /// Build method

  @override
  Widget build(BuildContext context) {
    List<PageViewModel> pages = widget.pages;

    return Scaffold(
      //Stack is used to place components over one another.
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            Positioned(
              child: Image.asset(
                logoLocation,
                height: 100,
                width: 100,
              ),
              left: 0,
            ),
            PageIntro(
              pageViewModel: pages[activePageIndex],
              percentVisible: 1.0,
              columnMainAxisAlignment: widget.columnMainAxisAlignment,
            ), //Pages

            PageReveal(
              //next page reveal
              revealPercent: slidePercent,
              child: PageIntro(
                  pageViewModel: pages[nextPageIndex],
                  percentVisible: slidePercent,
                  columnMainAxisAlignment: widget.columnMainAxisAlignment),
            ), //PageReveal
            Positioned(
              child: Column(
                children: [
                  PagerIndicator(
                    //bottom page indicator
                    viewModel: PagerIndicatorViewModel(
                      pages,
                      activePageIndex,
                      slideDirection,
                      slidePercent,
                    ),
                  ), //PagerIndicator
                  const SizedBox(
                    height: kDefaultMargin,
                  ),
                  widget.getStartedButton,
                  const SizedBox(
                    height: kDefaultMargin / 2,
                  ),
                  widget.logInButton
                ],
              ),
              bottom: kDefaultMargin,
              left: kDefaultMargin,
              right: kDefaultMargin,
            ),
            PageDragger(
              //Used for gesture control
              fullTransitionPX: widget.fullTransition,
              canDragLeftToRight: activePageIndex > 0,
              canDragRightToLeft: activePageIndex < pages.length - 1,
              slideUpdateStream: slideUpdateStream,
            ), //PageDragger
          ], //Widget
        ), //Stac
      ), //
    ); //Scaffold
  }
}
