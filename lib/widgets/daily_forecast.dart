import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/weather_model.dart';

class DailyForecast extends StatelessWidget {
  final List<DailyWeather> dailyData;

  const DailyForecast({
    super.key,
    required this.dailyData,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 8.0, bottom: 16.0),
          child: Text(
            'Prévisions sur 7 jours',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.15),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: Colors.white.withOpacity(0.2),
              width: 1,
            ),
          ),
          child: ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: dailyData.length,
            itemBuilder: (context, index) {
              final day = dailyData[index];
              final isLast = index == dailyData.length - 1;

              return _buildDailyItem(day, isLast);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildDailyItem(DailyWeather day, bool isLast) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        border: isLast
            ? null
            : Border(
                bottom: BorderSide(
                  color: Colors.white.withOpacity(0.1),
                  width: 1,
                ),
              ),
      ),
      child: Row(
        children: [
          // Jour de la semaine
          Expanded(
            flex: 2,
            child: Text(
              DateFormat('EEEE', 'fr_FR').format(day.date),
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),

          // Icône météo
          Expanded(
            flex: 1,
            child: Center(
              child: _buildWeatherIcon(day.icon),
            ),
          ),

          // Températures min/max
          Expanded(
            flex: 2,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  '${day.maxTemp.round()}°',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  '${day.minTemp.round()}°',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white.withOpacity(0.7),
                  ),
                ),
              ],
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
      size: 28,
      color: Colors.white,
    );
  }
}
