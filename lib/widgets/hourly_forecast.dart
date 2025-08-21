import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/weather_model.dart';

class HourlyForecast extends StatelessWidget {
  final List<WeatherData> hourlyData;

  const HourlyForecast({
    super.key,
    required this.hourlyData,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 8.0, bottom: 16.0),
          child: Text(
            'Prévisions horaires (7 jours)',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        SizedBox(
          height: 120,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: hourlyData.length,
            itemBuilder: (context, index) {
              final weather = hourlyData[index];
              return _buildHourlyItem(weather);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildHourlyItem(WeatherData weather) {
    return Container(
      width: 80,
      margin: const EdgeInsets.only(right: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.white.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Heure
          Text(
            DateFormat('HH:mm').format(weather.timestamp),
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),

          const SizedBox(height: 8),

          // Icône météo
          _buildWeatherIcon(weather.icon),

          const SizedBox(height: 8),

          // Température
          Text(
            '${weather.temperature.round()}°',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWeatherIcon(String iconCode) {
    final iconMap = {
      '01d': Icons.wb_sunny,
      '01n': Icons.nightlight_round,
      '02d': Icons.cloud,
      '02n': Icons.cloud,
      '03d': Icons.cloud,
      '03n': Icons.cloud,
      '04d': Icons.cloud,
      '04n': Icons.cloud,
      '09d': Icons.grain,
      '09n': Icons.grain,
      '10d': Icons.opacity,
      '10n': Icons.opacity,
      '11d': Icons.flash_on,
      '11n': Icons.flash_on,
      '13d': Icons.ac_unit,
      '13n': Icons.ac_unit,
      '50d': Icons.blur_on,
      '50n': Icons.blur_on,
    };

    final icon = iconMap[iconCode] ?? Icons.cloud;
    return Icon(
      icon,
      size: 24,
      color: Colors.white,
    );
  }
}
