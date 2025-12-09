import 'package:flutter/material.dart';
import '../data/models/food_item.dart';
import '../data/services/database_helper.dart';

class NutritionViewModel extends ChangeNotifier {
  // --- 1. بيانات المستخدم (الافتراضية) ---
  double weight = 75.0;
  double height = 175.0;
  int age = 25;
  String gender = 'Male'; // Male, Female
  String goal = 'Lose Weight'; // Lose Weight, Build Muscle, Maintain

  // --- 2. النتائج المحسوبة ---
  int _targetCalories = 0;
  int waterGoal = 8;
  double _bodyFat = 0.0; // نسبة الدهون

  // --- 3. استهلاك اليوم ---
  int _consumedCalories = 0;
  double _consumedProtein = 0;
  double _consumedCarbs = 0;
  double _consumedFat = 0;
  int _consumedWater = 0;

  // --- 4. قوائم الطعام ---
  List<FoodItem> breakfast = [];
  List<FoodItem> lunch = [];
  List<FoodItem> dinner = [];
  List<FoodItem> snacks = [];

  // --- 5. قاعدة البيانات الأساسية (Hardcoded) ---
  final List<FoodItem> _defaultFoods = [
    // === فطار مصري وتقليدي ===
    FoodItem(
      id: 'f1',
      name: 'Foul Medames (Plate)',
      calories: 260,
      protein: 14,
      carbs: 35,
      fat: 5,
      imageUrl: 'assets/images/foul.png',
    ),
    FoodItem(
      id: 'f2',
      name: 'Falafel (Ta\'meya) 1pc',
      calories: 60,
      protein: 2,
      carbs: 7,
      fat: 3,
      imageUrl: 'assets/images/falafel.png',
    ),
    FoodItem(
      id: 'f3',
      name: 'Baladi Bread (1 Loaf)',
      calories: 280,
      protein: 9,
      carbs: 55,
      fat: 2,
      imageUrl: 'assets/images/bread.png',
    ),
    FoodItem(
      id: 'f4',
      name: 'Boiled Egg (Large)',
      calories: 75,
      protein: 7,
      carbs: 0.6,
      fat: 5,
      imageUrl: 'assets/images/egg.png',
    ),
    FoodItem(
      id: 'f5',
      name: 'Fried Egg (1 egg)',
      calories: 90,
      protein: 7,
      carbs: 0.6,
      fat: 7,
      imageUrl: 'assets/images/fried_egg.png',
    ),
    FoodItem(
      id: 'f6',
      name: 'White Cheese (100g)',
      calories: 260,
      protein: 15,
      carbs: 3,
      fat: 20,
      imageUrl: 'assets/images/cheese.png',
    ),
    FoodItem(
      id: 'f7',
      name: 'Rummy Cheese (1 slice)',
      calories: 110,
      protein: 7,
      carbs: 1,
      fat: 9,
      imageUrl: 'assets/images/rummy.png',
    ),
    FoodItem(
      id: 'f8',
      name: 'Oatmeal with Milk',
      calories: 250,
      protein: 10,
      carbs: 32,
      fat: 6,
      imageUrl: 'assets/images/oatmeal.png',
    ),
    FoodItem(
      id: 'f9',
      name: 'Pancakes (2 pcs)',
      calories: 350,
      protein: 8,
      carbs: 45,
      fat: 12,
      imageUrl: 'assets/images/pancakes.png',
    ),

    // === غداء وعشاء ===
    FoodItem(
      id: 'l1',
      name: 'Koshary (Medium Bowl)',
      calories: 550,
      protein: 18,
      carbs: 90,
      fat: 12,
      imageUrl: 'assets/images/koshary.png',
    ),
    FoodItem(
      id: 'l2',
      name: 'Grilled Chicken (1/4)',
      calories: 250,
      protein: 30,
      carbs: 0,
      fat: 12,
      imageUrl: 'assets/images/grilled_chicken.png',
    ),
    FoodItem(
      id: 'l3',
      name: 'Rice (White, 1 Plate)',
      calories: 220,
      protein: 4,
      carbs: 45,
      fat: 1,
      imageUrl: 'assets/images/rice.png',
    ),
    FoodItem(
      id: 'l4',
      name: 'Mahshi (Mixed, 6 pcs)',
      calories: 300,
      protein: 5,
      carbs: 50,
      fat: 10,
      imageUrl: 'assets/images/mahshi.png',
    ),
    FoodItem(
      id: 'l5',
      name: 'Chicken Pane (1 pc)',
      calories: 280,
      protein: 20,
      carbs: 15,
      fat: 18,
      imageUrl: 'assets/images/pane.png',
    ),
    FoodItem(
      id: 'l6',
      name: 'Molokhia (Small Bowl)',
      calories: 120,
      protein: 4,
      carbs: 10,
      fat: 6,
      imageUrl: 'assets/images/molokhia.png',
    ),
    FoodItem(
      id: 'l7',
      name: 'Bamia (Okra with meat)',
      calories: 300,
      protein: 20,
      carbs: 15,
      fat: 18,
      imageUrl: 'assets/images/bamia.png',
    ),
    FoodItem(
      id: 'l8',
      name: 'Macaroni Béchamel (Piece)',
      calories: 450,
      protein: 15,
      carbs: 40,
      fat: 25,
      imageUrl: 'assets/images/bechamel.png',
    ),
    FoodItem(
      id: 'l9',
      name: 'Fatta (Rice & Bread)',
      calories: 600,
      protein: 25,
      carbs: 70,
      fat: 20,
      imageUrl: 'assets/images/fatta.png',
    ),
    FoodItem(
      id: 'l10',
      name: 'Hawawshi (1 Loaf)',
      calories: 600,
      protein: 25,
      carbs: 40,
      fat: 35,
      imageUrl: 'assets/images/hawawshi.png',
    ),
    FoodItem(
      id: 'l11',
      name: 'Beef Burger (Sandwich)',
      calories: 500,
      protein: 25,
      carbs: 40,
      fat: 25,
      imageUrl: 'assets/images/burger.png',
    ),
    FoodItem(
      id: 'l12',
      name: 'Pizza Slice (Cheese)',
      calories: 280,
      protein: 12,
      carbs: 30,
      fat: 10,
      imageUrl: 'assets/images/pizza.png',
    ),
    FoodItem(
      id: 'l13',
      name: 'Grilled Fish (1 pc)',
      calories: 200,
      protein: 25,
      carbs: 0,
      fat: 8,
      imageUrl: 'assets/images/fish.png',
    ),
    FoodItem(
      id: 'l14',
      name: 'Tuna Salad (Bowl)',
      calories: 350,
      protein: 30,
      carbs: 10,
      fat: 15,
      imageUrl: 'assets/images/tuna_salad.png',
    ),
    FoodItem(
      id: 'l15',
      name: 'Green Salad',
      calories: 50,
      protein: 2,
      carbs: 10,
      fat: 0,
      imageUrl: 'assets/images/salad.png',
    ),

    // === سناكس ومشروبات ===
    FoodItem(
      id: 's1',
      name: 'Yogurt (Plain Cup)',
      calories: 100,
      protein: 8,
      carbs: 10,
      fat: 3,
      imageUrl: 'assets/images/yogurt.png',
    ),
    FoodItem(
      id: 's2',
      name: 'Apple (Medium)',
      calories: 95,
      protein: 0.5,
      carbs: 25,
      fat: 0.3,
      imageUrl: 'assets/images/apple.png',
    ),
    FoodItem(
      id: 's3',
      name: 'Banana (Medium)',
      calories: 105,
      protein: 1.3,
      carbs: 27,
      fat: 0.3,
      imageUrl: 'assets/images/banana.png',
    ),
    FoodItem(
      id: 's4',
      name: 'Orange',
      calories: 62,
      protein: 1.2,
      carbs: 15,
      fat: 0.2,
      imageUrl: 'assets/images/orange.png',
    ),
    FoodItem(
      id: 's5',
      name: 'Watermelon (Slice)',
      calories: 85,
      protein: 1.7,
      carbs: 21,
      fat: 0.4,
      imageUrl: 'assets/images/watermelon.png',
    ),
    FoodItem(
      id: 's6',
      name: 'Dates (3 pcs)',
      calories: 80,
      protein: 1,
      carbs: 20,
      fat: 0,
      imageUrl: 'assets/images/dates.png',
    ),
    FoodItem(
      id: 's7',
      name: 'Almonds (Handful)',
      calories: 160,
      protein: 6,
      carbs: 6,
      fat: 14,
      imageUrl: 'assets/images/almonds.png',
    ),
    FoodItem(
      id: 's8',
      name: 'Potato Chips (Small bag)',
      calories: 150,
      protein: 2,
      carbs: 15,
      fat: 10,
      imageUrl: 'assets/images/chips.png',
    ),
    FoodItem(
      id: 's9',
      name: 'Dark Chocolate (2 squares)',
      calories: 120,
      protein: 2,
      carbs: 12,
      fat: 8,
      imageUrl: 'assets/images/chocolate.png',
    ),
    FoodItem(
      id: 'd1',
      name: 'Coffee (Black)',
      calories: 2,
      protein: 0,
      carbs: 0,
      fat: 0,
      imageUrl: 'assets/images/coffee.png',
    ),
    FoodItem(
      id: 'd2',
      name: 'Tea with Sugar',
      calories: 40,
      protein: 0,
      carbs: 10,
      fat: 0,
      imageUrl: 'assets/images/tea.png',
    ),
    FoodItem(
      id: 'd3',
      name: 'Pepsi Can (330ml)',
      calories: 140,
      protein: 0,
      carbs: 39,
      fat: 0,
      imageUrl: 'assets/images/pepsi.png',
    ),
    FoodItem(
      id: 'd4',
      name: 'Protein Shake',
      calories: 120,
      protein: 24,
      carbs: 3,
      fat: 1,
      imageUrl: 'assets/images/protein_shake.png',
    ),
  ];

