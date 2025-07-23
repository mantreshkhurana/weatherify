import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/weather_model.dart';
import '../core/constants.dart';

class WeatherService {
  Future<WeatherModel> getWeather(double lat, double lon) async {
    final apiKey = dotenv.env['OPEN_WEATHER_API_KEY'];
    final url = Uri.parse(
      '$baseUrl?lat=$lat&lon=$lon&units=metric&appid=$apiKey',
    );

    final response = await http.get(url);
    if (response.statusCode != 200) {
      throw Exception('Failed to load weather');
    }

    final jsonData = json.decode(response.body);
    return WeatherModel.fromJson(jsonData);
  }
}
