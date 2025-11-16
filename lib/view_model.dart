import 'package:budget_app/components.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logger/logger.dart';

final viewModel =
    ChangeNotifierProvider.autoDispose<ViewModel>((ref) => ViewModel());

class ViewModel extends ChangeNotifier {
  final _auth = FirebaseAuth.instance;
  bool isSignIn = false;
  bool isObsure = true;
  var logger = Logger();

  List expenseName = [];
  List expenseAmount = [];
  List incomeName = [];
  List incomeAmount = [];

  //CHeck if Sign In

  Future<void> isLogin() async {
    await _auth.authStateChanges().listen((User? user) {
      if (user == null) {
        isSignIn = false;
      } else {
        isSignIn = true;
      }
    });
    notifyListeners();
  }

  toggleObscure() {
    isObsure = !isObsure;
    notifyListeners();
  }

  //Auth
  Future<void> createUserWithEmailAndPassword(
      BuildContext context, String email, String password) async {
    await _auth
        .createUserWithEmailAndPassword(email: email, password: password)
        .then((onValue) => logger.d('Registration Successfully'))
        .onError((error, stackTrace) {
      logger.d('Registration Error $error');
      DialogBox(context, error.toString().replaceAll(RegExp('\\[.*?\\]'), ''));
    });
  }

  Future<void> signInWithEmailAndPassword(
      BuildContext context, String email, String password) async {
    await _auth
        .signInWithEmailAndPassword(email: email, password: password)
        .then((onValue) => logger.d('Login Successfully'))
        .onError((error, stackTrace) {
      logger.d('Login Error $error');
      DialogBox(context, error.toString().replaceAll(RegExp('\\[.*?\\]'), ''));
    });
  }

  Future<void> sigInInWithGoogleWeb(BuildContext context) async {
    GoogleAuthProvider googleAuthProvider = GoogleAuthProvider();
    await _auth.signInWithPopup(googleAuthProvider).onError(
        (error, stackTrace) => DialogBox(
            context, error.toString().replaceAll(RegExp('\\[.*?\\]'), '')));
    logger
        .d("Current User is not empty = ${_auth.currentUser!.uid.isNotEmpty}");
  }

  Future<void> signInWithGoogleMobile(BuildContext context) async {
    final GoogleSignInAccount? googleSignInAccount = await GoogleSignIn()
        .signIn()
        .onError((error, stackTrace) => DialogBox(
            context, error.toString().replaceAll(RegExp('\\[.*?\\]'), '')));
    final GoogleSignInAuthentication? googleAuth =
        await googleSignInAccount?.authentication;

    final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken, idToken: googleAuth?.idToken);
    await _auth.signInWithCredential(credential).then((value) {
      logger.d('Google Sign in successfully');
    }).onError((error, stackTrace) => DialogBox(
        context, error.toString().replaceAll(RegExp('\\[.*?\\]'), '')));
  }

  Future<void> logOut() async {
    await _auth.signOut();
  }
}
