part of 'weather_bloc.dart';

/// Общее состояние для WeatherBloc
@immutable
abstract class WeatherState {}

/// Исходное состояние
class WeatherInitial extends WeatherState {}

/// Состояние при нахождении на экране с погодой на данный момент.
///
/// Принимает список с тремя объектами [Weather]
class WeatherToday extends WeatherState {
  final List<Weather> weatherList;

  WeatherToday({required this.weatherList});
}

/// Состояние после получении ошибки при запросе данных.
class WeatherFetchingFailure extends WeatherState {}

/// Состояние при нахождении на экране с прогнозом погоды на 3 дня.
///
/// /// Принимает список с тремя объектами [Weather]
class WeatherForecast extends WeatherState {
  final List<Weather> weatherList;

  WeatherForecast({required this.weatherList});

  /// Возвращает отсортированный по возрастанию температуры
  ///  список с тремя объектами [Weather]
  List<Weather> get sortedWeatherList {
    List<Weather> sortedList = weatherList;
    sortedList.sort((a, b) => a.temperature.compareTo(b.temperature));
    return sortedList;
  }
}
