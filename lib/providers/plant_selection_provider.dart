import 'package:flutter/material.dart';

class PlantSelectionProvider with ChangeNotifier {
  String? _selectedPlant;

  String? get selectedPlant => _selectedPlant;

  void selectPlant(String plantName) {
    _selectedPlant = plantName;
    notifyListeners();
  }

  void clearSelection() {
    _selectedPlant = null;
    notifyListeners();
  }
}


