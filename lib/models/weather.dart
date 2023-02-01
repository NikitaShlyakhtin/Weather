import 'package:weather/presentation/constants/consts.dart';

/// Класс для хранения информации о погоде в городе.
///
/// Принимает название города [cityName], температуру [temperature],
/// влажность [humidity], скорость ветра [windSpeed],
/// url-адрес большой иконки погоды [iconUrl], маленькой [smallIconUrl] и
/// дату прогноза [date].
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

  /// Возвращает дату в формате "<День недели>, <Число> <Месяц>"
  String get dateString {
    String weekday = week[date.weekday - 1];
    int day = date.day;
    String month = year[date.month - 1];
    return "$weekday, $day $month";
  }
}
