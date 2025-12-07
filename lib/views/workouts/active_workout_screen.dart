import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/workout_view_model.dart';
import 'rest_screen.dart'; // تأكد أنك أنشأت هذا الملف كما في الخطوة السابقة
import 'exercise_info_sheet.dart'; // تأكد أنك أنشأت هذا الملف كما في الخطوة السابقة

class ActiveWorkoutScreen extends StatefulWidget {
  const ActiveWorkoutScreen({super.key});

  @override
  State<ActiveWorkoutScreen> createState() => _ActiveWorkoutScreenState();
}

class _ActiveWorkoutScreenState extends State<ActiveWorkoutScreen> {
  // متغير للتحكم في ظهور شاشة الراحة
  bool isResting = false;

  @override
  void initState() {
    super.initState();
    // تهيئة التمرين عند فتح الشاشة لأول مرة
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<WorkoutViewModel>(context, listen: false).initWorkout();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<WorkoutViewModel>(
      builder: (context, viewModel, child) {
        // 1. إذا كنا في وضع الراحة، اعرض شاشة RestScreen
        if (isResting) {
          return RestScreen(
            onNext: () {
              // عند انتهاء وقت الراحة، نعود للشاشة البيضاء
              setState(() {
                isResting = false;
              });
            },
          );
        }

        // 2. إذا لم نكن في راحة، اعرض شاشة التمرين الحالية
        final exercise = viewModel.currentExercise;

        return Scaffold(
          backgroundColor: Colors.white,

          // الشريط العلوي (أزرار التحكم)
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.black),
              onPressed: () => Navigator.pop(context),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.videocam_outlined, color: Colors.grey),
                onPressed: () {
                  // كود تشغيل الفيديو
                },
              ),
              IconButton(
                icon: const Icon(Icons.volume_up_outlined, color: Colors.grey),
                onPressed: () {
                  // كود الصوت
                },
              ),
              IconButton(
                icon: const Icon(Icons.info_outline, color: Colors.grey),
                onPressed: () {
                  // فتح شاشة التفاصيل (التبويبات)
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    backgroundColor: Colors.transparent,
                    builder: (c) => ExerciseInfoSheet(exercise: exercise),
                  );
                },
              ),
            ],
          ),

          body: SafeArea(
            child: Column(
              children: [
                // أ. مساحة الفيديو أو الصورة المتحركة
                Expanded(
                  flex: 4,
                  child: Center(
                    // هنا يتم عرض صورة التمرين
                    child: Image.asset(
                      exercise.imageUrl,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) {
                        return const Icon(
                          Icons.fitness_center,
                          size: 100,
                          color: Colors.grey,
                        );
                      },
                    ),
                  ),
                ),

                // ب. اسم التمرين والعداد
                Expanded(
                  flex: 3,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Text(
                          exercise.name.toUpperCase(),
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      // العداد الكبير (مثل x4 أو الوقت)
                      Text(
                        exercise.duration,
                        style: const TextStyle(
                          fontSize: 60,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),

                // ج. زر Done الكبير والأزرار السفلية
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 30.0,
                    vertical: 20.0,
                  ),
                  child: Column(
                    children: [
                      // زر DONE الأزرق
                      SizedBox(
                        width: double.infinity,
                        height: 55,
                        child: ElevatedButton(
                          onPressed: () {
                            if (viewModel.currentExerciseIndex <
                                viewModel.exercises.length - 1) {
                              // 1. جهز التمرين التالي
                              viewModel.nextExercise();
                              // 2. أظهر شاشة الراحة
                              setState(() {
                                isResting = true;
                              });
                            } else {
                              // انتهى التمرين بالكامل
                              _showFinishDialog(context);
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(
                              0xFF0066FF,
                            ), // الأزرق حسب الصورة
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            elevation: 0,
                          ),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.check, color: Colors.white),
                              SizedBox(width: 10),
                              Text(
                                "DONE",
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      // أزرار التنقل السفلية (Previous | Skip)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TextButton.icon(
                            onPressed: () {
                              // كود الرجوع للتمرين السابق (يمكن إضافته في ViewModel)
                            },
                            icon: const Icon(
                              Icons.skip_previous,
                              color: Colors.grey,
                            ),
                            label: const Text(
                              "Previous",
                              style: TextStyle(color: Colors.grey),
                            ),
                          ),
                          TextButton.icon(
                            onPressed: () {
                              // تخطي التمرين الحالي والانتقال للراحة
                              viewModel.nextExercise();
                              setState(() => isResting = true);
                            },
                            label: const Text(
                              "Skip",
                              style: TextStyle(color: Colors.grey),
                            ),
                            icon: const Icon(
                              Icons.skip_next,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showFinishDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text("Good Job!"),
        content: const Text("You have completed the full body challenge!"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              Navigator.pop(context);
            },
            child: const Text(
              "Finish",
              style: TextStyle(color: Color(0xFF0066FF)),
            ),
          ),
        ],
      ),
    );
  }
}
