import 'package:flutter/material.dart';

class ChallengePlan {
  final String id; // <--- أضفنا هذا السطر (مهم جداً للتمييز)
  final String title;
  final String subtitle;
  final String duration;
  final String imageUrl;
  final Color cardColor;

  ChallengePlan({
    required this.id, // <--- مطلوب
    required this.title,
    required this.subtitle,
    required this.duration,
    required this.imageUrl,
    required this.cardColor,
  });
}
