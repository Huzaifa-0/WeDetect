import 'dart:async';

import '/Models/user_information.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_web_auth/flutter_web_auth.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../services/data_base.dart';
import 'urls/fitbitAuthAPIURL.dart';

/// [FitbitConnector] is a class that is in charge of managing the connection authorization
///  between the app and Fitbit APIs.
/// In details, it can authorize the app thus retaining the access and refresh tokens (see
/// [FitbitConnector.authorize] for more details), refresh the access token if needed (see
/// [FitbitConnector.refreshToken] for more details), unauthorize the app (see
/// [FitbitConnector.unauthorize] for more details), and check for the access token status
/// (see [FitbitConnector.isTokenValid] for more details).

class FitbitConnector {
  /// [FitbitConnector] Singleton instance.
  static final FitbitConnector _instance = FitbitConnector._internal();

  /// Public factory constructor of [FitbitConector].
  factory FitbitConnector() => _instance;

  /// [FitbitConnector] internal constructor used to implement the Singleton pattern.
  FitbitConnector._internal();

  /// Method that refreshes the Fitbit access token.
  static Future<void> refreshToken(
      {String? userID, String? clientID, String? clientSecret, String? uid, bool isFirestore= false,UserInformation? userInfo}) async {
    // Instantiate Dio and its Response
    Dio dio = Dio();
    Response response;

    // Generate the fitbit url
    final fitbitUrl = await FitbitAuthAPIURL.refreshToken(
        userID: userID, clientID: clientID, clientSecret: clientSecret, uid: uid,isFirestore: isFirestore, userInfo: userInfo);

    // Post refresh query to Fitbit API
    response = await dio.post(
      fitbitUrl.url!,
      data: fitbitUrl.data,
      options: Options(
        contentType: Headers.formUrlEncodedContentType,
        headers: {
          'Authorization': fitbitUrl.authorizationHeader,
        },
      ),
    );

    // Debugging
    final logger = Logger();
    logger.i('$response');

    // Overwrite the tokens into the shared preferences
    final accessToken = response.data['access_token'] as String;
    final refreshToken = response.data['refresh_token'] as String;
    await FireStoreApi.refreshUserToken(uid!, accessToken, refreshToken);
    final localStorage = await SharedPreferences.getInstance();
    await localStorage.clear();
    localStorage.setString('fitbitAccessToken', accessToken);
    localStorage.setString('fitbitRefreshToken', refreshToken);
  } // refreshToken

  /// Method that checks if the current token is still valid to be used
  /// by the Fitbit APIs OAuth or it is expired.
  static FutureOr<bool> isTokenValid([bool isFirestore = false, String? uid,UserInformation? userInfo]) async {
    // Instantiate Dio and its Response
    Dio dio = Dio();
    late Response response;

    final fitbitUrl = await FitbitAuthAPIURL.isTokenValid(isFirestore, uid, userInfo);

    //Get the response
    try {
      response = await dio.post(
        fitbitUrl.url!,
        data: fitbitUrl.data,
        options: Options(
          contentType: Headers.formUrlEncodedContentType,
          headers: {
            'Authorization': fitbitUrl.authorizationHeader,
          },
        ),
      );
    } on DioError catch (e) {
      if (e.response!.statusCode == 401) {
        return false;
      }
    }

    // Debugging
    final logger = Logger();
    logger.i('$response');

    // get token status and return it
    return response.data['active'] as bool;
  } // isTokenValid

  /// Method that implements the OAuth 2.0 protocol and gets (and retain)
  /// in the [SharedPreferences] the access and refresh tokens from Fitbit APIs.
  static Future<String?> authorize({
    UserInformation? user,
    BuildContext? context,
    String? clientID,
    String? clientSecret,
    required String redirectUri,
    required String callbackUrlScheme,
  }) async {
    // Instantiate Dio and its Response
    Dio dio = Dio();
    Response response;

    String? userID;

    // Generate the fitbit url
    final fitbitAuthorizeFormUrl = FitbitAuthAPIURL.authorizeForm(
        userID: userID, redirectUri: redirectUri, clientID: clientID);

    // Perform authentication
    try {
      final result = await FlutterWebAuth.authenticate(
          url: fitbitAuthorizeFormUrl.url!,
          callbackUrlScheme: callbackUrlScheme);
      //Get the auth code
      final code = Uri.parse(result).queryParameters['code'];

      // Generate the fitbit url
      final fitbitAuthorizeUrl = FitbitAuthAPIURL.authorize(
          userID: userID,
          redirectUri: redirectUri,
          code: code,
          clientID: clientID,
          clientSecret: clientSecret);

      response = await dio.post(
        fitbitAuthorizeUrl.url!,
        data: fitbitAuthorizeUrl.data,
        options: Options(
          contentType: Headers.formUrlEncodedContentType,
          headers: {
            'Authorization': fitbitAuthorizeUrl.authorizationHeader,
          },
        ),
      );

      // Debugging
      final logger = Logger();
      logger.i('$response');

      // Save authorization tokens
      final accessToken = response.data['access_token'] as String;
      final refreshToken = response.data['refresh_token'] as String;
      userID = response.data['user_id'] as String?;

      user!.fitbitAccessToken = accessToken;
      user.fitbitRefreshToken = refreshToken;
      user.fitbitUserId = userID;

      final localStorage = await SharedPreferences.getInstance();
      localStorage.setString('fitbitAccessToken', accessToken);
      localStorage.setString('fitbitRefreshToken', refreshToken);
      await FireStoreApi.createUser(user);
      var x = localStorage.getString('fitbitAccessToken');
      print('********************fitbitAccessToken************************');
      print(x);
      print('********************fitbitAccessToken************************');
    } catch (e) {
      print(e);
    } // catch

    return userID;
  } // authorize

  /// Method that revokes the current access, refreshes tokens and
  /// deletes them from the [SharedPreferences].
  static Future<void> unauthorize(
      {String? clientID, String? clientSecret}) async {
    // Instantiate Dio and its Response
    Dio dio = Dio();
    Response response;

    //String userID;

    // Generate the fitbit url
    final fitbitUrl = await FitbitAuthAPIURL.unauthorize(
        clientSecret: clientSecret, clientID: clientID);

    // Post revoke query to Fitbit API
    try {
      response = await dio.post(
        fitbitUrl.url!,
        data: fitbitUrl.data,
        options: Options(
          contentType: Headers.formUrlEncodedContentType,
          headers: {
            'Authorization': fitbitUrl.authorizationHeader,
          },
        ),
      );

      // Debugging
      final logger = Logger();
      logger.i('$response');
      // Remove the tokens from shared preferences
      final localStorage = await SharedPreferences.getInstance();
      localStorage.remove('fitbitAccessToken');
      localStorage.remove('fitbitRefreshToken');
      print('..............Removed..........');
    } catch (e) {
      print(e);
    } // catch
  } // unauthorize

} // FitbitConnector
