import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'core/constants/app_colors.dart';
import 'views/onboarding/onboarding_screen.dart';

// --- استدعاء الـ ViewModels ---
import 'package:forma_gym/viewmodels/home_view_model.dart';
import 'package:forma_gym/viewmodels/onboarding_view_model.dart';
import 'package:forma_gym/viewmodels/profile_view_model.dart';
import 'package:forma_gym/viewmodels/workout_view_model.dart';
// 1. تأكد من إضافة هذا السطر (استدعاء ملف الخطة)
import 'package:forma_gym/viewmodels/training_plan_view_model.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      // هنا نقوم بتسجيل كل الـ ViewModels
      providers: [
        ChangeNotifierProvider(create: (_) => OnboardingViewModel()),
        ChangeNotifierProvider(create: (_) => ProfileViewModel()),
        ChangeNotifierProvider(create: (_) => HomeViewModel()),
        ChangeNotifierProvider(create: (_) => WorkoutViewModel()),
        // 2. أضفنا هذا السطر لحل المشكلة
        ChangeNotifierProvider(create: (_) => TrainingPlanViewModel()),
      ],
      child: MaterialApp(
        title: 'Capi Fitness',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          primaryColor: AppColors.primary,
          scaffoldBackgroundColor: AppColors.background,
          // تطبيق خط جميل على كل التطبيق
          textTheme: GoogleFonts.poppinsTextTheme(),
          colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary),
        ),
        home: const OnboardingScreen(),
      ),
    );
  }
}
