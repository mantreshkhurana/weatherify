import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:weather_animation/weather_animation.dart';

class WeatherDisplay extends StatelessWidget {
  final String condition;
  final String cityName;
  final String description;
  final double temperature;
  final double tempMax;
  final double tempMin;
  final bool isCelsius;
  final int humidity;
  final double windSpeed;
  final DateTime sunrise;
  final DateTime sunset;
  final int aqi;

  const WeatherDisplay({
    super.key,
    required this.condition,
    required this.description,
    required this.cityName,
    required this.temperature,
    required this.tempMax,
    required this.tempMin,
    required this.isCelsius,
    required this.humidity,
    required this.windSpeed,
    required this.sunrise,
    required this.sunset,
    required this.aqi,
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
    return isCelsius
        ? '${temp.toStringAsFixed(1)}°C'
        : '${((temp * 9 / 5) + 32).toStringAsFixed(1)}°F';
  }

  String _formatTime(DateTime time) {
    return DateFormat('h:mm a').format(time);
  }

  Widget _infoItem(IconData icon, String label, String value) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: Colors.white, size: 26),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(color: Colors.white70, fontSize: 12),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontSize: 14,
          ),
        ),
      ],
    );
  }

  Widget _blurredBox(Widget child) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.15),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.white.withOpacity(0.3)),
          ),
          child: child,
        ),
      ),
    );
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
                '${description.toUpperCase()} | ${_formatTemperature(temperature)}',
                style: const TextStyle(
                  fontSize: 22,
                  color: Colors.white,
                  shadows: [Shadow(blurRadius: 5, color: Colors.black)],
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'H: ${_formatTemperature(tempMax)}  |  L: ${_formatTemperature(tempMin)}',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                  shadows: [Shadow(blurRadius: 5, color: Colors.black)],
                ),
              ),
              const SizedBox(height: 20),

              // Blurry info card with rounded corners
              _blurredBox(
                Wrap(
                  spacing: 24,
                  runSpacing: 12,
                  alignment: WrapAlignment.center,
                  children: [
                    _infoItem(
                      Icons.air,
                      'Wind',
                      '${windSpeed.toStringAsFixed(1)} m/s',
                    ),
                    _infoItem(Icons.opacity, 'Humidity', '$humidity%'),
                    _infoItem(
                      Icons.wb_sunny_outlined,
                      'Sunrise',
                      _formatTime(sunrise),
                    ),
                    _infoItem(
                      Icons.nights_stay_outlined,
                      'Sunset',
                      _formatTime(sunset),
                    ),
                    _infoItem(Icons.cloud, 'AQI', '$aqi'),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
