import 'dart:convert';
import 'dart:io';

import '../model/coin_model.dart';
import 'package:http/http.dart' as http;


const String baseUrl = 'https://noonpool.herokuapp.com/api/v1/';

Future<List<CoinModel>> getAllCoinDetails() async {

  try {
    final response = await http.get(
      Uri.parse(baseUrl + 'fetchCoinData'),
      headers: {'Content-Type': 'application/json'},
    );

    var decode = jsonDecode(response.body);

    if (response.statusCode == 200) {
      final allData = decode as List<dynamic>;

      final coinData = allData
          .map((data) => CoinModel(
          imageLocation: data['coin_logo'].toString().trim(),
          coin: data['coin_name'].toString().trim(),
          coinSubTitle: data['coin_symbol'].toString().trim(),
          algorithm: data['algo'].toString().trim(),
          id: data['_id'],
          difficulty: data['difficulty'],
          reward: data['reward'],
          profit: data['profit'],
          price: data['price'],
          networkHashRate: data['net_hashrate']))
          .toList();

      return coinData;
    } else {
      return Future.error('Error occurred, please try again');
    }
  } on SocketException {
    return Future.error(
        'Kindly enable your internet connection to load new data');
  } catch (e) {
    return Future.error(e.toString());
  }
}


Future createUserAccount(String username, email, id) async {

  String param = "username=$username&email=$email&user_id=$id";
  try {
    final response = await http.get(
      Uri.parse(baseUrl + 'createUserAccount?$param'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      return Future.error('Error occurred, please try again');
    }
  } on SocketException {
    return Future.error(
        'Kindly enable your internet connection to load new data');
  } catch (e) {
    return Future.error(e.toString());
  }

}


Future<bool> checkUsername(String username) async {

  try {
    final response = await http.get(
      Uri.parse(baseUrl + 'checkUsername?username=$username'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      return true;
    }
    if (response.statusCode == 201) {
      return false;
    }
    else {
      return Future.error('Error occurred, please try again');
    }
  } on SocketException {
    return Future.error(
        'Kindly enable your internet connection to load new data');
  } catch (e) {
    return Future.error(e.toString());
  }

}


Future<dynamic> getHomepageData (String userId) async {

  final url = baseUrl + 'getHomepageData?user_id=$userId';
  final response = await http.get(Uri.parse(url));

  if (response.statusCode==201 || response.statusCode==400) {
    return null;
  } else {
    var data = jsonDecode(response.body);
    return data;
  }

}