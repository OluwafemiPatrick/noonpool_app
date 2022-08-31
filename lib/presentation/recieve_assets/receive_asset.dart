import 'package:flutter/material.dart';
import 'package:noonpool/helpers/constants.dart';
import 'package:noonpool/helpers/error_widget.dart';
import 'package:noonpool/helpers/network_helper.dart';
import 'package:noonpool/main.dart';
import 'package:noonpool/model/recieve_data/recieve_data.dart';
import 'package:noonpool/model/wallet_data/datum.dart';
import 'package:clipboard/clipboard.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:share_plus/share_plus.dart';

class ReceiveAssets extends StatefulWidget {
  final WalletDatum walletDatum;
  const ReceiveAssets({Key? key, required this.walletDatum}) : super(key: key);

  @override
  State<ReceiveAssets> createState() => _ReceiveAssetsState();
}

class _ReceiveAssetsState extends State<ReceiveAssets> {
  RecieveData recieveData = RecieveData();
  bool _isLoading = true;
  bool _hasError = false;
  @override
  initState() {
    super.initState();
    Future.delayed(Duration.zero, getData);
  }

  getData() async {
    setState(() {
      _isLoading = true;
    });
    try {
      recieveData = await walletData(walletDatum: widget.walletDatum);

      _hasError = false;
    } catch (exception) {
      _hasError = true;
      MyApp.scaffoldMessengerKey.currentState?.showSnackBar(
        SnackBar(
          content: Text(
            exception.toString(),
          ),
        ),
      );
    }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final bodyText2 = textTheme.bodyText2;
    final bodyText1 = textTheme.bodyText1;
    return Scaffold(
      appBar: buildAppBar(bodyText1),
      body: buildBody(bodyText2),
    );
  }

  AppBar buildAppBar(TextStyle? bodyText1) {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.transparent,
      title: Text(
        'Receive ${widget.walletDatum.coinSymbol}',
        style: bodyText1?.copyWith(fontWeight: FontWeight.bold),
      ),
      leading: const BackButton(
        color: Colors.black,
      ),
    );
  }

  buildProgressBar() {
    return const Center(
      child: SizedBox(
        height: 50,
        width: 50,
        child: CircularProgressIndicator.adaptive(
          backgroundColor: kLightBackgroud,
        ),
      ),
    );
  }

  Widget buildBody(TextStyle? bodyText2) {
    return _isLoading
        ? buildProgressBar()
        : _hasError
            ? CustomErrorWidget(
                error:
                    "An error occurred with the data fetch, please try again",
                onRefresh: () {
                  getData();
                })
            : Padding(
                padding: const EdgeInsets.only(top: 10, left: 20, right: 20),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      buildQrCode(bodyText2),
                      const SizedBox(
                        height: 20,
                      ),
                      Text(
                        'You should only send ${widget.walletDatum.coinName} cash (${widget.walletDatum.coinSymbol}) to this address. Sending any other coins may result in permanent loss.',
                        textAlign: TextAlign.center,
                        style: bodyText2,
                      ),
                      const SizedBox(
                        height: 40,
                      ),
                      buildBottomControllers()
                    ],
                  ),
                ),
              );
  }

  Row buildBottomControllers() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      children: [
        RoundedIconWithTitle(
            title: 'Copy',
            icon: Icons.copy_rounded,
            onPressed: () async {
              try {
                await FlutterClipboard.copy(
                    recieveData.coinInfo?.address ?? '');
                () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                          'Wallet address has been copied to your clipboard'),
                    ),
                  );
                }();
              } catch (exception) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      exception.toString(),
                    ),
                  ),
                );
              }
            }),
        RoundedIconWithTitle(
            title: 'Share',
            icon: Icons.share_rounded,
            onPressed: () {
              Share.share(recieveData.coinInfo?.address ?? '',
                  subject: 'Share wallet address');
            }),
      ],
    );
  }

  Card buildQrCode(TextStyle? bodyText2) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.all(20),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            QrImage(
              data: recieveData.coinInfo?.address ?? '',
              version: QrVersions.auto,
              size: 250,
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              recieveData.coinInfo?.address ?? '',
              textAlign: TextAlign.center,
              style: bodyText2,
            ),
          ],
        ),
      ),
    );
  }
}

class RoundedIconWithTitle extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onPressed;

  const RoundedIconWithTitle({
    Key? key,
    required this.title,
    required this.icon,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final bodyText2 = textTheme.bodyText2;

    return InkWell(
      onTap: onPressed,
      splashColor: Colors.transparent,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: kPrimaryColor.withOpacity(.05),
            ),
            child: Icon(
              icon,
              size: 30,
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          Text(
            title,
            textAlign: TextAlign.center,
            style: bodyText2,
          ),
        ],
      ),
    );
  }
}
