import 'package:logger/logger.dart';

import '../data/fitbitActivityTimeseriesData.dart';
import '../data/fitbitData.dart';
import '../errors/fitbitUnexistentFitbitResourceException.dart';
import '../urls/fitbitAPIURL.dart';
import '../urls/fitbitActivityTimeseriesAPIURL.dart';
import '../utils/formats.dart';
import 'fitbitDataManager.dart';


/// [FitbitActivityTimeseriesDataManager] is a class the manages the requests related to
/// [FitbitActivityTimeseriesData].
class FitbitActivityTimeseriesDataManager extends FitbitDataManager {
  /// The type of activity timeseries data.
  String? type;

  /// Default [FitbitActivityTimeseriesDataManager] constructor.
  FitbitActivityTimeseriesDataManager(
      {String? clientID, String? clientSecret, String? type}) {
    this.clientID = clientID;
    this.clientSecret = clientSecret;
    this.type = type;
  } // FitbitActivityTimeseriesDataManager

  @override
  Future<List<FitbitData>> fetch(FitbitAPIURL fitbitUrl) async {
    //Set the resource type
    final fitbitSpecificUrl = fitbitUrl as FitbitActivityTimeseriesAPIURL;
    type = fitbitSpecificUrl.resource;

    // Get the response
    final response = await getResponse(fitbitUrl);

    // Debugging
    final logger = Logger();
    logger.i('$response');

    //Extract data and return them
    List<FitbitData> ret =
        _extractFitbitActivityTimeseriesData(response, fitbitUrl.userID);
    return ret;
  } // fetch

  /// A private method that extracts [FitbitActivityTimeseriesData] from the given response.
  List<FitbitActivityTimeseriesData> _extractFitbitActivityTimeseriesData(
      dynamic response, String? userId) {
    final data = response[_getDataField()];
    List<FitbitActivityTimeseriesData> atDatapoints =
        List<FitbitActivityTimeseriesData>.empty(growable: true);

    for (var record = 0; record < data.length; record++) {
      atDatapoints.add(FitbitActivityTimeseriesData(
        encodedId: userId,
        dateOfMonitoring:
            Formats.onlyDayDateFormatTicks.parse(data[record]['dateTime']),
        type: this.type,
        value: double.parse(data[record]['value']),
      ));
    } // for entry
    return atDatapoints;
  } // _extractFitbitActivityTimeseriesData

  /// A private method that returns the data field name of the response.
  String _getDataField() {
    final validTypes = [
      'activityCalories',
      'calories',
      'caloriesBMR',
      'distance',
      'floors',
      'elevation',
      'minutesSedentary',
      'minutesLightlyActive',
      'minutesFairlyActive',
      'minutesVeryActive',
      'steps'
    ];

    if (validTypes.contains(type))
      return 'activities-' + type!;
    else {
      throw FitbitUnaexistentFitbitResourceException(
          message: 'The specified resource is not existent.');
    } // else
  } // _getDataField

} // FitbitActivityTimeseriesDataManager
