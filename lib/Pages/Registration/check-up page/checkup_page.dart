// ignore_for_file: use_key_in_widget_constructors

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:we_detect/route_name.dart';
import 'package:we_detect/services/data_base.dart';
import '/Widgets/button.dart';
import '/Widgets/check_box.dart';
import '/Models/check_box_state.dart';
import 'covid_exposure_widget.dart';

class CheckUpPage extends StatefulWidget {
  @override
  _CheckUpPageState createState() => _CheckUpPageState();
}

class _CheckUpPageState extends State<CheckUpPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  var _isLoading = false;
  bool isVaccinated = false;
  bool haveSymptoms = false;
  String exposure = '';
  List<String> checkUpList = [];
  final _symptomsText = TextEditingController();
  final checkUpSurvey = [
    CheckBoxState(title: CheckBoxState.checkUpTitleList[0]),
    CheckBoxState(title: CheckBoxState.checkUpTitleList[1]),
    CheckBoxState(title: CheckBoxState.checkUpTitleList[2]),
    CheckBoxState(title: CheckBoxState.checkUpTitleList[3]),
    CheckBoxState(title: CheckBoxState.checkUpTitleList[4]),
  ];

  @override
  Widget build(BuildContext context) {
    final user = _auth.currentUser;
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            'Check-up Survey',
          ),
        ),
        body: Form(
          child: ListView(
            children: [
              Container(
                width: 310,
                padding: const EdgeInsets.all(12),
                child: const Text(
                  'We would like to ask few general questions regarding your health condition.',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontFamily: 'RobotoCondensed',
                    fontSize: 20,
                  ),
                ),
              ),
              const Divider(),
              const SizedBox(
                height: 16,
              ),
              ...checkUpSurvey
                  .map((chBox) => CheckBox(
                        checkBox: chBox,
                        titleList: checkUpList,
                      ))
                  .toList(),
              const SizedBox(
                height: 16,
              ),
              Container(
                padding: const EdgeInsets.all(10),
                width: double.infinity,
                child: const Text(
                  'Have you received a vaccination for covid-19 ?',
                  style: TextStyle(
                      fontSize: 17.55,
                      fontWeight: FontWeight.w500,
                      fontFamily: 'RobotoCondensed'),
                  overflow: TextOverflow.fade,
                  softWrap: true,
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: RadioListTile(
                      activeColor: Colors.green,
                      value: true,
                      title: const Text('Yes'),
                      groupValue: isVaccinated,
                      onChanged: (bool? val) =>
                          setState(() => isVaccinated = val!),
                    ),
                  ),
                  Expanded(
                    child: RadioListTile(
                      activeColor: Colors.green,
                      value: false,
                      title: const Text('No'),
                      groupValue: isVaccinated,
                      onChanged: (bool? val) =>
                          setState(() => isVaccinated = val!),
                    ),
                  ),
                ],
              ),
              Visibility(
                visible: isVaccinated,
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      width: double.infinity,
                      child: const Text(
                        'Did you experience any symptoms after the vaccination ?',
                        style: TextStyle(
                            fontSize: 17.55,
                            fontWeight: FontWeight.w500,
                            fontFamily: 'RobotoCondensed'),
                        overflow: TextOverflow.fade,
                        softWrap: true,
                      ),
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: RadioListTile(
                            activeColor: Colors.green,
                            value: true,
                            title: const Text('Yes'),
                            groupValue: isVaccinated
                                ? haveSymptoms
                                : haveSymptoms = false,
                            onChanged: (bool? val) =>
                                setState(() => haveSymptoms = val!),
                          ),
                        ),
                        Expanded(
                          child: RadioListTile(
                            activeColor: Colors.green,
                            value: false,
                            title: const Text('No'),
                            groupValue: haveSymptoms,
                            onChanged: (bool? val) =>
                                setState(() => haveSymptoms = val!),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Visibility(
                visible: haveSymptoms && isVaccinated,
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      width: double.infinity,
                      child: const Text(
                        'Please indicate the symptoms you had below: ',
                        style: TextStyle(
                            fontSize: 17.55,
                            fontWeight: FontWeight.w500,
                            fontFamily: 'RobotoCondensed'),
                        overflow: TextOverflow.fade,
                        softWrap: true,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(10),
                      child: TextFormField(
                        controller: _symptomsText,
                        maxLines: 6,
                        decoration: const InputDecoration(
                          hintText: 'Symptoms',
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.multiline,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              CovidExposureSurvey((val) {
                exposure = val;
                debugPrint(exposure);
              }),
              Padding(
                padding: const EdgeInsets.all(10),
                child: _isLoading
                    ? const Center(
                        child: CircularProgressIndicator(),
                      )
                    : Button(
                        text: 'Submit',
                        onClicked: () async {
                          if (exposure.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: const Text(
                                    'Please Choose Your Exposure Level',
                                    textAlign: TextAlign.center),
                                backgroundColor: Theme.of(context).errorColor,
                                duration: const Duration(
                                  seconds: 1,
                                ),
                              ),
                            );
                          } else {
                            setState(() {
                              _isLoading = true;
                            });
                            await FireStoreApi.submitCheckUpSurvey(
                              user: user!,
                              isVaccinated: isVaccinated,
                              haveSymptoms: haveSymptoms,
                              exposure: exposure,
                              symptoms: _symptomsText.text,
                              checkUpList: checkUpList,
                            );
                            Navigator.of(context).pushNamedAndRemoveUntil(
                                RouteName.Covid_Study, (route) => false);
                          }
                        }),
              ),
            ],
          ),
        ));
  }
}
