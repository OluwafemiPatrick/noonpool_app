import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../helpers/constants.dart';
import '../../helpers/elevated_button.dart';

class CalculatorTab extends StatefulWidget {
  const CalculatorTab({Key? key}) : super(key: key);

  @override
  State<CalculatorTab> createState() => _CalculatorTabState();
}

class _CalculatorTabState extends State<CalculatorTab> {
  static const _difficulty = "difficulty";
  static const _price = "price";
  static const _ppsRate = "ppsRate";
  static const _validHashRate = "validHashRate";

  final Map<String, dynamic> _initValues = {
    _difficulty: '',
    _price: '',
    _ppsRate: '',
    _validHashRate: ''
  };
  final _formKey = GlobalKey<FormState>();
  final _priceFocusNode = FocusNode();
  final _ppsFocusNode = FocusNode();
  final _validHashRateFocusNode = FocusNode();

  void _saveForm() {
    final isValid = _formKey.currentState?.validate();
    if ((isValid ?? false) == false) {
      return;
    }
    _formKey.currentState?.save();
  }

  @override
  void dispose() {
    _priceFocusNode.dispose();
    _ppsFocusNode.dispose();
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
    return Scaffold(
        body: Form(
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
          ...buildPrice(bodyText2),
          spacer,
          ...buildPPSFeeRate(bodyText2),
          spacer,
          ...buildValidHashRate(bodyText2),
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
    ));
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
      Padding(
        padding: const EdgeInsets.only(
            left: kDefaultPadding, right: kDefaultPadding),
        child: TextFormField(
          textInputAction: TextInputAction.next,
          style: bodyText2,
          onFieldSubmitted: (_) {
            FocusScope.of(context).requestFocus(_priceFocusNode);
          },
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
            return null;
          },
          onSaved: (value) {
            _initValues[_difficulty] = value ?? "";
          },
        ),
      ),
    ];
  }

  List<Widget> buildPrice(TextStyle bodyText2) {
    return [
      Padding(
        child: Text(
          'Price',
          style: bodyText2,
        ),
        padding: const EdgeInsets.only(left: kDefaultMargin),
      ),
      const SizedBox(
        height: kDefaultMargin / 4,
      ),
      Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(
                  left: kDefaultPadding, right: kDefaultPadding),
              child: TextFormField(
                textInputAction: TextInputAction.next,
                focusNode: _priceFocusNode,
                style: bodyText2,
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_ppsFocusNode);
                },
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.only(
                      left: kDefaultPadding / 2, right: kDefaultPadding / 2),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(kDefaultMargin / 4),
                    borderSide:
                        const BorderSide(width: 1, color: kPrimaryColor),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(kDefaultMargin / 4),
                    borderSide:
                        const BorderSide(width: 1, color: kPrimaryColor),
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
                  _initValues[_price] = value ?? "";
                },
              ),
            ),
          ),
          const SizedBox(
            width: kDefaultMargin / 2,
          ),
          Container(
            margin: const EdgeInsets.only(right: kDefaultMargin),
            padding: const EdgeInsets.all(kDefaultPadding / 4),
            decoration: BoxDecoration(
              border: Border.all(width: 1, color: kPrimaryColor),
              borderRadius: BorderRadius.circular(kDefaultMargin / 4),
            ),
            child: Row(
              children: [
                Text(
                  'USD/BTC',
                  style: bodyText2,
                ),
                const Icon(
                  Icons.arrow_drop_down,
                  color: kTextColor,
                )
              ],
            ),
          )
        ],
      ),
    ];
  }

  List<Widget> buildPPSFeeRate(TextStyle bodyText2) {
    return [
      Padding(
        child: Text(
          'PPS Fee Rate',
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
          focusNode: _ppsFocusNode,
          style: bodyText2,
          onFieldSubmitted: (_) {
            FocusScope.of(context).requestFocus(_validHashRateFocusNode);
          },
          decoration: InputDecoration(
            suffixIcon: const Icon(
              Icons.percent_rounded,
              size: 18,
              color: kPrimaryColor,
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
            _initValues[_ppsRate] = value ?? "";
          },
        ),
      ),
    ];
  }

  List<Widget> buildValidHashRate(TextStyle bodyText2) {
    return [
      Padding(
        child: Text(
          'Valid HashRate',
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
              '0.00000565',
              style: bodyText1.copyWith(fontSize: 25),
            ),
            const SizedBox(
              width: kDefaultMargin / 5,
            ),
            Text(
              'BTC',
              style: bodyText2,
            ),
            const Spacer(),
            Text(
              '= \$ 0.2566',
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
            padding: const EdgeInsets.all(kDefaultMargin / 4),
            decoration: BoxDecoration(
                color: kLightBackgroud,
                borderRadius: BorderRadius.circular(kDefaultMargin)),
            child: Row(
              children: [
                SvgPicture.asset(
                  'assets/coins/btc.svg',
                  height: 25,
                  width: 25,
                ),
                const SizedBox(
                  width: kDefaultMargin / 5,
                ),
                Text(
                  'BTC',
                  style: bodyText2,
                ),
                const Icon(
                  Icons.arrow_drop_down,
                  color: kTextColor,
                )
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
