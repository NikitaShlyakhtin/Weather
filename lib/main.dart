import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather/app.dart';
import 'package:weather/bloc/weather_bloc.dart';

void main() {
  // запускаем приложение, создаем WeatherBloc и передаем его дереву виджетов
  runApp(BlocProvider(
    create: (context) => WeatherBloc(),
    child: const WeatherApp(),
  ));
}
