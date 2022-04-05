import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:noonpool/helpers/error_widget.dart';

import '../../helpers/constants.dart';
import '../../helpers/elevated_button.dart';
import '../../helpers/firebase_util.dart';
import '../../model/coin_model.dart';

class CalculatorTab extends StatefulWidget {
  const CalculatorTab({Key? key}) : super(key: key);

  @override
  State<CalculatorTab> createState() => _CalculatorTabState();
}

class _CalculatorTabState extends State<CalculatorTab> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<CoinModel>>(
        future: getAllCoinDetails(),
        builder: (ctx, asyncDataSnapshot) {
          if (asyncDataSnapshot.hasError) {
            // show error
            final error = asyncDataSnapshot.error.toString();
            return CustomErrorWidget(
                error: error,
                onRefresh: () {
                  setState(() {});
                });
          } else {
            if (asyncDataSnapshot.hasData) {
              List<CoinModel> allData = asyncDataSnapshot.data ?? [];
              if (allData.isNotEmpty) {
                return _CalculatorTabBody(coinModel: allData[0]);
              } else {
                return CustomErrorWidget(
                    error: 'Error occurred, please refresh the page',
                    onRefresh: () {
                      setState(() {});
                    });
              }
            } else {
              //  loading progress bar
              return Center(
                child: Lottie.asset(
                  'assets/lottie/loading.json',
                  width: 100,
                  animate: true,
                  reverse: true,
                  repeat: true,
                  height: 100,
                  fit: BoxFit.contain,
                ),
              );
            }
          }
        },
      ),
    );
  }
}

class _CalculatorTabBody extends StatefulWidget {
  final CoinModel coinModel;

  const _CalculatorTabBody({Key? key, required this.coinModel})
      : super(key: key);

  @override
  State<_CalculatorTabBody> createState() => _CalculatorTabBodyState();
}

class _CalculatorTabBodyState extends State<_CalculatorTabBody> {
  static const _miners = "miners";
  static const _validHashRate = "validHashRate";

  final Map<String, dynamic> _initValues = {_miners: '1', _validHashRate: ''};
  final _formKey = GlobalKey<FormState>();
  final _minersFocusNode = FocusNode();

  final _validHashRateFocusNode = FocusNode();
  final _minersController = TextEditingController(text: '1');

  double _estimatedAmount = 0.0;
  double _dollarValue = 0.0;

  void _saveForm() {
    final isValid = _formKey.currentState?.validate();
    if ((isValid ?? false) == false) {
      return;
    }
    _formKey.currentState?.save();

    final miners = double.tryParse(_initValues[_miners]) ?? .0;

    final hashRate = double.tryParse(_initValues[_validHashRate]) ?? .0;
    const blockReward = 6.25;
    const numberOfBlocks = 144;

    final firstCal = hashRate *
        numberOfBlocks *
        blockReward *
        miners; // (miner hashrate * number of blocks per day * block reward * number of miners)
    final secondCal = firstCal /
        widget.coinModel
            .networkHashRate; //(miner hashrate * number of blocks per day * block reward * number of miners) / network hashrate
    final profitability = secondCal * 0.95;

    setState(() {
      _estimatedAmount = profitability;
      _dollarValue = profitability * widget.coinModel.price;
    });
  }

