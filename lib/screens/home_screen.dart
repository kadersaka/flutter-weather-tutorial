import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/weather_provider.dart';
import '../widgets/weather_card.dart';
import '../widgets/hourly_forecast.dart';
import '../widgets/daily_forecast.dart';
import '../widgets/search_bar.dart';
import '../widgets/error_widget.dart';
import '../widgets/loading_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    // Initialiser la météo au démarrage
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<WeatherProvider>().initialize();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<WeatherProvider>(
        builder: (context, weatherProvider, child) {
          return _buildBody(weatherProvider);
        },
      ),
    );
  }

  Widget _buildBody(WeatherProvider weatherProvider) {
    switch (weatherProvider.state) {
      case WeatherState.initial:
        return _buildInitialState();
      case WeatherState.loading:
        return const LoadingWidget();
      case WeatherState.loaded:
        return _buildLoadedState(weatherProvider);
      case WeatherState.error:
        return WeatherErrorWidget(
          message: weatherProvider.errorMessage ?? 'Une erreur est survenue',
          onRetry: () => weatherProvider.initialize(),
        );
    }
  }

  Widget _buildInitialState() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFF1E3A8A),
            Color(0xFF3B82F6),
            Color(0xFF60A5FA),
          ],
        ),
      ),
      child: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.cloud,
              size: 100,
              color: Colors.white,
            ),
            SizedBox(height: 20),
            Text(
              'Weather App',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 10),
            Text(
              'Trouvez la météo de votre ville',
              style: TextStyle(
                fontSize: 18,
                color: Colors.white70,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadedState(WeatherProvider weatherProvider) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFF1E3A8A),
            Color(0xFF3B82F6),
            Color(0xFF60A5FA),
          ],
        ),
      ),
      child: SafeArea(
        child: Column(
          children: [
            // Barre de recherche
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: WeatherSearchBar(
                onSearch: (city) => weatherProvider.changeCity(city),
                currentCity: weatherProvider.currentLocation,
              ),
            ),

            // Contenu principal avec scroll
            Expanded(
              child: RefreshIndicator(
                onRefresh: () => weatherProvider.refreshWeather(),
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    children: [
                      // Carte météo principale
                      WeatherCard(
                        weatherData: weatherProvider.weatherData!,
                      ),

                      const SizedBox(height: 24),

                      // Prévisions horaires
                      if (weatherProvider.hourlyForecast.isNotEmpty)
                        HourlyForecast(
                          hourlyData: weatherProvider.hourlyForecast,
                        ),

                      const SizedBox(height: 24),

                      // Prévisions quotidiennes
                      if (weatherProvider.dailyForecast.isNotEmpty)
                        DailyForecast(
                          dailyData: weatherProvider.dailyForecast,
                        ),

                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
