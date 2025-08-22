import 'package:flutter/material.dart';
import '../models/weather_model.dart';
import '../services/weather_service.dart';
import '../services/mock_weather_service.dart';
import '../config/app_config.dart';

enum WeatherState { initial, loading, loaded, error }

class WeatherProvider extends ChangeNotifier {
  final WeatherService _weatherService = WeatherService();

  WeatherState _state = WeatherState.initial;
  WeatherResponse? _weatherData;
  String? _errorMessage;
  String _currentCity = 'Paris'; // Ville par défaut

  // Getters
  WeatherState get state => _state;
  WeatherResponse? get weatherData => _weatherData;
  String? get errorMessage => _errorMessage;
  bool get isLoading => _state == WeatherState.loading;
  bool get hasData => _weatherData != null;
  bool get hasError => _state == WeatherState.error;
  String get currentCity => _currentCity;

  // Initialiser avec la météo de la ville par défaut
  Future<void> initialize() async {
    if (AppConfig.useMockData) {
      await loadDemoData();
    } else {
      await fetchWeatherByCity(_currentCity);
    }
  }

  // Récupérer la météo par nom de ville
  Future<void> fetchWeatherByCity(String cityName) async {
    try {
      _setState(WeatherState.loading);
      _currentCity = cityName;

      // Rechercher d'abord les coordonnées de la ville
      final location = await _weatherService.searchCity(cityName);

      // Récupérer la météo complète avec Open-Meteo
      final weatherData =
          await _weatherService.getWeatherData(location.lat, location.lon);

      // Mettre à jour les informations de localisation
      weatherData.location.name = location.name;
      weatherData.location.country = location.country;

      _weatherData = weatherData;
      _setState(WeatherState.loaded);
    } catch (e) {
      _setError(e.toString());
    }
  }

  // Récupérer la météo par coordonnées GPS
  Future<void> fetchWeatherByLocation(double lat, double lon) async {
    try {
      _setState(WeatherState.loading);

      final weatherData = await _weatherService.getWeatherData(lat, lon);
      _weatherData = weatherData;
      _currentCity = weatherData.location.name;
      _setState(WeatherState.loaded);
    } catch (e) {
      _setError(e.toString());
    }
  }

  // Charger des données de démonstration
  Future<void> loadDemoData() async {
    if (AppConfig.useMockData) {
      _setState(WeatherState.loading);

      // Simuler un délai de chargement
      await Future.delayed(Duration(seconds: AppConfig.mockLoadingDelay));

      // Utiliser le service mock
      final weatherData = MockWeatherService.getMockWeatherData();

      _weatherData = weatherData;
      _setState(WeatherState.loaded);
    }
  }

  // Changer de ville
  Future<void> changeCity(String cityName) async {
    await fetchWeatherByCity(cityName);
  }

  // Actualiser les données météo
  Future<void> refreshWeather() async {
    if (_weatherData != null) {
      await fetchWeatherByLocation(
        _weatherData!.location.lat,
        _weatherData!.location.lon,
      );
    }
  }

  // Réinitialiser l'état d'erreur
  void clearError() {
    _errorMessage = null;
    _setState(WeatherState.initial);
  }

  // Méthodes privées
  void _setState(WeatherState newState) {
    _state = newState;
    _errorMessage = null;
    notifyListeners();
  }

  void _setError(String error) {
    _state = WeatherState.error;
    _errorMessage = error;
    notifyListeners();
  }

  // Réinitialiser l'état
  void reset() {
    _weatherData = null;
    _state = WeatherState.initial;
    _errorMessage = null;
    notifyListeners();
  }

  // Obtenir la ville actuelle
  String get currentLocation {
    if (_weatherData == null) return _currentCity;
    return '${_weatherData!.location.name}, ${_weatherData!.location.country}';
  }

  // Obtenir les prévisions horaires (40 prévisions sur 7 jours)
  List<WeatherData> get hourlyForecast {
    if (_weatherData == null) return [];
    return _weatherData!.hourly.take(40).toList(); // Prévisions sur 7 jours
  }

  // Obtenir les prévisions quotidiennes (7 jours)
  List<DailyWeather> get dailyForecast {
    if (_weatherData == null) return [];
    return _weatherData!.daily.take(7).toList(); // Prochains 7 jours
  }
}
