import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../data/models/exercise.dart';

class ExerciseDetailScreen extends StatelessWidget {
  final Exercise exercise;

  const ExerciseDetailScreen({super.key, required this.exercise});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // 1. صورة التمرين (خلفية كاملة في الأعلى)
          Container(
            height: 400,
            width: double.infinity,
            color: AppColors.primaryLight.withOpacity(0.2),
            child: Center(
              // عرض الصورة الحقيقية أو أيقونة احتياطية
              child: Image.asset(
                exercise.imageUrl,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  return Icon(
                    Icons.fitness_center,
                    size: 120,
                    color: AppColors.primary,
                  );
                },
              ),
            ),
          ),

          // زر الرجوع
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.white,
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.black),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // 2. تفاصيل التمرين (Sheet من الأسفل)
          DraggableScrollableSheet(
            initialChildSize: 0.6,
            minChildSize: 0.6,
            maxChildSize: 0.9,
            builder: (context, scrollController) {
              return Container(
                padding: const EdgeInsets.all(25),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(40),
                    topRight: Radius.circular(40),
                  ),
                ),
                child: ListView(
                  controller: scrollController,
                  children: [
                    // مقبض صغير للسحب
                    Center(
                      child: Container(
                        width: 50,
                        height: 5,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // العنوان والمدة
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            exercise.name,
                            style: const TextStyle(
                              fontSize: 26,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textDark,
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 15,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            exercise.duration,
                            style: const TextStyle(
                              color: AppColors.primary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 25),

                    // الوصف العام (INSTRUCTIONS)
                    const Text(
                      "INSTRUCTIONS",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      exercise.description,
                      style: const TextStyle(
                        color: Colors.grey,
                        height: 1.5,
                        fontSize: 16,
                      ),
                    ),

                    const SizedBox(height: 25),

                    // المناطق المستهدفة (FOCUS AREA) - بديل الخطوات القديمة
                    if (exercise.focusAreas.isNotEmpty) ...[
                      const Text(
                        "FOCUS AREA",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Wrap(
                        spacing: 10,
                        runSpacing: 10,
                        children: exercise.focusAreas
                            .map((area) => _buildChip(area))
                            .toList(),
                      ),
                      const SizedBox(height: 20),

                      // صورة العضلات (Muscle Map)
                      Center(
                        child: Image.asset(
                          exercise.muscleMapImage,
                          height: 200,
                          errorBuilder: (c, e, s) => const SizedBox(),
                        ),
                      ),
                      const SizedBox(height: 25),
                    ],

                    // الأخطاء الشائعة (COMMON MISTAKES)
                    if (exercise.commonMistakes.isNotEmpty) ...[
                      const Text(
                        "COMMON MISTAKES",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                      ),
                      const SizedBox(height: 10),
                      ...exercise.commonMistakes.map(
                        (mistake) => _buildMistakeItem(mistake),
                      ),
                      const SizedBox(height: 25),
                    ],

                    const SizedBox(height: 50), // مساحة إضافية في الأسفل
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  // ودجت لعرض الـ Chips (للمناطق المستهدفة)
  Widget _buildChip(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFF0F4FF),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.circle, size: 8, color: AppColors.primary),
          const SizedBox(width: 8),
          Text(
            label,
            style: const TextStyle(
              color: Colors.black87,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  // ودجت لعرض الأخطاء الشائعة
  Widget _buildMistakeItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.warning_amber_rounded,
            color: Colors.orange,
            size: 20,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(color: AppColors.textDark, height: 1.4),
            ),
          ),
        ],
      ),
    );
  }
}
