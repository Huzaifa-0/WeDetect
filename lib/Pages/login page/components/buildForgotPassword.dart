import 'package:flutter/material.dart';
import 'package:we_detect/services/authentication.dart';

class ForgetPassword extends StatefulWidget {
  const ForgetPassword({Key? key}) : super(key: key);

  @override
  State<ForgetPassword> createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword> {
  String? _email;
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.centerRight,
      child: TextButton(
        child: const Text('Forgotten Password?'),
        onPressed: () async {
          showDialog(
            context: context,
            builder: (_) => AlertDialog(
              title: const Text('Reset Password'),
              content: TextField(
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(hintText: 'Email'),
                onChanged: (value) {
                  setState(() {
                    _email = value;
                  });
                },
              ),
              actions: [
                TextButton(
                  child: const Text('Submit'),
                  onPressed: () {
                    if (_email != null) {
                      AuthService().resetPassword(_email!);
                      Navigator.of(context).pop();
                      FocusScope.of(context).requestFocus(FocusNode());
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Email Submitted',
                              textAlign: TextAlign.center),
                          duration: Duration(
                            seconds: 1,
                          ),
                        ),
                      );
                    }
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
