import 'dart:async';
import 'package:flutter/material.dart';
import '../data/models/exercise.dart';

class WorkoutViewModel extends ChangeNotifier {
  // القائمة الحالية التي ستتغير حسب التحدي المختار
  List<Exercise> _currentExercises = [];

  List<Exercise> get exercises => _currentExercises;

  // --- 1. قواعد بيانات التمارين (Lists) ---

  // قائمة 1: تمارين الجسم الكامل (Full Body) - القائمة التي أرسلتها
  final List<Exercise> _fullBodyExercises = [
    Exercise(
      id: '1',
      name: 'Jumping Jacks',
      duration: '00:20',
      isTimeBased: true,
      imageUrl: 'assets/images/jumping_jacks.png',
      muscleMapImage: 'assets/images/muscle_map_fullbody.png',
      description:
          "1) Stand up, straight back, knees slightly bent, arms down.\n2) Make a mini-jump to land with your legs apart and your hands above your head.\n3) Repeat.",
      focusAreas: [
        "Shoulders",
        "Quadriceps",
        "Adductors",
        "Chest",
        "Glutes",
        "Calves",
      ],
      commonMistakes: [
        "Landing too hard.",
        "Not keeping knees bent.",
        "Not engaging the core.",
      ],
      breathingTips: ["Inhale as you jump apart.", "Exhale as you jump back."],
    ),
    Exercise(
      id: '2',
      name: 'Incline Push-Ups',
      duration: 'x6',
      isTimeBased: false,
      imageUrl: 'assets/images/incline_pushups.png',
      description:
          "Place hands on a bench. Perform a push-up keeping body straight.",
      focusAreas: ["Lower Chest", "Triceps", "Shoulders"],
    ),
    Exercise(
      id: '3',
      name: 'Knee Push-Ups',
      duration: 'x4',
      isTimeBased: false,
      imageUrl: 'assets/images/knee_pushups.png',
      description: "Beginner-friendly push-up on knees.",
      focusAreas: ["Chest", "Triceps", "Shoulders"],
    ),
    Exercise(
      id: '4',
      name: 'Push-Ups',
      duration: 'x4',
      isTimeBased: false,
      imageUrl: 'assets/images/pushups.png',
      description: "Standard push-up targeting chest and triceps.",
      focusAreas: ["Chest", "Triceps", "Shoulders", "Core"],
    ),
    Exercise(
      id: '5',
      name: 'Wide Arm Push-Ups',
      duration: 'x4',
      isTimeBased: false,
      imageUrl: 'assets/images/wide_pushups.png',
      description: "Hands wider than shoulder-width.",
      focusAreas: ["Chest", "Shoulders"],
    ),
    Exercise(
      id: '6',
      name: 'Cobra Stretch',
      duration: '00:20',
      isTimeBased: true,
      imageUrl: 'assets/images/cobra_stretch.png',
      description: "Lie on stomach and push chest up.",
      focusAreas: ["Abs", "Lower Back"],
    ),
    Exercise(
      id: '7',
      name: 'Chest Stretch',
      duration: '00:20',
      isTimeBased: true,
      imageUrl: 'assets/images/chest_stretch.png',
      description: "Clasp hands behind back and lift.",
      focusAreas: ["Chest", "Shoulders"],
    ),
  ];

  // قائمة 2: تمارين البطن (Abs / Belly Fat)
  final List<Exercise> _absExercises = [
    Exercise(
      id: 'abs1',
      name: 'Abdominal Crunches',
      duration: 'x16',
      isTimeBased: false,
      imageUrl: 'assets/images/crunches.png',
      description:
          "Lie on your back, knees bent. Lift your shoulders off the floor.",
      focusAreas: ["Abs"],
    ),
    Exercise(
      id: 'abs2',
      name: 'Mountain Climber',
      duration: '00:30',
      isTimeBased: true,
      imageUrl: 'assets/images/mountain_climber.png',
      description:
          "Start in a plank position. Bring your knee to your chest rapidly.",
      focusAreas: ["Abs", "Cardio", "Legs"],
    ),
    Exercise(
      id: 'abs3',
      name: 'Plank',
      duration: '00:45',
      isTimeBased: true,
      imageUrl: 'assets/images/plank.png',
      description: "Hold your body in a straight line supported by forearms.",
      focusAreas: ["Core", "Abs"],
    ),
    Exercise(
      id: 'abs4',
      name: 'Leg Raises',
      duration: 'x12',
      isTimeBased: false,
      imageUrl: 'assets/images/leg_raises.png',
      description: "Lie flat and lift your legs to a 90-degree angle.",
      focusAreas: ["Lower Abs"],
    ),
  ];

