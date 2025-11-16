import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sign_button/constants.dart';
import 'package:sign_button/create_button.dart';

import '../view_model.dart';

class LoginViewWeb extends HookConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    TextEditingController _email = useTextEditingController();
    TextEditingController _password = useTextEditingController();
    final viewModelProvider = ref.watch(viewModel);
    final double deviceHeight = MediaQuery.of(context).size.height;
    final double deviceWidth = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        body: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              'assets/login_image.png',
              width: deviceWidth / 2.6,
            ),
            SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    height: deviceHeight / 5.5,
                  ),
                  Image.asset(
                    'assets/logo.png',
                    fit: BoxFit.contain,
                    width: 200,
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  SizedBox(
                    width: 350,
                    child: TextFormField(
                      keyboardType: TextInputType.emailAddress,
                      controller: _email,
                      textAlign: TextAlign.center,
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                        focusedBorder: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                        prefixIcon: Icon(
                          Icons.email,
                          color: Colors.black,
                          size: 30,
                        ),
                        hintText: 'Email',
                        // hintStyle: GoogleFonts.openSans(),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  //Password
                  SizedBox(
                    width: 350,
                    child: TextFormField(
                      keyboardType: TextInputType.visiblePassword,
                      controller: _password,
                      obscureText: viewModelProvider.isObsure,
                      textAlign: TextAlign.center,
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                        focusedBorder: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                        prefixIcon: IconButton(
                            onPressed: () => viewModelProvider.toggleObscure(),
                            icon: Icon(
                              viewModelProvider.isObsure
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              color: Colors.black,
                              size: 30,
                            )),
                        hintText: 'Password',
                        // hintStyle: GoogleFonts.openSans(),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 50,
                        width: 150,
                        child: MaterialButton(
                          onPressed: () async {
                            await viewModelProvider
                                .createUserWithEmailAndPassword(
                                    context, _email.text, _password.text);
                          },
                          child: Text(
                            'Register',
                            style:
                                TextStyle(fontSize: 24.0, color: Colors.white),
                          ),
                          splashColor: Colors.grey,
                          color: Colors.black,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                        ),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Text(
                        'Or',
                        style: TextStyle(fontSize: 15, color: Colors.black),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      SizedBox(
                        height: 50,
                        width: 150,
                        child: MaterialButton(
                          onPressed: () async {
                            await viewModelProvider.signInWithEmailAndPassword(
                                context, _email.text, _password.text);
                          },
                          child: Text(
                            'Login',
                            style:
                                TextStyle(fontSize: 24.0, color: Colors.white),
                          ),
                          splashColor: Colors.grey,
                          color: Colors.black,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 30),
                  //Google SignIn
                  SignInButton(
                    buttonType: ButtonType.google,
                    btnColor: Colors.black,
                    btnTextColor: Colors.white,
                    buttonSize: ButtonSize.medium,
                    onPressed: () async {
                      if (kIsWeb) {
                        await viewModelProvider.sigInInWithGoogleWeb(context);
                      } else {
                        await viewModelProvider.signInWithGoogleMobile(context);
                      }
                    },
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
