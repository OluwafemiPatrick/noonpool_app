import 'dart:async';
import 'package:noonpool/helpers/constants.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:flutter/material.dart';
import 'package:noonpool/helpers/outlined_button.dart';
import 'package:noonpool/helpers/page_route.dart';
import 'package:noonpool/model/wallet_data/datum.dart';

import 'send_asset.dart';

class SendInputScreen extends StatefulWidget {
  final WalletDatum walletDatum;
  const SendInputScreen({Key? key, required this.walletDatum})
      : super(key: key);

  @override
  State<SendInputScreen> createState() => _SendInputScreenState();
}

class _SendInputScreenState extends State<SendInputScreen> {
  final _formKey = GlobalKey<FormState>();

  static const _recipientAddress = "recipientAddress";
  static const _amount = "amount";

  final _recipientAddressController = TextEditingController(text: '');
  final _amountTextController = TextEditingController(text: '');

  final _amountFocusNode = FocusNode();
  final Map<String, dynamic> _initValues = {_recipientAddress: '', _amount: ''};

  @override
  void dispose() {
    _amountFocusNode.dispose();
    _recipientAddressController.dispose();
    _amountTextController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _recipientAddressController.addListener(() {
      _initValues[_recipientAddress] = _recipientAddressController.text;
    });
    _amountTextController.addListener(() {
      _initValues[_amount] = _amountTextController.text;
    });
  }

  void _saveForm() async {
    final isValid = _formKey.currentState?.validate();
    if ((isValid ?? false) == false) {
      return;
    }

    _formKey.currentState?.save();
    showSendAssetStatus();
  }

  Future showSendAssetStatus() async {
    final receiver = _initValues[_recipientAddress] ?? '';
    final amount = double.tryParse(_initValues[_amount] ?? '') ?? 0;

    Navigator.of(context).pushReplacement(CustomPageRoute(
      screen: SendAsset(
        assetDatum: widget.walletDatum,
        recipientAddress: receiver,
        amount: amount,
      ),
    ));
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final bodyText1 = textTheme.bodyText1!;
    final bodyText2 = textTheme.bodyText2!;

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
        '${AppLocalizations.of(context)!.send} ${widget.walletDatum.coinSymbol}',
        style: bodyText1,
      ),
      leading: const BackButton(
        color: Colors.black,
      ),
    );
  }

  Widget buildBody(TextStyle bodyText2) {
    return SingleChildScrollView(
      padding: const EdgeInsets.only(top: 10, left: 20, right: 20),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: [
            const SizedBox(
              height: 20,
            ),
            ...buildRecipientField(bodyText2),
            const SizedBox(
              height: 20,
            ),
            ...buildAmountField(bodyText2),
            const SizedBox(
              height: 40,
            ),
            buildContinueButton()
          ],
        ),
      ),
    );
  }

  List<Widget> buildAmountField(TextStyle bodyText2) {
    return [
      TextFormField(
        textInputAction: TextInputAction.done,
        focusNode: _amountFocusNode,
        controller: _amountTextController,
        style: bodyText2,
        decoration: InputDecoration(
          labelText:
              '${AppLocalizations.of(context)!.amount} ${widget.walletDatum.coinSymbol}',
          suffixIcon: TextButton(
            onPressed: () {
              _amountTextController.text =
                  (widget.walletDatum.balance ?? 0).toString();
            },
            child: Text(
              '${AppLocalizations.of(context)!.max} ${widget.walletDatum.coinSymbol}',
              style: bodyText2.copyWith(
                fontSize: 12,
              ),
            ),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Colors.red),
          ),
        ),
        keyboardType: TextInputType.number,
        validator: (value) {
          final parsedDouble = double.tryParse(value ?? '');
          if (value == null || value.isEmpty) {
            return AppLocalizations.of(context)!.pleaseProvideTheAmount;
          } else if (parsedDouble == null || parsedDouble == 0) {
            return AppLocalizations.of(context)!.pleaseEnterAValidAmount;
          } else if (parsedDouble > (widget.walletDatum.balance ?? 0)) {
            return AppLocalizations.of(context)!
                .youCanNotSendMoreThanYouPresentlyHave;
          }
          return null;
        },
      ),
    ];
  }

  Widget buildContinueButton() {
    return CustomOutlinedButton(
      onPressed: _saveForm,
      widget: Text(AppLocalizations.of(context)!.continueH),
    );
  }

  List<Widget> buildRecipientField(TextStyle bodyText2) {
    return [
      TextFormField(
        textInputAction: TextInputAction.next,
        controller: _recipientAddressController,
        decoration: InputDecoration(
          labelText: AppLocalizations.of(context)!.recipientAdddress,
          suffixIcon: IconButton(
            icon: const Icon(
              Icons.qr_code_scanner_rounded,
              color: Colors.black,
            ),
            onPressed: () async {
              try {
                final barcodeScanRes = await Navigator.push(
                    context,
                    CustomPageRoute(
                      screen: const _QrScanner(),
                    ));
                if (barcodeScanRes != null && barcodeScanRes.isNotEmpty) {
                  _recipientAddressController.text = barcodeScanRes;
                }
              } catch (exception) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(exception.toString()),
                  ),
                );
              }
            },
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Colors.red),
          ),
        ),
        style: bodyText2,
        onFieldSubmitted: (_) {
          FocusScope.of(context).requestFocus(_amountFocusNode);
        },
        validator: (value) {
          if (value == null || value.isEmpty) {
            return AppLocalizations.of(context)!
                .pleaseProvideTheRecipientAddress;
          }
          return null;
        },
      ),
    ];
  }
}

class _QrScanner extends StatefulWidget {
  const _QrScanner({
    Key? key,
  }) : super(key: key);

  @override
  State<_QrScanner> createState() => __QrScannerState();
}

class __QrScannerState extends State<_QrScanner> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  QRViewController? controller;

/*   @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    } else if (Platform.isIOS) {
      controller!.resumeCamera();
    }
  }
 */
  @override
  Widget build(BuildContext context) {
    final scanArea = (MediaQuery.of(context).size.width < 400 ||
            MediaQuery.of(context).size.height < 400)
        ? 300.0
        : 500.0;
    return Scaffold(
      body: QRView(
        key: qrKey,
        onQRViewCreated: _onQRViewCreated,
        overlay: QrScannerOverlayShape(
            borderColor: kPrimaryColor,
            borderRadius: 10,
            borderLength: 30,
            borderWidth: 10,
            cutOutSize: scanArea),
        onPermissionSet: (ctrl, p) => _onPermissionSet(context, ctrl, p),
      ),
    );
  }

  void _onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
    if (!p) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(AppLocalizations.of(context)!.permissionsNotGranted)),
      );
    }
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;

    late StreamSubscription<Barcode> subscription;
    subscription = controller.scannedDataStream.listen((scanData) {
      Navigator.pop(context, scanData.code ?? '');
      subscription.cancel();
    });
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
