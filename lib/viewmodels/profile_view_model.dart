import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // لتنسيق التاريخ
import '../data/models/user_profile.dart';

class ProfileViewModel extends ChangeNotifier {
  // كائن يحمل البيانات
  final UserProfile _userProfile = UserProfile(birthday: DateTime(1995, 1, 1));

  // Getters للوصول للبيانات من الواجهة
  String get gender => _userProfile.gender;
  double get weight => _userProfile.weight;
  double get height => _userProfile.height;
  bool get useAppleHealth => _userProfile.useAppleHealth;

  // تنسيق التاريخ ليظهر كنص (مثال: Aug 25, 1990)
  String get birthDateString {
    if (_userProfile.birthday == null) return "Select Date";
    return DateFormat('MMM dd, yyyy').format(_userProfile.birthday!);
  }

  // --- دوال التحديث (Logic) ---

  void setGender(String val) {
    _userProfile.gender = val;
    notifyListeners(); // تحديث الواجهة لتغيير اللون
  }

  void setWeight(double val) {
    _userProfile.weight = val;
    notifyListeners();
  }

  void setHeight(double val) {
    _userProfile.height = val;
    notifyListeners();
  }

  void toggleAppleHealth(bool val) {
    _userProfile.useAppleHealth = val;
    notifyListeners();
  }

  void setBirthday(DateTime date) {
    _userProfile.birthday = date;
    notifyListeners();
  }

  // دالة الحفظ (سنحتاجها لاحقاً لتخزين البيانات في الجهاز)
  void saveDataAndStart(BuildContext context) {
    print("User Data: ${_userProfile.gender}, ${_userProfile.weight}kg");
    // هنا سنضيف كود الانتقال للشاشة الرئيسية (Home) لاحقاً
    // Navigator.pushReplacementNamed(context, '/home');
  }
}
