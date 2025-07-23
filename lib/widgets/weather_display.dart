import 'package:flutter/material.dart';
import 'package:weather_animation/weather_animation.dart';

class WeatherDisplay extends StatelessWidget {
  final String condition;
  final double temperature;
  final String cityName;

  const WeatherDisplay({
    super.key,
    required this.condition,
    required this.temperature,
    required this.cityName,
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
                '$condition | ${temperature.toStringAsFixed(1)}°C',
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
