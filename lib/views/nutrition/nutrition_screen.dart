import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../data/models/food_item.dart';
import '../../viewmodels/nutrition_view_model.dart';

// استدعاء الويدجت المنفصلة
import 'widgets/calories_macro_card.dart'; // الملف الجديد 1
import 'widgets/animated_meal_tile.dart'; // الملف الجديد 2
import 'widgets/water_tracker_card.dart';
import 'widgets/user_profile_card.dart';

class NutritionScreen extends StatelessWidget {
  const NutritionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<NutritionViewModel>(context);

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.grey.shade50, Colors.white],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: CustomScrollView(
            slivers: [
              // 1. شريط العنوان
              SliverAppBar(
                backgroundColor: Colors.white,
                pinned: true,
                floating: true,
                elevation: 0.5,
                centerTitle: true,
                title: const Text(
                  "Nutrition Plan",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Colors.black87,
                  ),
                ),
              ),

              // 2. محتوى الصفحة
              SliverPadding(
                padding: const EdgeInsets.all(20),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    // أ. كارت المستخدم
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 600),
                      curve: Curves.easeOut,
                      child: UserProfileCard(vm: viewModel),
                    ),

                    const SizedBox(height: 25),

                    // ب. الكارت الرئيسي (السعرات + الماكروز)
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 800),
                      curve: Curves.easeOut,
                      child: CaloriesMacroCard(vm: viewModel),
                    ),

                    const SizedBox(height: 30),

                    // ج. متتبع المياه
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 900),
                      curve: Curves.easeOut,
                      child: WaterTrackerCard(vm: viewModel),
                    ),

                    const SizedBox(height: 20),

                    // د. الوجبات (باستخدام الودجت الجديد)
                    AnimatedMealTile(
                      vm: viewModel,
                      title: "Breakfast",
                      foods: viewModel.breakfast,
                      type: MealType.breakfast,
                      delay: 1000,
                    ),
                    AnimatedMealTile(
                      vm: viewModel,
                      title: "Lunch",
                      foods: viewModel.lunch,
                      type: MealType.lunch,
                      delay: 1100,
                    ),
                    AnimatedMealTile(
                      vm: viewModel,
                      title: "Dinner",
                      foods: viewModel.dinner,
                      type: MealType.dinner,
                      delay: 1200,
                    ),
                    AnimatedMealTile(
                      vm: viewModel,
                      title: "Snacks & Drinks",
                      foods: viewModel.snacks,
                      type: MealType.snack,
                      delay: 1300,
                    ),

                    const SizedBox(height: 50),
                  ]),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
