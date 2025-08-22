import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/weather_model.dart';

class WeatherService {
  // Open-Meteo API - 100% gratuite, sans clé API
  static const String _baseUrl = 'https://api.open-meteo.com/v1';

  // Récupérer la météo complète avec Open-Meteo
  Future<WeatherResponse> getWeatherData(double lat, double lon) async {
    try {
      // Une seule requête pour toutes les données météo
      final response = await http.get(
        Uri.parse(
          '$_baseUrl/forecast?latitude=$lat&longitude=$lon&current=temperature_2m,relative_humidity_2m,apparent_temperature,wind_speed_10m,weather_code&hourly=temperature_2m,relative_humidity_2m,apparent_temperature,wind_speed_10m,weather_code&daily=weather_code,temperature_2m_max,temperature_2m_min,relative_humidity_2m_max,wind_speed_10m_max&timezone=auto&forecast_days=7',
        ),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return _parseOpenMeteoResponse(data, lat, lon);
      } else {
        throw WeatherException('Erreur API: ${response.statusCode}');
      }
    } catch (e) {
      if (e is WeatherException) rethrow;
      throw WeatherException('Erreur de connexion: $e');
    }
  }

  // Rechercher une ville par nom avec Geocoding API gratuite
  Future<LocationInfo> searchCity(String cityName) async {
    try {
      // Utilisation de l'API Geocoding gratuite de Open-Meteo
      final response = await http.get(
        Uri.parse(
          'https://geocoding-api.open-meteo.com/v1/search?name=$cityName&count=1&language=fr&format=json',
        ),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data['results'] != null && (data['results'] as List).isNotEmpty) {
          final city = data['results'][0];
          return LocationInfo(
            name: city['name'],
            country: city['country'],
            lat: city['latitude'].toDouble(),
            lon: city['longitude'].toDouble(),
          );
        } else {
          throw WeatherException('Ville non trouvée: $cityName');
        }
      } else {
        throw WeatherException('Erreur de recherche: ${response.statusCode}');
      }
    } catch (e) {
      if (e is WeatherException) rethrow;
      throw WeatherException('Erreur de connexion: $e');
    }
  }

  // Parser la réponse Open-Meteo
  WeatherResponse _parseOpenMeteoResponse(
      Map<String, dynamic> data, double lat, double lon) {
    // Météo actuelle
    final current = _parseCurrentWeather(data['current']);

    // Localisation (sera mise à jour par le provider)
    final location = LocationInfo(
      name: 'Ville',
      country: 'Pays',
      lat: lat,
      lon: lon,
    );

    // Prévisions horaires (168h = 7 jours)
    final hourly = (data['hourly'] as Map<String, dynamic>?)
            ?.let((hourlyData) => _parseHourlyWeather(hourlyData)) ??
        [];

    // Prévisions quotidiennes (7 jours)
    final daily = (data['daily'] as Map<String, dynamic>?)
            ?.let((dailyData) => _parseDailyWeather(dailyData)) ??
        [];

    return WeatherResponse(
      current: current,
      hourly: hourly,
      daily: daily,
      location: location,
    );
  }

  // Parser la météo actuelle
  WeatherData _parseCurrentWeather(Map<String, dynamic> current) {
    return WeatherData(
      temperature: current['temperature_2m']?.toDouble() ?? 0.0,
      feelsLike: current['apparent_temperature']?.toDouble() ?? 0.0,
      humidity: current['relative_humidity_2m']?.toInt() ?? 0,
      windSpeed: current['wind_speed_10m']?.toDouble() ?? 0.0,
      description: _getWeatherDescription(current['weather_code'] ?? 0),
      icon: _getWeatherIcon(current['weather_code'] ?? 0),
      timestamp: DateTime.now(),
    );
  }

  // Parser les prévisions horaires
  List<WeatherData> _parseHourlyWeather(Map<String, dynamic> hourlyData) {
    final times = hourlyData['time'] as List<dynamic>? ?? [];
    final temps = hourlyData['temperature_2m'] as List<dynamic>? ?? [];
    final feelsLike =
        hourlyData['apparent_temperature'] as List<dynamic>? ?? [];
    final humidity = hourlyData['relative_humidity_2m'] as List<dynamic>? ?? [];
    final windSpeed = hourlyData['wind_speed_10m'] as List<dynamic>? ?? [];
    final weatherCodes = hourlyData['weather_code'] as List<dynamic>? ?? [];

    final List<WeatherData> hourly = [];

    for (int i = 0; i < times.length && i < 40; i++) {
      // Limiter à 40 prévisions
      hourly.add(WeatherData(
        temperature: temps[i]?.toDouble() ?? 0.0,
        feelsLike: feelsLike[i]?.toDouble() ?? 0.0,
        humidity: humidity[i]?.toInt() ?? 0,
        windSpeed: windSpeed[i]?.toDouble() ?? 0.0,
        description: _getWeatherDescription(weatherCodes[i] ?? 0),
        icon: _getWeatherIcon(weatherCodes[i] ?? 0),
        timestamp: DateTime.parse(times[i]),
      ));
    }

    return hourly;
  }

  // Parser les prévisions quotidiennes
  List<DailyWeather> _parseDailyWeather(Map<String, dynamic> dailyData) {
    final times = dailyData['time'] as List<dynamic>? ?? [];
    final maxTemps = dailyData['temperature_2m_max'] as List<dynamic>? ?? [];
    final minTemps = dailyData['temperature_2m_min'] as List<dynamic>? ?? [];
    final humidity =
        dailyData['relative_humidity_2m_max'] as List<dynamic>? ?? [];
    final windSpeed = dailyData['wind_speed_10m_max'] as List<dynamic>? ?? [];
    final weatherCodes = dailyData['weather_code'] as List<dynamic>? ?? [];

    final List<DailyWeather> daily = [];

    for (int i = 0; i < times.length && i < 7; i++) {
      // Limiter à 7 jours
      daily.add(DailyWeather(
        date: DateTime.parse(times[i]),
        maxTemp: maxTemps[i]?.toDouble() ?? 0.0,
        minTemp: minTemps[i]?.toDouble() ?? 0.0,
        description: _getWeatherDescription(weatherCodes[i] ?? 0),
        icon: _getWeatherIcon(weatherCodes[i] ?? 0),
        humidity: humidity[i]?.toInt() ?? 0,
        windSpeed: windSpeed[i]?.toDouble() ?? 0.0,
      ));
    }

    return daily;
  }

  // Convertir les codes météo Open-Meteo en descriptions françaises
  String _getWeatherDescription(int weatherCode) {
    final descriptions = {
      0: 'Ciel dégagé',
      1: 'Peu nuageux',
      2: 'Partiellement nuageux',
      3: 'Couvert',
      45: 'Brouillard',
      48: 'Brouillard givrant',
      51: 'Bruine légère',
      53: 'Bruine modérée',
      55: 'Bruine dense',
      56: 'Bruine verglaçante légère',
      57: 'Bruine verglaçante dense',
      61: 'Pluie légère',
      63: 'Pluie modérée',
      65: 'Pluie forte',
      66: 'Pluie verglaçante légère',
      67: 'Pluie verglaçante forte',
      71: 'Neige légère',
      73: 'Neige modérée',
      75: 'Neige forte',
      77: 'Grains de neige',
      80: 'Averses légères',
      81: 'Averses modérées',
      82: 'Averses fortes',
      85: 'Averses de neige légères',
      86: 'Averses de neige fortes',
      95: 'Orage',
      96: 'Orage avec grêle légère',
      99: 'Orage avec grêle forte',
    };

    return descriptions[weatherCode] ?? 'Conditions variables';
  }

  // Convertir les codes météo en icônes
  String _getWeatherIcon(int weatherCode) {
    final icons = {
      0: '01d', // Ciel dégagé
      1: '02d', // Peu nuageux
      2: '03d', // Partiellement nuageux
      3: '04d', // Couvert
      45: '50d', // Brouillard
      48: '50d', // Brouillard givrant
      51: '09d', // Bruine
      53: '09d', // Bruine
      55: '09d', // Bruine
      56: '13d', // Bruine verglaçante
      57: '13d', // Bruine verglaçante
      61: '10d', // Pluie
      63: '10d', // Pluie
      65: '10d', // Pluie
      66: '13d', // Pluie verglaçante
      67: '13d', // Pluie verglaçante
      71: '13d', // Neige
      73: '13d', // Neige
      75: '13d', // Neige
      77: '13d', // Grains de neige
      80: '09d', // Averses
      81: '09d', // Averses
      82: '09d', // Averses
      85: '13d', // Averses de neige
      86: '13d', // Averses de neige
      95: '11d', // Orage
      96: '11d', // Orage avec grêle
      99: '11d', // Orage avec grêle
    };

    return icons[weatherCode] ?? '02d';
  }

  // Méthodes de compatibilité
  Future<WeatherResponse> getCurrentWeather(double lat, double lon) async {
    return getWeatherData(lat, lon);
  }

  Future<WeatherResponse> getForecast(double lat, double lon) async {
    return getWeatherData(lat, lon);
  }
}

// Extension pour simplifier le code
extension NullableMapExtension on Map<String, dynamic>? {
  T? let<T>(T Function(Map<String, dynamic>) block) {
    if (this != null) {
      return block(this!);
    }
    return null;
  }
}

// Classe d'exception personnalisée pour la gestion d'erreurs
class WeatherException implements Exception {
  final String message;
  WeatherException(this.message);

  @override
  String toString() => 'WeatherException: $message';
}
