import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather/bloc/weather_bloc.dart';
import 'package:weather/models/weather.dart';
import 'package:weather/presentation/screens/weather_forecast_screen.dart';
import 'package:weather/presentation/constants/text_styles.dart';
import 'package:weather/presentation/widgets/gap.dart';

/// Экран с погодой на данный момент.
///
/// Отображает иконку погоды, имя города, температуру, влажность
/// и скорость ветра
class WeatherTodayScreen extends StatelessWidget {
  const WeatherTodayScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<WeatherBloc, WeatherState>(
      listener: _weatherListener,
      buildWhen: _buildWhenHandler,
      builder: (context, state) {
        return Scaffold(
            appBar: const MyAppBar(),
            backgroundColor: Colors.white,
            body: _buildScaffold(context, state));
      },
    );
  }

  /// Открывает экран с прогнозом погоды, если состояние [WeatherForecast].
  /// Возвращается на начальный экран, если состояние [WeatherInitial].
  void _weatherListener(BuildContext context, WeatherState state) {
    if (state is WeatherForecast) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => const WeatherForecastScreen(),
        ),
      );
    } else if (state is WeatherInitial) {
      Navigator.pop(context);
    }
  }

  /// Вызывает перестройку только если состояние [WeatherToday].
  bool _buildWhenHandler(previousState, state) {
    return state is WeatherToday;
  }

  /// Возвращает [WeatherTodayColumn] если состояние [WeatherToday].
  /// В противном случае возвращает виджет с ошибкой.
  Widget _buildScaffold(BuildContext context, WeatherState state) {
    if (state is WeatherToday) {
      return WeatherTodayColumn(state: state);
    } else {
      return const CenterErrorMessage();
    }
  }
}

/// Строит [AppBar] с иконками "назад" для возвращения на начальный экран
/// и "вперед" для перехода к экрану с погодой на три дня.
class MyAppBar extends StatelessWidget with PreferredSizeWidget {
  const MyAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WeatherBloc, WeatherState>(
      builder: (context, state) {
        return AppBar(
          backgroundColor: Colors.white,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () {
              _buttonHandler(context, state);
            },
          ),
          actions: [
            IconButton(
                onPressed: () {
                  if (state is WeatherToday) {
                    context.read<WeatherBloc>().add(
                        WeatherForecastOpened(weatherList: state.weatherList));
                  }
                },
                icon: const Icon(Icons.arrow_forward))
          ],
        );
      },
    );
  }

  /// Вызывает событие [WeatherSearchOpened] при нажатии на кнопку
  void _buttonHandler(BuildContext context, WeatherState state) {
    context.read<WeatherBloc>().add(WeatherSearchOpened());
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

/// Строит колонну с информацией о погоде на данный момент.
///
/// Принимает [state] с List<Weather>
class WeatherTodayColumn extends StatelessWidget {
  final WeatherToday state;
  const WeatherTodayColumn({required this.state, super.key});

  @override
  Widget build(BuildContext context) {
    Weather today = state.weatherList[0];

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.network(
            today.iconUrl,
            errorBuilder: _errorBuilder,
          ),
          Text(today.cityName, style: labelText),
          const Gap(),
          InfoRow(
              icon: const Icon(Icons.thermostat),
              text: "${today.temperature}°C"),
          const Gap(),
          InfoRow(
              icon: const Icon(Icons.water_drop), text: "${today.humidity}%"),
          const Gap(),
          InfoRow(icon: const Icon(Icons.air), text: "${today.windSpeed} м/с"),
        ],
      ),
    );
  }

  /// Строит текст с пустой строкой если Image.network возвращает ошибку
  Widget _errorBuilder(
      BuildContext context, Object exception, StackTrace? stackTrace) {
    return const Text('');
  }
}

/// Строит строку с иконкой и строкой.
///
/// Принимает иконку [icon] и текст [text]
class InfoRow extends StatelessWidget {
  final Icon icon;
  final String text;
  const InfoRow({required this.icon, required this.text, super.key});

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: 0.7,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          icon,
          const Gap(),
          Text(text, style: bodyText),
        ],
      ),
    );
  }
}

/// Строит виджет с информацией об ошибке.
class CenterErrorMessage extends StatelessWidget {
  const CenterErrorMessage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('Ошибка получения данных'));
  }
}
