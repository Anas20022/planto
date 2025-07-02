import 'package:flutter/material.dart';

class TipProvider with ChangeNotifier {
  late final String _randomTipKey;

  TipProvider() {
    _initTip();
  }

  void _initTip() {
    // قائمة مفاتيح النصائح كما هي في ملف الترجمة (JSON)
    final List<String> tipKeys = [
      "Water your plants early in the morning.",
      "Use organic fertilizers for better soil health.",
      "Rotate your crops each season.",
      "Prune your plants regularly for better growth.",
      "Ensure plants get 6 hours of sunlight daily.",
      "Mulch around plants to retain moisture.",
      "Check leaves for signs of disease weekly.",
      "Use natural pest control methods.",
      "Don't overwater your plants.",
    ];
    tipKeys.shuffle();
    _randomTipKey = tipKeys.first;
  }

  String get randomTipKey => _randomTipKey;
}
