import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:noonpool/helpers/elevated_button.dart';
import 'package:noonpool/helpers/locale_cubit.dart';
import '../../helpers/constants.dart';

class LanguageChanger extends StatefulWidget {
  const LanguageChanger({Key? key}) : super(key: key);

  @override
  State<LanguageChanger> createState() => _LanguageChangerState();
}

class _LanguageChangerState extends State<LanguageChanger> {
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final bodyText1 = textTheme.bodyText1!;
    final bodyText2 = textTheme.bodyText2!;
    const spacer = SizedBox(
      height: kDefaultMargin,
    );

    return Scaffold(
      appBar: buildAppBar(bodyText1, bodyText2),
      body: BlocBuilder<LocaleCubit, Locale?>(
        builder: (context, locale) {
          final allLocales = appLocales(context);
          return ListView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.all(10),
            children: [
              spacer,
              Center(
                child: Lottie.asset('assets/lottie/language.json',
                    width: 180,
                    animate: true,
                    reverse: true,
                    repeat: true,
                    height: 150,
                    fit: BoxFit.fitWidth,
                    alignment: Alignment.center),
              ),
              spacer,
              ...allLocales
                  .map(
                    (appLocale) => Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Divider(),
                        ListTile(
                          contentPadding: const EdgeInsets.all(0),
                          onTap: () {
                            BlocProvider.of<LocaleCubit>(context)
                                .updateCurrentLocale(appLocale.locale);
                          },
                          trailing: Checkbox(
                            value: (locale == null && appLocale.locale == null)
                                ? true
                                : locale == appLocale.locale,
                            onChanged: (bool? value) {
                              if (value == null) {
                                return;
                              } else if (value) {
                                BlocProvider.of<LocaleCubit>(context)
                                    .updateCurrentLocale(appLocale.locale);
                              }
                            },
                          ),
                          title: Text(
                            appLocale.rawName + " " + appLocale.translatedName,
                            style: bodyText2,
                          ),
                        ),
                      ],
                    ),
                  )
                  .toList(),
              spacer,
              spacer
            ],
          );
        },
      ),
    );
  }

  AppBar buildAppBar(TextStyle? bodyText1, TextStyle bodyText2) {
    return AppBar(
      elevation: 0,
      leading: const BackButton(color: Colors.black),
      backgroundColor: Colors.transparent,
      title: Text(
        AppLocalizations.of(context)!.language,
        style: bodyText1,
      ),
    );
  }

  void showLanguageDialog() async {
    final textTheme = Theme.of(context).textTheme;
    final bodyText1 = textTheme.bodyText1!;
    final bodyText2 = textTheme.bodyText2!;

    Dialog dialog = Dialog(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(10),
        ),
      ),
      elevation: 5,
      child: BlocBuilder<LocaleCubit, Locale?>(
        builder: (context, locale) {
          return Container(
            clipBehavior: Clip.antiAliasWithSaveLayer,
            padding: const EdgeInsets.only(
                top: kDefaultPadding,
                bottom: kDefaultPadding,
                left: kDefaultPadding,
                right: kDefaultPadding),
            decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(10))),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppLocalizations.of(context)!.language,
                  style: bodyText1,
                ),
                const SizedBox(
                  height: kDefaultMargin / 2,
                ),
                const Divider(),
              ],
            ),
          );
        },
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
