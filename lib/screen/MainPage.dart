import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:weather_forecast/data/api/API_key.dart';
import 'package:http/http.dart' as http;

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  String location = 'Ho Chi Minh';
  String weatherIcon = 'heavycloud.png';

  int temperature = 0;
  int humidity = 0;
  int windSpeed = 0;
  int cloud = 0;

  String currentDate = '';

  List hourlyWeatherForcast = [];
  List dailyWeatherForcast = [];

  String currentWeatherStatus = '';

  Future<void> fetchWeatherData(String searchText) async {
    try {
      String searchWeatherAPI =
          'https://api.weatherapi.com/v1/forecast.json?key=${ApiKey.API_KEY}&q=$searchText&days=7&aqi=no&alerts=no';

      var searchResult = await http.get(Uri.parse(searchWeatherAPI));

      if (searchResult.statusCode == 200) {
        final weatherData = Map<String, dynamic>.from(
          json.decode(searchResult.body) ?? "No data");
        var locationData = weatherData['location'];
        var currentWeather = weatherData['current'];

        setState(() {
          location = getShortName(locationData['name']);

          var parsedDate = DateTime.parse(locationData['localtime'].substring(0, 10));
          var newDate = DateFormat('MMMMEEEEd').format(parsedDate);
          currentDate = newDate;

          currentWeatherStatus = currentWeather['condition']['text'];
          weatherIcon = currentWeatherStatus.replaceAll(' ', '').toLowerCase() + '.png';

          temperature = currentWeather['temp_c'].toInt();
          humidity = currentWeather['humidity'].toInt();
          windSpeed = currentWeather['wind_kph'].toInt();
          cloud = currentWeather['cloud'].toInt();

          dailyWeatherForcast = weatherData['forecast']['forecastday'];
          hourlyWeatherForcast = dailyWeatherForcast[0]['hour'];
        });
      } else {
        print("Failed to load weather data");
      }
    } catch (e) {
      print("An error occurred: $e");
    }
  }

  static String getShortName(String s) {
    List<String> wordList = s.split(" ");
    if (wordList.isNotEmpty) {
      if (wordList.length > 1) {
        return wordList[0] + " " + wordList[1] + " " + wordList[2];
      } else {
        return wordList[0];
      }
    } else {
      return " ";
    }
  }

  @override
  void initState() {
    fetchWeatherData(location);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(location),
      ),
    );
  }
}
