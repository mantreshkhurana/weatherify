import 'package:flutter/material.dart';
import 'package:weather_animation/weather_animation.dart';

class WeatherDisplay extends StatelessWidget {
  final String condition;
  final double temperature;
  final String cityName;
  final bool isCelsius;

  const WeatherDisplay({
    super.key,
    required this.condition,
    required this.temperature,
    required this.cityName,
    required this.isCelsius,
  });

  WeatherScene _getScene(String condition) {
    switch (condition.toLowerCase()) {
      case 'rain':
        return WeatherScene.rainyOvercast;
      case 'snow':
        return WeatherScene.snowfall;
      case 'clouds':
        return WeatherScene.weatherEvery;
      case 'thunderstorm':
        return WeatherScene.stormy;
      case 'clear':
      default:
        return WeatherScene.sunset;
    }
  }

  String _formatTemperature(double temp) {
    if (isCelsius) {
      return '${temp.toStringAsFixed(1)}°C';
    } else {
      final fahrenheit = (temp * 9 / 5) + 32;
      return '${fahrenheit.toStringAsFixed(1)}°F';
    }
  }

  @override
  Widget build(BuildContext context) {
    final scene = _getScene(condition);
    return Stack(
      children: [
        SizedBox.expand(child: scene.sceneWidget),
        Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                cityName,
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  shadows: [Shadow(blurRadius: 5, color: Colors.black)],
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '$condition | ${_formatTemperature(temperature)}',
                style: const TextStyle(
                  fontSize: 22,
                  color: Colors.white,
                  shadows: [Shadow(blurRadius: 5, color: Colors.black)],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
