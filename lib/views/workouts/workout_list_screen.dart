import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../viewmodels/workout_view_model.dart';
import '../../viewmodels/training_plan_view_model.dart';
import 'active_workout_screen.dart';
import 'exercise_detail_screen.dart';

class WorkoutListScreen extends StatefulWidget {
  final int dayNumber;
  final String challengeId; // متغير لتحديد نوع التحدي

  const WorkoutListScreen({
    super.key,
    required this.dayNumber,
    required this.challengeId,
  });

  @override
  State<WorkoutListScreen> createState() => _WorkoutListScreenState();
}

class _WorkoutListScreenState extends State<WorkoutListScreen> {
  @override
  void initState() {
    super.initState();
    // عند فتح الشاشة، نطلب تحميل التمارين الخاصة بهذا التحدي
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<WorkoutViewModel>(
        context,
        listen: false,
      ).loadExercisesForChallenge(widget.challengeId, widget.dayNumber);
    });
  }

  @override
  Widget build(BuildContext context) {
    // نستمع للتغييرات في WorkoutViewModel لعرض التمارين المحملة
    final workoutViewModel = Provider.of<WorkoutViewModel>(context);

    // حساب مدة التمارين وعددها
    int exerciseCount = workoutViewModel.exercises.length;
    String totalDuration = "${exerciseCount * 2} mins";

    return Scaffold(
      backgroundColor: const Color(0xFFF4F6FA), // خلفية رمادية فاتحة
      body: SafeArea(
        child: Column(
          children: [
            // 1. Header (صورة علوية + زر رجوع)
            Stack(
              children: [
                Container(
                  height: 180,
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: AppColors.primaryLight,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(30),
                      bottomRight: Radius.circular(30),
                    ),
                    image: DecorationImage(
                      // يمكنك تغيير الصورة هنا بناءً على التحدي إذا أردت
                      image: AssetImage(
                        'assets/images/full_body_challenge1.png',
                      ),
                      fit: BoxFit.cover,
                      opacity: 0.8,
                    ),
                  ),
                ),
                Positioned(
                  top: 10,
                  left: 10,
                  child: CircleAvatar(
                    backgroundColor: Colors.white24,
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 20,
                  left: 20,
                  child: Text(
                    "DAY ${widget.dayNumber}", // رقم اليوم الديناميكي
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                      shadows: [Shadow(blurRadius: 10, color: Colors.black45)],
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 15),

            // 2. كروت المعلومات
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  _buildInfoCard("Duration", totalDuration, Icons.timer),
                  const SizedBox(width: 15),
                  _buildInfoCard(
                    "Exercises",
                    "$exerciseCount",
                    Icons.fitness_center,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // 3. عنوان القائمة
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Exercises",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: const Text(
                      "Edit",
                      style: TextStyle(color: AppColors.primary),
                    ),
                  ),
                ],
              ),
            ),

            // 4. قائمة التمارين
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: workoutViewModel.exercises.length,
                itemBuilder: (context, index) {
                  final exercise = workoutViewModel.exercises[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              ExerciseDetailScreen(exercise: exercise),
                        ),
                      );
                    },
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 15),
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.05),
                            blurRadius: 10,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          // صورة مصغرة للتمرين
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.asset(
                              exercise.imageUrl,
                              width: 70,
                              height: 70,
                              fit: BoxFit.cover,
                              errorBuilder: (c, e, s) => Container(
                                width: 70,
                                height: 70,
                                color: Colors.grey[200],
                                child: const Icon(Icons.fitness_center),
                              ),
                            ),
                          ),
                          const SizedBox(width: 15),

                          // النصوص
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  exercise.name,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  exercise.duration,
                                  style: const TextStyle(
                                    color: Colors.grey,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const Icon(Icons.drag_handle, color: Colors.grey),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

            // 5. زر إنهاء اليوم
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: () {
                    // منطق إنهاء اليوم وفتح اليوم التالي
                    Provider.of<TrainingPlanViewModel>(
                      context,
                      listen: false,
                    ).markDayAsCompleted(widget.dayNumber);

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          "Great job! Day ${widget.dayNumber} Completed.",
                        ),
                      ),
                    );

                    Navigator.pop(context); // الرجوع للخطة
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    elevation: 5,
                  ),
                  child: const Text(
                    "START & COMPLETE DAY",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard(String label, String value, IconData icon) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 15),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          children: [
            Text(
              value,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 5),
            Text(
              label,
              style: const TextStyle(color: Colors.grey, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}
