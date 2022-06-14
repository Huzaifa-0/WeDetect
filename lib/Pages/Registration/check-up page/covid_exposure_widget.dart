// ignore_for_file: prefer_const_constructors_in_immutables, use_key_in_widget_constructors
import 'package:flutter/material.dart';

class CovidExposureSurvey extends StatefulWidget {
  //static const routeName = '/regestration/check_up/covid_exposure';
  final ValueChanged<String> onChangedRadio;
  CovidExposureSurvey(this.onChangedRadio);
  @override
  _CovidExposureSurveyState createState() => _CovidExposureSurveyState();
}

class _CovidExposureSurveyState extends State<CovidExposureSurvey> {
  int? selectedRadio;
  //bool? isSelected;
  final _formKey = GlobalKey<FormState>();
  static List<String> exposure = [
    'I haven\'t had higher exposure to COVID-19',
    'Family member has COVID-19',
    'Close contact with COVID-19 positive indivdual',
    'Attended event with known COVID-19 case',
    'Exposure as healthcare/medical worker',
    'Exposure as frontline worker',
  ];

  @override
  void initState() {
    super.initState();
    selectedRadio = null;
    //isSelected = false;
  }

  setSelectedRadio(int val) {
    setState(() {
      selectedRadio = val;
      // isSelected = true;
    });
    widget.onChangedRadio(exposure[val]);
  }

  Widget buildRadioListTile(
          Widget titleText, int value, Function(int?) setRadio,
          {Widget? subtitleText}) =>
      RadioListTile(
        value: value,
        title: titleText,
        subtitle: subtitleText,
        groupValue: selectedRadio,
        onChanged: setRadio,
        activeColor: Colors.green,
      );

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            child: const Text(
              'COVID-19 Exposure: Please select the case mostly represent you ',
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontFamily: 'RobotoCondensed',
                fontSize: 20,
              ),
            ),
          ),
          const Divider(),
          buildRadioListTile(
              Text(exposure[0]), 0, (val) => setSelectedRadio(val!)),
          buildRadioListTile(
              Text(exposure[1]), 1, (val) => setSelectedRadio(val!)),
          buildRadioListTile(
              Text(exposure[2]), 2, (val) => setSelectedRadio(val!)),
          buildRadioListTile(
              Text(exposure[3]), 3, (val) => setSelectedRadio(val!)),
          buildRadioListTile(
              Text(exposure[4]), 4, (val) => setSelectedRadio(val!)),
          buildRadioListTile(
            Text(exposure[5]),
            5,
            (val) => setSelectedRadio(val!),
            subtitleText: const Text('e.g grocery, retail, public interaction'),
          ),
        ],
      ),
    );
  }
}
