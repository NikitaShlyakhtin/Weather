part of 'weather_bloc.dart';

@immutable
abstract class WeatherEvent {}

class WeatherFetching extends WeatherEvent {
  final String city;

  WeatherFetching({required this.city});
}

class WeatherTodayOpened extends WeatherEvent {
  final List<Weather> weatherList;

  WeatherTodayOpened({required this.weatherList});
}

class WeatherForecastOpened extends WeatherEvent {
  final List<Weather> weatherList;

  WeatherForecastOpened({required this.weatherList});
}

class WeatherSearchOpened extends WeatherEvent {}
