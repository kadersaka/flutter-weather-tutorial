class ApiConfig {
  // Remplacez cette clé par votre clé API OpenWeatherMap
  // Obtenez une clé gratuite sur : https://openweathermap.org/api
  static const String openWeatherApiKey = '9df8e622e47892e0c80e03c231a26733';

  // URL de base de l'API OpenWeatherMap One Call 3.0
  static const String openWeatherBaseUrl =
      'https://api.openweathermap.org/data/3.0';

  // URL de l'API Geocoding pour la recherche de villes
  static const String geocodingApiUrl =
      'https://api.openweathermap.org/geo/1.0';

  // Limite de requêtes par jour (One Call API 3.0 : 1000 appels/jour gratuits)
  static const int rateLimitPerDay = 1000;

  // Timeout des requêtes en secondes
  static const int requestTimeout = 30;

  // Configuration de la langue (fr = français)
  static const String defaultLanguage = 'fr';

  // Configuration des unités (metric = Celsius, km/h)
  static const String defaultUnits = 'metric';
}
