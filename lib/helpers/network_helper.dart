import 'dart:convert';
import 'dart:io';
 
import 'package:noonpool/helpers/shared_preference_util.dart';
import 'package:noonpool/model/coin_model/coin_model.dart';
import 'package:noonpool/model/login_details/login_details.dart';

import 'package:http/http.dart' as http;
import 'package:noonpool/model/recieve_data/recieve_data.dart';
import 'package:noonpool/model/user_secret.dart';
import 'package:noonpool/model/wallet_data/datum.dart';
import 'package:noonpool/model/wallet_data/wallet_data.dart';
import 'package:noonpool/model/wallet_transactions/wallet_transactions.dart';
import 'package:noonpool/model/worker_data/worker_data.dart';

const String baseUrl = 'http://5.189.137.144:1028/api/v2/';
// const String baseUrl = 'http://5.189.137.144:3505/api/v2/';

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

Future<WorkerData> fetchWorkerData(String pool) async {
  String name = AppPreferences.userName;

  try {
    final response = await http.get(
      Uri.parse(baseUrl +
          "pool/getPoolPageData?worker_name=$name&pool=${pool.toLowerCase()}"),
    );

    final data = jsonDecode(response.body);

    if (response.statusCode <= 299) {
      return WorkerData.fromMap(data);
    } else {
      return Future.error(
          data['message'] ?? 'An error occurred while fetching worker data');
    }
  } catch (exception) {
    return Future.error(exception.toString());
  }
}

Future<void> sendUserOTP({required String email}) async {
  try {
    final response = await http.post(
      Uri.parse(baseUrl + "auth/sendOtp"),
      body: jsonEncode({
        "email": email,
      }),
      headers: {'Content-Type': 'application/json'},
    );

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

Future<void> set2FAStatus({
  required bool status,
  required String secret,
}) async {
  try {
    final id = AppPreferences.userId;
    final response = await http.post(
      Uri.parse(baseUrl + "auth/google_2FA"),
      body: jsonEncode({
        "id": id,
        "isSecret": status,
        "secret": secret,
      }),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      return;
    } else {
      return Future.error(jsonDecode(response.body)['message'] ??
          'An error occurred while performing your reqest,  please try again');
    }
  } on SocketException {
    return Future.error(
        'Kindly enable your internet connection to send an OTP');
  } catch (exception) {
    return Future.error(exception.toString());
  }
}

Future<UserSecret> get2FAStatus({required String id}) async {
  try {
    final response = await http.get(
      Uri.parse(baseUrl + "auth/google_2FA?id=$id"),
      headers: {'Content-Type': 'application/json'},
    ); 
    if (response.statusCode == 200) {
      return UserSecret.fromJson(response.body);
    } else {
      return Future.error(jsonDecode(response.body)['message'] ??
          'An error occurred while performing your reqest,  please try again');
    }
  } on SocketException {
    return Future.error('Kindly enable your internet connection');
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
   
    final decode = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return WalletTransactions.fromMap(decode);
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
