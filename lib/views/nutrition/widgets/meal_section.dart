import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../data/models/food_item.dart';
import '../../../../viewmodels/nutrition_view_model.dart';
import 'add_food_sheet.dart'; // الشيت المنفصل

class MealSection extends StatelessWidget {
  final String title;
  final List<FoodItem> foods;
  final MealType type;
  final NutritionViewModel vm;

  const MealSection({
    super.key,
    required this.title,
    required this.foods,
    required this.type,
    required this.vm,
  });

  @override
  Widget build(BuildContext context) {
    int mealCalories = foods.fold(0, (sum, item) => sum + item.calories);

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      margin: const EdgeInsets.symmetric(vertical: 10),
      shadowColor: Colors.grey.withOpacity(0.2),
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          children: [
            // رأس القسم مع العنوان والسعرات وزر الإضافة
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                Row(
                  children: [
                    Text(
                      "$mealCalories Kcal",
                      style: const TextStyle(
                        color: Colors.grey,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(width: 10),
                    IconButton(
                      icon: const Icon(
                        Icons.add_circle,
                        color: AppColors.primary,
                        size: 28,
                      ),
                      onPressed: () {
                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(20),
                            ),
                          ),
                          builder: (ctx) => AddFoodSheet(type: type, vm: vm),
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 10),

            // قائمة الطعام
            if (foods.isEmpty)
              Container(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: const Center(
                  child: Text(
                    "No food added yet.",
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              )
            else
              Column(
                children: foods.map((food) {
                  return Container(
                    margin: const EdgeInsets.symmetric(vertical: 5),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade50,
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.1),
                          blurRadius: 5,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 5,
                      ),
                      leading: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.asset(
                          food.imageUrl,
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
                          errorBuilder: (c, e, s) => Container(
                            width: 50,
                            height: 50,
                            color: Colors.grey[200],
                            child: const Icon(
                              Icons.fastfood,
                              color: Colors.orange,
                            ),
                          ),
                        ),
                      ),
                      title: Text(
                        food.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                      subtitle: Text(
                        "${food.calories} kcal • ${food.protein}g P",
                        style: const TextStyle(
                          color: Colors.grey,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.close, color: Colors.redAccent),
                        onPressed: () => vm.removeFood(food, type),
                      ),
                      tileColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  );
                }).toList(),
              ),

            const SizedBox(height: 5),
          ],
        ),
      ),
    );
  }
}
