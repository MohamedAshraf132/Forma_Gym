import 'package:flutter/material.dart';
import '../data/models/onboarding_model.dart';

class OnboardingViewModel extends ChangeNotifier {
  int _currentIndex = 0;
  int get currentIndex => _currentIndex;

  // قائمة البيانات (مطابقة للصورة الأولى والتي تليها)
  final List<OnboardingModel> _pages = [
    OnboardingModel(
      image: 'assets/images/onboarding1.png', // تأكد من وجود الصورة
      title: "Welcome to Capi Fitness Application",
      description:
          "Personalized workouts will help you gain strength, get in better shape and embrace a healthy lifestyle",
    ),
    OnboardingModel(
      image: 'assets/images/onboarding2.png',
      title: "Select your fitness level",
      description:
          "Choose the workout plan that fits your needs and current level.",
    ),
    OnboardingModel(
      image: 'assets/images/onboarding3.png',
      title: "Track your progress",
      description:
          "Keep track of your workouts and calories to stay motivated.",
    ),
  ];

  List<OnboardingModel> get pages => _pages;

  // دالة تحديث الصفحة عند السحب
  void onPageChanged(int index) {
    _currentIndex = index;
    notifyListeners();
  }

  // دالة الانتقال للصفحة التالية أو الشاشة القادمة
  void nextPage(BuildContext context) {
    if (_currentIndex < _pages.length - 1) {
      // إذا لم نكن في الصفحة الأخيرة، فقط قم بإشعار الواجهة لتتحرك (التحكم بالأنيميشن سيكون في الـ View)
      _currentIndex++;
      notifyListeners();
    } else {
      // إذا وصلنا للنهاية، انتقل لشاشة تسجيل الدخول
      // Navigator.pushReplacementNamed(context, '/login');
      print("Go to Login/Setup Screen");
    }
  }
}
