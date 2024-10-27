import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:weather/services/model.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  TextEditingController text = TextEditingController();

  @override
  void initState() {
    super.initState();
    setState(() {
      getWeather("karachi");
    });
  }

  weatherModel? weather;
  bool isLoading = true;

  getWeather(String city) async {
    setState(() {
      isLoading = true;
    });
    String baseUrl =
        "https://api.openweathermap.org/data/2.5/weather?q=$city&appid=675556f33d7e1777e499f101eaf8310e";
    Uri url = Uri.parse(baseUrl);
    http.Response response = await http.get(url);
    if (response.statusCode == 200) {
      setState(() {
        weather = weatherModel.fromJson(jsonDecode(response.body));
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
      print("Error: ${response.statusCode}");
    }
  }

  Widget condition() {
    if (weather != null) {
      String weatherMain = weather!.weather![0].main!
          .toLowerCase(); // Get main weather condition.
      double temperature = weather!.main!.temp!; // Get temperature.

      DateTime now = DateTime.now();
      bool isNight = now.hour >= 18 || now.hour < 6;

      if (isNight && weatherMain == "clear") {
        return Padding(
          padding: const EdgeInsets.only(bottom: 210),
          child: Lottie.asset(
            'assets/animations/moon.json',
            fit: BoxFit.cover,
            repeat: true,
            reverse: false,
          ),
        );
      } else if (!isNight && weatherMain == "clear") {
        // Display clear day animation
        return Lottie.asset(
          'assets/backgrounds/cloudy.jpg',
          fit: BoxFit.cover,
          repeat: true,
          reverse: false,
        );
      } else if (!isNight && temperature > 30 && weatherMain == "clear") {
        // Display sunny day animation
        return Lottie.asset(
          'assets/backgrounds/sunny.jpeg',
          fit: BoxFit.cover,
          repeat: true,
          reverse: false,
        );
      } else if (weatherMain == "clouds") {
        // Display cloudy animation for both day and night
        return Lottie.asset(
          'assets/animations/cloudy.json',
          fit: BoxFit.cover,
          repeat: true,
          reverse: false,
        );
      } else if (weatherMain == "rain") {
        // Display rain animation for both day and night
        return Lottie.asset(
          'assets/animations/rainny.json',
          fit: BoxFit.cover,
          repeat: true,
          reverse: false,
        );
      } else if (isNight) {
        // Fallback for other conditions at night
        return Padding(
          padding: const EdgeInsets.only(bottom: 210),
          child: Lottie.asset(
            'assets/animations/moon.json',
            fit: BoxFit.cover,
            repeat: true,
            reverse: false,
          ),
        );
      } else {
        // Fallback for other conditions during the day
        return Lottie.asset(
          'assets/backgrounds/cloudy.jpg',
          fit: BoxFit.cover,
          repeat: true,
          reverse: false,
        );
      }
    }

    return Lottie.asset(
      'assets/backgrounds/cloudy.jpg',
      fit: BoxFit.cover,
      repeat: true,
      reverse: false,
    );
  }

  Widget background() {
    if (weather != null) {
      String weatherMain = weather!.weather![0].main!
          .toLowerCase(); // Get main weather condition.
      double temperature = weather!.main!.temp!; // Get temperature.

      DateTime now = DateTime.now();
      bool isNight = now.hour >= 18 || now.hour < 6;
      if (isNight && weatherMain == "smoke") {
        return Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/backgrounds/night.jpg"),
              fit: BoxFit.cover,
            ),
          ),
        );
      } else if (!isNight && weatherMain == "clear") {
        // Display clear day animation
        return Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/backgrounds/cloudy.jpg"),
              fit: BoxFit.cover,
            ),
          ),
        );
      } else if (!isNight && temperature > 30 && weatherMain == "clear") {
        // Display sunny day animation
        return Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/backgrounds/sunny.jpg"),
              fit: BoxFit.cover,
            ),
          ),
        );
      } else if (weatherMain == "clouds") {
        // Display cloudy animation for both day and night
        return Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/backgrounds/cloudy.jpg"),
              fit: BoxFit.cover,
            ),
          ),
        );
      } else if (weatherMain == "rain") {
        // Display rain animation for both day and night
        return Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/backgrounds/rainny.jpg"),
              fit: BoxFit.cover,
            ),
          ),
        );
      } else if (isNight) {
        // Fallback for other conditions at night
        Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/backgrounds/moon.jpg"),
              fit: BoxFit.cover,
            ),
          ),
        );
      } else {
        // Fallback for other conditions during the day
        return Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/backgrounds/cloudy.jpg"),
              fit: BoxFit.cover,
            ),
          ),
        );
      }
    }
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/backgrounds/cloudy.jpg"),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(children: [
          background(),
          isLoading
              ? Center(
                  child: Hero(
                  tag: "tag",
                  child: ClipOval(
                    child: SizedBox(
                      width: 80,
                      height: 80,
                      child: Image.asset(
                        'assets/backgrounds/splash.gif',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ))
              : weather!.main != null
                  ? SingleChildScrollView(
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Hero(
                                tag: "tag",
                                child: ClipOval(
                                  child: SizedBox(
                                    width: 80,
                                    height: 80,
                                    child: Image.asset(
                                      'assets/backgrounds/splash.gif',
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: TextFormField(
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                      fontSize: 20),
                                  controller: text,
                                  decoration: InputDecoration(
                                    hintText: 'Enter city name',
                                    hintStyle:
                                        const TextStyle(color: Colors.white),
                                    focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide: const BorderSide(
                                            color: Colors.white, width: 3)),
                                    enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide: BorderSide(
                                            color: Colors.grey.withOpacity(0.5),
                                            width: 2)),
                                    prefixIcon: const Icon(
                                      Icons.location_on_outlined,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    getWeather(text.text);
                                  });
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(19),
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(colors: [
                                      Colors.transparent,
                                      Colors.black.withOpacity(0.5)
                                    ]),
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  child: const Icon(
                                    Icons.search,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          _dateTime(),
                          Text(
                            " ${weather!.name}",
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            "${(weather!.main!.temp!).toStringAsFixed(0)}°C",
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 30,
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            "Feel : ${(weather!.main!.feelsLike!).toStringAsFixed(0)}°C",
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                            ),
                          ),
                          condition(),
                          Text(" ${weather!.weather![0].main}",
                              style: const TextStyle(
                                  fontSize: 18,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold)),
                          const SizedBox(
                            height: 10,
                          ),
                          Container(
                            height: MediaQuery.sizeOf(context).height * 0.15,
                            width: MediaQuery.sizeOf(context).width * 0.80,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(colors: [
                                Colors.transparent,
                                Colors.black.withOpacity(0.4)
                              ]),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Row(
                                  mainAxisSize: MainAxisSize.max,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                          "Max: ${weather!.main!.tempMax!.toStringAsFixed(0)}°C",
                                          style: const TextStyle(
                                            fontSize: 15,
                                            color: Colors.white,
                                          )),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                          "Min: ${weather!.main!.tempMax!.toStringAsFixed(0)}°C",
                                          style: const TextStyle(
                                            fontSize: 15,
                                            color: Colors.white,
                                          )),
                                    ),
                                  ],
                                ),
                                const Divider(
                                  color: Colors.white,
                                  thickness: 2.0,
                                ),
                                Row(
                                  mainAxisSize: MainAxisSize.max,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                              "wind: ${weather!.wind!.speed!.toStringAsFixed(0)}m/s",
                                              style: const TextStyle(
                                                fontSize: 15,
                                                color: Colors.white,
                                              )),
                                        ),
                                      ],
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                          "Humidity: ${weather!.main!.humidity!.toStringAsFixed(0)}%",
                                          style: const TextStyle(
                                            fontSize: 15,
                                            color: Colors.white,
                                          )),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Text(
                              "Coordinates = ${weather!.coord!.lat} - ${weather!.coord!.lon}",
                              style: const TextStyle(
                                color: Colors.white,
                              )),
                        ],
                      ),
                    )
                  : const Center(
                      child: Text("Error fetching weather data",
                          style: TextStyle(
                            color: Colors.white,
                          ))),
        ]),
      ),
    );
  }

  Widget _dateTime() {
    DateTime now = DateTime.now();
    if (weather != null && weather!.dt != null) {
      now = DateTime.fromMillisecondsSinceEpoch(weather!.dt! * 1000);
    }

    return Column(
      children: [
        Text(
          DateFormat("h:mm a").format(now),
          style: const TextStyle(
              fontSize: 30, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        const SizedBox(
          height: 10,
        ),
        Row(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              DateFormat("EEEE").format(now),
              style: const TextStyle(
                  fontWeight: FontWeight.w700, color: Colors.white),
            ),
            Text(
              "   ${DateFormat("d.M.y").format(now)}",
              style: const TextStyle(
                  fontWeight: FontWeight.w400, color: Colors.white),
            ),
          ],
        )
      ],
    );
  }
}
