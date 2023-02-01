import 'dart:convert';

import 'package:weather/models/location.dart';
import 'package:weather/models/weather.dart';
import 'package:dio/dio.dart';

class WeatherService {
  static const String _apiKey = '27b98e589c3adfcfb4caa7a09ec94175';

  static Future<Location> getLocation(String city) async {
    var geocodingUrl =
        'http://api.openweathermap.org/geo/1.0/direct?q=$city&appid=$_apiKey';
    var response = await Dio().get(geocodingUrl);

    if (response.statusCode == 200) {
      var data = response.data[0];
      double lat = data['lat'];
      double lon = data['lon'];
      return Location(lat: lat, lon: lon);
    } else {
      throw Exception('Ошибка получения локации');
    }
  }

  static Future<List<Weather>> getWeather(String city) async {
    Location location = await getLocation(city);
    double lat = location.lat;
    double lon = location.lon;

    var weatherUrl =
        'http://api.openweathermap.org/data/2.5/forecast?units=metric&lat=$lat&lon=$lon&appid=$_apiKey';

    var response = await Dio().get(weatherUrl);

    if (response.statusCode == 200) {
      var data = response.data['list'];
      List<Weather> weatherList = [];
      for (int i = 0; i < 3; i++) {
        var day = data[i * 8];
        int temperature = day['main']['temp'].toInt();
        int humidity = day['main']['humidity'].toInt();
        int windSpeed = day['wind']['speed'].toInt();
        String iconId = day['weather'][0]['icon'];
        String iconUrl = 'https://openweathermap.org/img/wn/$iconId@2x.png';
        String smallIconUrl = 'https://openweathermap.org/img/wn/$iconId.png';
        DateTime date = DateTime.now().add(Duration(days: i));
        weatherList.add(Weather(
            cityName: city,
            temperature: temperature,
            humidity: humidity,
            windSpeed: windSpeed,
            iconUrl: iconUrl,
            smallIconUrl: smallIconUrl,
            date: date));
      }

      return weatherList;
    } else {
      throw Exception('Ошибка получения данных о погоде');
    }
  }
}
