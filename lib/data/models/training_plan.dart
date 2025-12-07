// حالة اليوم: مغلق، الحالي، أو مكتمل
enum DayStatus { locked, current, completed }

class TrainingDay {
  final int dayNumber; // رقم اليوم (1, 2, 3...)
  DayStatus status; // حالته
  bool isRestDay; // هل هو يوم راحة؟

  TrainingDay({
    required this.dayNumber,
    this.status = DayStatus.locked,
    this.isRestDay = false,
  });
}

class TrainingWeek {
  final int weekNumber; // رقم الأسبوع
  final List<TrainingDay> days; // قائمة أيام هذا الأسبوع

  TrainingWeek({required this.weekNumber, required this.days});
}
