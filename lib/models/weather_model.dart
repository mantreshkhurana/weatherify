class WeatherModel {
  final String condition;
  final double temperature;
  final double feelsLike;
  final double tempMin;
  final double tempMax;
  final String cityName;

  WeatherModel({
    required this.condition,
    required this.temperature,
    required this.feelsLike,
    required this.tempMin,
    required this.tempMax,
    required this.cityName,
  });

  factory WeatherModel.fromJson(Map<String, dynamic> json) {
    return WeatherModel(
      condition: json['weather'][0]['main'],
      temperature: json['main']['temp'].toDouble(),
      feelsLike: json['main']['feels_like'].toDouble(),
      tempMin: json['main']['temp_min'].toDouble(),
      tempMax: json['main']['temp_max'].toDouble(),
      cityName: json['name'],
    );
  }

  @override
  String toString() =>
      'WeatherModel($cityName, $condition, $temperature°C, FeelsLike: $feelsLike, Min: $tempMin, Max: $tempMax)';
}
