class WeatherModel {
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

  WeatherModel({
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
  });

  factory WeatherModel.fromJson(Map<String, dynamic> json) {
    final main = json['main'];
    final sys = json['sys'];
    final weather = json['weather'][0];
    final wind = json['wind'];
    final rain = json['rain'];
    final snow = json['snow'];

    double? precipitation;
    if (rain != null && rain['1h'] != null) {
      precipitation = rain['1h'].toDouble();
    } else if (snow != null && snow['1h'] != null) {
      precipitation = snow['1h'].toDouble();
    }

    return WeatherModel(
      condition: weather['main'],
      temperature: main['temp'].toDouble(),
      feelsLike: main['feels_like'].toDouble(),
      tempMin: main['temp_min'].toDouble(),
      tempMax: main['temp_max'].toDouble(),
      humidity: main['humidity'],
      precipitation: precipitation,
      windSpeed: wind['speed'].toDouble(),
      sunrise:
          DateTime.fromMillisecondsSinceEpoch(
            sys['sunrise'] * 1000,
            isUtc: true,
          ).toLocal(),
      sunset:
          DateTime.fromMillisecondsSinceEpoch(
            sys['sunset'] * 1000,
            isUtc: true,
          ).toLocal(),
      cityName: json['name'],
    );
  }
}
