import 'package:workmanager/workmanager.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'widget_service.dart';
import 'weather_service.dart';
import 'location_service.dart';

const String weatherUpdateTask = 'com.mantresh.weatherify.weatherUpdate';

@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    try {
      await dotenv.load(fileName: '.env');

      final position = await LocationService.getCurrentLocation();
      final weather = await WeatherService().getWeather(
        position.latitude,
        position.longitude,
      );

      await WidgetService.updateWidgetData(weather);
      await WidgetService.saveLastLocation(
          position.latitude, position.longitude);

      return true;
    } catch (e) {
      print('Background task error: $e');
      return false;
    }
  });
}

class BackgroundService {
  static Future<void> initialize() async {
    await Workmanager().initialize(
      callbackDispatcher,
      isInDebugMode: false,
    );
  }

  static Future<void> schedulePeriodicUpdate() async {
    await Workmanager().registerPeriodicTask(
      'weatherWidgetUpdate',
      weatherUpdateTask,
      frequency: const Duration(minutes: 30),
      constraints: Constraints(
        networkType: NetworkType.connected,
      ),
      existingWorkPolicy: ExistingPeriodicWorkPolicy.keep,
    );
  }

  static Future<void> triggerImmediateUpdate() async {
    await Workmanager().registerOneOffTask(
      'weatherWidgetImmediateUpdate',
      weatherUpdateTask,
      constraints: Constraints(
        networkType: NetworkType.connected,
      ),
    );
  }
}
