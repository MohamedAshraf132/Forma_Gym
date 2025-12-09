import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../viewmodels/nutrition_view_model.dart';

class CaloriesMacroCard extends StatelessWidget {
  final NutritionViewModel vm;

  const CaloriesMacroCard({super.key, required this.vm});

  @override
  Widget build(BuildContext context) {
    int remainingCalories = (vm.targetCalories - vm.consumedCalories).clamp(
      0,
      vm.targetCalories.toInt(),
    );

    return AnimatedContainer(
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeOut,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.white, Colors.grey.shade100],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
          BoxShadow(
            color: Colors.white.withOpacity(0.7),
            blurRadius: 15,
            offset: const Offset(-5, -5),
          ),
        ],
      ),
      child: Row(
        children: [
          // الدائرة المتحركة مع السعرات
          TweenAnimationBuilder<double>(
            tween: Tween<double>(begin: 0, end: vm.progress.clamp(0.0, 1.0)),
            duration: const Duration(seconds: 1),
            curve: Curves.easeOutCubic,
            builder: (context, value, _) => CircularPercentIndicator(
              radius: 65,
              lineWidth: 12.0,
              percent: value,
              circularStrokeCap: CircularStrokeCap.round,
              backgroundColor: Colors.grey.shade200,
              linearGradient: const LinearGradient(
                colors: [AppColors.primary, Colors.lightBlueAccent],
              ),
              animation: true,
              animationDuration: 1000,
              center: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TweenAnimationBuilder<int>(
                    tween: IntTween(begin: 0, end: remainingCalories),
                    duration: const Duration(milliseconds: 900),
                    builder: (context, val, _) => Text(
                      val == 0 ? "Done!" : "$val",
                      style: TextStyle(
                        fontWeight: FontWeight.w900,
                        fontSize: 22,
                        color: val == 0 ? Colors.red : AppColors.textDark,
                      ),
                    ),
                  ),
                  const Text(
                    "Kcal Left",
                    style: TextStyle(color: Colors.grey, fontSize: 10),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(width: 25),

          // قائمة الماكروز مع شريط متحرك لكل ماكرو
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Macronutrients",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 15),
                _buildMacroRow("Protein", vm.consumedProtein, Colors.blue),
                const SizedBox(height: 12),
                _buildMacroRow("Carbs", vm.consumedCarbs, Colors.orange),
                const SizedBox(height: 12),
                _buildMacroRow("Fat", vm.consumedFat, Colors.red),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMacroRow(String title, double consumed, Color color) {
    // نسبة وهمية للprogress bar (يمكن تعديلها حسب التصميم)
    double percent = (consumed / 100).clamp(0.0, 1.0);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              height: 8,
              width: 8,
              decoration: BoxDecoration(color: color, shape: BoxShape.circle),
            ),
            const SizedBox(width: 8),
            Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 14,
                color: AppColors.textDark,
              ),
            ),
            const Spacer(),
            TweenAnimationBuilder<int>(
              tween: IntTween(begin: 0, end: consumed.toInt()),
              duration: const Duration(milliseconds: 800),
              builder: (context, val, _) => Text(
                "${val}g",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: Colors.grey[700],
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        TweenAnimationBuilder<double>(
          tween: Tween<double>(begin: 0, end: percent),
          duration: const Duration(seconds: 1),
          curve: Curves.easeOutCubic,
          builder: (context, value, _) => ClipRRect(
            borderRadius: BorderRadius.circular(5),
            child: LinearProgressIndicator(
              value: value,
              minHeight: 6,
              backgroundColor: Colors.grey.shade200,
              valueColor: AlwaysStoppedAnimation(
                Color.lerp(color.withOpacity(0.5), color, value)!,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
