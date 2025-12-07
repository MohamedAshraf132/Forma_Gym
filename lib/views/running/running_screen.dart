import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart'; // الخرائط المجانية
import 'package:latlong2/latlong.dart'; // الإحداثيات
import 'package:provider/provider.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';
import '../../core/constants/app_colors.dart';
import '../../viewmodels/running_view_model.dart';

class RunningScreen extends StatefulWidget {
  const RunningScreen({super.key});

  @override
  State<RunningScreen> createState() => _RunningScreenState();
}

class _RunningScreenState extends State<RunningScreen> {
  @override
  void initState() {
    super.initState();
    // تهيئة الموقع عند فتح الشاشة
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<RunningViewModel>(context, listen: false).initLocation();
    });
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<RunningViewModel>(context);

    return Scaffold(
      body: Stack(
        children: [
          // 1. خريطة OpenStreetMap
          FlutterMap(
            mapController: viewModel.mapController,
            options: MapOptions(
              initialCenter: const LatLng(30.0444, 31.2357), // القاهرة (مبدئي)
              initialZoom: 15.0,
            ),
            children: [
              // الطبقة الأولى: صور الخريطة (Tiles)
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                // 👇👇 تم تصحيح الاسم هنا ليطابق مشروعك 👇👇
                userAgentPackageName: 'com.example.forma_gym',
                // 👆👆
              ),

              // الطبقة الثانية: خط المسار (Polyline)
              PolylineLayer(
                polylines: [
                  Polyline(
                    points: viewModel.routePoints,
                    strokeWidth: 5.0,
                    color: Colors.blue,
                  ),
                ],
              ),

              // الطبقة الثالثة: علامة الموقع الحالي (Marker)
              if (viewModel.currentLocation != null)
                MarkerLayer(
                  markers: [
                    Marker(
                      point: viewModel.currentLocation!,
                      width: 80,
                      height: 80,
                      child: const Icon(
                        Icons.my_location,
                        color: Colors.red,
                        size: 30,
                      ),
                    ),
                  ],
                ),
            ],
          ),

          // زر الرجوع
          Positioned(
            top: 50,
            left: 20,
            child: CircleAvatar(
              backgroundColor: Colors.white,
              child: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.black),
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ),

          // 2. لوحة البيانات السفلية
          Positioned(
            bottom: 30,
            left: 20,
            right: 20,
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(25),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 15,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // عداد الوقت
                  StreamBuilder<int>(
                    stream: viewModel.timerStream,
                    initialData: 0,
                    builder: (context, snapshot) {
                      final value = snapshot.data;
                      final displayTime = StopWatchTimer.getDisplayTime(
                        value!,
                        milliSecond: false,
                      );
                      return Text(
                        displayTime,
                        style: const TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textDark,
                        ),
                      );
                    },
                  ),
                  const Text(
                    "DURATION",
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 12,
                      letterSpacing: 1.5,
                    ),
                  ),

                  const SizedBox(height: 20),
                  const Divider(),
                  const SizedBox(height: 10),

                  // المسافة والسعرات
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildStatItem(
                        "DISTANCE",
                        "${viewModel.totalDistanceKm.toStringAsFixed(2)} km",
                        Icons.map,
                      ),
                      _buildStatItem(
                        "CALORIES",
                        "${viewModel.caloriesBurned.toStringAsFixed(0)} kcal",
                        Icons.local_fire_department,
                      ),
                    ],
                  ),

                  const SizedBox(height: 25),

                  // زر البدء / الإيقاف
                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton(
                      onPressed: () {
                        // طباعة للتأكد من استجابة الزر
                        print("🟢 Button Clicked!");

                        if (viewModel.isRunning) {
                          viewModel.stopRun();
                        } else {
                          viewModel.startRun();
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: viewModel.isRunning
                            ? Colors.redAccent
                            : AppColors.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: Text(
                        viewModel.isRunning ? "STOP RUNNING" : "START RUNNING",
                        style: const TextStyle(
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
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: AppColors.primary, size: 28),
        const SizedBox(height: 5),
        Text(
          value,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        Text(label, style: const TextStyle(color: Colors.grey, fontSize: 12)),
      ],
    );
  }
}
