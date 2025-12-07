import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart'; // مكتبة الخرائط المجانية
import 'package:latlong2/latlong.dart'; // للإحداثيات
import 'package:geolocator/geolocator.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';

class RunningViewModel extends ChangeNotifier {
  // --- متغيرات الحالة ---
  bool isRunning = false;

  // قائمة النقاط لرسم الخط (المسار)
  List<LatLng> routePoints = [];

  // الموقع الحالي (لوضع علامة عليه)
  LatLng? currentLocation;

  double totalDistanceKm = 0.0;
  double caloriesBurned = 0.0;

  // العداد الزمني
  final StopWatchTimer _stopWatchTimer = StopWatchTimer(
    mode: StopWatchMode.countUp,
  );
  Stream<int> get timerStream => _stopWatchTimer.rawTime;

  // التحكم في الخريطة والموقع
  StreamSubscription<Position>? _positionStream;
  final MapController mapController = MapController();

  // --- الدوال ---

  // 1. بدء الجري (تم التعديل لإضافة فحوصات الأخطاء)
  Future<void> startRun() async {
    print("👉 Button Pressed! Checking requirements...");

    try {
      // أ. التأكد من أن خدمة الموقع (GPS) مفتوحة
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        print("❌ GPS Service is disabled.");
        await Geolocator.openLocationSettings();
        return;
      }
      print("✅ GPS Service is ON");

      // ب. التأكد من الأذونات
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          print("❌ Location permissions are denied");
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        print(
          "❌ Location permissions are permanently denied, we cannot request permissions.",
        );
        await Geolocator.openAppSettings();
        return;
      }
      print("✅ Permissions granted");

      // ج. بدء الجري فعلياً
      isRunning = true;
      _stopWatchTimer.onStartTimer();
      print("✅ Timer Started");

      // إعدادات تتبع دقيقة
      const LocationSettings locationSettings = LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 5, // تحديث كل 5 متر
      );

      // بدء استقبال البيانات
      _positionStream =
          Geolocator.getPositionStream(
            locationSettings: locationSettings,
          ).listen(
            (Position position) {
              // طباعة للتأكد أن البيانات تصل
              print(
                "📍 New Location received: ${position.latitude}, ${position.longitude}",
              );
              _updateLocation(position);
            },
            onError: (e) {
              print("❌ Error in Position Stream: $e");
            },
          );

      notifyListeners();
    } catch (e) {
      print("❌ CRITICAL ERROR in startRun: $e");
    }
  }

  // 2. تحديث الموقع والرسم
  void _updateLocation(Position position) {
    LatLng newPoint = LatLng(position.latitude, position.longitude);

    // حساب المسافة
    if (routePoints.isNotEmpty) {
      final Distance distance = const Distance();
      double dist = distance.as(LengthUnit.Meter, routePoints.last, newPoint);

      totalDistanceKm += (dist / 1000);
      caloriesBurned = totalDistanceKm * 60; // معادلة تقريبية

      print("🏃 Distance updated: $totalDistanceKm km"); // طباعة للتأكد
    }

    routePoints.add(newPoint);
    currentLocation = newPoint;

    // تحريك الخريطة لتتبع المستخدم
    mapController.move(newPoint, 17.0);

    notifyListeners();
  }

  // 3. إيقاف الجري
  void stopRun() {
    print("🛑 Run Stopped");
    isRunning = false;
    _stopWatchTimer.onStopTimer();
    _positionStream?.cancel();
    notifyListeners();
  }

  // دالة لجلب الموقع المبدئي عند فتح الخريطة
  Future<void> initLocation() async {
    try {
      // طلب إذن مبدئي للتأكد
      await Geolocator.requestPermission();

      Position pos = await Geolocator.getCurrentPosition();
      currentLocation = LatLng(pos.latitude, pos.longitude);
      mapController.move(currentLocation!, 15.0);
      notifyListeners();
      print("✅ Initial Location set: ${pos.latitude}, ${pos.longitude}");
    } catch (e) {
      print("❌ Error getting initial location: $e");
    }
  }

  @override
  void dispose() {
    _stopWatchTimer.dispose();
    _positionStream?.cancel();
    super.dispose();
  }
}
