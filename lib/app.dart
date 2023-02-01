import 'package:flutter/material.dart';
import 'package:weather/presentation/screens/search_screen.dart';

class WeatherApp extends StatelessWidget {
  const WeatherApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData(useMaterial3: true), // включаем material 3
        home: const SearchScreen() // открываем экран поиска города
        );
  }
}