  @override
  void dispose() {
    _minersFocusNode.dispose();
    _minersController.dispose();
    _validHashRateFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final bodyText1 = textTheme.bodyText1!;
    final bodyText2 = textTheme.bodyText2!;
    const spacer = SizedBox(
      height: kDefaultMargin,
    );

    return Form(
      key: _formKey,
      child: ListView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(0),
        children: [
          buildAppBar(bodyText1, bodyText2),
          spacer,
          buildTopText(bodyText2),
          spacer,
          ...buildDifficulty(bodyText2),
          spacer,
          ...buildPPSFeeRate(bodyText2),
          spacer,
          ...buildValidHashRate(bodyText2),
          spacer,
          ...buildMinersNumber(bodyText2),
          spacer,
          Padding(
            padding: const EdgeInsets.only(
                left: kDefaultPadding, right: kDefaultPadding),
            child: CustomElevatedButton(
              onPressed: _saveForm,
              widget: Text(
                'Calculate',
                style: bodyText2.copyWith(
                  color: Colors.white,
                ),
              ),
            ),
          ),
          spacer,
          const Divider(),
          spacer,
          ...buildTotal(bodyText2, bodyText1),
        ],
      ),
    );
  }

  Card buildTopText(TextStyle bodyText2) {
    return Card(
      margin:
          const EdgeInsets.only(left: kDefaultMargin, right: kDefaultMargin),
      color: kLightBackgroud,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(kDefaultPadding / 2),
        child: Text(
          'The result is the theoretical PPS+ mining yield based on the set difficulty and the average miner fees in the past 7 days',
          style: bodyText2.copyWith(color: kPrimaryColor),
        ),
      ),
    );
  }

  List<Widget> buildMinersNumber(TextStyle bodyText2) {
    return [
      Padding(
        child: Text(
          'Number of miners',
          style: bodyText2,
        ),
        padding: const EdgeInsets.only(left: kDefaultMargin),
      ),
      const SizedBox(
        height: kDefaultMargin / 4,
      ),
      Padding(
        padding: const EdgeInsets.only(
            left: kDefaultPadding, right: kDefaultPadding),
        child: TextFormField(
          textInputAction: TextInputAction.done,
          focusNode: _minersFocusNode,
          style: bodyText2,
          controller: _minersController,
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.only(
                left: kDefaultPadding / 2, right: kDefaultPadding / 2),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(kDefaultMargin / 4),
              borderSide: const BorderSide(width: 1, color: kPrimaryColor),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(kDefaultMargin / 4),
              borderSide: const BorderSide(width: 1, color: kPrimaryColor),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(kDefaultMargin / 4),
              borderSide: const BorderSide(width: 2, color: Colors.red),
            ),
          ),
          keyboardType: TextInputType.number,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return '';
            }
            final number = int.tryParse(value.trim());
            if (number != null) {
              return null;
            } else {
              return 'Enter a valid digit';
            }
          },
          onSaved: (value) {
            _initValues[_miners] = value ?? "";
          },
        ),
      ),
    ];
  }

  List<Widget> buildPPSFeeRate(TextStyle bodyText2) {
    return [
      Padding(
        child: Text(
          'PPS fee rate',
          style: bodyText2,
        ),
        padding: const EdgeInsets.only(left: kDefaultMargin),
      ),
      const SizedBox(
        height: kDefaultMargin / 4,
      ),
      Container(
        margin: const EdgeInsets.only(
            left: kDefaultPadding, right: kDefaultPadding),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
              child: Text(
                '5',
                style: bodyText2,
              ),
            ),
            const SizedBox(
              width: kDefaultMargin / 4,
            ),
            const Icon(
              Icons.percent_rounded,
              color: kPrimaryColor,
              size: 18,
            ),
          ],
        ),
        padding: const EdgeInsets.all(kDefaultPadding / 1.5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(kDefaultMargin / 4),
          border: Border.all(
            color: kPrimaryColor,
            width: 1,
          ),
        ),
      ),
    ];
  }

  List<Widget> buildDifficulty(TextStyle bodyText2) {
    return [
      Padding(
        child: Text(
          'Difficulty',
          style: bodyText2,
        ),
        padding: const EdgeInsets.only(left: kDefaultMargin),
      ),
      const SizedBox(
        height: kDefaultMargin / 4,
      ),
      Container(
        margin: const EdgeInsets.only(
            left: kDefaultPadding, right: kDefaultPadding),
        child: Text(
          widget.coinModel.networkHashRate.toString(),
          style: bodyText2,
        ),
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.all(kDefaultPadding / 1.5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(kDefaultMargin / 4),
          border: Border.all(
            color: kPrimaryColor,
            width: 1,
          ),
        ),
      ),
    ];
  }

  List<Widget> buildValidHashRate(TextStyle bodyText2) {
    return [
      Padding(
        child: Text(
          'Valid hashRate',
          style: bodyText2,
        ),
        padding: const EdgeInsets.only(left: kDefaultMargin),
      ),
      const SizedBox(
        height: kDefaultMargin / 4,
      ),
      Padding(
        padding: const EdgeInsets.only(
            left: kDefaultPadding, right: kDefaultPadding),
        child: TextFormField(
          textInputAction: TextInputAction.next,
          onFieldSubmitted: (_) {
            FocusScope.of(context).requestFocus(_minersFocusNode);
          },
          focusNode: _validHashRateFocusNode,
          style: bodyText2,
          decoration: InputDecoration(
            suffixIcon: Container(
              alignment: Alignment.centerRight,
              width: double.minPositive,
              margin: const EdgeInsets.only(
                  left: kDefaultMargin / 4, right: kDefaultMargin / 2),
              child: Text(
                'TH/s',
                style: bodyText2.copyWith(color: kPrimaryColor),
              ),
            ),
            contentPadding: const EdgeInsets.only(
                left: kDefaultPadding / 2, right: kDefaultPadding / 2),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(kDefaultMargin / 4),
              borderSide: const BorderSide(width: 1, color: kPrimaryColor),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(kDefaultMargin / 4),
              borderSide: const BorderSide(width: 1, color: kPrimaryColor),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(kDefaultMargin / 4),
              borderSide: const BorderSide(width: 2, color: Colors.red),
            ),
          ),
          keyboardType: TextInputType.number,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return '';
            }
            return null;
          },
          onSaved: (value) {
            _initValues[_validHashRate] = value ?? "";
          },
        ),
      ),
    ];
  }

  List<Widget> buildTotal(TextStyle bodyText2, TextStyle bodyText1) {
    return [
      Padding(
        child: Text(
          'EST. Daily Yield',
          style: bodyText2,
        ),
        padding: const EdgeInsets.only(
            left: kDefaultPadding, right: kDefaultPadding),
      ),
      const SizedBox(
        height: kDefaultMargin / 4,
      ),
      Padding(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              _estimatedAmount.toStringAsExponential(5),
              style: bodyText1.copyWith(fontSize: 25),
            ),
            const SizedBox(
              width: kDefaultMargin / 5,
            ),
            Text(
              widget.coinModel.coinSubTitle.toUpperCase(),
              style: bodyText2,
            ),
            const Spacer(),
            Text(
              '= \$ ${_dollarValue.toStringAsExponential(5)}',
              style: bodyText2.copyWith(color: kPrimaryColor),
            ),
          ],
        ),
        padding: const EdgeInsets.only(
            left: kDefaultPadding, right: kDefaultPadding),
      ),
    ];
  }

  AppBar buildAppBar(TextStyle? bodyText1, TextStyle bodyText2) {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.transparent,
      title: Text(
        'Profit Calculator',
        style: bodyText1,
      ),
      actions: [
        Center(
          child: Container(
            padding: const EdgeInsets.only(
                top: kDefaultPadding / 4,
                bottom: kDefaultPadding / 4,
                left: kDefaultPadding / 2,
                right: kDefaultPadding / 2),
            decoration: BoxDecoration(
                color: kLightBackgroud,
                borderRadius: BorderRadius.circular(kDefaultMargin)),
            child: Row(
              children: [
                ClipRRect(
                  child: CachedNetworkImage(
                    imageUrl: widget.coinModel.imageLocation,
                    fit: BoxFit.fill,
                    width: 25,
                    height: 25,
                    placeholder: (context, url) => const SizedBox(),
                    errorWidget: (context, url, error) => const SizedBox(),
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                const SizedBox(
                  width: kDefaultMargin / 5,
                ),
                Text(
                  widget.coinModel.coinSubTitle,
                  style: bodyText2,
                ),
              ],
            ),
          ),
        ),
        const SizedBox(
          width: kDefaultMargin / 2,
        )
      ],
    );
  }
}
