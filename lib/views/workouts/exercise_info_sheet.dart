import 'package:flutter/material.dart';
import '../../data/models/exercise.dart';

class ExerciseInfoSheet extends StatefulWidget {
  final Exercise exercise;
  const ExerciseInfoSheet({super.key, required this.exercise});

  @override
  State<ExerciseInfoSheet> createState() => _ExerciseInfoSheetState();
}

class _ExerciseInfoSheetState extends State<ExerciseInfoSheet> {
  // للتحكم في التبويبات العلوية
  int _selectedTab = 0; // 0: Animation, 1: Muscle, 2: How to do

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.90, // ارتفاع 90%
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        children: [
          // 1. Header (Title + Replace Button)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.exercise.name.toUpperCase(),
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.swap_horiz, color: Colors.blue),
                  label: const Text(
                    "Replace",
                    style: TextStyle(color: Colors.blue),
                  ),
                ),
              ],
            ),
          ),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 2. Animation / Image Area
                  Container(
                    height: 200,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Image.asset(
                      widget.exercise.imageUrl,
                      fit: BoxFit.contain,
                    ),
                  ),

                  const SizedBox(height: 20),

                  // 3. Custom Tab Bar (Animation, Muscle, How to do)
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: Row(
                      children: [
                        _buildTabButton("Animation", 0),
                        _buildTabButton("Muscle", 1),
                        _buildTabButton("How to do", 2),
                      ],
                    ),
                  ),

                  const SizedBox(height: 25),

                  // 4. Duration / Repeats Controller
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        widget.exercise.isTimeBased ? "DURATION" : "REPEATS",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                          fontSize: 16,
                        ),
                      ),
                      Row(
                        children: [
                          _buildCircleButton(Icons.remove),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 15),
                            child: Text(
                              widget.exercise.duration,
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          _buildCircleButton(Icons.add),
                        ],
                      ),
                    ],
                  ),

                  const SizedBox(height: 25),

                  // 5. Instructions
                  _buildSectionTitle("INSTRUCTIONS"),
                  Text(
                    widget.exercise.description,
                    style: const TextStyle(
                      color: Colors.grey,
                      height: 1.5,
                      fontSize: 15,
                    ),
                  ),

                  const SizedBox(height: 25),

                  // 6. Focus Area (Chips)
                  if (widget.exercise.focusAreas.isNotEmpty) ...[
                    _buildSectionTitle("FOCUS AREA"),
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: widget.exercise.focusAreas
                          .map((area) => _buildChip(area))
                          .toList(),
                    ),
                    const SizedBox(height: 20),

                    // Muscle Map Image (صورة الجسم الأزرق)
                    Center(
                      child: Image.asset(
                        widget.exercise.muscleMapImage,
                        height: 200,
                        errorBuilder: (c, e, s) =>
                            const SizedBox(), // إخفاء لو الصورة مش موجودة
                      ),
                    ),
                    const SizedBox(height: 25),
                  ],

                  // 7. Common Mistakes
                  if (widget.exercise.commonMistakes.isNotEmpty) ...[
                    _buildSectionTitle("COMMON MISTAKES"),
                    ...widget.exercise.commonMistakes.asMap().entries.map((
                      entry,
                    ) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 15),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: Colors.blue.withOpacity(0.1),
                                shape: BoxShape.circle,
                              ),
                              child: Text(
                                "${entry.key + 1}",
                                style: const TextStyle(
                                  color: Colors.blue,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const SizedBox(width: 15),
                            Expanded(
                              child: Text(
                                entry.value,
                                style: const TextStyle(
                                  height: 1.4,
                                  color: Colors.black87,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ],

                  // 8. Breathing Tips
                  if (widget.exercise.breathingTips.isNotEmpty) ...[
                    _buildSectionTitle("BREATHING TIPS"),
                    ...widget.exercise.breathingTips
                        .map(
                          (tip) => Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.circle,
                                  size: 8,
                                  color: Colors.blue,
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Text(
                                    tip,
                                    style: const TextStyle(
                                      color: Colors.black87,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                        .toList(),
                  ],

                  const SizedBox(height: 80), // مساحة للزر السفلي
                ],
              ),
            ),
          ),

          // 9. Close Button
          Padding(
            padding: const EdgeInsets.all(20),
            child: SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(
                    0xFF0066FF,
                  ), // اللون الأزرق من الصورة
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: const Text(
                  "CLOSE",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --- Helper Widgets ---

  Widget _buildTabButton(String text, int index) {
    bool isSelected = _selectedTab == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _selectedTab = index),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFF0066FF) : Colors.transparent,
            borderRadius: BorderRadius.circular(25),
          ),
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.grey,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCircleButton(IconData icon) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(10),
      ),
      child: Icon(icon, size: 20, color: Colors.black),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Text(
        title,
        style: const TextStyle(
          color: Color(0xFF0066FF),
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
      ),
    );
  }

  Widget _buildChip(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFF0F4FF), // أزرق فاتح جداً
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.circle, size: 8, color: Color(0xFF0066FF)),
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
}
