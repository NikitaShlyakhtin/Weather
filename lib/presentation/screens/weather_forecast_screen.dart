import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather/bloc/weather_bloc.dart';
import 'package:weather/models/weather.dart';
import 'package:weather/presentation/constants/text_styles.dart';
import 'package:weather/presentation/widgets/gap.dart';

/// Строит экран с прогнозом погоды на три дня.
class WeatherForecastScreen extends StatelessWidget {
  const WeatherForecastScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<WeatherBloc, WeatherState>(
      listener: _weatherListener,
      builder: (context, state) {
        return Scaffold(
            appBar: MyAppBar(state),
            backgroundColor: Colors.white,
            body: _buildScaffold(state));
      },
    );
  }

  /// Возвращает к предыдущему экрану при смене состояния на
  /// [WeatherToday]
  void _weatherListener(BuildContext context, WeatherState state) {
    if (state is WeatherToday) {
      Navigator.pop(context);
    }
  }

  /// Строит экран
  Widget _buildScaffold(WeatherState state) {
    return Column(
      children: _weatherForecast(state),
    );
  }

  /// Возвращает список из трех рядов с информацией о погоде.
  ///
  /// Принимает [state] с данными.
  List<Widget> _weatherForecast(WeatherState state) {
    if (state is WeatherForecast) {
      return [
        for (var weather in state.sortedWeatherList)
          Column(children: [
            weatherRow(weather),
            const Divider(
              thickness: 1,
            )
          ])
      ];
    }
    return [];
  }

  /// Возвращает ряд с информацией о погоде в один из дней.
  Widget weatherRow(Weather weather) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          weather.dateString,
          style: bodyText,
        ),
        SizedBox(
          width: 100,
          child: Row(children: [
            Image.network(
              weather.smallIconUrl,
              errorBuilder: _errorBuilder,
            ),
            const Gap(),
            Text(
              '${weather.temperature}°',
              style: bodyText,
            ),
          ]),
        )
      ],
    );
  }

  /// Строит текст с пустой строкой если Image.network возвращает ошибку
  Widget _errorBuilder(
      BuildContext context, Object exception, StackTrace? stackTrace) {
    return const Text('');
  }
}

/// Строит [AppBar] с иконкой "назад" для возвращения на экран с погодой на
/// данный момент.
class MyAppBar extends StatelessWidget with PreferredSizeWidget {
  final WeatherState state;
  const MyAppBar(this.state, {super.key});

  /// Возвращает название города для [title].
  String get text {
    if (state is WeatherForecast) {
      return (state as WeatherForecast).weatherList[0].cityName;
    } else {
      return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
        title: Text(text),
        centerTitle: true,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            _buttonHandler(context, state);
          },
        ));
  }

  /// Вызывает событие [WeatherTodayOpened] при нажатии на кнопку "назад".
  void _buttonHandler(BuildContext context, WeatherState state) {
    if (state is WeatherForecast) {
      context
          .read<WeatherBloc>()
          .add(WeatherTodayOpened(weatherList: state.weatherList));
    }
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
