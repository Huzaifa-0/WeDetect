import 'package:flutter/material.dart';

Widget buildCard(
        {required BuildContext context,
        required VoidCallback onTap,
        required String title}) =>
    SizedBox(
      height: 100,
      width: 300,
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 8),
        color: Theme.of(context).primaryColor,
        child: InkWell(
          onTap: onTap,
          child: Center(
            child: Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 21,
              ),
            ),
          ),
        ),
      ),
    );
