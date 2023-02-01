part of 'weather_bloc.dart';

@immutable
abstract class WeatherState {}

class WeatherInitial extends WeatherState {}

class WeatherToday extends WeatherState {
  final List<Weather> weatherList;

  WeatherToday({required this.weatherList});
}

class WeatherFetchingFailure extends WeatherState {}

class WeatherForecast extends WeatherState {
  final List<Weather> weatherList;

  WeatherForecast({required this.weatherList});

  List<Weather> get sortedWeatherList {
    List<Weather> sortedList = weatherList;
    sortedList.sort((a, b) => a.temperature.compareTo(b.temperature));
    return sortedList;
  }
}
