import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather/bloc/weather_bloc.dart';
import 'package:weather/models/weather.dart';
import 'package:weather/presentation/screens/three_day_weather_screen.dart';
import 'package:weather/presentation/constants/text_styles.dart';
import 'package:weather/presentation/widgets/gap.dart';

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

  void _weatherListener(BuildContext context, WeatherState state) {
    if (state is WeatherForecast) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => const ThreeDayWeatherScreen(),
        ),
      );
    } else if (state is WeatherInitial) {
      Navigator.pop(context);
    }
  }

  bool _buildWhenHandler(previousState, state) {
    return state is WeatherToday;
  }

  Widget _buildScaffold(BuildContext context, WeatherState state) {
    if (state is WeatherToday) {
      return WeatherTodayColumn(state: state);
    } else {
      return const CenterErrorMessage();
    }
  }
}

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

  void _buttonHandler(BuildContext context, WeatherState state) {
    context.read<WeatherBloc>().add(WeatherSearchOpened());
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

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
          Gap(),
          InfoRow(
              icon: const Icon(Icons.thermostat),
              text: "${today.temperature}°C"),
          Gap(),
          InfoRow(
              icon: const Icon(Icons.water_drop), text: "${today.humidity}%"),
          Gap(),
          InfoRow(icon: const Icon(Icons.air), text: "${today.windSpeed} м/с"),
        ],
      ),
    );
  }

  Widget _errorBuilder(
      BuildContext context, Object exception, StackTrace? stackTrace) {
    return const Text('');
  }
}

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
          Gap(),
          Text(text, style: bodyText),
        ],
      ),
    );
  }
}

class CenterErrorMessage extends StatelessWidget {
  const CenterErrorMessage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('Ошибка получения данных'));
  }
}
