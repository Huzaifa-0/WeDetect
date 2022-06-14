// ignore_for_file: use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:we_detect/route_name.dart';
import '../../services/authentication.dart';
import 'components/components.dart';
import 'functions/validateToken.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _auth = AuthService();
  final _passwordFocusNode = FocusNode();
  var _isLoading = false;

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
  }

  generateroute() async {
    final pref = await SharedPreferences.getInstance();
    var route = pref.get('study') as String?;
    debugPrint('$route  ........... route');
    if (route != null) {
      switch (route) {
        case RouteName.Covid_Study:
          Navigator.of(context)
              .pushNamedAndRemoveUntil(RouteName.Covid_Study, (route) => false);
          break;
        default:
          Navigator.of(context).pushNamedAndRemoveUntil('/', (route) => false);
          break;
      }
    } else {
      Navigator.of(context)
          .pushNamedAndRemoveUntil(RouteName.Studies, (route) => false);
    }
  }

  Future<void> login() async {
    final form = _formKey.currentState!;
    setState(() {
      _isLoading = true;
    });
    if (form.validate()) {
      TextInput.finishAutofillContext();

      final firebaseUser = await _auth.signIn(
          _emailController.text, _passwordController.text, context);
      if (firebaseUser != null) {
        debugPrint('${firebaseUser.uid}..................');
        validateToken(firebaseUser);
        FocusScope.of(context).unfocus();
        // Navigator.of(context).pop();
        generateroute();
      }
    }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: Center(
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          elevation: 7,
          child: Container(
            height: 340,
            width: 340,
            padding: const EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    EmailField(
                        controller: _emailController,
                        passwordFocusNode: _passwordFocusNode),
                    const SizedBox(height: 16),
                    PasswordField(
                      controller: _passwordController,
                      passwordFocusNode: _passwordFocusNode,
                      login: login,
                    ),
                    // buildForgotPassword(context),
                    const ForgetPassword(),
                    const SizedBox(height: 16),
                    if (_isLoading) const CircularProgressIndicator(),
                    if (!_isLoading) buildButton(login),
                    buildNoAccount(context),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
