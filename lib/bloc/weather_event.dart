part of 'weather_bloc.dart';

/// Общее событие для WeatherBloc
@immutable
abstract class WeatherEvent {}

/// Событие вызывается при запросе данных с api.
///
/// Вызывает переход к экрану с погодой на данный момент из начального экрана
/// или [SnackBar] с ошибкой.
class WeatherFetching extends WeatherEvent {
  final String city;

  WeatherFetching({required this.city});
}

/// Событие вызывается при переходе на экран с погодой на данный момент
/// из экрана с прогнозом погоды на 3 дня.
class WeatherTodayOpened extends WeatherEvent {
  final List<Weather> weatherList;

  WeatherTodayOpened({required this.weatherList});
}

/// Событие вызывается при переходе на экран с прогнозом погоды
/// на 3 дня из экрана с погодой на данный момент.
class WeatherForecastOpened extends WeatherEvent {
  final List<Weather> weatherList;

  WeatherForecastOpened({required this.weatherList});
}

/// Событие вызывается при переходе на начальный экран из экрана с погодой
/// на данный момент.
class WeatherSearchOpened extends WeatherEvent {}
