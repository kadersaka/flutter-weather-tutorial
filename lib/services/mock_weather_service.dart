import '../models/weather_model.dart';

class MockWeatherService {
  // Données fictives pour la démonstration
  static WeatherResponse getMockWeatherData() {
    final now = DateTime.now();

    // Météo actuelle
    final current = WeatherData(
      temperature: 22.5,
      feelsLike: 24.0,
      humidity: 65,
      windSpeed: 12.0,
      description: 'Nuageux avec éclaircies',
      icon: '02d',
      timestamp: now,
    );

    // Localisation
    final location = LocationInfo(
      name: 'Paris',
      country: 'FR',
      lat: 48.8566,
      lon: 2.3522,
    );

    // Prévisions horaires (prochaines 24h)
    final hourly = List.generate(24, (index) {
      final hour = now.add(Duration(hours: index));
      return WeatherData(
        temperature: 20.0 + (index % 5) - 2.0, // Variation de température
        feelsLike: 20.0 + (index % 5) - 1.0,
        humidity: 60 + (index % 20),
        windSpeed: 10.0 + (index % 8),
        description: index < 6
            ? 'Nuit claire'
            : index < 12
                ? 'Matin ensoleillé'
                : index < 18
                    ? 'Après-midi nuageux'
                    : 'Soirée calme',
        icon: index < 6
            ? '01n'
            : index < 12
                ? '01d'
                : index < 18
                    ? '03d'
                    : '01n',
        timestamp: hour,
      );
    });

    // Prévisions quotidiennes (7 jours)
    final daily = List.generate(7, (index) {
      final day = now.add(Duration(days: index));
      return DailyWeather(
        date: day,
        maxTemp: 25.0 + (index % 3),
        minTemp: 15.0 + (index % 2),
        description: [
          'Ensoleillé',
          'Nuageux',
          'Pluvieux',
          'Orageux',
          'Venteux'
        ][index % 5],
        icon: ['01d', '03d', '10d', '11d', '50d'][index % 5],
        humidity: 60 + (index % 20),
        windSpeed: 8.0 + (index % 10),
      );
    });

    return WeatherResponse(
      current: current,
      hourly: hourly,
      daily: daily,
      location: location,
    );
  }

  // Simuler un délai de chargement
  static Future<WeatherResponse> getMockWeatherDataAsync() async {
    await Future.delayed(const Duration(seconds: 2)); // Simuler le délai réseau
    return getMockWeatherData();
  }

  // Simuler une recherche de ville
  static Future<LocationInfo> searchMockCity(String cityName) async {
    await Future.delayed(const Duration(milliseconds: 500));

    final cities = {
      'paris':
          LocationInfo(name: 'Paris', country: 'FR', lat: 48.8566, lon: 2.3522),
      'london': LocationInfo(
          name: 'Londres', country: 'GB', lat: 51.5074, lon: -0.1278),
      'new york': LocationInfo(
          name: 'New York', country: 'US', lat: 40.7128, lon: -74.0060),
      'tokyo': LocationInfo(
          name: 'Tokyo', country: 'JP', lat: 35.6762, lon: 139.6503),
      'sydney': LocationInfo(
          name: 'Sydney', country: 'AU', lat: -33.8688, lon: 151.2093),
    };

    final city = cities[cityName.toLowerCase()];
    if (city != null) {
      return city;
    } else {
      throw Exception('Ville non trouvée: $cityName');
    }
  }
}