  List<FoodItem> availableFoods = [];

  // --- Getters ---
  int get targetCalories => _targetCalories;
  double get bodyFat => _bodyFat;
  int get consumedCalories => _consumedCalories;
  double get consumedProtein => _consumedProtein;
  double get consumedCarbs => _consumedCarbs;
  double get consumedFat => _consumedFat;
  int get consumedWater => _consumedWater;

  double get progress =>
      _targetCalories > 0 ? _consumedCalories / _targetCalories : 0.0;

  NutritionViewModel() {
    calculateAll();
    _loadAllFoods();
  }

  // --- دالة تحديث بيانات المستخدم (تستدعى من الاستبيان) ---
  void updateUserProfile({
    required double newWeight,
    required double newHeight,
    required int newAge,
    required String newGender,
    required String newGoal,
  }) {
    weight = newWeight;
    height = newHeight;
    age = newAge;
    gender = newGender;
    goal = newGoal;

    calculateAll();
    notifyListeners();
  }

  void calculateAll() {
    _calculateCalories();
    _calculateWater();
    _calculateBodyFat();
  }

  void _calculateCalories() {
    double bmr;
    if (gender == 'Male') {
      bmr = (10 * weight) + (6.25 * height) - (5 * age) + 5;
    } else {
      bmr = (10 * weight) + (6.25 * height) - (5 * age) - 161;
    }
    double tdee = bmr * 1.55;

    if (goal == 'Lose Weight') {
      _targetCalories = (tdee - 500).round();
    } else if (goal == 'Build Muscle') {
      _targetCalories = (tdee + 300).round();
    } else {
      _targetCalories = tdee.round();
    }
  }

