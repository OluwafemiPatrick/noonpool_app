import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:noonpool/model/coin_model/coin_model.dart';
import 'package:shimmer/shimmer.dart';

import '../../../helpers/constants.dart';

class HomeCoinItem extends StatelessWidget {
  final CoinModel coinModel;
  final bool shimmerEnabled;
  const HomeCoinItem({
    Key? key,
    required this.coinModel,
    this.shimmerEnabled = false,
  }) : super(key: key);

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
      child: shimmerEnabled
          ? Shimmer.fromColors(
              baseColor: Colors.grey.shade100,
              highlightColor: Colors.grey.shade300,
              child: shimmerBody(spacer),
            )
          : buildBody(spacer, bodyText1, lightText),
    );
  }

  Row shimmerBody(SizedBox spacer) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        ClipRRect(
          child: Hero(
            tag: coinModel.id?.toString() ?? '-',
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                color: Colors.grey,
              ),
            ),
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        spacer,
        Expanded(
          child: Column(children: [
            Container(
              width: double.infinity,
              height: 10,
              color: kPrimaryColor,
            ),
            const SizedBox(height: kDefaultMargin / 4),
            Container(
              width: double.infinity,
              height: 10,
              color: kPrimaryColor,
            ),
          ]),
        ),
        spacer,
        Expanded(
          child: Column(children: [
            Container(
              width: double.infinity,
              height: 10,
              color: kPrimaryColor,
            ),
            const SizedBox(height: kDefaultMargin / 4),
            Container(
              width: double.infinity,
              height: 10,
              color: kPrimaryColor,
            ),
          ]),
        ),
        spacer,
        Expanded(
          child: Column(children: [
            Container(
              width: double.infinity,
              height: 10,
              color: kPrimaryColor,
            ),
            const SizedBox(height: kDefaultMargin / 4),
            Container(
              width: double.infinity,
              height: 10,
              color: kPrimaryColor,
            ),
          ]),
        ),
      ],
    );
  }

  Row buildBody(SizedBox spacer, TextStyle bodyText1, TextStyle lightText) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        ClipRRect(
          child: Hero(
            tag: coinModel.id?.toString() ?? '-',
            child: CachedNetworkImage(
              imageUrl: coinModel.coinLogo ?? '',
              fit: BoxFit.fill,
              width: 40,
              height: 40,
              placeholder: (context, url) => Container(
                color: Colors.brown[300],
              ),
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
    );
  }

  Column buildCoinDetails(TextStyle bodyText1, TextStyle lightText) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          coinModel.coinName ?? '',
          style: bodyText1,
        ),
        const SizedBox(height: kDefaultMargin / 4),
        Text(
          coinModel.algo ?? '',
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
          (coinModel.price ?? 0).toStringAsFixed(4),
          style: bodyText1,
        ),
        const SizedBox(height: kDefaultMargin / 4),
        Text(
          (coinModel.profit ?? 0).toStringAsExponential(8),
          style: lightText,
        ),
      ],
    );
  }

  Column buildHashRate(TextStyle bodyText1, TextStyle lightText) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          (coinModel.difficulty ?? 0).toStringAsExponential(6),
          style: bodyText1,
        ),
        const SizedBox(height: kDefaultMargin / 4),
        Text(
          (coinModel.netHashrate ?? 0).toStringAsExponential(6),
          style: lightText,
        )
      ],
    );
  }
}
