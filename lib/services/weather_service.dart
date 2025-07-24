import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/weather_model.dart';
import '../core/constants.dart';

class WeatherService {
  Future<WeatherModel> getWeather(double lat, double lon) async {
    final apiKey =
        kIsWeb
            ? "ef719e15621dacfbf900726c3c8ec6b0"
            : dotenv.env['OPEN_WEATHER_API_KEY'];

    final weatherUrl = Uri.parse(
      '$baseUrl/weather?lat=$lat&lon=$lon&units=metric&appid=$apiKey',
    );

    final aqiUrl = Uri.parse(
      '$baseUrl/air_pollution?lat=$lat&lon=$lon&appid=$apiKey',
    );

    final weatherResponse = await http.get(weatherUrl);
    final aqiResponse = await http.get(aqiUrl);

    if (weatherResponse.statusCode != 200) {
      throw Exception('Failed to load weather data');
    }

    if (aqiResponse.statusCode != 200) {
      throw Exception('Failed to load AQI data');
    }

    final weatherJson = json.decode(weatherResponse.body);
    final aqiJson = json.decode(aqiResponse.body);

    return WeatherModel.fromJson(weatherJson, aqiJson);
  }
}
