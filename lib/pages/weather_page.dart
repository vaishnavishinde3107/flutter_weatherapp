import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:weatherapp/models/weather_model.dart';
import 'package:weatherapp/services/weather_service.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  //api key
  final _weatherServices = WeatherService(apiKey: '23f7fd439598ab3e646f7069f4e09b68');
  Weather? _weather;

  //fetch weather
  _fetchWeather() async {
    //get the current city
    String cityName = await _weatherServices.getCurrentCity();

    //get weather for city
    try{
      final weather = await _weatherServices.getWeather(cityName);
      setState(() {
        _weather = weather;
      });
    }
    catch(e){
      print (e);
    }
  }

  //weather animation
  String getWeatherAnimation(String? mainCondition){
    if (mainCondition == null) {
      return 'assets/sunny.json'; //default set to sunny
    }
    

    switch (mainCondition.toLowerCase()) {
      case 'clouds':
      case 'mist':
      case 'smoke':
      case 'haze':
      case 'dust':
      case 'fog':
      return 'assets/cloudy.json';
      case 'rain':
      case 'drizzle':
      case 'shower rain':  
      return 'assets/rainy.json';
      case 'thunderstorm': 
      return 'assets/thunder-rain.json';
      case 'clear': 
      return 'assets/sunny.json'; 
      case 'winter': 
      return 'assets/winter.json'; 
      default: 
        return'assets/sunny.json';
    }
  }

  @override
  void initState() {
    super.initState();
    
    //fetch weather on startup
    _fetchWeather();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 43, 43, 43),
      body: Center(
        child: Column(

          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            //city name
            const Icon(Icons.location_on,
            color: Colors.white,),
            Text(_weather?.cityName ?? "loading city...",
            style: const TextStyle(
              fontSize: 18, 
              fontWeight: FontWeight.bold,
              color: Color.fromARGB(255, 255, 230, 0),
            ),),

            //animation
            Lottie.asset(getWeatherAnimation(_weather?.mainCondition)),
        
            //temperature
            Text('${_weather?.temperature.round()}°C',
            style: const TextStyle(
              fontSize: 18, 
              color: Colors.white,
            ),),

            //weather condition
            Text(_weather?.mainCondition ?? "",
            style: const TextStyle(
              fontSize: 18, 
              color: Colors.white,
            ),),
          ],
        ),
      ),
    );
  }
}