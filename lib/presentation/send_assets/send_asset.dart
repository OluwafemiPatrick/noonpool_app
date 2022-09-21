import 'package:flutter/material.dart';
import 'package:noonpool/helpers/constants.dart';
import 'package:noonpool/helpers/elevated_button.dart';
import 'package:noonpool/helpers/error_widget.dart';
import 'package:noonpool/helpers/network_helper.dart';
import 'package:noonpool/helpers/shared_preference_util.dart';
import 'package:noonpool/main.dart';
import 'package:noonpool/model/send_creation_model/send_creation_model.dart';
import 'package:noonpool/model/wallet_data/datum.dart';
import 'package:noonpool/presentation/settings/verify_otp.dart';

import '../../helpers/page_route.dart';
import 'receipt_detail_tab.dart';

class SendAsset extends StatefulWidget {
  final WalletDatum assetDatum;
  final String recipientAddress;
  final double amount;

  const SendAsset(
      {Key? key,
      required this.assetDatum,
      required this.recipientAddress,
      required this.amount})
      : super(key: key);

  @override
  State<SendAsset> createState() => _SendAssetState();
}

class _SendAssetState extends State<SendAsset> {
  bool _isLoading = false;
  bool _isFetchingPrice = true;
  bool _priceFetchHasError = false;

  SendCreationModel sendCreationModel = SendCreationModel();
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, getData);
  }

  getData() async {
    setState(() {
      _isFetchingPrice = true;
      _priceFetchHasError = false;
    });

    try {
      final reciever = widget.recipientAddress;
      final network = widget.assetDatum.coinSymbol ?? '';
      final amount = widget.amount;
      sendCreationModel = await createSendTransaction(
        reciever: reciever,
        amount: amount,
        network: network,
      );
      _priceFetchHasError = false;
    } catch (exception) {
      MyApp.scaffoldMessengerKey.currentState?.showSnackBar(
        SnackBar(
          content: Text(
            exception.toString(),
          ),
        ),
      );
      _priceFetchHasError = true;
    }

    setState(() {
      _isFetchingPrice = false;
    });
  }

  AppBar buildAppBar(
    TextStyle? bodyText1,
  ) {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.transparent,
      title: Text(
        '${AppLocalizations.of(context)!.send} ${widget.assetDatum.coinSymbol}',
        style: bodyText1?.copyWith(fontWeight: FontWeight.bold),
      ),
      leading: const BackButton(
        color: Colors.black,
      ),
    );
  }

  void showConfirmationDialog() async {
    if (_isLoading) {
      return;
    }

    final action = await confirmTransaction();
    if (action != null && action) {
      if (AppPreferences.get2faSecurityEnabled) {
        Navigator.of(context).push(
          CustomPageRoute(
            screen: VerifyOtp(
              backEnaled: false,
              onNext: (_) => showSendAssetStatus(),
              id: AppPreferences.userId,
            ),
          ),
        );
      } else {
        showSendAssetStatus();
      }
    }
  }

  Future showSendAssetStatus() async {
    final network = widget.assetDatum.coinSymbol ?? '';

    setState(() {
      _isLoading = true;
    });
    try {
      await sendFromWallet(
        creationModel: sendCreationModel,
        network: network,
      );

      await showMessage(
        AppLocalizations.of(context)!.yourTransactionWasSentSuccessfully,
      );
      () {
        Navigator.of(context).pop();
      }();
    } catch (exception) {
      await showMessage(
        exception.toString(),
      );
      () {
        Navigator.of(context).pop();
      }();
    }
    setState(() {
      _isLoading = false;
    });
  }

  Future<bool?> confirmTransaction() async {
    return showDialog<bool>(
      context: context,
      barrierDismissible: false, // user must tap button for close dialog!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(AppLocalizations.of(context)!.transactionConfirmation),
          content: Text(AppLocalizations.of(context)!
              .doYouWantToTransferThisAmountToTheSelectedAddress),
          actions: <Widget>[
            TextButton(
              child: Text(AppLocalizations.of(context)!.cancel),
              onPressed: () {
                Navigator.of(context).pop(false);
              },
            ),
            TextButton(
              child: Text(AppLocalizations.of(context)!.confirm),
              onPressed: () {
                Navigator.of(context).pop(true);
              },
            )
          ],
        );
      },
    );
  }

  showMessage(String message) async {
    return showDialog(
      context: context,
      barrierDismissible: false, // user must tap button for close dialog!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(AppLocalizations.of(context)!.transactionStatus),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: Text(AppLocalizations.of(context)!.confirm),
              onPressed: () {
                Navigator.of(context).pop();
              },
            )
          ],
        );
      },
    );
  }

  buildProgressBar() {
    return const Center(
      child: SizedBox(
        height: 50,
        width: 50,
        child: CircularProgressIndicator.adaptive(
          backgroundColor: kLightBackground,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final bodyText1 = textTheme.bodyText1!;
    final bodyText2 = textTheme.bodyText2!;

    return Scaffold(
      appBar: buildAppBar(bodyText1),
      body: _isFetchingPrice
          ? buildProgressBar()
          : _priceFetchHasError
              ? CustomErrorWidget(
                  error: AppLocalizations.of(context)!
                      .anErrorOccurredWithTheDataFetchPleaseTryAgain,
                  onRefresh: () {
                    getData();
                  })
              : buildBody(bodyText2, bodyText1),
    );
  }

  SingleChildScrollView buildBody(
    TextStyle bodyText2,
    TextStyle? bodyText1,
  ) {
    return SingleChildScrollView(
      padding: const EdgeInsets.only(
        top: 10,
        left: 20,
        right: 20,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: [
          const SizedBox(
            height: 20,
          ),
          Container(
            alignment: Alignment.center,
            child: Text(
              '-${widget.amount} ${widget.assetDatum.coinSymbol}',
              style:
                  bodyText2.copyWith(fontSize: 20, fontWeight: FontWeight.w500),
            ),
          ),
          /*  Container(
            alignment: Alignment.center,
            child: Text(
              '= \$ 5.23',
              style: bodyText2.copyWith(fontSize: 16),
            ),
          ), */
          const SizedBox(
            height: 40,
          ),
          ReceiptDetailsTab(
              heading: AppLocalizations.of(context)!.asset,
              tailingText:
                  "${widget.assetDatum.coinName} (${widget.assetDatum.coinSymbol})"),
          ReceiptDetailsTab(
              heading: AppLocalizations.of(context)!.to,
              tailingText: sendCreationModel.message?.reciepient ?? ''),
          ReceiptDetailsTab(
              heading: AppLocalizations.of(context)!.noonPoolFee,
              tailingText:
                  '-${sendCreationModel.message?.fee} ${widget.assetDatum.coinSymbol}'),
          ReceiptDetailsTab(
              heading: AppLocalizations.of(context)!.totalAmount,
              tailingText:
                  '-${widget.amount - (double.tryParse(sendCreationModel.message?.fee ?? '0.0') ?? 0)} ${widget.assetDatum.coinSymbol}'),
          const SizedBox(
            height: 40,
          ),
          CustomElevatedButton(
            onPressed: showConfirmationDialog,
            widget: _isLoading
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator.adaptive(
                      backgroundColor: Colors.white,
                    ),
                  )
                : Text(
                    AppLocalizations.of(context)!.confirm,
                    style: bodyText2.copyWith(color: Colors.white),
                  ),
          ),
        ],
      ),
    );
  }
}
