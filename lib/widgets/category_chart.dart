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
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [

            const SizedBox(height: 20),
            SizedBox(
              height: 250,
              child: PieChart(
                PieChartData(
                  sections: _buildChartSections(),
                  centerSpaceRadius: 40,
                  sectionsSpace: 4,
                  borderData: FlBorderData(show: false),
                  centerSpaceColor: Colors.white,
                  pieTouchData: PieTouchData(enabled: true),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<PieChartSectionData> _buildChartSections() {
    final totalAmount = categoryData.values.fold(0.0, (sum, amount) => sum + amount);

    return categoryData.entries.map((entry) {
      final category = categoryProvider.getCategoryById(entry.key);
      if (category == null) {
        return PieChartSectionData(
          color: Colors.grey,
          value: entry.value,
          title: 'N/A',
          radius: 70,
          titleStyle: const TextStyle(
            fontSize: 14,
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
        radius: 70,
        titleStyle: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
        showTitle: true,
        badgeWidget: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 4,
                offset: const Offset(0, 2),
              )
            ],
          ),
          child: Text(
            '${category.name}: ${entry.value.toStringAsFixed(2)}',
            style: const TextStyle(fontSize: 12, color: Colors.black),
          ),
        ),
        badgePositionPercentageOffset: 1.3, // Further out for clearer view
      );
    }).toList();
  }

  Color _getColorFromHex(String hexColor) {
    final buffer = StringBuffer();
    if (hexColor.length == 6 || hexColor.length == 7) {
      buffer.write('ff');
      buffer.write(hexColor.replaceFirst('#', ''));
    } else {
      buffer.write('ff000000');
    }
    return Color(int.parse(buffer.toString(), radix: 16));
  }
}
