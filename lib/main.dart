import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'screens/home_screen.dart';
import 'services/widget_service.dart';
import 'services/background_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: '.env');

  // Initialize widget services
  await WidgetService.initialize();
  await BackgroundService.initialize();

  // Save API key for native background worker
  final apiKey = dotenv.env['OPEN_WEATHER_API_KEY'];
  if (apiKey != null) {
    await WidgetService.saveApiKey(apiKey);
  }

  // Schedule periodic widget updates
  await BackgroundService.schedulePeriodicUpdate();

  runApp(const WeatherApp());
}

class WeatherApp extends StatelessWidget {
  const WeatherApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: HomeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
