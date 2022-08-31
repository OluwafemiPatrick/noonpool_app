import 'package:flutter/material.dart';
import 'package:noonpool/helpers/constants.dart';
import 'package:noonpool/helpers/error_widget.dart';
import 'package:noonpool/helpers/network_helper.dart';
import 'package:noonpool/helpers/outlined_button.dart';
import 'package:noonpool/helpers/page_route.dart';
import 'package:noonpool/helpers/shared_preference_util.dart';
import 'package:noonpool/main.dart';
import 'package:noonpool/model/wallet_data/datum.dart';
import 'package:noonpool/model/wallet_data/wallet_data.dart';
import 'package:noonpool/presentation/recieve_assets/recieve_asset_list.dart';
import 'package:noonpool/presentation/send_assets/send_asset_list.dart';
import 'package:noonpool/presentation/transactions/wallet_transaction_screen.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shimmer/shimmer.dart';

class WalletTab extends StatefulWidget {
  const WalletTab({Key? key}) : super(key: key);

  @override
  State<WalletTab> createState() => _WalletTabState();
}

class _WalletTabState extends State<WalletTab> {
  bool _isLoading = true;
  bool _hasError = false;
  WalletData walletData = WalletData();
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, getData);
  }

  getData() async {
    debugPrint(AppPreferences.userId);
    setState(() {
      _isLoading = true;
      _hasError = false;
    });
    try {
      walletData = await getWalletData();
      _hasError = false;
    } catch (exception) {
      MyApp.scaffoldMessengerKey.currentState?.showSnackBar(
        SnackBar(
          content: Text(
            exception.toString(),
          ),
        ),
      );
      _hasError = true;
    }
    setState(() {
      _isLoading = false;
    });
  }

  void _onRefresh() async {
    await Future.delayed(Duration.zero, getData).then((value) {
      _refreshController.refreshCompleted();
    });
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final bodyText1 = textTheme.bodyText1!;
    final bodyText2 = textTheme.bodyText2!;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: Text(
          "Wallet",
          style: bodyText1.copyWith(fontWeight: FontWeight.bold),
        ),
      ),
      body: SmartRefresher(
        enablePullDown: true,
        header: const WaterDropHeader(waterDropColor: kPrimaryColor),
        controller: _refreshController,
        onRefresh: _onRefresh,
        child: Container(
          color: kLightBackgroud,
          child: Column(
            children: [
              Container(
                height: MediaQuery.of(context).size.height / 6,
                width: double.infinity,
                padding: const EdgeInsets.only(left: 15, right: 15, top: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'EST. Amount (BTC)',
                      style: bodyText2.copyWith(fontSize: 12),
                    ),
                    const SizedBox(height: 5),
                    Row(
                      children: [
                        Text(
                          "0 ",
                          style: bodyText1.copyWith(
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '(\$0.0)',
                          style: bodyText2.copyWith(fontSize: 16),
                        ),
                      ],
                    ),
                    const Spacer(flex: 1),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: CustomOutlinedButton(
                              padding: const EdgeInsets.only(
                                left: kDefaultMargin / 4,
                                right: kDefaultMargin / 4,
                                top: 0,
                                bottom: 0,
                              ),
                              onPressed: () {
                                Navigator.of(context).push(CustomPageRoute(
                                  screen: const RecieveAssetList(),
                                ));
                              },
                              widget: Text(
                                'Receive',
                                style: bodyText2.copyWith(
                                  color: kPrimaryColor,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 5),
                          Expanded(
                            child: CustomOutlinedButton(
                              padding: const EdgeInsets.only(
                                left: kDefaultMargin / 4,
                                right: kDefaultMargin / 4,
                                top: 0,
                                bottom: 0,
                              ),
                              onPressed: () {
                                Navigator.of(context).push(CustomPageRoute(
                                  screen: const SendAssetList(),
                                ));
                              },
                              widget: Text(
                                'Send',
                                style: bodyText2.copyWith(
                                  color: kPrimaryColor,
                                ),
                              ),
                            ),
                          ),
                        ]),
                    const Spacer(flex: 4),
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white,
                  ),
                  child: _isLoading
                      ? buildLoadingBody()
                      : _hasError
                          ? CustomErrorWidget(
                              error:
                                  "An error occurred with the data fetch, please try again",
                              onRefresh: () {
                                getData();
                              })
                          : buildBody(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  ListView buildBody() {
    final walletDatum = walletData.data ?? [];
    return ListView.separated(
      separatorBuilder: (context, index) => const Divider(),
      padding: const EdgeInsets.all(0),
      physics: const BouncingScrollPhysics(),
      itemCount: walletDatum.length,
      itemBuilder: (ctx, index) {
        return CoinShow(
          data: walletDatum[index],
          onPressed: () {
            Navigator.of(context).push(
              CustomPageRoute(
                screen: WalletTransactionsScreen(
                  walletDatum: walletDatum[index],
                ),
              ),
            );
          },
        );
      },
    );
  }

  ListView buildLoadingBody() {
    return ListView.builder(
      padding: const EdgeInsets.all(0),
      physics: const BouncingScrollPhysics(),
      itemCount: 10,
      itemBuilder: (ctx, index) {
        return CoinShow(
          data: WalletDatum(),
          shimmerEnabled: true,
          onPressed: () {},
        );
      },
    );
  }
}

class CoinShow extends StatelessWidget {
  final WalletDatum data;
  final VoidCallback onPressed;
  final bool shimmerEnabled;
  const CoinShow({
    Key? key,
    required this.data,
    required this.onPressed,
    this.shimmerEnabled = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return shimmerEnabled
        ? Shimmer.fromColors(
            baseColor: Colors.grey.shade100,
            highlightColor: Colors.grey.shade300,
            child: shimmerBody(),
          )
        : InkWell(
            splashColor: Colors.transparent,
            onTap: onPressed,
            child: buildBody(context),
          );
  }

  Container shimmerBody() {
    return Container(
      margin: const EdgeInsets.only(bottom: 8.0),
      padding: const EdgeInsets.all(5),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            clipBehavior: Clip.antiAliasWithSaveLayer,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: kPrimaryColor,
            ),
          ),
          const SizedBox(
            width: 10,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: double.infinity,
                  height: 20,
                  color: kPrimaryColor,
                ),
                const SizedBox(
                  height: 5,
                ),
                Container(
                  width: double.infinity,
                  height: 20,
                  color: kPrimaryColor,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Container buildBody(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    final titleStyle = textTheme.bodyText1;
    final subTitleStyle = textTheme.bodyText2;
    return Container(
      margin: const EdgeInsets.only(bottom: 8.0, top: 12.0),
      padding: const EdgeInsets.only(left: 10.0, right: 15.0),
      child: Row(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              width: 40,
              height: 40,
              clipBehavior: Clip.antiAliasWithSaveLayer,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
              ),
              child: Image.network(
                data.imageUrl ?? '',
                height: 40,
                width: 40,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            Expanded(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Text(
                            data.coinName?.trim() ?? '',
                            style: titleStyle,
                          ),
                          Text(
                            (data.balance ?? 0).toString(),
                            style: subTitleStyle,
                          ),
                        ]),
                    const SizedBox(
                      height: 5,
                    ),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            "Frozen: ${data.frozen}",
                            style: subTitleStyle,
                          ),
                          const Spacer(),
                          Text(
                            "\$ ${data.usdPrice ?? 0}",
                            style: subTitleStyle,
                          ),
                        ]),
                  ]),
            ),
          ]),
    );
  }
}
