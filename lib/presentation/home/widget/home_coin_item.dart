import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:noonpool/model/coin_model.dart';

import '../../../helpers/constants.dart';

class HomeCoinItem extends StatelessWidget {
  final Function(CoinModel) onPressed;
  final CoinModel coinModel;

  const HomeCoinItem(
      {Key? key, required this.coinModel, required this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final bodyText1 = textTheme.bodyText1!;
    final bodyText2 = textTheme.bodyText2!;
    final lightText = bodyText2.copyWith(color: kLightText);
    const spacer = SizedBox(
      width: kDefaultMargin / 2,
    );
    return Padding(
      padding: const EdgeInsets.only(
          bottom: kDefaultMargin,
          left: kDefaultMargin / 2,
          right: kDefaultMargin / 2),
      child: InkWell(
        onTap: () => onPressed(coinModel),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SvgPicture.asset(
              coinModel.imageLocation,
              width: 40,
              height: 40,
            ),
            spacer,
            buildCoinDetails(bodyText1, lightText),
            const Spacer(),
            buildPrice(bodyText1, lightText),
            const Spacer(),
            buildHashRate(bodyText1, lightText),
            spacer,
            const Icon(
              Icons.navigate_next,
              color: kPrimaryColor,
            )
          ],
        ),
      ),
    );
  }

  Column buildCoinDetails(TextStyle bodyText1, TextStyle lightText) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          coinModel.coin,
          style: bodyText1,
        ),
        const SizedBox(height: kDefaultMargin / 4),
        Text(
          coinModel.algorithm,
          style: lightText,
        )
      ],
    );
  }

  Column buildPrice(TextStyle bodyText1, TextStyle lightText) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          coinModel.profit,
          style: bodyText1,
        ),
        const SizedBox(height: kDefaultMargin / 4),
        Text(
          coinModel.price,
          style: lightText,
        )
      ],
    );
  }

  Column buildHashRate(TextStyle bodyText1, TextStyle lightText) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          coinModel.poolHashRate,
          style: bodyText1,
        ),
        const SizedBox(height: kDefaultMargin / 4),
        Text(
          coinModel.networkHashRate,
          style: lightText,
        )
      ],
    );
  }
}
