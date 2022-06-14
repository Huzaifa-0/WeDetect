import 'package:flutter/material.dart';

Widget buildSurveyCard(String title, BuildContext context, Widget page) =>
      Card(
        elevation: 5,
        margin: const EdgeInsets.symmetric(
          vertical: 8,
          horizontal: 5,
        ),
        child: ListTile(
          title: Text(
            title,
            style: TextStyle(
              color: Theme.of(context).primaryColor,
              fontSize: 18,
            ),
          ),
          trailing: Icon(Icons.add, color: Theme.of(context).primaryColor),
          onTap: () => Navigator.of(context)
              .push(MaterialPageRoute(builder: (_) => page))
              .then(
                (result) => result == null
                    ? null
                    : showDialog(
                        context: context,
                        builder: (_) => AlertDialog(
                          title: const Text('Great Job!!'),
                          content: const Text('Thank you for your submition'),
                          actions: [
                            TextButton(
                              child: const Text('Okay'),
                              onPressed: () => Navigator.of(context).pop(),
                            ),
                          ],
                        ),
                      ),
              ),
        ),
      );
