import 'package:logger/logger.dart';

import '../data/fitbitActivityData.dart';
import '../data/fitbitData.dart';
import '../urls/fitbitAPIURL.dart';
import 'fitbitDataManager.dart';

/// [FitbitActivityDataManager] is a class the manages the requests related to
/// [FitbitActivityData].
class FitbitActivityDataManager extends FitbitDataManager {
  /// Default [FitbitActivityDataManager] constructor.
  FitbitActivityDataManager({String? clientID, String? clientSecret}) {
    this.clientID = clientID;
    this.clientSecret = clientSecret;
  } // FitbitActivityDataManager

  @override
  Future<List<FitbitData>> fetch(FitbitAPIURL fitbitUrl) async {
    // Get the response
    final response = await getResponse(fitbitUrl);

    // Debugging
    final logger = Logger();
    logger.i('$response');

    //Extract data and return them
    List<FitbitData> ret =
        _extractFitbitActivityData(response, fitbitUrl.userID);
    return ret;
  } // fetch

  Future<int> fetchActivitySteps(FitbitAPIURL fitbitAPIURL) async{
        final response = await getResponse(fitbitAPIURL);

    // Debugging
    final logger = Logger();
    logger.i('$response');

    //Extract data and return them
    int ret = response['summary']['sedentaryMinutes'] as int;
    return ret;
  }

  List<FitbitActivityData> _extractFitbitActivityData(
      dynamic response, String? userID) {
    final data = response['activities'];
    List<FitbitActivityData> activityDatapoints =
        List<FitbitActivityData>.empty(growable: true);

    for (var record = 0; record < data.length; record++) {
      activityDatapoints.add(
        FitbitActivityData(
          activityTypeId: data[record]['activityTypeId'].toString(),
          calories: double.parse(data[record]['calories'].toString()),
          steps: int.parse(data[record]["steps"].toString()),
          duration: double?.parse(data[record]['duration'].toString()) ,
          logId: data[record]['logId'].toString(),
          activityName: data[record]['activityName'],
          startTime: DateTime.parse(data[record]["startTime"]),
        ),
      );
    } // for entry
    return activityDatapoints;
  } // _extractFitbitActivityData

} // FitbitActivityDataManager
