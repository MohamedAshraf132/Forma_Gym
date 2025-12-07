import 'package:flutter/material.dart';
import '../data/models/training_plan.dart';

class TrainingPlanViewModel extends ChangeNotifier {
  List<TrainingWeek> weeks = [];
  int totalDays = 0;
  int daysLeft = 0;
  double progress = 0.0;
  String challengeTitle = "";

  // إنشاء الخطة (يتم استدعاؤها مرة واحدة عند دخول التحدي)
  void createPlan(String title, int durationInDays) {
    challengeTitle = title;
    totalDays = durationInDays;
    weeks = [];

    int totalWeeks = (totalDays / 7).ceil();

    for (int i = 1; i <= totalWeeks; i++) {
      List<TrainingDay> days = [];
      for (int j = 1; j <= 7; j++) {
        int dayNum = (i - 1) * 7 + j;
        if (dayNum > totalDays) break;

        // المنطق: اليوم رقم 1 مفتوح، والباقي مغلق
        DayStatus status = (dayNum == 1) ? DayStatus.current : DayStatus.locked;

        days.add(
          TrainingDay(
            dayNumber: dayNum,
            status: status, // هنا السر: كله Locked ما عدا الأول
            isRestDay: dayNum % 4 == 0,
          ),
        );
      }
      if (days.isNotEmpty) weeks.add(TrainingWeek(weekNumber: i, days: days));
    }
    _calculateProgress();
    notifyListeners();
  }

  // --- أهم دالة: إنهاء اليوم وفتح التالي ---
  void markDayAsCompleted(int dayNumber) {
    bool found = false;

    // 1. تحويل اليوم الحالي إلى Completed
    for (var week in weeks) {
      for (var day in week.days) {
        if (day.dayNumber == dayNumber) {
          if (day.status != DayStatus.completed) {
            day.status = DayStatus.completed;
            found = true;
          }
          break;
        }
      }
    }

    // 2. فتح اليوم التالي (Unlock Next Day)
    if (found && dayNumber < totalDays) {
      _unlockDay(dayNumber + 1);
    }

    // 3. تحديث شريط التقدم
    _calculateProgress();
    notifyListeners();
  }

  void _unlockDay(int dayNum) {
    for (var week in weeks) {
      for (var day in week.days) {
        if (day.dayNumber == dayNum) {
          day.status = DayStatus.current; // تحويله من Locked لـ Current
          return;
        }
      }
    }
  }

  void _calculateProgress() {
    int completed = 0;
    for (var week in weeks) {
      completed += week.days
          .where((d) => d.status == DayStatus.completed)
          .length;
    }
    daysLeft = totalDays - completed;
    progress = totalDays > 0 ? completed / totalDays : 0.0;
  }
}
