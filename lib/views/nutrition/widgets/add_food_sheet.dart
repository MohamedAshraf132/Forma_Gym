import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../data/models/food_item.dart';
import '../../../../viewmodels/nutrition_view_model.dart';

class AddFoodSheet extends StatefulWidget {
  final MealType type;
  final NutritionViewModel vm;

  const AddFoodSheet({super.key, required this.type, required this.vm});

  @override
  State<AddFoodSheet> createState() => _AddFoodSheetState();
}

class _AddFoodSheetState extends State<AddFoodSheet>
    with SingleTickerProviderStateMixin {
  List<FoodItem> filteredFoods = [];
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    filteredFoods = widget.vm.availableFoods;

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
      lowerBound: 0.95,
      upperBound: 1.0,
    )..forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.85,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      expand: false,
      builder: (context, scrollController) {
        return Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.white, Colors.grey.shade100],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 15,
                offset: const Offset(0, -5),
              ),
              BoxShadow(
                color: Colors.white.withOpacity(0.7),
                blurRadius: 10,
                offset: const Offset(0, -3),
              ),
            ],
          ),
          child: Column(
            children: [
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
              const SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Add Food",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  TextButton.icon(
                    onPressed: () => _showCustomEntryDialog(context),
                    icon: const Icon(Icons.edit, size: 18),
                    label: const Text("Create New"),
                    style: TextButton.styleFrom(
                      foregroundColor: AppColors.primary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 15),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.03),
                      blurRadius: 5,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: TextField(
                  onChanged: (value) {
                    setState(() {
                      filteredFoods = widget.vm.availableFoods
                          .where(
                            (food) => food.name.toLowerCase().contains(
                              value.toLowerCase(),
                            ),
                          )
                          .toList();
                    });
                  },
                  decoration: const InputDecoration(
                    icon: Icon(Icons.search, color: Colors.grey),
                    hintText: "Search for food...",
                    border: InputBorder.none,
                  ),
                ),
              ),
              const SizedBox(height: 15),
              Expanded(
                child: ListView.separated(
                  controller: scrollController,
                  itemCount: filteredFoods.length,
                  separatorBuilder: (c, i) => const SizedBox(height: 10),
                  itemBuilder: (context, index) {
                    final food = filteredFoods[index];

                    return ScaleTransition(
                      scale: Tween<double>(begin: 0.95, end: 1.0).animate(
                        CurvedAnimation(
                          parent: _controller,
                          curve: Curves.easeOut,
                        ),
                      ),
                      child: Material(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                        elevation: 2,
                        child: ListTile(
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 5,
                          ),
                          leading: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.asset(
                              food.imageUrl,
                              width: 50,
                              height: 50,
                              fit: BoxFit.cover,
                              errorBuilder: (c, e, s) => Container(
                                width: 50,
                                height: 50,
                                color: Colors.grey[200],
                                child: const Icon(
                                  Icons.fastfood,
                                  color: Colors.orange,
                                ),
                              ),
                            ),
                          ),
                          title: Text(
                            food.name,
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
                          ),
                          subtitle: Text(
                            "${food.calories} kcal • ${food.protein}g P",
                            style: const TextStyle(color: Colors.grey),
                          ),
                          trailing: const Icon(
                            Icons.add_circle_outline,
                            color: AppColors.primary,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          onTap: () {
                            int remainingCalories =
                                (widget.vm.targetCalories -
                                        widget.vm.consumedCalories)
                                    .clamp(0, widget.vm.targetCalories.toInt());

                            if (remainingCalories == 0) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    "Its Done Today !",
                                    textAlign: TextAlign.center,
                                  ),
                                  backgroundColor: Colors.red,
                                  duration: Duration(seconds: 2),
                                ),
                              );
                              return;
                            }

                            widget.vm.addFood(food, widget.type);
                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text("${food.name} added!"),
                                backgroundColor: AppColors.primary,
                                duration: const Duration(seconds: 1),
                              ),
                            );
                          },
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showCustomEntryDialog(BuildContext context) {
    final nameController = TextEditingController();
    final calsController = TextEditingController();
    final proteinController = TextEditingController();
    final carbsController = TextEditingController();
    final fatController = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) {
        return TweenAnimationBuilder<double>(
          tween: Tween(begin: 0.8, end: 1.0),
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
          builder: (context, scale, child) {
            return Transform.scale(scale: scale, child: child);
          },
          child: AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            backgroundColor: Colors.white,
            title: const Text(
              "Add Custom Food",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Food Name",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  _buildCustomTextField(nameController, "", Icons.fastfood),
                  const SizedBox(height: 10),
                  const Text(
                    "Calories (kcal)",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  _buildCustomTextField(
                    calsController,
                    "",
                    Icons.local_fire_department,
                    isNumber: true,
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "Protein (g)",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  _buildCustomTextField(
                    proteinController,
                    "",
                    Icons.fitness_center,
                    isNumber: true,
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "Carbs (g)",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  _buildCustomTextField(
                    carbsController,
                    "",
                    Icons.grain,
                    isNumber: true,
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "Fat (g)",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  _buildCustomTextField(
                    fatController,
                    "",
                    Icons.emoji_food_beverage,
                    isNumber: true,
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: const Text(
                  "Cancel",
                  style: TextStyle(color: Colors.grey),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  if (nameController.text.isEmpty ||
                      calsController.text.isEmpty)
                    return;

                  int remainingCalories =
                      (widget.vm.targetCalories - widget.vm.consumedCalories)
                          .clamp(0, widget.vm.targetCalories.toInt());

                  if (remainingCalories == 0) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          "It Is Done Today!",
                          textAlign: TextAlign.center,
                        ),
                        backgroundColor: Colors.red,
                        duration: Duration(seconds: 2),
                      ),
                    );
                    return;
                  }

                  final newFood = FoodItem(
                    id: DateTime.now().toString(),
                    name: nameController.text,
                    calories: int.tryParse(calsController.text) ?? 0,
                    protein: double.tryParse(proteinController.text) ?? 0,
                    carbs: double.tryParse(carbsController.text) ?? 0,
                    fat: double.tryParse(fatController.text) ?? 0,
                    imageUrl: "assets/images/food_placeholder.png",
                    isCustom: true,
                  );

                  widget.vm.addNewCustomFood(newFood);
                  widget.vm.addFood(newFood, widget.type);
                  Navigator.pop(ctx);

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Food Saved & Added!"),
                      backgroundColor: Colors.green,
                      duration: Duration(seconds: 1),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                child: const Text("Add", style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildCustomTextField(
    TextEditingController controller,
    String label,
    IconData icon, {
    bool isNumber = false,
  }) {
    return TextField(
      controller: controller,
      keyboardType: isNumber ? TextInputType.number : TextInputType.text,
      decoration: InputDecoration(
        prefixIcon: icon != Icons.fastfood
            ? Icon(icon, color: AppColors.primary)
            : null,
        labelText: label.isNotEmpty ? label : null,
        filled: true,
        fillColor: Colors.grey.shade100,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 12,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(color: AppColors.primary),
        ),
      ),
    );
  }
}
