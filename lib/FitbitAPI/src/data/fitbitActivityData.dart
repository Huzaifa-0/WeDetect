import '../utils/formats.dart';
import 'fitbitData.dart';

/// [FitbitActivityData] is a class implementing the data model of the
/// user's physical activity data.
class FitbitActivityData implements FitbitData {
  /// The activity type id.
  String? activityTypeId;

  /// The calories spent during the activity.
  double? calories;

  /// The distance spanned during the activity.
  int? steps;

  /// The duration of the activity.
  double? duration;

  /// The univocal activity id.
  String? logId;

  /// The name of the activity.
  String? activityName;

  /// The start time of the activity.
  DateTime? startTime;

  /// Default [FitbitActivityData] constructor.
  FitbitActivityData({
    this.activityTypeId,
    this.calories,
    this.steps,
    this.duration,
    this.logId,
    this.activityName,
    this.startTime,
  });

  /// Generates a [FitbitActivityData] obtained from a json.
  factory FitbitActivityData.fromJson({required Map<String, dynamic> json}) {
    return FitbitActivityData(
      activityTypeId: json['activityTypeId'],
      calories: json['calories'],
      steps: json['steps'],
      duration: json['duration'],
      logId: json['logId'],
      activityName: json['activityName'],
      startTime: Formats.onlyTimeNoSeconds.parse(json['startTime']),
    );
  } // fromJson

  @override
  String toString() {
    return (StringBuffer('FitbitActivityData(')
          ..write('activityId: $activityTypeId, ')
          ..write('calories: $calories, ')
          ..write('steps: $steps, ')
          ..write('duration: $duration, ')
          ..write('logId: $logId, ')
          ..write('activityName: $activityName, ')
          ..write('startTime: $startTime')
          ..write(')'))
        .toString();
  } // toString

  @override
  Map<String, dynamic> toJson<T extends FitbitData>() {
    return <String, dynamic>{
      'activityId': activityTypeId,
      'calories': calories,
      'steps': steps,
      'duration': duration,
      'logId': logId,
      'name': activityName,
      'startTime': startTime,
    };
  } // toJson

} // FitbitActivityData
