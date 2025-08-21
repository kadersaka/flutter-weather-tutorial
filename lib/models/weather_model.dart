class WeatherResponse {
  final WeatherData current;
  final List<WeatherData> hourly;
  final List<DailyWeather> daily;
  final LocationInfo location;

  WeatherResponse({
    required this.current,
    required this.hourly,
    required this.daily,
    required this.location,
  });

  factory WeatherResponse.fromJson(Map<String, dynamic> json) {
    return WeatherResponse(
      current: WeatherData.fromJson(json['current'] ?? {}),
      hourly: (json['hourly'] as List<dynamic>?)
              ?.map((item) => WeatherData.fromJson(item))
              .toList() ??
          [],
      daily: (json['daily'] as List<dynamic>?)
              ?.map((item) => DailyWeather.fromJson(item))
              .toList() ??
          [],
      location: LocationInfo.fromJson(json['location'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'current': current.toJson(),
      'hourly': hourly.map((item) => item.toJson()).toList(),
      'daily': daily.map((item) => item.toJson()).toList(),
      'location': location.toJson(),
    };
  }
}

class WeatherData {
  final double temperature;
  final double feelsLike;
  final int humidity;
  final double windSpeed;
  final String description;
  final String icon;
  final DateTime timestamp;

  WeatherData({
    required this.temperature,
    required this.feelsLike,
    required this.humidity,
    required this.windSpeed,
    required this.description,
    required this.icon,
    required this.timestamp,
  });

  factory WeatherData.fromJson(Map<String, dynamic> json) {
    return WeatherData(
      temperature: (json['temperature'] ?? json['temp'] ?? 0.0).toDouble(),
      feelsLike: (json['feelsLike'] ?? json['feels_like'] ?? 0.0).toDouble(),
      humidity: json['humidity'] ?? 0,
      windSpeed:
          (json['windSpeed'] ?? json['wind']?['speed'] ?? 0.0).toDouble(),
      description:
          json['description'] ?? json['weather']?[0]?['description'] ?? '',
      icon: json['icon'] ?? json['weather']?[0]?['icon'] ?? '',
      timestamp: json['timestamp'] != null
          ? DateTime.parse(json['timestamp'])
          : json['dt'] != null
              ? DateTime.fromMillisecondsSinceEpoch(json['dt'] * 1000)
              : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'temperature': temperature,
      'feelsLike': feelsLike,
      'humidity': humidity,
      'windSpeed': windSpeed,
      'description': description,
      'icon': icon,
      'timestamp': timestamp.toIso8601String(),
    };
  }
}

class DailyWeather {
  final DateTime date;
  final double maxTemp;
  final double minTemp;
  final String description;
  final String icon;
  final int humidity;
  final double windSpeed;

  DailyWeather({
    required this.date,
    required this.maxTemp,
    required this.minTemp,
    required this.description,
    required this.icon,
    required this.humidity,
    required this.windSpeed,
  });

  factory DailyWeather.fromJson(Map<String, dynamic> json) {
    return DailyWeather(
      date: json['date'] != null
          ? DateTime.parse(json['date'])
          : json['dt'] != null
              ? DateTime.fromMillisecondsSinceEpoch(json['dt'] * 1000)
              : DateTime.now(),
      maxTemp: (json['maxTemp'] ?? json['temp']?['max'] ?? 0.0).toDouble(),
      minTemp: (json['minTemp'] ?? json['temp']?['min'] ?? 0.0).toDouble(),
      description:
          json['description'] ?? json['weather']?[0]?['description'] ?? '',
      icon: json['icon'] ?? json['weather']?[0]?['icon'] ?? '',
      humidity: json['humidity'] ?? 0,
      windSpeed:
          (json['windSpeed'] ?? json['wind']?['speed'] ?? 0.0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'date': date.toIso8601String(),
      'maxTemp': maxTemp,
      'minTemp': minTemp,
      'description': description,
      'icon': icon,
      'humidity': humidity,
      'windSpeed': windSpeed,
    };
  }
}

class LocationInfo {
  String name;
  String country;
  final double lat;
  final double lon;

  LocationInfo({
    required this.name,
    required this.country,
    required this.lat,
    required this.lon,
  });

  factory LocationInfo.fromJson(Map<String, dynamic> json) {
    return LocationInfo(
      name: json['name'] ?? '',
      country: json['country'] ?? json['sys']?['country'] ?? '',
      lat: (json['lat'] ?? json['coord']?['lat'] ?? 0.0).toDouble(),
      lon: (json['lon'] ?? json['coord']?['lon'] ?? 0.0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'country': country,
      'lat': lat,
      'lon': lon,
    };
  }
}
