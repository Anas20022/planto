import 'package:flutter/material.dart';

class TipProvider with ChangeNotifier {
  late final String _randomTip;

  TipProvider() {
    _initTip();
  }

  void _initTip() {
    final List<String> tips = [
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
    tips.shuffle();
    _randomTip = tips.first;
  }

  String get randomTip => _randomTip;
}
