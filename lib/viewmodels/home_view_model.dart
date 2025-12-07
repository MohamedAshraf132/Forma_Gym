import 'package:flutter/material.dart';
import '../data/models/menu_item.dart';
import '../data/models/challenge_plan.dart';

class HomeViewModel extends ChangeNotifier {
  String userName = "Forma Gym";

  // 1. قائمة التحديات الجديدة (بناءً على الصور)
  // تم إضافة id لكل خطة لضمان عمل التنقل بشكل صحيح
  final List<ChallengePlan> _challenges = [
    ChallengePlan(
      id: "full_body",
      title: "FULL BODY\nCHALLENGE",
      subtitle:
          "Start your body-toning journey to target all muscle groups and build your dream body in 4 weeks!",
      duration: "28 DAYS",
      imageUrl: "assets/images/full_body_challenge1.png",
      cardColor: const Color(0xFF0066FF), // الأزرق
    ),
    ChallengePlan(
      id: "INTENSE_BELLY_FAT_BURN",
      title: "INTENSE\nBELLY FAT BURN",
      subtitle:
          "Feel the burn, lose the fat—killer abs exercises that work your core fast!",
      duration: "14 DAYS",
      imageUrl: "assets/images/belly_fat.png",
      cardColor: const Color(0xFF6D4C41), // بني غامق
    ),
    ChallengePlan(
      id: "GET_RIPPED_WITH_DUMBBELL",
      title: "GET RIPPED\nWITH DUMBBELL",
      subtitle:
          "Use dumbbells to build bigger muscles and boost full-body strength in 30 days!",
      duration: "30 DAYS",
      imageUrl: "assets/images/dumbbell_workout.png",
      cardColor: const Color(0xFF009688), // تركواز/أخضر مزرق
    ),
    ChallengePlan(
      id: "six_pack",
      title: "SIX PACK\nCHALLENGE",
      subtitle: "Crush this challenge and carve out your six-pack in no time!",
      duration: "30 DAYS",
      imageUrl: "assets/images/six_pack.png",
      cardColor: const Color(0xFF283593), // نيلي غامق (Indigo)
    ),
    ChallengePlan(
      id: "calisthenics",
      title: "CALISTHENICS\nPLAN",
      subtitle:
          "Take on bodyweight exercises to maximize your muscle gain and fat loss!",
      duration: "28 DAYS",
      imageUrl: "assets/images/calisthenics.png",
      cardColor: const Color(0xFF7B1FA2), // بنفسجي
    ),
    ChallengePlan(
      id: "lose_weight_men",
      title: "LOSE WEIGHT\nFOR MEN",
      subtitle: "Lose man boobs and love handles in just 5-10 min a day!",
      duration: "30 DAYS",
      imageUrl: "assets/images/lose_weight.png",
      cardColor: const Color(0xFFFF6D00), // برتقالي
    ),
    ChallengePlan(
      id: "kegel_power",
      title: "KEGEL\nPOWER BOOST",
      subtitle:
          "Strengthen your pelvic floor with Kegel exercises for better sex and intimacy!",
      duration: "14 DAYS",
      imageUrl: "assets/images/kegell.png",
      cardColor: const Color(0xFF455A64), // رصاصي مزرق
    ),
  ];

  // 2. القائمة السفلية (Grid List) - كما هي
  final List<MenuItem> _menuItems = [
    MenuItem(title: "Training Plan", icon: Icons.calendar_today),
    MenuItem(title: "Weight", icon: Icons.monitor_weight_outlined),
    MenuItem(title: "Meal Plan", icon: Icons.restaurant_menu),
    MenuItem(title: "Schedule", icon: Icons.access_time),
    MenuItem(title: "Running", icon: Icons.directions_run),
    MenuItem(title: "Exercises", icon: Icons.fitness_center),
    MenuItem(title: "Tips", icon: Icons.lightbulb_outline),
    MenuItem(title: "Settings", icon: Icons.settings),
    MenuItem(title: "Mental Health", icon: Icons.self_improvement),
  ];

  List<ChallengePlan> get challenges => _challenges;
  List<MenuItem> get menuItems => _menuItems;
}
