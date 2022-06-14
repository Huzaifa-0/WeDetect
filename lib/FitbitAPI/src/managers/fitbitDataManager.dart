import 'dart:convert';
import 'dart:async';

import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/fitbitData.dart';
import '../errors/fitbitBadRequestException.dart';
import '../errors/fitbitForbiddenException.dart';
import '../errors/fitbitNotFoundException.dart';
import '../errors/fitbitRateLimitExceededException.dart';
import '../errors/fitbitUnauthorizedException.dart';
import '../fitbitConnector.dart';
import '../urls/fitbitAPIURL.dart';


/// [FitbitDataManager] is an abstract class the manages the requests related to
/// [FitbitData].
abstract class FitbitDataManager {
  /// The client id.
  String? clientID;

  /// The client secret id.
  String? clientSecret;

  /// Default constructor
  FitbitDataManager({this.clientID, this.clientSecret});

  /// Method that fetches data from the Fitbit API.
  Future<List<FitbitData>> fetch(FitbitAPIURL url);

  /// Method the obtains the response from the given [FitbitAPIURL].
  Future<dynamic> getResponse(FitbitAPIURL fitbitUrl) async {
    //Check access token
    await _checkAccessToken(fitbitUrl);

    // Instantiate Dio and its Response
    Dio dio = Dio();
    late Response response;
    final localStorage =await SharedPreferences.getInstance();
    final fitbitAccessToken = localStorage.getString('fitbitAccessToken');
    print('$fitbitAccessToken......................................');
    try {
      // get the fitbit profile data
      response = await dio.get(
        fitbitUrl.url!,
        options: Options(
          contentType: Headers.formUrlEncodedContentType,
          headers: {
            'Authorization':
                'Bearer $fitbitAccessToken',
          },
        ),
      );
    } on DioError catch (e) {
      FitbitDataManager.manageError(e);
    } // try - catch

    final decodedResponse =
        response.data is String ? jsonDecode(response.data) : response.data;

    Future<dynamic> ret = Future.value(decodedResponse);
    return ret;
  } //getResponse

  /// Method that check the validity of the current access token.
  Future<void> _checkAccessToken(FitbitAPIURL fitbitUrl) async {
    //check if the access token is stil valid, if not refresh it
    if (!await (FitbitConnector.isTokenValid())) {
      await FitbitConnector.refreshToken(
          userID: fitbitUrl.userID,
          clientID: clientID,
          clientSecret: clientSecret);
    } // if
  } //_checkAccessToken

  /// Method that manages errors that could return from the Fitbit API.
  static void manageError(DioError e) {
    switch (e.response!.statusCode) {
      case 200:
        break;
      case 400:
        throw FitbitBadRequestException(
            message: e.response!.data['errors'][0]['message']);
      case 401:
        throw FitbitUnauthorizedException(
            message: e.response!.data['errors'][0]['message']);
      case 403:
        throw FitbitForbiddenException(
            message: e.response!.data['errors'][0]['message']);
      case 404:
        throw FitbitNotFoundException(
            message: e.response!.data['errors'][0]['message']);
      case 429:
        throw FitbitRateLimitExceededException(
            message: e.response!.data['errors'][0]['message']);
    } // switch
  } // manageError

} // FitbitDataManager
