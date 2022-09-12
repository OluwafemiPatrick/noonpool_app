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
        Text(getDifficulty(coinModel.difficulty), style: bodyText1),
        const SizedBox(height: kDefaultMargin / 4),
        Text(
          getHashrate(coinModel.netHashrate),
          style: lightText,
        )
      ],
    );
  }

  String getDifficulty(var cDifficulty) {
    String difficulty = '';
    var diffLength = cDifficulty.toStringAsFixed(0).length;
    int mod = diffLength! % 3;

    String digit_1 = cDifficulty.toString()[0];
    String digit_2 = cDifficulty.toString()[1];
    String digit_3 = cDifficulty.toString()[2];

    if (diffLength <= 3) {
      if (mod == 0) {
        difficulty = "$digit_1$digit_2$digit_3 H";
      } else if (mod == 1) {
        difficulty = "$digit_1.$digit_2$digit_3 H";
      } else {
        difficulty = "$digit_1$digit_2.$digit_3 H";
      }
    }
    if (diffLength > 3 && diffLength <= 6) {
      if (mod == 0) {
        difficulty = "$digit_1$digit_2$digit_3 KH";
      } else if (mod == 1) {
        difficulty = "$digit_1.$digit_2$digit_3 KH";
      } else {
        difficulty = "$digit_1$digit_2.$digit_3 KH";
      }
    }
    if (diffLength > 6 && diffLength <= 9) {
      if (mod == 0) {
        difficulty = "$digit_1$digit_2$digit_3 MH";
      } else if (mod == 1) {
        difficulty = "$digit_1.$digit_2$digit_3 MH";
      } else {
        difficulty = "$digit_1$digit_2.$digit_3 MH";
      }
    }
    if (diffLength > 9 && diffLength <= 12) {
      if (mod == 0) {
        difficulty = "$digit_1$digit_2$digit_3 GH";
      } else if (mod == 1) {
        difficulty = "$digit_1.$digit_2$digit_3 GH";
      } else {
        difficulty = "$digit_1$digit_2.$digit_3 GH";
      }
    }
    if (diffLength > 12 && diffLength <= 15) {
      if (mod == 0) {
        difficulty = "$digit_1$digit_2$digit_3 TH";
      } else if (mod == 1) {
        difficulty = "$digit_1.$digit_2$digit_3 TH";
      } else {
        difficulty = "$digit_1$digit_2.$digit_3 TH";
      }
    }
    if (diffLength > 15 && diffLength <= 18) {
      if (mod == 0) {
        difficulty = "$digit_1$digit_2$digit_3 PH";
      } else if (mod == 1) {
        difficulty = "$digit_1.$digit_2$digit_3 PH";
      } else {
        difficulty = "$digit_1$digit_2.$digit_3 PH";
      }
    }

    return difficulty;
  }

  String getHashrate(var cHashrate) {
    String hashrate = '';
    var diffLength = cHashrate.toStringAsFixed(0).length;
    int mod = diffLength! % 3;

    String digit_1 = cHashrate.toString()[0];
    String digit_2 = cHashrate.toString()[1];
    String digit_3 = cHashrate.toString()[2];

    if (diffLength <= 3) {
      if (mod == 0) {
        hashrate = "$digit_1$digit_2$digit_3 H/s";
      } else if (mod == 1) {
        hashrate = "$digit_1.$digit_2$digit_3 H/s";
      } else {
        hashrate = "$digit_1$digit_2.$digit_3 H/s";
      }
    }
    if (diffLength > 3 && diffLength <= 6) {
      if (mod == 0) {
        hashrate = "$digit_1$digit_2$digit_3 KH/s";
      } else if (mod == 1) {
        hashrate = "$digit_1.$digit_2$digit_3 KH/s";
      } else {
        hashrate = "$digit_1$digit_2.$digit_3 KH/s";
      }
    }
    if (diffLength > 6 && diffLength <= 9) {
      if (mod == 0) {
        hashrate = "$digit_1$digit_2$digit_3 MH/s";
      } else if (mod == 1) {
        hashrate = "$digit_1.$digit_2$digit_3 MH/s";
      } else {
        hashrate = "$digit_1$digit_2.$digit_3 MH/s";
      }
    }
    if (diffLength > 9 && diffLength <= 12) {
      if (mod == 0) {
        hashrate = "$digit_1$digit_2$digit_3 GH/s";
      } else if (mod == 1) {
        hashrate = "$digit_1.$digit_2$digit_3 GH/s";
      } else {
        hashrate = "$digit_1$digit_2.$digit_3 GH/s";
      }
    }
    if (diffLength > 12 && diffLength <= 15) {
      if (mod == 0) {
        hashrate = "$digit_1$digit_2$digit_3 TH/s";
      } else if (mod == 1) {
        hashrate = "$digit_1.$digit_2$digit_3 TH/s";
      } else {
        hashrate = "$digit_1$digit_2.$digit_3 TH/s";
      }
    }
    if (diffLength > 15 && diffLength <= 18) {
      if (mod == 0) {
        hashrate = "$digit_1$digit_2$digit_3 PH/s";
      } else if (mod == 1) {
        hashrate = "$digit_1.$digit_2$digit_3 PH/s";
      } else {
        hashrate = "$digit_1$digit_2.$digit_3 PH/s";
      }
    }
    if (diffLength > 18 && diffLength <= 21) {
      if (mod == 0) {
        hashrate = "$digit_1$digit_2$digit_3 EH/s";
      } else if (mod == 1) {
        hashrate = "$digit_1.$digit_2$digit_3 EH/s";
      } else {
        hashrate = "$digit_1$digit_2.$digit_3 EH/s";
      }
    }
    return hashrate;
  }

}
