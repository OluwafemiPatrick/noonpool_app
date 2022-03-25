import 'package:flutter/material.dart';

import '../../../helpers/constants.dart';

class PoolStatisticsTitle extends StatelessWidget {
  final List<String> titles;
  final Function(int) onTitleClicked;
  final Stream<int> positionStream;
  final duration = const Duration(milliseconds: 300);

  const PoolStatisticsTitle(
      {Key? key,
      required this.titles,
      required this.onTitleClicked,
      required this.positionStream})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final bodyText2 = textTheme.bodyText2!;

    return StreamBuilder<int>(
        stream: positionStream,
        initialData: 0,
        builder: (
          BuildContext context,
          AsyncSnapshot<int> snapshot,
        ) {
          if (snapshot.hasData) {
            return Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              children: titles.map((title) {
                final itemPosition = titles.indexOf(title);
                final isSelected = itemPosition == (snapshot.data ?? 0);
                return getTitleItem(bodyText2, isSelected, title, itemPosition);
              }).toList(),
            );
          } else {
            return Container();
          }
        });
  }

  Widget getTitleItem(
      TextStyle bodyText2, bool isSelected, String title, int position) {
    final itemDecoration = isSelected
        ? const BoxDecoration(
            border: Border(
              bottom: BorderSide(color: kPrimaryColor, width: 2),
            ),
          )
        : const BoxDecoration();

    return InkWell(
      onTap: () => onTitleClicked(position),
      child: AnimatedContainer(
        duration: duration,
        padding: const EdgeInsets.only(
            top: kDefaultPadding / 4,
            bottom: kDefaultPadding / 4,
            left: kDefaultPadding,
            right: kDefaultPadding),
        decoration: itemDecoration,
        child: Text(
          title,
          style:
              isSelected ? bodyText2.copyWith(color: kPrimaryColor) : bodyText2,
        ),
      ),
    );
  }
}
