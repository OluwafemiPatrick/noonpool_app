import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:noonpool/helpers/shared_preference_util.dart';
import 'package:noonpool/model/coin_model/coin_model.dart';
import 'package:noonpool/model/login_details/login_details.dart';

import 'package:http/http.dart' as http;
import 'package:noonpool/model/recieve_data/recieve_data.dart';
import 'package:noonpool/model/wallet_data/datum.dart';
import 'package:noonpool/model/wallet_data/wallet_data.dart';
import 'package:noonpool/model/wallet_transactions/wallet_transactions.dart';

// const String baseUrl = 'http://5.189.137.144:1027/api/v2/';
const String baseUrl = 'http://5.189.137.144:3505/api/v2/';

Future<List<CoinModel>> getAllCoinDetails() async {
  try {
    final response = await http.get(
      Uri.parse(baseUrl + 'home/fetchCoinData'),
      headers: {'Content-Type': 'application/json'},
    );

    final decode = jsonDecode(response.body);

    if (response.statusCode == 200) {
      final allData = decode as List<dynamic>;

      final coinData = allData
          .map((data) => CoinModel.fromMap(data as Map<String, dynamic>))
          .toList();

      return coinData;
    } else {
      return Future.error(jsonDecode(response.body)['message'] ??
          'Error occurred, please try again');
    }
  } on SocketException {
    return Future.error(
        'Kindly enable your internet connection to load new data');
  } catch (e) {
    return Future.error(e.toString());
  }
}

Future<dynamic> fetchWorkerData(String workerName, poolUrl) async {
  final url = '$poolUrl/miners?method=$workerName';
  final response = await http.get(Uri.parse(url));

  if (response.statusCode == 200) {
    var workerData = jsonDecode(response.body);
    List workers = workerData['body']['primary']['workers']['shared'];
    List dataToReturn = [];

    String paidEarning =
        workerData['body']['primary']['payments']['paid'].toString();
    String unpaidEarning =
        workerData['body']['primary']['payments']['balances'].toString();

    for (var name in workers) {
      String subUrl = '$poolUrl/miners?method=$name';
      var res = await http.get(Uri.parse(subUrl));

      Map<String, dynamic> list = json.decode(res.body);
      var subList = list['body']['primary'];

      String hashrate = subList['hashrate']['shared'].toString();
      String sharesValid = subList['shares']['shared']['valid'].toString();
      String sharesInvalid = subList['shares']['shared']['invalid'].toString();
      String sharesStale = subList['shares']['shared']['stale'].toString();
      String payBalance = subList['payments']['balances'].toString();
      String payGenerate = subList['payments']['generate'].toString();
      String payImmature = subList['payments']['immature'].toString();
      String payPaid = subList['payments']['paid'].toString();
      String work = subList['work']['shared'].toString();

      Map<String, String> workerD = {
        'workerId': name,
        'hashrate': hashrate,
        'sharesValid': sharesValid,
        'sharesInvalid': sharesInvalid,
        'sharesStale': sharesStale,
        'payBalance': payBalance,
        'payGenerate': payGenerate,
        'payImmature': payImmature,
        'payPaid': payPaid,
        'work': work,
        'paidEarning': paidEarning,
        'unpaidEarning': unpaidEarning
      };
      dataToReturn.add(workerD);
    }
    return dataToReturn;
  } else {
    return null;
  }
}

/////////
Future<void> sendUserOTP({required String email}) async {
  try {
    final response = await http.post(
      Uri.parse(baseUrl + "auth/sendOtp"),
      body: jsonEncode({
        "email": email,
      }),
      headers: {'Content-Type': 'application/json'},
    );
    debugPrint(response.body.toString());
    if (response.statusCode == 200) {
      return;
    } else {
      return Future.error(jsonDecode(response.body)['message'] ??
          'An error occurred while sending an OTP,  please try again');
    }
  } on SocketException {
    return Future.error(
        'Kindly enable your internet connection to send an OTP');
  } catch (exception) {
    return Future.error(exception.toString());
  }
}

