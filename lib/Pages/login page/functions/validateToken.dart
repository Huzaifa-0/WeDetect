import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../FitbitAPI/src/fitbitConnector.dart';
import '../../../Models/user_information.dart';
import '../../../constants.dart';
import '../../../services/data_base.dart';

Future validateToken(User? firebaseUser) async {
  final UserInformation userInfo =
      await FireStoreApi.getUserInfo(firebaseUser!.uid);

  debugPrint('name................${userInfo.firstName}');

  final localStorage = await SharedPreferences.getInstance();
  final localStorageFitbitAccessToken =
      localStorage.getString('fitbitAccessToken');

  debugPrint('fitbitAccessToken local storage................$localStorageFitbitAccessToken');
  debugPrint(
      'userInfo.fitbitAccessToken................${userInfo.fitbitAccessToken}');

  try {
    if (localStorageFitbitAccessToken != null &&
        userInfo.fitbitAccessToken == localStorageFitbitAccessToken) {
      debugPrint('First Phase..........start');
      final isTokenValid = await FitbitConnector.isTokenValid();
      debugPrint('$isTokenValid....................isTokenValid');
      if (!isTokenValid) {
        await FitbitConnector.refreshToken(
          clientID: Strings.fitbitClientID,
          clientSecret: Strings.fitbitClientSecret,
          uid: firebaseUser.uid,
        );
        debugPrint('First Phase..........done');
  
      }
    } else {
      debugPrint('second Phase..........start');
      final isTokenValid =
          await FitbitConnector.isTokenValid(true, firebaseUser.uid, userInfo);

      debugPrint('$isTokenValid....................isTokenValid');
      if (isTokenValid) {
        await localStorage.clear();
        localStorage.setString(
            'fitbitAccessToken', userInfo.fitbitAccessToken!);
        localStorage.setString(
            'fitbitRefreshToken', userInfo.fitbitRefreshToken!);
            debugPrint('second Phase..........done');
       
      } else {
        debugPrint('third Phase..........start');
        await FitbitConnector.refreshToken(
          clientID: Strings.fitbitClientID,
          clientSecret: Strings.fitbitClientSecret,
          isFirestore: true,
          uid: firebaseUser.uid,
          userInfo: userInfo,
        );
        debugPrint('third Phase..........done');
      }
    }
    return;
  } catch (err) {
    debugPrint(err.toString() + '................................ERROR');
    return;
  }
}
