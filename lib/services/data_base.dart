import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import '/Models/user_information.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FireStoreApi {
  static Future createUser(UserInformation user) async {
    final userDoc =
        FirebaseFirestore.instance.collection('Users').doc(user.uid);
    await userDoc.set(user.toJson());
  }

  static Future submitCheckUpSurvey({
    required User user,
    required bool isVaccinated,
    required bool haveSymptoms,
    required String exposure,
    required String symptoms,
    required List<String> checkUpList,
  }) async {
    final studyDoc = FirebaseFirestore.instance
        .collection('Users')
        .doc(user.uid)
        .collection('Studies')
        .doc('Covid-19 Study');
    await studyDoc.set({
      'isVaccinated': isVaccinated,
      'haveSymptoms': haveSymptoms,
      'exposure': exposure,
      'symptoms': symptoms,
      'health condition': checkUpList,
      'submitted': true,
    });
  }

  static Future<bool> checkIfSubmitted(User user) async {
    try {
      final studyDoc = FirebaseFirestore.instance
          .collection('Users')
          .doc(user.uid)
          .collection('Studies')
          .doc('Covid-19 Study');
      final studydata = await studyDoc.get();
      final data = studydata.data()!['submitted'] as bool;
      debugPrint(data.toString() + '.....................True');
      return data;
    } catch (e) {
      return false;
    }
  }

  static Future<UserInformation> getUserInfo(String uid) async {
    final userDoc =
        await FirebaseFirestore.instance.collection('Users').doc(uid).get();
    return UserInformation.fromJson(userDoc.data());
  }

  static Future<void> refreshUserToken(
      String uid, String fitbitAccessToken, String fitbitRefreshToken) async {
    try {
      final userDoc = FirebaseFirestore.instance.collection('Users').doc(uid);
      await userDoc.update({
        'fitbitAccessToken': fitbitAccessToken,
        'fitbitRefreshToken': fitbitRefreshToken,
      });
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  static Future addSurvey(List<String> survey, String collection, String docId,
      [String? condition]) async {
    final creationTime = Timestamp.now();
    final user = FirebaseAuth.instance.currentUser!;
    final surveyDoc = FirebaseFirestore.instance
        .collection('Users')
        .doc(user.uid)
        .collection('Studies')
        .doc('Covid-19 Study')
        .collection(collection);
    if (collection == 'Symptoms-Survey') {
      await surveyDoc.add({
        'createdAt': creationTime,
        'symptoms': survey,
        'feeling': condition,
      });
    } else {
      await surveyDoc.add({
        'createdAt': creationTime,
        'illnesses': survey,
      });
    }
  }

  static Future testedPositive(
    String docId,
    bool? isPositive,
  ) async {
    final creationTime = DateTime.now().toIso8601String();
    // final validationTime = creationTime.add(Duration(days: 1));
    final user = FirebaseAuth.instance.currentUser!;
    final positiveDoc = FirebaseFirestore.instance
        .collection('Users')
        .doc(user.uid)
        .collection('Studies')
        .doc('Covid-19 Study')
        .collection('Covid-Positive')
        .doc(docId);
    await positiveDoc.set({
      'createdAt': creationTime,
      'Checked': isPositive,
      // 'document_Id': DateTime.now(),
    });
  }

  static Future<bool> isPositive(String docId) async {
    try {
      final user = FirebaseAuth.instance.currentUser!;
      var isPositive = false;
      final positiveDoc = FirebaseFirestore.instance
          .collection('Users')
          .doc(user.uid)
          .collection('Studies')
          .doc('Covid-19 Study')
          .collection('Covid-Positive')
          .doc(docId);

      final positiveData = await positiveDoc.get();

      final createdAt = DateTime.parse(positiveData['createdAt'])
          .add(const Duration(days: 1));
      debugPrint('Creation date............24h ' + createdAt.toString());

      if (createdAt.isBefore(DateTime.now())) {
        await positiveDoc.update({
          'Checked': false,
        });
      } else {
        isPositive = positiveData['Checked'];
      }
      // isPositive = positiveData['Checked'];
      return isPositive;
    } catch (e) {
      debugPrint(e.toString());
      return false;
    }
  }
}
