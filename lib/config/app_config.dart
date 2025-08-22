class AppConfig {
  // Mode démo : true pour utiliser des données fictives, false pour l'API réelle
  static const bool useMockData =
      false; // Maintenant on utilise la vraie API Open-Meteo !

  // Délai de chargement simulé en mode démo (en secondes)
  static const int mockLoadingDelay = 2;

  // Villes disponibles en mode démo
  static const List<String> demoCities = [
    'Paris',
    'Londres',
    'New York',
    'Tokyo',
    'Sydney',
  ];

  // Configuration de l'interface
  static const bool enableAnimations = true;
  static const bool enablePullToRefresh = true;
  static const bool enableSearchBar = true;

  // Configuration des prévisions (Open-Meteo API)
  static const int hourlyForecastCount = 40; // Prévisions horaires sur 7 jours
  static const int dailyForecastCount = 7; // Prévisions sur 7 jours

  // Configuration des thèmes
  static const bool useGradientBackground = true;
  static const bool useGlassmorphism = true;

  // Configuration de la localisation
  static const String defaultLanguage = 'fr';
  static const String defaultCountry = 'FR';

  // Configuration de l'API Open-Meteo
  static const bool enableWeatherAlerts =
      false; // Non disponible sur Open-Meteo gratuit
  static const bool enableMinuteForecast =
      false; // Non disponible sur Open-Meteo gratuit

  // Avantages d'Open-Meteo
  static const bool noApiKeyRequired = true; // 100% gratuit, sans clé
  static const bool unlimitedRequests = true; // Aucune limite de requêtes
  static const bool highAccuracy = true; // Données météo précises
}
