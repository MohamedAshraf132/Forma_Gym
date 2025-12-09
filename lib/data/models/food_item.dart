enum MealType { breakfast, lunch, dinner, snack }
// 👆👆👆👆

class FoodItem {
  final String id;
  final String name;
  final int calories;
  final double protein;
  final double carbs;
  final double fat;
  final String imageUrl;
  final bool isCustom; // حقل جديد لنعرف هل هذه وجبة مستخدم أم وجبة النظام

  FoodItem({
    required this.id,
    required this.name,
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fat,
    required this.imageUrl,
    this.isCustom = false, // الافتراضي false
  });

  // 1. تحويل الكائن إلى Map للحفظ في قاعدة البيانات
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'calories': calories,
      'protein': protein,
      'carbs': carbs,
      'fat': fat,
      'imageUrl': imageUrl,
      'isCustom': isCustom ? 1 : 0, // SQLite لا يدعم bool، نستخدم 1 و 0
    };
  }

  // 2. تحويل الـ Map القادم من قاعدة البيانات إلى كائن
  factory FoodItem.fromMap(Map<String, dynamic> map) {
    return FoodItem(
      id: map['id'],
      name: map['name'],
      calories: map['calories'],
      protein: map['protein'],
      carbs: map['carbs'],
      fat: map['fat'],
      imageUrl: map['imageUrl'],
      isCustom: map['isCustom'] == 1,
    );
  }
}
