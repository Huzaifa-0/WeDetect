import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:we_detect/Pages/Registration/registration_pages.dart';
import 'package:we_detect/Pages/study%20case%20page/components/card.dart';
import 'package:we_detect/route_name.dart';
import 'package:we_detect/services/data_base.dart';

class StudyPage extends StatefulWidget {
  const StudyPage({Key? key}) : super(key: key);

  @override
  State<StudyPage> createState() => _StudyPageState();
}

class _StudyPageState extends State<StudyPage> {
  late SharedPreferences pref;
  initSharedPreferences() async {
    pref = await SharedPreferences.getInstance();
  }

  @override
  void initState() {
    super.initState();
    initSharedPreferences();
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Study'),
        centerTitle: true,
      ),
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(16),
          width: 380,
          height: 350,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                buildCard(
                    context: context,
                    onTap: () async {
                      pref.setString('study', RouteName.Covid_Study);
                      var name = pref.getString('study');
                      debugPrint(name);
                      final sub = await FireStoreApi.checkIfSubmitted(user!);
                      if (sub) {
                        Navigator.of(context).pushNamedAndRemoveUntil(
                            RouteName.Covid_Study, (route) => false);
                      } else {
                        Navigator.of(context).push(
                            MaterialPageRoute(builder: (_) => CheckUpPage()));
                      }
                    },
                    title: "COVID-19 STUDY"),
                buildCard(context: context, onTap: () {}, title: "..."),
                buildCard(context: context, onTap: () {}, title: "..."),
                buildCard(context: context, onTap: () {}, title: "..."),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