  void _calculateWater() {
    double waterNeededMl = weight * 30;
    if (goal != 'Maintain') waterNeededMl += 500;
    waterGoal = (waterNeededMl / 250).round();
    if (waterGoal < 8) waterGoal = 8;
  }

  void _calculateBodyFat() {
    double heightInMeters = height / 100;
    double bmi = weight / (heightInMeters * heightInMeters);

    if (gender == 'Male') {
      _bodyFat = (1.20 * bmi) + (0.23 * age) - 16.2;
    } else {
      _bodyFat = (1.20 * bmi) + (0.23 * age) - 5.4;
    }

    if (_bodyFat < 5) _bodyFat = 5;
  }

  // --- تحميل الطعام (دمج القائمة) ---
  Future<void> _loadAllFoods() async {
    availableFoods = List.from(_defaultFoods);
    final customFoods = await DatabaseHelper.instance.getCustomFoods();
    availableFoods.addAll(customFoods);
    notifyListeners();
  }

  // --- إضافة طعام مخصص جديد ---
  Future<void> addNewCustomFood(FoodItem food) async {
    await DatabaseHelper.instance.insertFood(food);
    availableFoods.add(food);
    notifyListeners();
  }

  // --- إضافة طعام للوجبة ---
  void addFood(FoodItem food, MealType type) {
    if (type == MealType.breakfast) breakfast.add(food);
    if (type == MealType.lunch) lunch.add(food);
    if (type == MealType.dinner) dinner.add(food);
    if (type == MealType.snack) snacks.add(food);

    _consumedCalories += food.calories;
    _consumedProtein += food.protein;
    _consumedCarbs += food.carbs;
    _consumedFat += food.fat;

    notifyListeners();
  }

  // --- حذف طعام من الوجبة ---
  void removeFood(FoodItem food, MealType type) {
    bool removed = false;

    if (type == MealType.breakfast) removed = breakfast.remove(food);
    if (type == MealType.lunch) removed = lunch.remove(food);
    if (type == MealType.dinner) removed = dinner.remove(food);
    if (type == MealType.snack) removed = snacks.remove(food);

    if (removed) {
      _consumedCalories -= food.calories;
      _consumedProtein -= food.protein;
      _consumedCarbs -= food.carbs;
      _consumedFat -= food.fat;

      if (_consumedCalories < 0) _consumedCalories = 0;
      if (_consumedProtein < 0) _consumedProtein = 0;
      if (_consumedCarbs < 0) _consumedCarbs = 0;
      if (_consumedFat < 0) _consumedFat = 0;

      notifyListeners();
    }
  }

  // --- المياه ---
  void drinkWater() {
    if (_consumedWater < waterGoal) {
      _consumedWater++;
      notifyListeners();
    }
  }

  void removeWaterCup() {
    if (_consumedWater > 0) {
      _consumedWater--;
      notifyListeners();
    }
  }
}
