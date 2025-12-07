import 'package:flutter/material.dart';
import 'package:forma_gym/viewmodels/profile_view_model.dart';
import 'package:forma_gym/views/home/home_screen.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';

class SetupProfileScreen extends StatelessWidget {
  const SetupProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // استدعاء الـ ViewModel
    final viewModel = Provider.of<ProfileViewModel>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          "Step 3 of 3",
          style: TextStyle(color: AppColors.primary),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              "Personal Details",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColors.textDark,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              "Let us know about you to speed up the result, Get fit with your personal workout plan!",
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.textLight, fontSize: 14),
            ),
            const SizedBox(height: 30),

            // 1. Apple Health Switch
            _buildListTile(
              title: "Apple Health",
              subtitle: "Allow access to fill parameters",
              trailing: Switch(
                value: viewModel.useAppleHealth,
                onChanged: (val) => viewModel.toggleAppleHealth(val),
                activeColor: AppColors.primary,
              ),
            ),
            const Divider(),

            // 2. Birthday Picker
            InkWell(
              onTap: () async {
                DateTime? picked = await showDatePicker(
                  context: context,
                  initialDate: DateTime(1995),
                  firstDate: DateTime(1950),
                  lastDate: DateTime.now(),
                  builder: (context, child) {
                    return Theme(
                      data: ThemeData.light().copyWith(
                        colorScheme: ColorScheme.light(
                          primary: AppColors.primary,
                        ),
                      ),
                      child: child!,
                    );
                  },
                );
                if (picked != null) viewModel.setBirthday(picked);
              },
              child: _buildListTile(
                title: "Birthday",
                trailing: Text(
                  viewModel.birthDateString,
                  style: const TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const Divider(),

            // 3. Height Slider
            _buildLabel("Height", "${viewModel.height.toInt()} cm"),
            Slider(
              value: viewModel.height,
              min: 100,
              max: 220,
              activeColor: AppColors.primary,
              inactiveColor: AppColors.primaryLight,
              onChanged: (val) => viewModel.setHeight(val),
            ),

            // 4. Weight Slider
            _buildLabel("Weight", "${viewModel.weight.toInt()} kg"),
            Slider(
              value: viewModel.weight,
              min: 30,
              max: 150,
              activeColor: AppColors.primary,
              inactiveColor: AppColors.primaryLight,
              onChanged: (val) => viewModel.setWeight(val),
            ),

            const SizedBox(height: 20),

            // 5. Gender Selection
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Gender",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 15),
            Row(
              children: [
                Expanded(child: _buildGenderButton(context, "Male", viewModel)),
                const SizedBox(width: 20),
                Expanded(
                  child: _buildGenderButton(context, "Female", viewModel),
                ),
              ],
            ),

            const SizedBox(height: 40),

            // 6. Start Button
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: () {
                  viewModel.saveDataAndStart(context); // حفظ البيانات

                  // الانتقال للشاشة الرئيسية وحذف الصفحات السابقة من الذاكرة
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => const HomeScreen()),
                    (route) => false,
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  elevation: 5,
                  shadowColor: AppColors.primary.withOpacity(0.4),
                ),
                child: const Text(
                  "Start",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- Helper Widgets لتنظيف الكود ---

  Widget _buildListTile({
    required String title,
    String? subtitle,
    required Widget trailing,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textDark,
                ),
              ),
              if (subtitle != null) ...[
                const SizedBox(height: 5),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textLight,
                  ),
                ),
              ],
            ],
          ),
          trailing,
        ],
      ),
    );
  }

  Widget _buildLabel(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.textDark,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGenderButton(
    BuildContext context,
    String gender,
    ProfileViewModel vm,
  ) {
    bool isSelected = vm.gender == gender;
    return GestureDetector(
      onTap: () => vm.setGender(gender),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 15),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : Colors.white,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: isSelected ? AppColors.primary : Colors.grey.shade300,
          ),
        ),
        child: Center(
          child: Text(
            gender,
            style: TextStyle(
              color: isSelected ? Colors.white : AppColors.textLight,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }
}
