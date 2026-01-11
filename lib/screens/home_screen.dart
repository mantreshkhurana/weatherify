import 'package:flutter/material.dart';
import '../services/location_service.dart';
import '../services/weather_service.dart';
import '../services/widget_service.dart';
import '../models/weather_model.dart';
import '../widgets/weather_display.dart';
import '../widgets/loading_widget.dart';
import '../core/utils.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  WeatherModel? _weather;
  bool _isLoading = true;
  bool _isCelsius = true;

  @override
  void initState() {
    super.initState();
    _loadWeather();
  }

  Future<void> _loadWeather() async {
    try {
      final position = await LocationService.getCurrentLocation();
      final weather = await WeatherService().getWeather(
        position.latitude,
        position.longitude,
      );
      setState(() {
        _weather = weather;
        _isLoading = false;
      });

      // Update home screen widget data
      await WidgetService.updateWidgetData(weather);
      await WidgetService.saveLastLocation(
        position.latitude,
        position.longitude,
      );
    } catch (e) {
      handleError(e);
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            _isLoading
                ? const LoadingWidget()
                : _weather == null
                ? const Center(
                  child: Text(
                    'Unable to load weather data.',
                    style: TextStyle(color: Colors.white),
                  ),
                )
                : WeatherDisplay(
                  condition: _weather!.condition,
                  temperature: _weather!.temperature,
                  feelsLike: _weather!.feelsLike,
                  tempMin: _weather!.tempMin,
                  tempMax: _weather!.tempMax,
                  humidity: _weather!.humidity,
                  precipitation: _weather!.precipitation,
                  windSpeed: _weather!.windSpeed,
                  sunrise: _weather!.sunrise,
                  sunset: _weather!.sunset,
                  cityName: _weather!.cityName,
                  isCelsius: _isCelsius,
                ),
            Positioned(
              right: 15,
              top: 15,
              child: Row(
                children: [
                  const Text('°C', style: TextStyle(fontSize: 16)),
                  Switch(
                    activeColor: Colors.black,
                    inactiveThumbColor: Colors.black,
                    inactiveTrackColor: Colors.grey,
                    activeTrackColor: Colors.grey,
                    value: !_isCelsius,
                    onChanged: (value) {
                      setState(() {
                        _isCelsius = !value;
                      });
                    },
                  ),
                  const Text('°F', style: TextStyle(fontSize: 16)),
                  const SizedBox(width: 15),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
