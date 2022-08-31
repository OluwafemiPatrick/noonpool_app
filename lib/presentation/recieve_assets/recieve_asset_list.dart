import 'package:flutter/material.dart';
import 'package:focus_detector/focus_detector.dart';
import 'package:noonpool/helpers/constants.dart';
import 'package:noonpool/helpers/error_widget.dart';
import 'package:noonpool/helpers/network_helper.dart';
import 'package:noonpool/helpers/page_route.dart';
import 'package:noonpool/model/wallet_data/datum.dart';
import 'package:noonpool/model/wallet_data/wallet_data.dart';
import 'package:noonpool/presentation/recieve_assets/receive_asset.dart';
import 'package:shimmer/shimmer.dart';

class RecieveAssetList extends StatefulWidget {
  const RecieveAssetList({Key? key}) : super(key: key);

  @override
  State<RecieveAssetList> createState() => _RecieveAssetListState();
}

class _RecieveAssetListState extends State<RecieveAssetList> {
  final _textController = TextEditingController();
  bool _isLoading = true;
  bool _hasError = false;
  WalletData asset = WalletData();
  WalletData searchAsset = WalletData();
  bool _isSearch = false;
  @override
  void initState() {
    super.initState();
    _textController.addListener(() {
      final text = _textController.text.toLowerCase();
      final oldData = asset.data ?? [];
      final newData = oldData
          .where((element) =>
              element.coinName?.toLowerCase().contains(text) == true ||
              element.coinSymbol?.toLowerCase().contains(text) == true)
          .toList();
      searchAsset.data = newData;
      setState(() {
        _isSearch = true;
      });
    });
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  fetchUserAssets() async {
    setState(() {
      _isLoading = true;
    });
    try {
      asset = await getWalletData();

      searchAsset.data = asset.data;
      setState(() {
        _hasError = false;
        _isSearch = false;
        _isLoading = false;
      });
    } catch (exception) {
      setState(() {
        _isSearch = false;
        _hasError = true;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final bodyText1 = textTheme.bodyText1;

    return Scaffold(appBar: buildAppBar(bodyText1), body: buildBody());
  }

  AppBar buildAppBar(TextStyle? bodyText1) {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.transparent,
      title: Text(
        'Recieve',
        style: bodyText1?.copyWith(fontWeight: FontWeight.bold),
      ),
      leading: const BackButton(
        color: Colors.black,
      ),
    );
  }

  Widget buildEmptyItem() {
    TextTheme textTheme = Theme.of(context).textTheme;
    final bodyText1 = textTheme.bodyText1;
    final bodyText2 = textTheme.bodyText2;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      children: [
        Text(
          'No Data!',
          style: bodyText1,
          textAlign: TextAlign.center,
        ),
        const SizedBox(
          height: 10,
          width: double.infinity,
        ),
        Text(
          _isSearch
              ? 'No asset found, kindly enter a new search query'
              : 'No data found, please check back later',
          textAlign: TextAlign.center,
          style: bodyText2,
        ),
      ],
    );
  }

  Widget buildBody() {
    final coinDatas = searchAsset.data ?? [];

    return FocusDetector(
      onFocusGained: () {
        fetchUserAssets();
      },
      child: _isLoading
          ? buildProgressBar()
          : _hasError
              ? CustomErrorWidget(
                  error:
                      "An error occurred with the data fetch, please try again",
                  onRefresh: () {
                    fetchUserAssets();
                  })
              : coinDatas.isEmpty
                  ? buildEmptyItem()
                  : Column(
                      children: [
                        buildSearchBar(),
                        Expanded(
                          child: ListView.builder(
                            physics: const BouncingScrollPhysics(),
                            padding: const EdgeInsets.all(0),
                            itemBuilder: (ctx, index) => SendAssetListItem(
                              walletDatum: coinDatas[index],
                              onPressed: (model) {
                                Navigator.of(context).push(CustomPageRoute(
                                  screen: ReceiveAssets(walletDatum: model),
                                ));
                              },
                            ),
                            itemCount: coinDatas.length,
                          ),
                        ),
                      ],
                    ),
    );
  }

  Padding buildSearchBar() {
    final textTheme = Theme.of(context).textTheme;
    final bodyText2 = textTheme.bodyText2;

    return Padding(
      padding: const EdgeInsets.only(
        left: 10,
        right: 10,
        bottom: 15,
        top: 15,
      ),
      child: TextFormField(
        controller: _textController,
        textInputAction: TextInputAction.search,
        style: bodyText2,
        cursorColor: kTextColor,
        decoration: InputDecoration(
          hintText: "Search",
          prefixIcon: const Icon(Icons.search_rounded, color: kTextColor),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: kTextColor),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        keyboardType: TextInputType.text,
      ),
    );
  }

  Widget buildProgressBar() {
    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(0),
      itemBuilder: (ctx, index) => SendAssetListItem(
        walletDatum: WalletDatum(),
        shimmerEnabled: true,
        onPressed: (model) {},
      ),
      itemCount: 15,
    );
  }
}

class SendAssetListItem extends StatelessWidget {
  final WalletDatum walletDatum;
  final Function(WalletDatum) onPressed;

  final bool shimmerEnabled;
  const SendAssetListItem({
    Key? key,
    required this.walletDatum,
    required this.onPressed,
    this.shimmerEnabled = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final titleStyle =
        textTheme.bodyText1!.copyWith(fontWeight: FontWeight.w500);
    final subTitleStyle = textTheme.bodyText2!;
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5),
      ),
      margin: const EdgeInsets.only(bottom: 10, left: 10, right: 10),
      child: InkWell(
        splashColor: Colors.transparent,
        onTap: () => onPressed(walletDatum),
        child: Padding(
          padding: const EdgeInsets.only(top: 5, bottom: 5, left: 5, right: 5),
          child: shimmerEnabled
              ? Shimmer.fromColors(
                  baseColor: Colors.grey.shade100,
                  highlightColor: Colors.grey.shade300,
                  child: shimmerBody(),
                )
              : buildBody(titleStyle, subTitleStyle),
        ),
      ),
    );
  }

  SizedBox shimmerBody() {
    return SizedBox(
      height: 50,
      width: double.infinity,
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
                  shape: BoxShape.circle, color: kPrimaryColor),
            ),
            const SizedBox(width: 10),
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
                  ]),
            ),
          ]),
    );
  }

  SizedBox buildBody(TextStyle titleStyle, TextStyle subTitleStyle) {
    return SizedBox(
      height: 50,
      width: double.infinity,
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
                walletDatum.imageUrl ?? '',
                height: 46,
                width: 46,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 10),
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
                          walletDatum.coinName ?? '',
                          style: titleStyle,
                        ),
                        const Spacer(),
                        Text(
                          (walletDatum.balance ?? 0).toString(),
                          style: subTitleStyle.copyWith(
                              fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            "Frozen: ${walletDatum.frozen}",
                            style: subTitleStyle,
                          ),
                          const Spacer(),
                          Text(
                            "\$ ${walletDatum.usdPrice ?? 0}",
                            style: subTitleStyle,
                          ),
                        ]),
                  ]),
            ),
          ]),
    );
  }
}
