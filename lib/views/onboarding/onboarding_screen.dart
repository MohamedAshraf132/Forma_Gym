import 'package:flutter/material.dart';
import 'package:forma_gym/viewmodels/onboarding_view_model.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
// 1. استدعاء شاشة إدخال البيانات
import '../setup_profile/setup_profile_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<OnboardingViewModel>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 20),

            // 1. مؤشر الخطوات
            Text(
              "Step ${viewModel.currentIndex + 1} of ${viewModel.pages.length}",
              style: const TextStyle(
                // أضفت const لتحسين الأداء
                color: AppColors.primary,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),

            // 2. المحتوى المنزلق
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: viewModel.pages.length,
                onPageChanged: (index) => viewModel.onPageChanged(index),
                itemBuilder: (context, index) {
                  final page = viewModel.pages[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // مكان الصورة
                        Container(
                          height: 300,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: AppColors.primaryLight.withOpacity(0.3),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.fitness_center,
                            size: 100,
                            color: AppColors.primary,
                          ),
                        ),
                        const SizedBox(height: 40),
                        Text(
                          page.title,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textDark,
                          ),
                        ),
                        const SizedBox(height: 15),
                        Text(
                          page.description,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 16,
                            color: AppColors.textLight,
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),

            // 3. الأزرار والنقاط السفلية
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  // --- بداية التعديل في الزر ---
                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton(
                      onPressed: () {
                        // إذا لم نكن في آخر صفحة، تحرك للصفحة التالية
                        if (viewModel.currentIndex <
                            viewModel.pages.length - 1) {
                          _pageController.nextPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeIn,
                          );
                        } else {
                          // إذا كنا في آخر صفحة، انتقل لشاشة إدخال البيانات
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const SetupProfileScreen(),
                            ),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        elevation: 0,
                      ),
                      child: Text(
                        viewModel.currentIndex == viewModel.pages.length - 1
                            ? "Get Started"
                            : "Next",
                        style: const TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),

                  // --- نهاية التعديل ---
                  const SizedBox(height: 20),

                  // نقاط المؤشر
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      viewModel.pages.length,
                      (index) => AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        margin: const EdgeInsets.symmetric(horizontal: 5),
                        height: 10,
                        width: viewModel.currentIndex == index ? 20 : 10,
                        decoration: BoxDecoration(
                          color: viewModel.currentIndex == index
                              ? AppColors.primary
                              : Colors.grey[300],
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
