import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/training_plan_view_model.dart';
import '../../data/models/training_plan.dart';
import '../../data/models/challenge_plan.dart';
import '../workouts/workout_list_screen.dart';

class TrainingPlanScreen extends StatefulWidget {
  final ChallengePlan plan; // نستقبل الخطة المختارة

  const TrainingPlanScreen({super.key, required this.plan});

  @override
  State<TrainingPlanScreen> createState() => _TrainingPlanScreenState();
}

class _TrainingPlanScreenState extends State<TrainingPlanScreen> {
  @override
  void initState() {
    super.initState();
    // بمجرد فتح الشاشة، نطلب من الـ ViewModel إنشاء الخطة المناسبة
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // استخراج الرقم من النص (مثلاً "28 DAYS" -> 28)
      int days = int.tryParse(widget.plan.duration.split(' ')[0]) ?? 28;

      Provider.of<TrainingPlanViewModel>(
        context,
        listen: false,
      ).createPlan(widget.plan.title, days);
    });
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<TrainingPlanViewModel>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          // 1. الجزء العلوي (يأخذ بياناته من widget.plan)
          SliverAppBar(
            expandedHeight: 250,
            pinned: true,
            backgroundColor: widget.plan.cardColor, // نستخدم لون الكارت
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Image.asset(
                    widget.plan.imageUrl, // نستخدم صورة التحدي المختارة
                    fit: BoxFit.cover,
                    color: Colors.black.withOpacity(0.5),
                    colorBlendMode: BlendMode.darken,
                    alignment: Alignment.topCenter, // عشان تظهر العضلات كويس
                    errorBuilder: (context, error, stackTrace) =>
                        Container(color: widget.plan.cardColor),
                  ),

                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.plan.title, // العنوان المتغير
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 28,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        const SizedBox(height: 15),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "${viewModel.daysLeft} Days left",
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              "${(viewModel.progress * 100).toInt()}%",
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),

                        ClipRRect(
                          borderRadius: BorderRadius.circular(5),
                          child: LinearProgressIndicator(
                            value: viewModel.progress,
                            backgroundColor: Colors.white30,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              widget.plan.cardColor,
                            ), // لون الشريط نفس لون التحدي
                            minHeight: 6,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // 2. قائمة الأسابيع (يتم بناؤها ديناميكياً)
          SliverList(
            delegate: SliverChildBuilderDelegate((context, index) {
              final week = viewModel.weeks[index];
              return _buildWeekSection(context, week, widget.plan.cardColor);
            }, childCount: viewModel.weeks.length),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 100)),
        ],
      ),

      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: SizedBox(
          width: double.infinity,
          height: 60,
          child: ElevatedButton(
            onPressed: () {
              // البحث عن اليوم الحالي (المفتوح) للبدء منه
              TrainingDay? currentDay;

              // نبحث في الأسابيع والأيام عن أول يوم حالته Current
              for (var week in viewModel.weeks) {
                for (var day in week.days) {
                  if (day.status == DayStatus.current) {
                    currentDay = day;
                    break;
                  }
                }
                if (currentDay != null) break;
              }

              // إذا لم نجد يوماً حالياً (ربما كلها مغلقة أو مكتملة)، نأخذ أول يوم كاحتياط
              currentDay ??= viewModel.weeks.first.days.first;

              // الانتقال وتمرير ID التحدي
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => WorkoutListScreen(
                    dayNumber: currentDay!.dayNumber,
                    challengeId: widget.plan.id, // <--- تمرير الـ ID هنا
                  ),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: widget.plan.cardColor, // لون الزر متغير
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              elevation: 8,
            ),
            child: const Text(
              "GO",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }

  // مررنا اللون color ليكون متناسقاً مع التحدي
  Widget _buildWeekSection(
    BuildContext context,
    TrainingWeek week,
    Color themeColor,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.flash_on, color: themeColor, size: 20),
              const SizedBox(width: 5),
              Text(
                "Week ${week.weekNumber}",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: themeColor,
                ),
              ),
              const Spacer(),
              Text(
                "0/${week.days.length}",
                style: const TextStyle(color: Colors.grey),
              ),
            ],
          ),

          const SizedBox(height: 15),

          Container(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Wrap(
              spacing: 15,
              runSpacing: 20,
              alignment: WrapAlignment.center,
              children: week.days
                  .map((day) => _buildDayCircle(context, day, themeColor))
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDayCircle(
    BuildContext context,
    TrainingDay day,
    Color themeColor,
  ) {
    Color bgColor;
    Color textColor;
    Border? border;

    switch (day.status) {
      case DayStatus.completed:
        bgColor = themeColor;
        textColor = Colors.white;
        break;
      case DayStatus.current:
        bgColor = Colors.white;
        textColor = themeColor;
        border = Border.all(color: themeColor, width: 2);
        break;
      case DayStatus.locked:
      default:
        bgColor = Colors.grey[200]!;
        textColor = Colors.grey;
        break;
    }

    bool isTrophyDay =
        day.dayNumber % 7 == 0 ||
        day.dayNumber == Provider.of<TrainingPlanViewModel>(context).totalDays;

    return GestureDetector(
      onTap: () {
        // الشرط: يفتح فقط إذا لم يكن Locked
        if (day.status != DayStatus.locked) {
          Navigator.push(
            context,
            MaterialPageRoute(
              // نمرر رقم اليوم و ID التحدي
              builder: (context) => WorkoutListScreen(
                dayNumber: day.dayNumber,
                challengeId: widget.plan.id, // <--- تمرير الـ ID هنا أيضاً
              ),
            ),
          );
        } else {
          // رسالة توضيحية للمستخدم
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Complete previous days to unlock this!"),
            ),
          );
        }
      },
      child: Container(
        width: 45,
        height: 45,
        decoration: BoxDecoration(
          color: bgColor,
          shape: BoxShape.circle,
          border: border,
        ),
        child: Center(
          child: isTrophyDay
              ? Icon(
                  Icons.emoji_events,
                  size: 24,
                  color: day.status == DayStatus.locked
                      ? Colors.grey
                      : (day.status == DayStatus.completed
                            ? Colors.white
                            : themeColor),
                )
              : Text(
                  "${day.dayNumber}",
                  style: TextStyle(
                    color: textColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
        ),
      ),
    );
  }
}
