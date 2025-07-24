import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:weather_animation/weather_animation.dart';

class WeatherDisplay extends StatelessWidget {
  final String condition;
  final double temperature;
  final double feelsLike;
  final double tempMin;
  final double tempMax;
  final int humidity;
  final double? precipitation;
  final double windSpeed;
  final DateTime sunrise;
  final DateTime sunset;
  final String cityName;
  final bool isCelsius;

  const WeatherDisplay({
    super.key,
    required this.condition,
    required this.temperature,
    required this.feelsLike,
    required this.tempMin,
    required this.tempMax,
    required this.humidity,
    required this.precipitation,
    required this.windSpeed,
    required this.sunrise,
    required this.sunset,
    required this.cityName,
    required this.isCelsius,
  });

  WeatherScene _getScene(String condition) {
    final lc = condition.toLowerCase();
    if (lc.contains('rain') || lc.contains('drizzle')) {
      return WeatherScene.rainyOvercast;
    } else if (lc.contains('snow')) {
      return WeatherScene.snowfall;
    } else if (lc.contains('cloud')) {
      return WeatherScene.weatherEvery;
    } else if (lc.contains('storm') || lc.contains('thunder')) {
      return WeatherScene.stormy;
    } else {
      return WeatherScene.sunset;
    }
  }

  String _format(double temp) {
    if (isCelsius) {
      return '${temp.toStringAsFixed(1)}°C';
    } else {
      final f = (temp * 9 / 5) + 32;
      return '${f.toStringAsFixed(1)}°F';
    }
  }

  String _formatTime(DateTime time) {
    final hour = time.hour % 12 == 0 ? 12 : time.hour % 12;
    final minute = time.minute.toString().padLeft(2, '0');
    final period = time.hour >= 12 ? 'PM' : 'AM';
    return '$hour:$minute $period';
  }

  Widget _buildGlassInfo({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          width: 100,
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.15),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.white.withOpacity(0.2)),
          ),
          child: Column(
            children: [
              Icon(icon, color: Colors.white, size: 24),
              const SizedBox(height: 6),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
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
                '$condition | ${_format(temperature)}',
                style: const TextStyle(
                  fontSize: 22,
                  color: Colors.white,
                  shadows: [Shadow(blurRadius: 5, color: Colors.black)],
                ),
              ),
              const SizedBox(height: 20),

              /// First row: Feels Like, High, Low
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildGlassInfo(
                    icon: Icons.thermostat_outlined,
                    label: 'Feels like',
                    value: _format(feelsLike),
                  ),
                  const SizedBox(width: 12),
                  _buildGlassInfo(
                    icon: Icons.arrow_upward,
                    label: 'High',
                    value: _format(tempMax),
                  ),
                  const SizedBox(width: 12),
                  _buildGlassInfo(
                    icon: Icons.arrow_downward,
                    label: 'Low',
                    value: _format(tempMin),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              /// Second row: Humidity, Precip, Wind
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildGlassInfo(
                    icon: Icons.water_drop,
                    label: 'Humidity',
                    value: '$humidity%',
                  ),
                  const SizedBox(width: 12),
                  _buildGlassInfo(
                    icon: Icons.water_drop_rounded,
                    label: 'Rain',
                    value:
                        precipitation != null
                            ? '${precipitation!.toStringAsFixed(1)} mm'
                            : '0 mm',
                  ),
                  const SizedBox(width: 12),
                  _buildGlassInfo(
                    icon: Icons.air,
                    label: 'Wind',
                    value: '${windSpeed.toStringAsFixed(1)} m/s',
                  ),
                ],
              ),

              const SizedBox(height: 12),

              /// Third row: Sunrise, Sunset
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildGlassInfo(
                    icon: Icons.wb_sunny_outlined,
                    label: 'Sunrise',
                    value: _formatTime(sunrise),
                  ),
                  const SizedBox(width: 12),
                  _buildGlassInfo(
                    icon: Icons.nightlight_round,
                    label: 'Sunset',
                    value: _formatTime(sunset),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
