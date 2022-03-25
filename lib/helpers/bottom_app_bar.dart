import 'dart:async';

import 'package:flutter/material.dart';
import 'package:noonpool/helpers/svg_image.dart';

import 'constants.dart';

class CustomBottomAppBar extends StatefulWidget {
  final Function(int) onBottomNavBarClicked;
  final Stream<int> positionStream;
  final List<Map<String, dynamic>> bottomNavItems;

  const CustomBottomAppBar(
      {Key? key,
      required this.onBottomNavBarClicked,
      required this.bottomNavItems,
      required this.positionStream})
      : super(key: key);

  @override
  State<CustomBottomAppBar> createState() => _CustomBottomAppBarState();
}

class _CustomBottomAppBarState extends State<CustomBottomAppBar> {
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final bodyText2 = textTheme.bodyText2;

    var bottomNavItems = widget.bottomNavItems;
    var canvasColor = Theme.of(context).canvasColor;

    return StreamBuilder<int>(
        stream: widget.positionStream,
        initialData: 0,
        builder: (
          BuildContext context,
          AsyncSnapshot<int> snapshot,
        ) {
          if (snapshot.hasData) {
            return BottomNavigationBar(
              items: bottomNavItems.map(
                (bottomNavItem) {
                  final itemPosition = bottomNavItems.indexOf(bottomNavItem);
                  final isSelected = itemPosition == (snapshot.data ?? 0);
                  final color = isSelected ? kPrimaryColor : kNavIcons;
                  return BottomNavigationBarItem(
                    icon: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SvgImage(
                            iconLocation: bottomNavItem['icon'],
                            name: bottomNavItem['title'],
                            color: color,
                            size: 22,
                          ),
                          const SizedBox(
                            height: kDefaultMargin / 5,
                          ),
                        ]),
                    label: bottomNavItem['title'],
                  );
                },
              ).toList(),
              selectedItemColor: kPrimaryColor,
              unselectedItemColor: kNavText,
              currentIndex: (snapshot.data ?? 0),
              selectedFontSize: 20,
              selectedLabelStyle: bodyText2,
              unselectedLabelStyle: bodyText2,
              unselectedFontSize: 16,
              onTap: widget.onBottomNavBarClicked,
              elevation: 10,
              backgroundColor: canvasColor,
            );
          } else {
            return Container();
          }
        });
  }
}
