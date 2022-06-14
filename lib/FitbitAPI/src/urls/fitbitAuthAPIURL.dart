import 'package:flutter/foundation.dart';

import '/Models/user_information.dart';
// import 'package:we_detect/services/data_base.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import 'fitbitAPIURL.dart';

/// [FitbitAuthAPIURL] is a class that expresses multiple factory
/// constructors to be used to generate Fitbit Web APIs urls to
/// be used by [FitbitConnector].
class FitbitAuthAPIURL extends FitbitAPIURL {
  /// The data to be attached to the url.
  String? data;

  /// The authorization header of the url.
  String? authorizationHeader;

  /// Default [FitbitAuthAPIURL] constructor.
  FitbitAuthAPIURL(
      {String? url,
      String? userID,
      String? data,
      String? authorizationHeader}) {
    // super fields
    this.url = url;
    this.userID = userID;

    // FitbitAuthAPIURL fields
    this.data = data;
    this.authorizationHeader = authorizationHeader;
  } // FitbitAuthAPIURL

  /// Factory constructor that generates a [FitbitAuthAPIURL] to be used
  /// to refresh the access token.
  static Future<FitbitAuthAPIURL> refreshToken({
    String? userID,
    String? clientID,
    String? clientSecret,
    String? uid,
    bool isFirestore = false,
    UserInformation? userInfo,
  }) async {
    // Generate the authorization header
    Codec<String, String> stringToBase64 = utf8.fuse(base64);
    final String authorizationHeader =
        stringToBase64.encode("$clientID:$clientSecret");

    if (isFirestore && userInfo != null) {
      debugPrint(
          'refresh token...........with firebase ::=> ${userInfo.fitbitRefreshToken}');
      return FitbitAuthAPIURL(
        url: '${_getBaseURL()}/token',
        userID: null,
        data:
            'grant_type=refresh_token&refresh_token=${userInfo.fitbitRefreshToken}',
        authorizationHeader: 'Basic $authorizationHeader',
      );
    }
//client_id=$clientID&
    final localStorage = await SharedPreferences.getInstance();
    final fitbitRefreshToken = localStorage.getString('fitbitRefreshToken');
    debugPrint(
        'refresh token...........with localStorage ::=> $fitbitRefreshToken');

    return FitbitAuthAPIURL(
      url: '${_getBaseURL()}/token',
      userID: null,
      data: 'grant_type=refresh_token&refresh_token=$fitbitRefreshToken',
      authorizationHeader: 'Basic $authorizationHeader',
    );
  } // FitbitAuthAPIURL.refreshToken

  /// Factory constructor that generates a [FitbitAuthAPIURL] to be used
  /// to get to the fitbit authorization form.
  factory FitbitAuthAPIURL.authorizeForm(
      {String? userID, required String redirectUri, String? clientID}) {
    // Encode the redirectUri
    final String encodedRedirectUri = Uri.encodeFull(redirectUri);

    return FitbitAuthAPIURL(
      url:
          'https://www.fitbit.com/oauth2/authorize?response_type=code&client_id=$clientID&redirect_uri=$encodedRedirectUri&scope=activity%20heartrate%20location%20nutrition%20profile%20settings%20sleep%20social%20weight&expires_in=604800',
      userID: userID,
      data: null,
      authorizationHeader: null,
    );
  } // FitbitAuthAPIURL.authorizeForm

  /// Factory constructor that generates a [FitbitAuthAPIURL] to be used
  /// to get the access and refresh tokens.
  factory FitbitAuthAPIURL.authorize(
      {String? userID,
      required String redirectUri,
      String? code,
      String? clientID,
      String? clientSecret}) {
    // Encode the redirectUri
    final String encodedRedirectUri = Uri.encodeFull(redirectUri);

    // Generate the authorization header
    Codec<String, String> stringToBase64 = utf8.fuse(base64);
    final String authorizationHeader =
        stringToBase64.encode("$clientID:$clientSecret");

    return FitbitAuthAPIURL(
      userID: userID,
      url: '${_getBaseURL()}/token',
      data:
          'client_id=$clientID&grant_type=authorization_code&code=$code&redirect_uri=$encodedRedirectUri',
      authorizationHeader: 'Basic $authorizationHeader',
    );
  } // FitbitAuthAPIURL.authorize

  Future<String?> getName() async {
    var localStorage = await SharedPreferences.getInstance();
    String? res = localStorage.getString('fitbitRefreshToken');
    return res;
  }

  /// Factory constructor that generates a [FitbitAuthAPIURL] to be used
  /// to revoke the access and refresh tokens.
  static Future<FitbitAuthAPIURL> unauthorize(
      {String? clientID, String? clientSecret}) async {
    final localStorage = await SharedPreferences.getInstance();
    final fitbitRefreshToken = localStorage.getString('fitbitRefreshToken');
    debugPrint('$fitbitRefreshToken......................................');
    Codec<String, String> stringToBase64 = utf8.fuse(base64);
    final String authorizationHeader =
        stringToBase64.encode("$clientID:$clientSecret");

    return FitbitAuthAPIURL(
      userID: null,
      url: '${_getBaseURL()}/revoke',
      data: 'token=$fitbitRefreshToken',
      authorizationHeader: 'Basic $authorizationHeader',
    );
  }
  // factory FitbitAuthAPIURL.unauthorizez(
  //     {String? clientID, String? clientSecret}) {
  //   // Generate the authorization header

  // String? fitbitRefreshToken = ;
  //   print('$fitbitRefreshToken......................................');
  //   Codec<String, String> stringToBase64 = utf8.fuse(base64);
  //   final String authorizationHeader =
  //       stringToBase64.encode("$clientID:$clientSecret");

  //   return FitbitAuthAPIURL(
  //     userID: null,
  //     url: '${_getBaseURL()}/revoke',
  //     data:
  //         'token=$fitbitRefreshToken',
  //     authorizationHeader: 'Basic $authorizationHeader',
  //   );
  // } // FitbitAuthAPIURL.unauthorize

  /// Factory constructor that generates a [FitbitAuthAPIURL] to be used
  /// to get the validity of the access and refresh tokens.
  static Future<FitbitAuthAPIURL> isTokenValid(
      [bool isFirestore = false,
      String? uid,
      UserInformation? userInfo]) async {
    if (isFirestore && userInfo != null) {
      debugPrint(
          'access token...........with localstorage ::=> ${userInfo.fitbitAccessToken}');
      return FitbitAuthAPIURL(
        userID: null,
        url: 'https://api.fitbit.com/1.1/oauth2/introspect',
        data: 'token=${userInfo.fitbitAccessToken}',
        authorizationHeader: 'Bearer ${userInfo.fitbitAccessToken}',
      );
    }
    final localStorage = await SharedPreferences.getInstance();
    final fitbitAccessToken = localStorage.getString('fitbitAccessToken');
    debugPrint(
        'access token...........with localstorage ::=> $fitbitAccessToken');
    return FitbitAuthAPIURL(
      userID: null,
      url: 'https://api.fitbit.com/1.1/oauth2/introspect',
      data: 'token=$fitbitAccessToken',
      authorizationHeader: 'Bearer $fitbitAccessToken',
    );
  } // FitbitAuthAPIURL.isTokenValid

  /// A private method that generates the base url of a [FitbitAuthAPIURL].
  static String _getBaseURL() {
    return 'https://api.fitbit.com/oauth2';
  } // _getBaseURL

} // FitbitAuthAPIURL
