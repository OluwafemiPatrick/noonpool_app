import 'package:flutter/material.dart';
import 'package:noonpool/helpers/constants.dart';
import 'package:noonpool/helpers/error_widget.dart';
import 'package:noonpool/helpers/network_helper.dart';
import 'package:noonpool/helpers/outlined_button.dart';
import 'package:noonpool/main.dart';
import 'package:noonpool/model/transactions/transaction.dart';
import 'package:noonpool/model/wallet_data/datum.dart';
import 'package:shimmer/shimmer.dart';

class WalletTransactionsScreen extends StatefulWidget {
  final WalletDatum walletDatum;
  const WalletTransactionsScreen({Key? key, required this.walletDatum})
      : super(key: key);

  @override
  State<WalletTransactionsScreen> createState() =>
      _WalletTransactionsScreenState();
}

class _WalletTransactionsScreenState extends State<WalletTransactionsScreen> {
  bool _isLoading = true;
  bool _hasError = false;
  bool _isOldDataLoading = false;
  bool _allLoaded = false;
  final ScrollController _scrollController = ScrollController();
  int currentPage = 1;
  List<Transaction> allTransactions = [];
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      getData();
      _scrollController.addListener(() {
        if (_scrollController.position.pixels <=
            _scrollController.position.maxScrollExtent - 10) {
          return;
        }

        if (!_isLoading &&
            !_allLoaded &&
            allTransactions.isNotEmpty &&
            !_isOldDataLoading) {
          getOldData();
        }
      });
    });
  }

  getData() async {
    setState(() {
      _isLoading = true;
      _hasError = false;
      _isOldDataLoading = false;
    });
    try {
      allTransactions.clear();

      final transactions = await getSummaryTransactions(
        coin: widget.walletDatum.coinSymbol ?? '',
        lastHash: '',
      );
      final data = transactions.transactions ?? [];

      allTransactions.addAll(data);

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

  void getOldData() async {
    setState(() {
      _isOldDataLoading = true;
    });

    try {
      currentPage++;
      final transactions = await getSummaryTransactions(
        coin: widget.walletDatum.coinSymbol ?? '',
        lastHash: allTransactions.last.hash ?? '',
      );
      final data = transactions.transactions ?? [];

      allTransactions.addAll(data);

      setState(() {
        _allLoaded = data.isEmpty;
        _isOldDataLoading = false;
      });
    } catch (exception) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            exception.toString(),
          ),
        ),
      );

      setState(() {
        _allLoaded = true;
        _isOldDataLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final bodyText1 = textTheme.bodyText1!;
    final bodyText2 = textTheme.bodyText2!;
    final topPadding = MediaQuery.of(context).padding.top;
    return Scaffold(
      backgroundColor: kLightBackgroud,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildAppBar(topPadding, bodyText1),
          buildHeader(bodyText2, bodyText1),
          const SizedBox(
            height: 5,
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
          /*       Expanded(
            child: CryptoTransaction(
              assetDatum: widget.walletDatum,
            ),
          ), */
        ],
      ),
    );
  }

  Widget buildBody() {
    return allTransactions.isEmpty
        ? buildEmptyItem()
        : Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemBuilder: (ctx, index) {
                    Transaction transaction = allTransactions[index];
                    return TransactionItem(
                      transaction: transaction,
                      onPressed: onTransactionItemPressed,
                    );
                  },
                  itemCount: allTransactions.length,
                  controller: _scrollController,
                  padding: const EdgeInsets.all(10),
                  physics: const BouncingScrollPhysics(),
                ),
              ),
              if (_isOldDataLoading) buildOldProgressBar()
            ],
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
          'No data found, please check back later for your transaction history',
          textAlign: TextAlign.center,
          style: bodyText2,
        ),
      ],
    );
  }

  void onTransactionItemPressed(Transaction trxSummary) {
    /*    Navigator.push(
      context,
      createRoute(
          page: TransactionDetailsScreen(
            transaction: trxSummary,
            assetDatum: widget.assetDatum,
          ),
          curveType: Curves.decelerate),
    ); */
  }

  Widget buildOldProgressBar() {
    return Container(
      width: double.infinity,
      height: 40,
      alignment: Alignment.center,
      child: const SizedBox(
        height: 20,
        width: 20,
        child: CircularProgressIndicator.adaptive(
          backgroundColor: Colors.white,
        ),
      ),
    );
  }

  ListView buildLoadingBody() {
    return ListView.builder(
      itemBuilder: (ctx, index) {
        return TransactionItem(
          shimmerEnabled: true,
          transaction: Transaction(),
          onPressed: (_) {},
        );
      },
      itemCount: 10,
      padding: const EdgeInsets.all(10),
      physics: const BouncingScrollPhysics(),
    );
  }

  Container buildHeader(TextStyle bodyText2, TextStyle bodyText1) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'EST. Amount (${widget.walletDatum.coinSymbol})',
            style: bodyText2.copyWith(fontSize: 12),
          ),
          const SizedBox(
            height: 5,
          ),
          Row(
            children: [
              Text(
                '${widget.walletDatum.balance ?? 0} ${widget.walletDatum.coinSymbol ?? ''}',
                style: bodyText1.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '(\$ ${formatNumber((widget.walletDatum.usdPrice ?? 0) + .0)})',
                style: bodyText2.copyWith(fontSize: 12),
              ),
            ],
          ),
          const SizedBox(
            height: 5,
          ),
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
                    //
                  },
                  widget: Text(
                    'Withdraw',
                    style: bodyText2.copyWith(
                      color: kPrimaryColor,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                width: 5,
              ),
              Expanded(
                child: CustomOutlinedButton(
                  padding: const EdgeInsets.only(
                    left: kDefaultMargin / 4,
                    right: kDefaultMargin / 4,
                    top: 0,
                    bottom: 0,
                  ),
                  onPressed: () {
                    //
                  },
                  widget: Text(
                    'Send',
                    style: bodyText2.copyWith(
                      color: kPrimaryColor,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                width: 5,
              ),
              Expanded(
                child: CustomOutlinedButton(
                  padding: const EdgeInsets.only(
                    left: kDefaultMargin / 4,
                    right: kDefaultMargin / 4,
                    top: 0,
                    bottom: 0,
                  ),
                  onPressed: () {
                    //
                  },
                  widget: Text(
                    'Recieve',
                    style: bodyText2.copyWith(
                      color: kPrimaryColor,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Container buildAppBar(double topPadding, TextStyle bodyText1) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.only(
        top: topPadding,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const BackButton(
            color: Colors.black,
          ),
          Container(
            width: 35,
            height: 35,
            clipBehavior: Clip.antiAliasWithSaveLayer,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
            ),
            child: Image.network(
              widget.walletDatum.imageUrl ?? '',
              height: 35,
              width: 35,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(
            width: 5,
          ),
          Text(
            widget.walletDatum.coinName ?? '',
            style: bodyText1.copyWith(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}

class TransactionItem extends StatelessWidget {
  final Transaction transaction;
  final bool shimmerEnabled;
  final Function(Transaction) onPressed;

  const TransactionItem({
    Key? key,
    required this.transaction,
    this.shimmerEnabled = false,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
//TRANSACTION TYPE

    return InkWell(
      onTap: () => onPressed(transaction),
      child: Padding(
        padding: const EdgeInsets.only(bottom: 10, left: 10, right: 10),
        child: shimmerEnabled
            ? Shimmer.fromColors(
                baseColor: Colors.grey.shade100,
                highlightColor: Colors.grey.shade300,
                child: shimmerBody(),
              )
            : buildBody(context),
      ),
    );
  }

  Column shimmerBody() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 60,
          height: 20,
          color: kPrimaryColor,
        ),
        const SizedBox(
          height: 5,
        ),
        Row(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                color: kPrimaryColor.withOpacity(0.05),
                borderRadius: const BorderRadius.all(
                  Radius.circular(20),
                ),
              ),
              padding: const EdgeInsets.all(5),
              child: const Icon(
                Icons.circle,
                color: kPrimaryColor,
                size: 25,
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
                    height: 8,
                  ),
                  Container(
                    width: double.infinity,
                    height: 20,
                    color: kPrimaryColor,
                  ),
                ],
              ),
            )
          ],
        ),
        const Divider(),
      ],
    );
  }

  Column buildBody(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final bodyText2 = textTheme.bodyText2!;
    final bodyText1 = textTheme.bodyText1!;
    final titleStyle = bodyText1;
    final subTitleStyle = bodyText2;

    Map<String, dynamic> transactionType =
        transaction.getTransactionTypeDetails();
    String transactionTypeName = transactionType['name'];
    String transactionUserAddress = transactionType['address'];
    Color transactionTypeColor = transactionType['color'];
    IconData transactionTypeIcon = transactionType['icon'];
    String transactionTypeIdentification = transactionType['identification'];

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          transaction.date ?? "",
          style: subTitleStyle.copyWith(fontSize: 16),
        ),
        const SizedBox(
          height: 5,
        ),
        Row(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                color: kPrimaryColor.withOpacity(0.05),
                borderRadius: const BorderRadius.all(
                  Radius.circular(20),
                ),
              ),
              padding: const EdgeInsets.all(5),
              child: Icon(
                transactionTypeIcon,
                color: transactionTypeColor,
                size: 25,
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
                        transactionTypeName,
                        style: titleStyle,
                      ),
                      const Spacer(),
                      Text(
                        transaction.amount ?? '',
                        style:
                            subTitleStyle.copyWith(fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Text(
                    '$transactionTypeIdentification: $transactionUserAddress ',
                    style: subTitleStyle,
                    softWrap: false,
                  ),
                ],
              ),
            )
          ],
        ),
        const Divider(),
      ],
    );
  }
}
