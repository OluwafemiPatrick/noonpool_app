import 'package:flutter/material.dart';
import 'package:noonpool/model/announcement_model.dart';
import 'package:noonpool/presentation/announcement/widget/announcement_item.dart';

import '../../helpers/constants.dart';

class AnnouncementScreen extends StatefulWidget {
  const AnnouncementScreen({Key? key}) : super(key: key);

  @override
  State<AnnouncementScreen> createState() => _AnnouncementScreenState();
}

class _AnnouncementScreenState extends State<AnnouncementScreen> {
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final bodyText1 = textTheme.bodyText1!;
    final bodyText2 = textTheme.bodyText2!;
    const spacer = SizedBox(
      height: kDefaultMargin * 2,
    );

    return Scaffold(
      appBar: buildAppBar(bodyText1, bodyText2),
      body: ListView.builder(
        itemCount: dummyAnnouncement.length,
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(0),
        itemBuilder: (ctx, index) =>
            AnnouncementItem(announcement: dummyAnnouncement[index]),
      ),
    );
  }

  AppBar buildAppBar(TextStyle? bodyText1, TextStyle bodyText2) {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.transparent,
      title: Text(
        'Announcement',
        style: bodyText1,
      ),
      leading: const BackButton(
        color: Colors.black,
      ),
    );
  }
}
