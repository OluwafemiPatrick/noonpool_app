import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:noonpool/helpers/error_widget.dart';
import 'package:noonpool/model/coin_model/coin_model.dart';

import '../../helpers/constants.dart';
import '../../helpers/elevated_button.dart';
import '../../helpers/network_helper.dart';

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({Key? key}) : super(key: key);

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
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
                    error: AppLocalizations.of(context)!
                        .anErrorOccurredPleaseRefreshThePage,
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
  static const _validHashRate = "validHashRate";

  final Map<String, dynamic> _initValues = {_validHashRate: ''};
  final _formKey = GlobalKey<FormState>();

  final _validHashRateFocusNode = FocusNode();

  double _estimatedAmount = 0.0;
  double _dollarValue = 0.0;

  void _saveForm() {
    final isValid = _formKey.currentState?.validate();
    if ((isValid ?? false) == false) {
      return;
    }
    _formKey.currentState?.save();

    final hashRate = double.tryParse(_initValues[_validHashRate]) ?? .0;
    const mswMultiplier = 1000000000000;

    final firstCal = hashRate *
        (widget.coinModel.reward ?? 0) *
        mswMultiplier *
        24; // mswRewards 	= mswReward * mswTemp * mswMultiplier * 24;

    final profitability = firstCal * 0.95;

    setState(() {
      _estimatedAmount = profitability;
      _dollarValue = profitability * (widget.coinModel.price ?? 0);
    });
  }

  @override
  void dispose() {
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
          ...buildNumberOfMiners(bodyText2),
          spacer,
          ...buildValidHashRate(bodyText2),
          spacer,
          Padding(
            padding: const EdgeInsets.only(
                left: kDefaultPadding, right: kDefaultPadding),
            child: CustomElevatedButton(
              onPressed: _saveForm,
              widget: Text(
                AppLocalizations.of(context)!.calculate,
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
          AppLocalizations.of(context)!
              .theResultIsTheTheoreticalPpsMiningYieldBasedOnTheSetDifficultyAndTheAverageMinerFeesInThePast7Days,
          style: bodyText2.copyWith(color: kPrimaryColor),
        ),
      ),
    );
  }

  List<Widget> buildPPSFeeRate(TextStyle bodyText2) {
    return [
      Padding(
        child: Text(
          AppLocalizations.of(context)!.ppsFeeRate,
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
          AppLocalizations.of(context)!.difficulty,
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
          widget.coinModel.difficulty.toString(),
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

  List<Widget> buildNumberOfMiners(TextStyle bodyText2) {
    return [
      Padding(
        child: Text(
          AppLocalizations.of(context)!.numberOfMiners,
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
          '1',
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
          AppLocalizations.of(context)!.validHashrate,
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
              borderSide: const BorderSide(width: 3, color: Colors.red),
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
          AppLocalizations.of(context)!.estDailyYield,
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
              _estimatedAmount.toStringAsFixed(8),
              style: bodyText1.copyWith(fontSize: 25),
            ),
            const SizedBox(
              width: kDefaultMargin / 5,
            ),
            Text(
              widget.coinModel.coinSymbol ?? '',
              style: bodyText2,
            ),
            const Spacer(),
            Text(
              '= \$ ${_dollarValue.toStringAsFixed(6)}',
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
      automaticallyImplyLeading: false,
      backgroundColor: Colors.transparent,
      title: Text(
        AppLocalizations.of(context)!.profitCalculator,
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
                    imageUrl: widget.coinModel.coinLogo ?? '',
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
                  widget.coinModel.coinSymbol ?? '',
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
