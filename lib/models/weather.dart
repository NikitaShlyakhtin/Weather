import 'package:weather/presentation/constants/consts.dart';

class Weather {
  final String cityName;
  final int temperature;
  final int humidity;
  final int windSpeed;
  final String iconUrl;
  final String smallIconUrl;
  final DateTime date;

  Weather(
      {required this.cityName,
      required this.temperature,
      required this.humidity,
      required this.windSpeed,
      required this.iconUrl,
      required this.smallIconUrl,
      required this.date});

  String get dateString {
    String weekday = week[date.weekday - 1];
    int day = date.day;
    String month = year[date.month - 1];
    return "$weekday, $day $month";
  }
}
