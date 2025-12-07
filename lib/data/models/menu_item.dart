import 'package:flutter/material.dart';

class MenuItem {
  final String title;
  final IconData icon;
  final String route; // سنستخدم هذا لاحقاً للتنقل

  MenuItem({required this.title, required this.icon, this.route = ''});
}
