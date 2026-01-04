import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:weather_forecast/data/api/API_key.dart';
import 'package:http/http.dart' as http;
import 'package:weather_forecast/data/models/Constants.dart';
import 'package:weather_forecast/widgets/WeatherItem.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  TextEditingController _cityController = TextEditingController();
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
          json.decode(searchResult.body) ?? "No data",
        );
        var locationData = weatherData['location'];
        var currentWeather = weatherData['current'];

        setState(() {
          location = getShortName(locationData['name']);

          var parsedDate = DateTime.parse(
            locationData['localtime'].substring(0, 10),
          );
          var newDate = DateFormat('MMMMEEEEd').format(parsedDate);
          currentDate = newDate;

          currentWeatherStatus = currentWeather['condition']['text'];
          weatherIcon =
              currentWeatherStatus.replaceAll(' ', '').toLowerCase() + '.png';

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
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.manual,
      overlays: SystemUiOverlay.values,
    );
    Size size = MediaQuery.of(context).size;
    Constants _constant = Constants();

    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        height: size.height,
        width: size.width,
        color: _constant.primaryColor.withOpacity(.1),
        padding: EdgeInsets.only(top: 70, left: 10, right: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              height: size.height * .7,
              decoration: BoxDecoration(
                gradient: _constant.linearGradientBlue.withOpacity(.5),
                boxShadow: [
                  BoxShadow(
                    color: _constant.primaryColor.withOpacity(.5),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: const Offset(0, 3),
                  ),
                ],
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.asset("assets/menu.png", width: 40, height: 40),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Image.asset("assets/pin.png", width: 20),
                          SizedBox(width: 2),
                          Text(
                            location,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16.0,
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              _cityController.clear();
                              showMaterialModalBottomSheet(
                                context: context,
                                builder: (context) => SingleChildScrollView(
                                  controller: ModalScrollController.of(context),
                                  child: Container(
                                    height: size.height * .2,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 20,
                                      vertical: 10,
                                    ),
                                    child: Column(
                                      children: [
                                        SizedBox(
                                          width: 70,
                                          child: Divider(
                                            thickness: 3.5,
                                            color: _constant.primaryColor,
                                          ),
                                        ),
                                        const SizedBox(height: 10),
                                        TextField(
                                          onChanged: (searchText) {
                                            fetchWeatherData(searchText);
                                          },
                                          controller: _cityController,
                                          autofocus: true,
                                          decoration: InputDecoration(
                                            prefixIcon: Icon(
                                              Icons.search,
                                              color: _constant.primaryColor,
                                            ),
                                            suffixIcon: GestureDetector(
                                              onTap: () =>
                                                  _cityController.clear(),
                                              child: Icon(
                                                Icons.close,
                                                color: _constant.primaryColor,
                                              ),
                                            ),
                                            hintText: 'Search city e.g. London',
                                            focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                color: _constant.primaryColor,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                            icon: const Icon(
                              Icons.keyboard_arrow_down,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.asset(
                          "assets/profile.png",
                          width: 40,
                          height: 40,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    height: 160,
                    child: Image.asset("assets/" + weatherIcon),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(
                          temperature.toString(),
                          style: TextStyle(
                            fontSize: 80,
                            fontWeight: FontWeight.bold,
                            foreground: Paint()..shader = _constant.shader,
                          ),
                        ),
                      ),
                      Text(
                        'o',
                        style: TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                          foreground: Paint()..shader = _constant.shader,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    currentWeatherStatus,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 30.0,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    currentDate,
                    style: const TextStyle(color: Colors.white70, fontSize: 20),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: const Divider(color: Colors.white70),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        WeatherItem(
                          value: windSpeed.toInt(),
                          unit: 'km/h',
                          imageUrl: 'assets/windspeed.png',
                        ),
                        WeatherItem(
                          value: humidity.toInt(),
                          unit: '%',
                          imageUrl: 'assets/humidity.png',
                        ),
                        WeatherItem(
                          value: cloud.toInt(),
                          unit: '%',
                          imageUrl: 'assets/cloud.png',
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.only(top: 10),
              height: size.height * .2,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Today',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20.0,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {},
                        child: Text(
                          'Forecasts',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                            color: _constant.primaryColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    height: 110,
                    child: ListView.builder(
                      itemCount: hourlyWeatherForcast.length,
                      scrollDirection: Axis.horizontal,
                      physics: const BouncingScrollPhysics(),
                      itemBuilder: (context, index) {

                        DateTime forecastDateTime =
                        DateTime.parse(hourlyWeatherForcast[index]['time']);

                        String currentHour = DateFormat('HH').format(DateTime.now());
                        String forecastHour = DateFormat('HH').format(forecastDateTime);

                        String forecastTimeDisplay = DateFormat('HH:mm').format(forecastDateTime);

                        String forecastWeatherName =
                        hourlyWeatherForcast[index]['condition']['text'];
                        String forecastWeatherIcon =
                            forecastWeatherName.replaceAll(' ', '').toLowerCase() + ".png";
                        String forecastTemperature =
                        hourlyWeatherForcast[index]['temp_c'].round().toString();


                        return Container(
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          margin: const EdgeInsets.only(right: 20),
                          width: 65,
                          decoration: BoxDecoration(
                            color: currentHour == forecastHour
                                ? Colors.white
                                : _constant.primaryColor,
                            borderRadius: const BorderRadius.all(
                              Radius.circular(50),
                            ),
                            boxShadow: [
                              BoxShadow(
                                offset: const Offset(0, 1),
                                blurRadius: 5,
                                color: _constant.primaryColor.withOpacity(.2),
                              ),
                            ],
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                forecastTimeDisplay,
                                style: TextStyle(
                                  fontSize: 17,
                                  color: _constant.greyColor,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Image.asset(
                                'assets/' + forecastWeatherIcon,
                                width: 20,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(top: 8.0),
                                    child: Text(
                                      forecastTemperature,
                                      style: TextStyle(
                                        color: _constant.greyColor,
                                        fontSize: 17,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    'o',
                                    style: TextStyle(
                                      color: _constant.greyColor,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 17,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