  // قائمة 3: تمارين الذراع/الدامبل (Dumbbell/Arm)
  final List<Exercise> _armExercises = [
    Exercise(
      id: 'arm1',
      name: 'Dumbbell Curl',
      duration: 'x12',
      isTimeBased: false,
      imageUrl: 'assets/images/dumbbell_curl.png',
      description: "Hold dumbbells and curl towards your shoulders.",
      focusAreas: ["Biceps"],
    ),
    Exercise(
      id: 'arm2',
      name: 'Tricep Dips',
      duration: 'x10',
      isTimeBased: false,
      imageUrl: 'assets/images/tricep_dips.png',
      description: "Use a chair to lower and raise your body.",
      focusAreas: ["Triceps"],
    ),
  ];

  // --- 2. الدالة الذكية لتحميل التمارين ---

  void loadExercisesForChallenge(String challengeId, int dayNumber) {
    // تصفير العدادات عند تحميل تحدي جديد
    _currentExerciseIndex = 0;
    _secondsRemaining = 0;
    _timer?.cancel();

    // اختيار القائمة بناءً على ID التحدي
    if (challengeId == 'full_body' || challengeId == 'calisthenics') {
      _currentExercises = List.from(_fullBodyExercises); // نسخة جديدة
    } else if (challengeId.contains('BELLY') || challengeId == 'six_pack') {
      _currentExercises = List.from(_absExercises);
    } else if (challengeId.contains('DUMBBELL') ||
        challengeId.contains('arm')) {
      _currentExercises = List.from(_armExercises);
    } else {
      // افتراضياً نعرض الجسم الكامل لو الـ ID غير معروف
      _currentExercises = List.from(_fullBodyExercises);
    }

    // (اختياري) يمكنك هنا تعديل التمارين بناءً على dayNumber
    // مثلاً: لو اليوم > 10، نزود العدادات
    if (dayNumber > 7) {
      // logic to make exercises harder...
    }

    notifyListeners();
  }

  // --- 3. متغيرات التحكم في التشغيل (Timer Logic) ---
  int _currentExerciseIndex = 0;
  Timer? _timer;
  int _secondsRemaining = 0;
  bool _isTimerRunning = false;

  int get currentExerciseIndex => _currentExerciseIndex;
  // التأكد من أن القائمة ليست فارغة لتجنب الأخطاء
  Exercise get currentExercise => _currentExercises.isNotEmpty
      ? _currentExercises[_currentExerciseIndex]
      : _fullBodyExercises[0];

  int get secondsRemaining => _secondsRemaining;
  bool get isTimerRunning => _isTimerRunning;

  double get workoutProgress => _currentExercises.isNotEmpty
      ? (_currentExerciseIndex + 1) / _currentExercises.length
      : 0.0;

  // --- 4. دوال التحكم ---

  void initWorkout() {
    // نبدأ دائماً من أول تمرين في القائمة المحملة
    _currentExerciseIndex = 0;
    _setupExercise();
  }

  void _setupExercise() {
    if (_currentExercises.isEmpty) return;

    String durationStr = currentExercise.duration;

    if (durationStr.contains('00:') ||
        durationStr.contains('min') ||
        currentExercise.isTimeBased) {
      // استخراج الوقت (بسيط جداً، يمكن تحسينه)
      if (durationStr.contains('00:')) {
        int seconds = int.tryParse(durationStr.split(':')[1]) ?? 30;
        _secondsRemaining = seconds;
      } else {
        _secondsRemaining = 30; // افتراضي
      }

      startTimer();
    } else {
      _secondsRemaining = 0;
      _isTimerRunning = false;
      _timer?.cancel();
    }
    notifyListeners();
  }

  void startTimer() {
    _isTimerRunning = true;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsRemaining > 0) {
        _secondsRemaining--;
        notifyListeners();
      } else {
        nextExercise();
      }
    });
    notifyListeners();
  }

  void pauseTimer() {
    _timer?.cancel();
    _isTimerRunning = false;
    notifyListeners();
  }

  void nextExercise() {
    _timer?.cancel();

    if (_currentExerciseIndex < _currentExercises.length - 1) {
      _currentExerciseIndex++;
      _setupExercise();
    } else {
      _isTimerRunning = false;
      // Workout Finished Logic handled in UI
    }
    notifyListeners();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
