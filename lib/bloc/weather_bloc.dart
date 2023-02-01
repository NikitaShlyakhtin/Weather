import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:weather/models/weather.dart';
import 'package:weather/services/weather_service.dart';

part 'weather_event.dart';
part 'weather_state.dart';

/// Bloc для управления состоянием приложения.
///
/// Доступные состояние: [WeatherInitial], [WeatherToday],
///  [WeatherFetchingFailure], [WeatherForecast].
///
/// Доступные события: [WeatherFetching], [WeatherTodayOpened],
/// [WeatherForecastOpened], [WeatherSearchOpened].
class WeatherBloc extends Bloc<WeatherEvent, WeatherState> {
  WeatherBloc() : super(WeatherInitial()) {
    on<WeatherFetching>(_weatherFetchingHandler);
    on<WeatherForecastOpened>(_weatherForecastOpenedHandler);
    on<WeatherSearchOpened>(_weatherSearchOpenedHandler);
    on<WeatherTodayOpened>(_weatherTodayOpenedHandler);
  }

  /// Принимает событие [WeatherTodayOpened].
  ///
  /// Вызывает переход в состояние [WeatherToday] из [WeatherInitial]
  /// или [WeatherForecast]
  Future<void> _weatherTodayOpenedHandler(
      WeatherTodayOpened event, Emitter emit) async {
    emit(WeatherToday(weatherList: event.weatherList));
  }

  /// Принимает событие [WeatherSearchOpened].
  ///
  /// Вызывает переход в состояние [WeatherInitial] из [WeatherToday]
  Future<void> _weatherSearchOpenedHandler(
      WeatherSearchOpened event, Emitter emit) async {
    emit(WeatherInitial());
  }

  /// Принимает событие [WeatherForecastOpened].
  ///
  /// Вызывает переход в состояние [WeatherForecast] из [WeatherToday]
  Future<void> _weatherForecastOpenedHandler(
      WeatherForecastOpened event, Emitter emit) async {
    emit(WeatherForecast(weatherList: event.weatherList));
  }

  /// Принимает событие [WeatherFetching].
  ///
  /// Вызывает переход в состояние [WeatherToday] или [WeatherFetchingFailure]
  Future<void> _weatherFetchingHandler(
      WeatherFetching event, Emitter emit) async {
    try {
      List<Weather> weatherList = await WeatherService.getWeather(event.city);
      emit(WeatherToday(weatherList: weatherList));
    } catch (e) {
      emit(WeatherFetchingFailure());
    }
  }
}
