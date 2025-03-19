import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../providers/category_provider.dart';

class CategoryChart extends StatelessWidget {
  final Map<String, double> categoryData;
  final CategoryProvider categoryProvider;

  const CategoryChart({
    Key? key,
    required this.categoryData,
    required this.categoryProvider,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min, // Add this to avoid expansion
          children: [
            const Text(
              'Category-wise Spending',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            // Use a container with fixed height for the chart
            SizedBox(
              height: 220, // Reduced height to avoid overflow
              child: PieChart(
                PieChartData(
                  sections: _buildChartSections(),
                  centerSpaceRadius: 40, // Reduced center space
                  sectionsSpace: 2, // Reduced space between sections
                  borderData: FlBorderData(show: false),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<PieChartSectionData> _buildChartSections() {
    // Calculate total amount to calculate percentage
    final totalAmount = categoryData.values.fold(0.0, (sum, amount) => sum + amount);

    return categoryData.entries.map((entry) {
      final category = categoryProvider.getCategoryById(entry.key);

      // Safe check for null category
      if (category == null) {
        return PieChartSectionData(
          color: Colors.grey, // Default color if no category found
          value: entry.value,
          title: 'N/A',
          radius: 60, // Reduced radius
          titleStyle: const TextStyle(
            fontSize: 12, // Smaller font size
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        );
      }

      final percentage = (entry.value / totalAmount) * 100;

      return PieChartSectionData(
        color: _getColorFromHex(category.color),
        value: entry.value,
        title: '${percentage.toStringAsFixed(1)}%',
        radius: 60, // Reduced radius
        titleStyle: const TextStyle(
          fontSize: 12, // Smaller font size
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      );
    }).toList();
  }

  // Utility method to parse hex color codes to Color objects
  Color _getColorFromHex(String hexColor) {
    final buffer = StringBuffer();
    if (hexColor.length == 6 || hexColor.length == 7) {
      buffer.write('ff'); // Adding full opacity if not specified
      buffer.write(hexColor.replaceFirst('#', ''));
    } else {
      buffer.write('ff000000'); // Default black if incorrect format
    }
    return Color(int.parse(buffer.toString(), radix: 16));
  }
}