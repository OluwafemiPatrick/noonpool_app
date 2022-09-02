import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class TransactionView extends StatefulWidget {
  final String hash;
  final String name;
  const TransactionView({
    Key? key,
    required this.hash,
    required this.name,
  }) : super(key: key);

  @override
  State<TransactionView> createState() => _TransactionViewState();
}

class _TransactionViewState extends State<TransactionView> {
  final GlobalKey webViewKey = GlobalKey();
  bool _isRotated = false;

  InAppWebViewController? controller;
  InAppWebViewGroupOptions options = InAppWebViewGroupOptions(
      crossPlatform: InAppWebViewOptions(
        useShouldOverrideUrlLoading: true,
        mediaPlaybackRequiresUserGesture: false,
      ),
      android: AndroidInAppWebViewOptions(
        useHybridComposition: true,
      ),
      ios: IOSInAppWebViewOptions(
        allowsInlineMediaPlayback: true,
      ));

  AppBar buildAppBar(
    TextStyle? bodyText1,
  ) {
    return AppBar(
        elevation: 1,
        backgroundColor: Colors.white,
        title: Text(
          widget.name,
          style: bodyText1,
        ),
        leading: const BackButton(
          color: Colors.black,
        ),
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                _isRotated = !_isRotated;
              });
            },
            icon: const Icon(
              Icons.rotate_90_degrees_ccw_rounded,
              color: Colors.black,
            ),
          ),
        ]);
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    final bodyText1 = textTheme.bodyText1!;

    return Scaffold(
      appBar: buildAppBar(bodyText1),
      body: buildBody(),
    );
  }

  RotatedBox buildBody() {
    return RotatedBox(
      quarterTurns: _isRotated ? 3 : 0,
      child: InAppWebView(
        key: webViewKey,
        initialUrlRequest: URLRequest(
          url: Uri.parse(
              "https://blockchair.com/${widget.name.toLowerCase()}/transaction/${widget.hash}"),
        ),
        initialOptions: options,
        onWebViewCreated: (controller) {
          this.controller = controller;
        },
        onLoadStart: (controller, url) {},
        androidOnPermissionRequest: (controller, origin, resources) async {
          return PermissionRequestResponse(
              resources: resources,
              action: PermissionRequestResponseAction.GRANT);
        },
      ),
    );
  }
}
