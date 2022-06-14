// ignore_for_file: use_key_in_widget_constructors

import 'Registration/registration_pages.dart';
import 'login page/login_page.dart';
import '/Widgets/button.dart';
import 'package:flutter/material.dart';

class MainLunchPage extends StatelessWidget {
  void navigate(BuildContext ctx, Widget route) {
    Navigator.of(ctx).push(MaterialPageRoute(builder: (_) => route));
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: SizedBox(
            height: (mediaQuery.size.height - mediaQuery.padding.top),
            width: (mediaQuery.size.width),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  padding: const EdgeInsets.all(15),
                  height: 390,
                  child: Image.asset('assets/images/heart_beat.png',
                      fit: BoxFit.cover),
                ),
                Container(
                  padding: const EdgeInsets.all(15),
                  child: Column(
                    children: <Widget>[
                      Button(
                          text: 'Login',
                          onClicked: () => navigate(
                                context,
                                LoginPage(),
                              )),
                      const SizedBox(
                        height: 15,
                      ),
                      Button(
                          text: 'Sign Up',
                          onClicked: () => navigate(
                                context,
                                RegestrationPage(),
                              )),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
