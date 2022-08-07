import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:noonpool/helpers/network_helper.dart';

FirebaseAuth sFirebaseAuth = FirebaseAuth.instance;

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
      return e.toString();
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
      'user_id': userId,
      'username': name,
    };

    // create a new account for user in mongodb
    await createUserAccount(name, email, userId);

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
