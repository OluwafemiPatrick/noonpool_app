import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:noonpool/helpers/constants.dart';
import 'package:noonpool/model/announcement_model.dart';

class AnnouncementItem extends StatelessWidget {
  final Announcement announcement;

  const AnnouncementItem({Key? key, required this.announcement})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final bodyText1 = textTheme.bodyText1!;
    final bodyText2 = textTheme.bodyText2!;

    return InkWell(
      onTap: () => showAnnouncementDialog(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(
            height: kDefaultMargin / 2,
          ),
          Text(
            getFormattedDate(announcement.timeStamp),
            style: bodyText2,
          ),
          const SizedBox(
            height: kDefaultMargin / 2,
          ),
          Card(
            elevation: 2,
            margin: const EdgeInsets.only(
                left: kDefaultMargin / 2, right: kDefaultMargin / 2),
            child: Padding(
              padding: const EdgeInsets.all(kDefaultPadding / 2),
              child: Column(
                children: [
                  Text(
                    announcement.title,
                    style: bodyText1,
                  ),
                  const SizedBox(
                    height: kDefaultMargin / 2,
                  ),
                  Text(
                    announcement.body,
                    maxLines: 3,
                    style: bodyText2,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(
            height: kDefaultMargin / 2,
          ),
          const Divider(),
        ],
      ),
    );
  }

  String getFormattedDate(String timestamp) {
    try {
      var dateTime = DateTime.fromMillisecondsSinceEpoch(int.parse(timestamp));
      return DateFormat('MMMM dd, yyyy h:mm').format(dateTime);
    } catch (exception) {
      return "";
    }
  }

  void showAnnouncementDialog(BuildContext context) async {
    final textTheme = Theme.of(context).textTheme;
    final bodyText1 = textTheme.bodyText1!;
    final bodyText2 = textTheme.bodyText2!;

    var height = MediaQuery.of(context).size.height;

    Dialog dialog = Dialog(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(10),
        ),
      ),
      elevation: 5,
      child: Container(
        clipBehavior: Clip.antiAliasWithSaveLayer,
        height: height * 0.5,
        padding: const EdgeInsets.only(
            bottom: kDefaultPadding,
            left: kDefaultPadding,
            right: kDefaultPadding),
        decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(10))),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Lottie.asset('assets/lottie/announcement.json',
                  width: 260,
                  animate: true,
                  reverse: true,
                  repeat: true,
                  height: 200,
                  fit: BoxFit.fitWidth,
                  alignment: Alignment.center),
              const SizedBox(
                height: kDefaultMargin,
              ),
              Text(
                announcement.title,
                style: bodyText1,
              ),
              const SizedBox(
                height: kDefaultMargin / 2,
              ),
              Text(
                announcement.body,
                style: bodyText2,
              ),
            ],
          ),
        ),
      ),
    );
    showGeneralDialog(
      context: context,
      barrierLabel: "Announcement Dialog",
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.5),
      transitionDuration: const Duration(milliseconds: 500),
      pageBuilder: (_, __, ___) => dialog,
      transitionBuilder: (_, anim, __, child) => FadeTransition(
        opacity: Tween(begin: 0.0, end: 1.0).animate(anim),
        child: child,
      ),
    );
  }
}
