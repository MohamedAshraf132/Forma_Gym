class Exercise {
  final String id;
  final String name;
  final String duration; // "00:20" or "x15"
  final bool isTimeBased; // هل هو وقت أم عدات
  final String imageUrl;
  final String description;
  final List<String> focusAreas; // المناطق المستهدفة (Shoulders, Quads...)
  final List<String> commonMistakes; // الأخطاء الشائعة
  final List<String> breathingTips; // نصائح التنفس
  final String muscleMapImage; // صورة التشريح العضلي (صورة الجسم الأزرق)

  Exercise({
    required this.id,
    required this.name,
    required this.duration,
    this.isTimeBased = false,
    required this.imageUrl,
    this.description = "",
    this.focusAreas = const [],
    this.commonMistakes = const [],
    this.breathingTips = const [],
    this.muscleMapImage =
        "assets/images/muscle_map_placeholder1.png", // صورة افتراضية
  });
}
