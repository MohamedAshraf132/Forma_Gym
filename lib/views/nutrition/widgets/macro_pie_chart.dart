import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../../../viewmodels/nutrition_view_model.dart';

class MacroPieChart extends StatelessWidget {
  final NutritionViewModel viewModel;

  const MacroPieChart({super.key, required this.viewModel});

  @override
  Widget build(BuildContext context) {
    bool hasData = viewModel.consumedCalories > 0;

    return Container(
      height: 200,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: hasData
                ? PieChart(
                    PieChartData(
                      sectionsSpace: 4,
                      centerSpaceRadius: 40,
                      pieTouchData: PieTouchData(
                        touchCallback: (event, response) {},
                      ),
                      sections: [
                        _buildSection(
                          viewModel.consumedProtein,
                          Colors.blue,
                          "P",
                        ),
                        _buildSection(
                          viewModel.consumedCarbs,
                          Colors.orange,
                          "C",
                        ),
                        _buildSection(viewModel.consumedFat, Colors.red, "F"),
                      ],
                    ),
                    swapAnimationDuration: const Duration(milliseconds: 800),
                    swapAnimationCurve: Curves.easeOutCubic,
                  )
                : _buildEmptyChart(),
          ),
          const SizedBox(width: 20),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildLegendItem(
                "Protein",
                Colors.blue,
                "${viewModel.consumedProtein.toInt()}g",
              ),
              const SizedBox(height: 10),
              _buildLegendItem(
                "Carbs",
                Colors.orange,
                "${viewModel.consumedCarbs.toInt()}g",
              ),
              const SizedBox(height: 10),
              _buildLegendItem(
                "Fat",
                Colors.red,
                "${viewModel.consumedFat.toInt()}g",
              ),
            ],
          ),
        ],
      ),
    );
  }

  PieChartSectionData _buildSection(double value, Color color, String title) {
    return PieChartSectionData(
      color: color,
      value: value,
      title: title,
      radius: 50,
      titleStyle: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
      showTitle: value > 0,
    );
  }

  Widget _buildLegendItem(String title, Color color, String value) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 8),
        Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(width: 5),
        Text(
          "($value)",
          style: const TextStyle(color: Colors.grey, fontSize: 12),
        ),
      ],
    );
  }

  Widget _buildEmptyChart() {
    return PieChart(
      PieChartData(
        centerSpaceRadius: 40,
        sections: [
          PieChartSectionData(
            color: Colors.grey.shade200,
            value: 1,
            title: "",
            radius: 50,
          ),
        ],
      ),
    );
  }
}
