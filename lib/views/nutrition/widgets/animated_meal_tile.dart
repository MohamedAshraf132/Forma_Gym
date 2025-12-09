import 'package:flutter/material.dart';
import '../../../../data/models/food_item.dart';
import '../../../../viewmodels/nutrition_view_model.dart';
import 'meal_section.dart'; // الملف الذي يحتوي على MealSection الأصلي

class AnimatedMealTile extends StatelessWidget {
  final NutritionViewModel vm;
  final String title;
  final List<FoodItem> foods;
  final MealType type;
  final int delay; // للتأخير في الأنيميشن

  const AnimatedMealTile({
    super.key,
    required this.vm,
    required this.title,
    required this.foods,
    required this.type,
    this.delay = 0,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: delay),
      curve: Curves.easeOut,
      margin: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.06),
            blurRadius: 15,
            offset: const Offset(0, 8),
            spreadRadius: 2,
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
        child: MealSection(title: title, foods: foods, type: type, vm: vm),
      ),
    );
  }
}
