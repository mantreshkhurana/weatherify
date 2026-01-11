import 'package:home_widget/home_widget.dart';
import 'package:intl/intl.dart';
import '../models/weather_model.dart';

class WidgetService {
  static const String appGroupId = 'com.mantresh.weatherify';

  /// Initialize home_widget
  static Future<void> initialize() async {
    await HomeWidget.setAppGroupId(appGroupId);
  }

  /// Update widget data from weather model
  static Future<void> updateWidgetData(WeatherModel weather) async {
    final timeFormat = DateFormat('h:mm a');
    final lastUpdate = timeFormat.format(DateTime.now());

    // Save all weather data to SharedPreferences
    await Future.wait([
      HomeWidget.saveWidgetData<String>(
          'temperature', '${weather.temperature.toInt()}°'),
      HomeWidget.saveWidgetData<String>(
          'feels_like', '${weather.feelsLike.toInt()}°'),
      HomeWidget.saveWidgetData<String>(
          'temp_min', '${weather.tempMin.toInt()}°'),
      HomeWidget.saveWidgetData<String>(
          'temp_max', '${weather.tempMax.toInt()}°'),
      HomeWidget.saveWidgetData<String>('humidity', weather.humidity.toString()),
      HomeWidget.saveWidgetData<String>('condition', weather.condition),
      HomeWidget.saveWidgetData<String>('city_name', weather.cityName),
      HomeWidget.saveWidgetData<String>('last_update', 'Updated $lastUpdate'),
    ]);

    // Trigger widget update for both widget types
    await HomeWidget.updateWidget(
      androidName: 'SmallWeatherWidget',
      qualifiedAndroidName: 'com.mantresh.weatherify.widget.SmallWeatherWidget',
    );
    await HomeWidget.updateWidget(
      androidName: 'MediumWeatherWidget',
      qualifiedAndroidName:
          'com.mantresh.weatherify.widget.MediumWeatherWidget',
    );
  }

  /// Save API key for native background worker
  static Future<void> saveApiKey(String apiKey) async {
    await HomeWidget.saveWidgetData<String>('api_key', apiKey);
  }

  /// Save last known location for background worker fallback
  static Future<void> saveLastLocation(double lat, double lon) async {
    await HomeWidget.saveWidgetData<double>('last_lat', lat);
    await HomeWidget.saveWidgetData<double>('last_lon', lon);
  }
}
