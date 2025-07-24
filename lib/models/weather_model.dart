class WeatherModel {
  final String condition;
  final String description;
  final double temperature;
  final String cityName;
  final double tempMin;
  final double tempMax;
  final int humidity;
  final double windSpeed;
  final DateTime sunrise;
  final DateTime sunset;
  final int aqi;

  WeatherModel({
    required this.condition,
    required this.description,
    required this.temperature,
    required this.cityName,
    required this.tempMin,
    required this.tempMax,
    required this.humidity,
    required this.windSpeed,
    required this.sunrise,
    required this.sunset,
    required this.aqi,
  });

  factory WeatherModel.fromJson(
    Map<String, dynamic> json,
    Map<String, dynamic> aqiJson,
  ) {
    return WeatherModel(
      condition: json['weather'][0]['main'],
      description: json['weather'][0]['description'],
      temperature: json['main']['temp'].toDouble(),
      cityName: json['name'],
      tempMin: json['main']['temp_min'].toDouble(),
      tempMax: json['main']['temp_max'].toDouble(),
      humidity: json['main']['humidity'],
      windSpeed: json['wind']['speed'].toDouble(),
      sunrise:
          DateTime.fromMillisecondsSinceEpoch(
            json['sys']['sunrise'] * 1000,
            isUtc: true,
          ).toLocal(),
      sunset:
          DateTime.fromMillisecondsSinceEpoch(
            json['sys']['sunset'] * 1000,
            isUtc: true,
          ).toLocal(),
      aqi: aqiJson['list'][0]['main']['aqi'],
    );
  }
}
