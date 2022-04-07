import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'package:noonpool/model/coin_model.dart';

FirebaseAuth sFirebaseAuth = FirebaseAuth.instance;
FirebaseFirestore sFirebaseCloud = FirebaseFirestore.instance;

const String successful = '--';

//*** FORGOT PASSWORD ***
Future<void> forgotPassword({
  required String email,
}) async {
  try {
    await sFirebaseAuth.sendPasswordResetEmail(email: email);
  } catch (e) {
    return Future.error(e.toString());
  }
}

//*** RESEND VERIFICATION ***
Future<String> resendVerification({
  required String email,
  required String password,
}) async {
  try {
    Future<UserCredential> userCredentials = sFirebaseAuth
        .signInWithEmailAndPassword(email: email, password: password);
    var userCredential = await userCredentials;
    if (userCredential.user?.emailVerified != true) {
      await userCredential.user?.sendEmailVerification();
      sFirebaseAuth.signOut();
      return 'verification link has been resent';
    } else {
      sFirebaseAuth.signOut();
      return 'account already verified';
    }
  } on SocketException {
    return 'No internet connection.';
  } on FirebaseAuthException catch (e) {
    if (e.code == 'user-not-found') {
      return ('No user found for that email.');
    } else if (e.code == 'wrong-password') {
      return ('Wrong password provided for that user.');
    } else {
      return e.message ?? 'error occurred';
    }
  } catch (e) {
    return e.toString();
  }
}

//*** SIGN IN ***
Future<String> signIn({
  required String email,
  required String password,
}) async {
  try {
    await sFirebaseAuth.signOut();
    Future<UserCredential> userCredentials = sFirebaseAuth
        .signInWithEmailAndPassword(email: email, password: password);
    var userCredential = await userCredentials;
    if (userCredential.user?.emailVerified == true) {
      return successful; // IF IT RETURNS THIS THEN IT IS SUCCESSFUL
    } else {
      return 'account_unverified';
    }
  } on SocketException {
    return 'No internet connection.';
  } on FirebaseAuthException catch (e) {
    if (e.code == 'user-not-found') {
      return ('No user found for that email.');
    } else if (e.code == 'wrong-password') {
      return ('Wrong password provided for that user.');
    } else {
      return "error occurred";
    }
  } catch (e) {
    return e.toString();
  }
}

//*** SIGN UP ***
Future<String> signUp(
    {required String email,
    required String password,
    required String name}) async {
  try {
    var userCredential = await sFirebaseAuth.createUserWithEmailAndPassword(
        email: email, password: password);
    await userCredential.user?.sendEmailVerification();

    var userId = userCredential.user?.uid ?? "";

    var body = {
      "email": email,
      'id': userId,
      'name': name,
    };

    await sFirebaseCloud.collection('users').doc(userId).set(body);

    sFirebaseAuth.signOut();
    return successful;
  } on FirebaseAuthException catch (e) {
    if (e.code == 'weak-password') {
      return ('The password provided is too weak.');
    } else if (e.code == 'email-already-in-use') {
      return ('The account already exists for that email.');
    } else {
      return e.message ?? 'error occurred';
    }
  } catch (e) {
    return (e.toString());
  }
}

Future<List<CoinModel>> getAllCoinDetails() async {
  try {
    final response = await http.get(
      Uri.parse('https://noonpool.herokuapp.com/api/v1/fetchCoinData'),
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
/*

      final coinData = allData
          .map((data) => CoinModel(
              imageLocation: data['coin_logo'],
              coin: data['coin_name'],
              coinName: data['coin_symbol'],
              algorithm: data['algo'],
              id: data['_id'],
              poolHashRate: data['pool_hashrate'] + .0,
              profit: data['profit'] + .0,
              price: data['price'] + .0,
              networkHashRate: data['net_hashrate'] + .0))
          .toList();
*/

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
