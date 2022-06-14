import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

Widget buildCurrentDate(BuildContext context) => Card(
                    color: Theme.of(context).primaryColor,
                    elevation: 5,
                    margin: const EdgeInsets.symmetric(
                      vertical: 8,
                      horizontal: 5,
                    ),
                    child: ListTile(
                      title: const Text(
                        'Today is :',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                        ),
                      ),
                      leading: const Icon(
                        Icons.date_range_sharp,
                        color: Colors.white,
                      ),
                      trailing: Text(
                        DateFormat.MMMMEEEEd().format(DateTime.now()),
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  );