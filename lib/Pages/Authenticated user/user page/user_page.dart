// import 'dart:async';
import 'package:we_detect/Pages/Authenticated%20user/user%20page/components/current_date_card.dart';
import 'package:we_detect/route_name.dart';

import '/services/authentication.dart';
import '/services/data_base.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../authenticated_user_pages.dart';
import 'components/survey_card.dart';

class CovidStudyUserPage extends StatefulWidget {
  const CovidStudyUserPage({Key? key}) : super(key: key);

  @override
  State<CovidStudyUserPage> createState() => _CovidStudyUserPageState();
}

class _CovidStudyUserPageState extends State<CovidStudyUserPage> {
  final _currentTime = DateFormat('d-M-y').format(DateTime.now());
  bool _checked = false;
  var _isloading = false;

  _stillPositive() async {
    final result = await FireStoreApi.isPositive(_currentTime);
    if (result) {
      setState(() {
        _checked = result;
        debugPrint(_checked.toString() + '...........is checked');
      });
    }
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      _isloading = true;
    });
    _stillPositive();
    setState(() {
      _isloading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('WeDetect'),
        actions: [
          IconButton(
              onPressed: () async {
                await AuthService().signOut();
                Navigator.of(context).pushReplacementNamed('/');
              },
              icon: const Icon(Icons.logout)),
          IconButton(
            onPressed: () async {
              Navigator.of(context).pushNamed(RouteName.Studies);
            },
            icon: const Icon(Icons.settings),
          ),
        ],
      ),
      body: _isloading
          ? const Center(child: CircularProgressIndicator())
          : Container(
              padding: const EdgeInsets.all(5),
              child: Column(
                children: [
                  buildCurrentDate(context),
                  Card(
                    elevation: 5,
                    margin: const EdgeInsets.symmetric(
                      vertical: 8,
                      horizontal: 5,
                    ),
                    child: CheckboxListTile(
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 9,
                      ),
                      onChanged: (val) async {
                        if (val == true) {
                          setState(() {
                            _checked = val!;
                          });
                          await FireStoreApi.testedPositive(
                              _currentTime, _checked);
                        } else {
                          return;
                        }
                      },
                      value: _checked,
                      title: Text(
                        'Tested positive for Covid-19',
                        softWrap: true,
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontSize: 18,
                        ),
                      ),
                      activeColor: Theme.of(context).primaryColor,
                    ),
                  ),
                  buildSurveyCard('Symptoms Survey', context,
                      CovidSurveyPage(_currentTime)),
                  buildSurveyCard('Illness Survey', context,
                      IllnessSurveyPage(_currentTime)),
                ],
              ),
            ),
    );
  }
}
