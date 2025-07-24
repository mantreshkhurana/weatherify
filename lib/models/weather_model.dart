class WeatherModel {
  final String condition;
  final double temperature;
  final String cityName;

  WeatherModel({
    required this.condition,
    required this.temperature,
    required this.cityName,
  });

  factory WeatherModel.fromJson(Map<String, dynamic> json) {
    return WeatherModel(
      condition: json['weather'][0]['main'],
      temperature: json['main']['temp'].toDouble(),
      cityName: json['name'], // <- City name from API
    );
  }
}
