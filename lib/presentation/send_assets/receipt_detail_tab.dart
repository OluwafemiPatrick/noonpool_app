import 'package:flutter/material.dart';

class ReceiptDetailsTab extends StatelessWidget {
  final String heading;
  final String tailingText;
  final Color? color;
  const ReceiptDetailsTab({
    Key? key,
    required this.heading,
    required this.tailingText,
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    var bodyText2 = textTheme.bodyText2!;
    final titleStyle =
        bodyText2.copyWith(fontSize: 16, fontWeight: FontWeight.w500);

    if (color != null) {
      bodyText2 = bodyText2.copyWith(color: color);
    }

    return Card(
      clipBehavior: Clip.antiAliasWithSaveLayer,
      elevation: 1,
      margin: const EdgeInsets.only(left: 3, right: 3, bottom: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(heading, style: titleStyle),
            const SizedBox(
              width: 5,
            ),
            Expanded(
              child: Text(
                tailingText,
                textAlign: TextAlign.end,
                style: bodyText2,
                maxLines: 1,
                softWrap: true,
                overflow: TextOverflow.ellipsis,
              ),
            )
          ],
        ),
      ),
    );
  }
}
