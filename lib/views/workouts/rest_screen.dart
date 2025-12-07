import 'dart:async';
import 'package:flutter/material.dart';
import 'package:forma_gym/viewmodels/workout_view_model.dart';
import 'package:provider/provider.dart';

class RestScreen extends StatefulWidget {
  final VoidCallback onNext; // دالة يتم استدعاؤها عند انتهاء الوقت
  const RestScreen({super.key, required this.onNext});

  @override
  State<RestScreen> createState() => _RestScreenState();
}

class _RestScreenState extends State<RestScreen> {
  int _timeLeft = 15; // وقت الراحة الافتراضي (يمكن تغييره)
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  void startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_timeLeft > 0) {
        setState(() => _timeLeft--);
      } else {
        _timer?.cancel();
        widget.onNext(); // الانتقال للتمرين التالي
      }
    });
  }

  void addTime() {
    setState(() => _timeLeft += 20);
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<WorkoutViewModel>(context);
    // نجلب التمرين القادم (وليس الحالي) لأنه "NEXT"
    final nextExercise = viewModel.exercises[viewModel.currentExerciseIndex];

    return Scaffold(
      backgroundColor: const Color(0xFF1565C0), // الأزرق الغامق
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(),
            const Text(
              "REST",
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),

            Text(
              "00:${_timeLeft.toString().padLeft(2, '0')}",
              style: const TextStyle(
                color: Colors.white,
                fontSize: 60,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 20),

            // أزرار التحكم في الوقت
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: addTime,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue[400],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 30,
                      vertical: 10,
                    ),
                  ),
                  child: const Text(
                    "+20s",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                const SizedBox(width: 20),
                ElevatedButton(
                  onPressed: widget.onNext, // تخطي الراحة
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 40,
                      vertical: 10,
                    ),
                  ),
                  child: const Text(
                    "Skip",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),

            const Spacer(),

            // معلومات التمرين القادم
            Container(
              width: double.infinity,
              color: Colors.blue[800], // لون أغمق قليلاً في الأسفل
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "NEXT",
                          style: TextStyle(color: Colors.white70, fontSize: 14),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          nextExercise.name.toUpperCase(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          nextExercise.duration, // x4 أو 00:30
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // صورة مصغرة للتمرين القادم (Gif/Image)
                  Image.asset(nextExercise.imageUrl, width: 60, height: 60),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
