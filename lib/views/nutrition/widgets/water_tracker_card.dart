import 'package:flutter/material.dart';
import '../../../../viewmodels/nutrition_view_model.dart';
import '../../../../core/constants/app_colors.dart';

class WaterTrackerCard extends StatefulWidget {
  final NutritionViewModel vm;

  const WaterTrackerCard({super.key, required this.vm});

  @override
  State<WaterTrackerCard> createState() => _WaterTrackerCardState();
}

class _WaterTrackerCardState extends State<WaterTrackerCard>
    with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 25),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blue[50]!, Colors.blue[100]!],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withOpacity(0.2),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        children: [
          // رأس الكارد
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.water_drop,
                    color: AppColors.primary,
                    size: 30,
                  ),
                  const SizedBox(width: 10),
                  const Text(
                    "Water Tracker",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
              Text(
                "${widget.vm.consumedWater} / ${widget.vm.waterGoal} Cups",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  foreground: Paint()
                    ..shader = LinearGradient(
                      colors: [
                        AppColors.primary.withOpacity(0.8),
                        AppColors.primary,
                      ],
                    ).createShader(const Rect.fromLTWH(0.0, 0.0, 200.0, 70.0)),
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),
          Text(
            "Goal: ${(widget.vm.waterGoal * 250) / 1000} Liters",
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),

          const SizedBox(height: 25),

          // رسم الأكواب
          Center(
            child: Wrap(
              spacing: 18,
              runSpacing: 18,
              children: List.generate(widget.vm.waterGoal, (index) {
                bool isFull = index < widget.vm.consumedWater;

                return GestureDetector(
                  onTap: () {
                    setState(() {
                      isFull
                          ? widget.vm.removeWaterCup()
                          : widget.vm.drinkWater();
                    });
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOutBack,
                    height: 50,
                    width: 35,
                    decoration: BoxDecoration(
                      gradient: isFull
                          ? const LinearGradient(
                              colors: [Colors.blue, Colors.lightBlueAccent],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                            )
                          : null,
                      color: isFull ? null : Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isFull ? Colors.blue : Colors.grey.shade300,
                        width: 2,
                      ),
                      boxShadow: isFull
                          ? [
                              BoxShadow(
                                color: Colors.blue.withOpacity(0.4),
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                              ),
                            ]
                          : [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.1),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                    ),
                    child: isFull
                        ? const Icon(
                            Icons.local_drink,
                            color: Colors.white,
                            size: 22,
                          )
                        : null,
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}
