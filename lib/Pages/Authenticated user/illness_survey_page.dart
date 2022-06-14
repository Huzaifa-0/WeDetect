// ignore_for_file: use_key_in_widget_constructors

import '/Models/check_box_state.dart';
import '/Widgets/button.dart';
import '/Widgets/check_box.dart';
import '/services/data_base.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class IllnessSurveyPage extends StatefulWidget {
  final String currentTime;
  const IllnessSurveyPage(this.currentTime);
  @override
  _IllnessSurveyPageState createState() => _IllnessSurveyPageState();
}

class _IllnessSurveyPageState extends State<IllnessSurveyPage> {
  var _isLoading = false;
  User user = FirebaseAuth.instance.currentUser!;
  final List<String> _illnessTitleList = [];
  final illnessSurvey = [
    CheckBoxState(title: CheckBoxState.illnessTitleList[0]),
    CheckBoxState(title: CheckBoxState.illnessTitleList[1]),
    CheckBoxState(title: CheckBoxState.illnessTitleList[2]),
    CheckBoxState(title: CheckBoxState.illnessTitleList[3]),
    CheckBoxState(title: CheckBoxState.illnessTitleList[4]),
    CheckBoxState(title: CheckBoxState.illnessTitleList[5]),
    CheckBoxState(title: CheckBoxState.illnessTitleList[6]),
    CheckBoxState(title: CheckBoxState.illnessTitleList[7]),
    CheckBoxState(title: CheckBoxState.illnessTitleList[8]),
  ];
  Widget _buildContainerText(String title) => Container(
        padding: const EdgeInsets.only(left: 10, top: 10),
        width: double.infinity,
        child: Text(
          title,
          style:const TextStyle(
              fontSize: 17.55,
              fontWeight: FontWeight.bold,
              fontFamily: 'RobotoCondensed'),
          overflow: TextOverflow.fade,
          softWrap: true,
        ),
      );
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Illness Survey'),
      ),
      body: _isLoading
          ?const Center(child: CircularProgressIndicator())
          : ListView(
              children: [
                _buildContainerText(
                    'Have you been diagnosed with any of illnesses on this day?'),
                const Divider(),
                ...illnessSurvey
                    .map((chBox) => CheckBox(
                          checkBox: chBox,
                          titleList: _illnessTitleList,
                        ))
                    .toList(),
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Button(
                    text: 'Submit',
                    onClicked: () async {
                      setState(() {
                        _isLoading = true;
                      });
                      if (_illnessTitleList.isNotEmpty) {
                        await FireStoreApi.addSurvey(
                            _illnessTitleList, 'Illness-Survey',widget.currentTime);
                        Navigator.of(context).pop(true);
                      } else {
                        setState(() {
                          _isLoading = false;
                        });
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content:const Text('Please Fill in The Survey',
                                textAlign: TextAlign.center),
                            backgroundColor: Theme.of(context).errorColor,
                            duration:const Duration(
                              seconds: 1,
                            ),
                          ),
                        );
                      }
                    },
                  ),
                ),
              ],
            ),
    );
  }
}