Future<void> verifyUserOTP({
  required String email,
  required String code,
}) async {
  try {
    final response = await http.post(
      Uri.parse(baseUrl + "auth/emailVerification"),
      body: jsonEncode({
        "email": email,
        "code": code,
      }),
      headers: {'Content-Type': 'application/json'},
    );
    debugPrint(response.request?.url.toString());
    debugPrint(jsonEncode({
      "email": email,
      "code": code,
    }).toString());
    debugPrint(
      response.body.toString(),
    );
    if (response.statusCode == 200) {
      return;
    } else {
      return Future.error(
        jsonDecode(response.body)['message'] ??
            'An error occurred while verifying your account, please try again',
      );
    }
  } on SocketException {
    return Future.error(
        'Kindly enable your internet connection to verfiy your account');
  } catch (exception) {
    return Future.error(exception.toString());
  }
}

Future<bool> checkUsername(String username) async {
  try {
    final response = await http.get(
      Uri.parse(baseUrl + 'auth/checkUsername?username=$username'),
      headers: {'Content-Type': 'application/json'},
    );
    debugPrint(response.body.toString());
    debugPrint(response.statusCode.toString());

    if (response.statusCode == 200) {
      return true;
    }
    if (response.statusCode == 201) {
      return false;
    } else {
      return Future.error(jsonDecode(response.body)['message'] ??
          'Error occurred, please try again');
    }
  } on SocketException {
    return Future.error(
        'Kindly enable your internet connection to load new data');
  } catch (e) {
    return Future.error(e.toString());
  }
}

