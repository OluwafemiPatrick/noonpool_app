import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:noonpool/model/coin_model.dart';

import '../../../helpers/constants.dart';

class HomeCoinItem extends StatelessWidget {
  final CoinModel coinModel;

  const HomeCoinItem({Key? key, required this.coinModel}) : super(key: key);

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
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ClipRRect(
            child: Hero(
              tag: coinModel.id,
              child: CachedNetworkImage(
                imageUrl: coinModel.imageLocation,
                fit: BoxFit.fill,
                width: 40,
                height: 40,
                placeholder: (context, url) => const SizedBox(),
                errorWidget: (context, url, error) => const SizedBox(),
              ),
            ),
            borderRadius: BorderRadius.circular(20),
          ),
          spacer,
          Expanded(
            child: buildCoinDetails(bodyText1, lightText),
          ),
          Expanded(
            child: buildPrice(bodyText1, lightText),
          ),
          spacer,
          Expanded(
            child: buildHashRate(bodyText1, lightText),
          ),
        ],
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
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          coinModel.profit.toStringAsExponential(8),
          style: bodyText1,
        ),
        const SizedBox(height: kDefaultMargin / 4),
        Text(
          coinModel.price.toStringAsFixed(4),
          style: lightText,
        )
      ],
    );
  }

  Column buildHashRate(TextStyle bodyText1, TextStyle lightText) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          coinModel.difficulty.toStringAsExponential(6),
          style: bodyText1,
        ),
        const SizedBox(height: kDefaultMargin / 4),
        Text(
          coinModel.networkHashRate.toStringAsExponential(6),
          style: lightText,
        )
      ],
    );
  }
}
