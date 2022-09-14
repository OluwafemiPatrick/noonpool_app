import 'dart:math';

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
    const spacer = SizedBox(width: kDefaultMargin / 2);
    return Padding(
      padding: const EdgeInsets.only(
          //    top: kDefaultMargin / 5,
          bottom: kDefaultMargin,
          left: kDefaultMargin / 2,
          right: kDefaultMargin / 1.2),
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
          (coinModel.price ?? 0).toStringAsFixed(2),
          style: bodyText1,
        ),
        const SizedBox(height: kDefaultMargin / 4),
        Text(
          (coinModel.profit ?? 0).toStringAsExponential(2),
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
        Text(getDifficulty(coinModel.difficulty ?? 0), style: bodyText1),
        const SizedBox(height: kDefaultMargin / 4),
        Text(
          getHashrate(coinModel.netHashrate ?? 0),
          style: lightText,
        )
      ],
    );
  }

  String getDifficulty(double cDifficulty) {
    String difficultyAsString = '';
    final diffLength = cDifficulty.toStringAsFixed(0).length;

    if (diffLength <= 3) {
      final division = (cDifficulty / pow(10, 0));

      difficultyAsString = division.toString().substring(
                0,
                division.toString().length > 4 ? 4 : division.toString().length,
              ) +
          ' H';
    }
    if (diffLength > 3 && diffLength <= 6) {
      final division = (cDifficulty / pow(10, 3));

      difficultyAsString = division.toString().substring(
                0,
                division.toString().length > 4 ? 4 : division.toString().length,
              ) +
          ' KH';
    }
    if (diffLength > 6 && diffLength <= 9) {
      final division = (cDifficulty / pow(10, 6));

      difficultyAsString = division.toString().substring(
                0,
                division.toString().length > 4 ? 4 : division.toString().length,
              ) +
          ' MH';
    }
    if (diffLength > 9 && diffLength <= 12) {
      final division = (cDifficulty / pow(10, 9));

      difficultyAsString = division.toString().substring(
                0,
                division.toString().length > 4 ? 4 : division.toString().length,
              ) +
          ' GH';
    }
    if (diffLength > 12 && diffLength <= 15) {
      final division = (cDifficulty / pow(10, 12));

      difficultyAsString = division.toString().substring(
                0,
                division.toString().length > 4 ? 4 : division.toString().length,
              ) +
          ' TH';
    }
    if (diffLength > 15 && diffLength <= 18) {
      final division = (cDifficulty / pow(10, 15));

      difficultyAsString = division.toString().substring(
                0,
                division.toString().length > 4 ? 4 : division.toString().length,
              ) +
          ' PH';
    }
    if (diffLength > 18 && diffLength <= 21) {
      debugPrint(diffLength.toString());
      final division = (cDifficulty / pow(10, 18));

      difficultyAsString = division.toString().substring(
                0,
                division.toString().length > 4 ? 4 : division.toString().length,
              ) +
          ' EH';
    }
    return difficultyAsString;
  }

  String getHashrate(double hashrate) {
    String hashrateAsString = '';
    final diffLength = hashrate.toStringAsFixed(0).length;

    if (diffLength <= 3) {
      final division = (hashrate / pow(10, 0));

      hashrateAsString = division.toString().substring(
                0,
                division.toString().length > 4 ? 4 : division.toString().length,
              ) +
          ' H/s';
    }
    if (diffLength > 3 && diffLength <= 6) {
      final division = (hashrate / pow(10, 3));

      hashrateAsString = division.toString().substring(
                0,
                division.toString().length > 4 ? 4 : division.toString().length,
              ) +
          ' KH/s';
    }
    if (diffLength > 6 && diffLength <= 9) {
      final division = (hashrate / pow(10, 6));

      hashrateAsString = division.toString().substring(
                0,
                division.toString().length > 4 ? 4 : division.toString().length,
              ) +
          ' MH/s';
    }
    if (diffLength > 9 && diffLength <= 12) {
      final division = (hashrate / pow(10, 9));

      hashrateAsString = division.toString().substring(
                0,
                division.toString().length > 4 ? 4 : division.toString().length,
              ) +
          ' GH/s';
    }
    if (diffLength > 12 && diffLength <= 15) {
      final division = (hashrate / pow(10, 12));

      hashrateAsString = division.toString().substring(
                0,
                division.toString().length > 4 ? 4 : division.toString().length,
              ) +
          ' TH/s';
    }
    if (diffLength > 15 && diffLength <= 18) {
      final division = (hashrate / pow(10, 15));

      hashrateAsString = division.toString().substring(
                0,
                division.toString().length > 4 ? 4 : division.toString().length,
              ) +
          ' PH/s';
    }
    if (diffLength > 18 && diffLength <= 21) {
      debugPrint(diffLength.toString());
      final division = (hashrate / pow(10, 18));

      hashrateAsString = division.toString().substring(
                0,
                division.toString().length > 4 ? 4 : division.toString().length,
              ) +
          ' EH/s';
    }
    return hashrateAsString;
  }
}
