import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather/bloc/weather_bloc.dart';
import 'package:weather/models/weather.dart';
import 'package:weather/presentation/constants/text_styles.dart';
import 'package:weather/presentation/widgets/gap.dart';

class ThreeDayWeatherScreen extends StatelessWidget {
  const ThreeDayWeatherScreen({super.key});

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

  void _weatherListener(BuildContext context, WeatherState state) {
    if (state is WeatherToday) {
      Navigator.pop(context);
    }
  }

  Widget _buildScaffold(WeatherState state) {
    return Column(
      children: _weatherForecast(state),
    );
  }

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
            Gap(),
            Text(
              '${weather.temperature}°',
              style: bodyText,
            ),
          ]),
        )
      ],
    );
  }

  Widget _errorBuilder(
      BuildContext context, Object exception, StackTrace? stackTrace) {
    return const Text('');
  }
}

class MyAppBar extends StatelessWidget with PreferredSizeWidget {
  final WeatherState state;
  const MyAppBar(this.state, {super.key});

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
