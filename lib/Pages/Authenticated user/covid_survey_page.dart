// ignore_for_file: use_key_in_widget_constructors

import '/Models/check_box_state.dart';
import '/Widgets/button.dart';
import '/Widgets/check_box.dart';
import '/services/data_base.dart';
import 'package:flutter/material.dart';

class CovidSurveyPage extends StatefulWidget {
  final String currentTime;
  const CovidSurveyPage(this.currentTime);
  @override
  _CovidSurveyPageState createState() => _CovidSurveyPageState();
}

class _CovidSurveyPageState extends State<CovidSurveyPage> {
  var _isLoading = false;
  int _conditionIndex = 0;
  String? _condition;
  final List<String> _covidTitleList = [];

  final List<Map<String, Object>> _conditions = [
    {'index': 1, 'condition': 'Generally healthy'},
    {'index': 2, 'condition': 'Overtired/ extreme stress'},
    {'index': 3, 'condition': 'Experiencing symptoms of beginning illness'},
    {'index': 4, 'condition': 'Currently ill'},
    {'index': 5, 'condition': 'Recovered from illness'},
  ];
  final covidSurvey = [
    CheckBoxState(title: CheckBoxState.covidTitleList[0]),
    CheckBoxState(title: CheckBoxState.covidTitleList[1]),
    CheckBoxState(title: CheckBoxState.covidTitleList[2]),
    CheckBoxState(title: CheckBoxState.covidTitleList[3]),
    CheckBoxState(title: CheckBoxState.covidTitleList[4]),
    CheckBoxState(title: CheckBoxState.covidTitleList[5]),
    CheckBoxState(title: CheckBoxState.covidTitleList[6]),
    CheckBoxState(title: CheckBoxState.covidTitleList[7]),
    CheckBoxState(title: CheckBoxState.covidTitleList[8]),
  ];

  Widget _buildSingleRadioButton(int index, String condition) => RadioListTile(
        value: index,
        groupValue: _conditionIndex,
        onChanged: (int? val) {
          setState(() {
            _conditionIndex = val!;
            _condition = condition;
            debugPrint(_condition! + ' ' + _conditionIndex.toString());
          });
        },
        title: Text(condition),
        activeColor: Colors.green,
      );
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
        title: const Text('Symptoms Survey'),
      ),
      body: _isLoading
          ?const Center(child: CircularProgressIndicator())
          : ListView(
              children: [
                _buildContainerText('How Do You Feel Today?'),
                const Divider(),
                ..._conditions
                    .map((condition) => _buildSingleRadioButton(
                        condition['index'] as int,
                        condition['condition'] as String))
                    .toList(),
                const SizedBox(height: 16),
                _buildContainerText(
                    'Are you experiencing any of these symptoms :'),
                const Divider(),
                ...covidSurvey
                    .map((chBox) => CheckBox(
                          checkBox: chBox,
                          titleList: _covidTitleList,
                        ))
                    .toList(),
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: Button(
                    text: 'Submit',
                    onClicked: () async {
                      setState(() {
                        _isLoading = true;
                      });
                      if (_covidTitleList.isNotEmpty && _condition != null) {
                        await FireStoreApi.addSurvey(_covidTitleList,
                            'Symptoms-Survey', widget.currentTime, _condition);
                        Navigator.of(context).pop(true);
                      } else {
                        setState(() {
                          _isLoading = false;
                        });
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: const Text('Please Fill in The Survey',
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