Future<void> createUserAccount({
  required String password,
  required String email,
  required String userName,
}) async {
  try {
    final response = await http.post(
      Uri.parse(baseUrl + "auth/createUserAccount"),
      body: jsonEncode({
        "email": email,
        "username": userName,
        "password": password,
      }),
      headers: {
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      return;
    } else {
      return Future.error(jsonDecode(response.body)['message'] ??
          'An error occurred while creating your account, please try again');
    }
  } on SocketException {
    return Future.error(
        'Kindly enable your internet connection to sign up to noonpool');
  } catch (exception) {
    return Future.error(exception.toString());
  }
}

Future<LoginDetails> signInToUserAccount({
  required String password,
  required String email,
}) async {
  try {
    final response = await http.post(
      Uri.parse(baseUrl + "auth/login"),
      body: jsonEncode({
        "email": email,
        "password": password,
      }),
      headers: {'Content-Type': 'application/json'},
    );
    debugPrint(response.request!.url.toString());
    debugPrint(response.body.toString());

    if (response.statusCode == 200) {
      return LoginDetails.fromJson(response.body);
    } else {
      return Future.error(jsonDecode(response.body)['message'] ??
          'An error occurred while accessing your account, please try again');
    }
  } on SocketException {
    return Future.error(
        'Kindly enable your internet connection to sign in to noonpool');
  } catch (exception) {
    return Future.error(exception.toString());
  }
}

Future<void> resetPassword({
  required String email,
  required String password,
}) async {
  try {
    final response = await http.post(
      Uri.parse(baseUrl + "auth/passwordReset"),
      body: jsonEncode({
        "email": email,
        "new_password": password,
      }),
      headers: {
        'Content-Type': 'application/json',
      },
    );

    debugPrint(
      response.body.toString(),
    );
    if (response.statusCode == 200) {
      return;
    } else {
      return Future.error(
        jsonDecode(response.body)['message'] ??
            'An error occurred while resetting your password, please try again',
      );
    }
  } on SocketException {
    return Future.error(
        'Kindly enable your internet connection to verfiy your account');
  } catch (exception) {
    return Future.error(exception.toString());
  }
}

Future<WalletData> getWalletData() async {
  final userId = AppPreferences.userId;
  try {
    final response = await http.get(
      Uri.parse(baseUrl + "wallet/wallet_list?user_id=$userId"),
      headers: {'Content-Type': 'application/json'},
    );
    debugPrint(response.request?.url.toString());
    debugPrint(response.body.toString());

    if (response.statusCode == 200) {
      return WalletData.fromJson(response.body);
    } else {
      return Future.error(jsonDecode(response.body)['message'] ??
          'An error occurred while fetchint your wallet information, please try again');
    }
  } on SocketException {
    return Future.error(
        'Kindly enable your internet connection to fetch wallet data');
  } catch (exception) {
    return Future.error(exception.toString());
  }
}

Future<void> getWalletInformation(WalletDatum walletDatum) async {
  final userId = AppPreferences.userId;

  try {
    final response = await http.get(
      Uri.parse(
          baseUrl + "wallet?id=$userId&network=${walletDatum.coinSymbol}"),
      headers: {'Content-Type': 'application/json'},
    );
    debugPrint(response.request?.url.toString());
    debugPrint(response.body.toString());

    if (response.statusCode == 200) {
      return;
    } else {
      return Future.error(jsonDecode(response.body)['message'] ??
          'An error occurred while fetchint your wallet information, please try again');
    }
  } on SocketException {
    return Future.error(
        'Kindly enable your internet connection to fetch wallet data');
  } catch (exception) {
    return Future.error(exception.toString());
  }
}

Future<WalletTransactions> getSummaryTransactions({
  required String lastHash,
  required String coin,
  required int page,
}) async {
  try {
    final userId = AppPreferences.userId;

    final response = await http.get(
      Uri.parse(baseUrl +
          "wallet/getTransactionList?id=$userId&coin=$coin&last_trx_id=$lastHash&page=$page"),
      headers: {'Content-Type': 'application/json'},
    );
    debugPrint(response.request?.url.toString());
    debugPrint(response.body.toString());
    final decode = jsonDecode(response.body);

    if (response.statusCode == 200) {
      /*   final data =
          '''{"trxs":[{"hash":"0f56b189a12f4bba5f43be0427dc3c3e08dd7f5c49837b061d15979db4037d91","isSend":false, "network":"bitcoin-cash"},
	{"hash":"f6b9bdbfa064a85f01fa812b962063f919bd7be6950cdb7a5aeace5cf72aae41","isSend":false, "network":"bitcoin-cash"},
	{"hash":"b0054876934e4800ce0f64970dfa78daff4b5312f726823200617da8e3dfb72a","isSend":true, "network":"bitcoin-cash"},
	{"hash":"232faf9be7871fcb451db4971ccce884d997f3efe9d15b143827d515e1e2255b","isSend":true, "network":"bitcoin-cash"},
	{"hash":"dce7a49750b9b981dcdba0a7b2d261c2695fdf85cf1350e5c351d7e4b89ee643","isSend":false, "network":"bitcoin-cash"}]}''';
      return WalletTransactions.fromMap(
        jsonDecode(data),
        coin.toLowerCase() != 'bch',
      ); */
      return WalletTransactions.fromMap(decode);
    } else {
      return Future.error(decode['message'] ?? '');
    }
  } on SocketException {
    return Future.error(
        'There is either no or a very weak network connection.');
  } catch (exception) {
    debugPrint(exception.toString());
    return Future.error('An error occurred while getting data');
  }
}

sendFromWallet({
  required String network,
  required String reciever,
  required double amount,
}) async {
  final userId = AppPreferences.userId;
  try {
    final body = <String, dynamic>{
      "user_id": userId,
      "reciepient": reciever,
      "amount": amount,
      "network": network,
    };

    final response = await http.post(
      Uri.parse(baseUrl + "wallet/send"),
      body: jsonEncode(body),
      headers: {'Content-Type': 'application/json'},
    );
    debugPrint(response.request?.url.toString());
    debugPrint(response.body.toString());
    final decode = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return;
    } else {
      return Future.error(decode['message'] ?? '');
    }
  } on SocketException {
    return Future.error(
        'There is either no or a very weak network connection.');
  } catch (exception) {
    return Future.error('An error occurred while getting data');
  }
}

Future<RecieveData> walletData({
  required WalletDatum walletDatum,
}) async {
  final userId = AppPreferences.userId;
  try {
    //
    final response = await http.get(
      Uri.parse(
          baseUrl + "wallet?id=$userId&network=${walletDatum.coinSymbol}"),
      headers: {'Content-Type': 'application/json'},
    );
    debugPrint(response.request?.url.toString());
    debugPrint(response.body.toString());
    final decode = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return RecieveData.fromMap(decode, walletDatum.coinSymbol ?? '');
    } else {
      return Future.error(decode['message'] ?? '');
    }
  } on SocketException {
    return Future.error(
        'There is either no or a very weak network connection.');
  } catch (exception) {
    return Future.error('An error occurred while getting data');
  }
}
