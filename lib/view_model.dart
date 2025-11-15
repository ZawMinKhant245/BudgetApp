import 'package:budget_app/components.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logger/logger.dart';

final viewModel =
    ChangeNotifierProvider.autoDispose<ViewModel>((ref) => ViewModel());

class ViewModel extends ChangeNotifier {
  final _auth = FirebaseAuth.instance;
  bool isSignIn = false;
  bool isObsure = true;
  var logger = Logger();

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
    _auth
        .signInWithEmailAndPassword(email: email, password: password)
        .then((onValue) => logger.d('Login Successfully'))
        .onError((error, stackTrace) {
      logger.d('Login Error $error');
      DialogBox(context, error.toString().replaceAll(RegExp('\\[.*?\\]'), ''));
    });
  }
}
