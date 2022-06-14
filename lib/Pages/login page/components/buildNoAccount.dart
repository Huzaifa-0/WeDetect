import 'package:flutter/material.dart';

import '../../Registration/registration_pages.dart';

Widget buildNoAccount(BuildContext context) => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('Don\'t have an account?'),
          TextButton(
            child: const Text('SIGN UP'),
            onPressed: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (_) => RegestrationPage()));
            },
          ),
        ],
      );