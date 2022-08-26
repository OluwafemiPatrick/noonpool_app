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
                List<String> _coinList = ['LTC', 'BTC', 'DOGE', 'BCH'];
                final selectedCoinData = <CoinModel>[];
                for (final element in allData) {
                  if (_coinList
                      .contains(element.coinSymbol?.toUpperCase() ?? '')) {
                    selectedCoinData.add(element);
                  }
                }

                if (selectedCoinData.isEmpty) {
                  return CustomErrorWidget(
                      error: AppLocalizations.of(context)!
                          .anErrorOccurredPleaseRefreshThePage,
                      onRefresh: () {
                        setState(() {});
                      });
                }

                return _CalculatorTabBody(
                  selectedCoins: selectedCoinData,
                );
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
  final List<CoinModel> selectedCoins;

  const _CalculatorTabBody({
    Key? key,
    required this.selectedCoins,
  }) : super(key: key);

  @override
  State<_CalculatorTabBody> createState() => _CalculatorTabBodyState();
}

class _CalculatorTabBodyState extends State<_CalculatorTabBody> {
  static const _validHashRate = "validHashRate";

  final Map<String, dynamic> _initValues = {_validHashRate: ''};
  final _formKey = GlobalKey<FormState>();

  final _validHashRateFocusNode = FocusNode();
  final _hashRateController = TextEditingController();
  int selectedCoinIndex = 0;
  double _estimatedAmount = 0.0;
  double _dollarValue = 0.0;

  @override
  void dispose() {
    _hashRateController.dispose();
    _validHashRateFocusNode.dispose();
    super.dispose();
  }

  void _saveForm() {
    final isValid = _formKey.currentState?.validate();
    if ((isValid ?? false) == false) {
      return;
    }
    _formKey.currentState?.save();

    final hashRate = double.tryParse(_initValues[_validHashRate]) ?? .0;
    const mswMultiplier = 1000000000000;

    final firstCal = hashRate *
        (widget.selectedCoins[selectedCoinIndex].reward ?? 0) *
        mswMultiplier *
        24; // mswRewards 	= mswReward * mswTemp * mswMultiplier * 24;

    final profitability = firstCal * 0.95;

    setState(() {
      _estimatedAmount = profitability;
      _dollarValue =
          profitability * (widget.selectedCoins[selectedCoinIndex].price ?? 0);
    });
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
      margin: const EdgeInsets.only(left: kDefaultMargin, right: kDefaultMargin),
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
          widget.selectedCoins[selectedCoinIndex].difficulty.toString(),
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
          controller: _hashRateController,
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
              widget.selectedCoins[selectedCoinIndex].coinSymbol ?? '',
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
      title: Row(
        children: [
          const BackButton(
            color: Colors.black,
          ),
          Text(
            AppLocalizations.of(context)!.profitCalculator,
            style: bodyText1,
          ),
        ],
      ),
      actions: [
        Container(
          alignment: Alignment.center,
          child: Container(
            padding: const EdgeInsets.all(kDefaultMargin / 4),
            decoration: BoxDecoration(
              color: kLightBackgroud,
              borderRadius: BorderRadius.circular(kDefaultMargin / 2),
            ),
            child: Row(children: [
              const SizedBox(width: kDefaultMargin),
              Text(widget.selectedCoins[selectedCoinIndex].coinSymbol ?? '',
                  style: bodyText2),
              dropDown(bodyText2),
            ]),
          ),
        ),
        const SizedBox(
          width: kDefaultMargin / 2,
        )
      ],
    );
  }

  Widget dropDown(TextStyle bodyText2) {
    return SizedBox(
      height: 30,
      child: DropdownButton<int>(
        underline: Container(),
        itemHeight: null,
        value: null,
        icon: const Icon(
          Icons.arrow_drop_down_sharp,
          color: kPrimaryColor,
        ),
        items: widget.selectedCoins.map((CoinModel value) {
          return DropdownMenuItem<int>(
            value: widget.selectedCoins.indexOf(value),
            child: Text(
              value.coinSymbol ?? '',
              style: bodyText2,
            ),
          );
        }).toList(),
        onChanged: (newValue) {
          setState(() {
            _hashRateController.text = '';
            _initValues[_validHashRate] = '';
            _dollarValue = 0;
            _estimatedAmount = 0;
            selectedCoinIndex = newValue ?? 0;
          });
        },
      ),
    );
  }
}
