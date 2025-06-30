import 'package:flutter/cupertino.dart';
import 'package:test_1/prefs/preference.dart';

class ModeProvider with ChangeNotifier{
  bool _darkModeEnable = false;
  ThemePreference themePreference = new ThemePreference();
  bool get darkModeEnable => _darkModeEnable;

  set darkModeEnable(bool value) {
    _darkModeEnable = value;
  }

  changeMode(){
    _darkModeEnable ?  _darkModeEnable = false : _darkModeEnable = true;

    themePreference.setTheme(_darkModeEnable);
    notifyListeners();

  }

  getTheme()async{
    darkModeEnable = await themePreference.getTheme();
    notifyListeners();

  }
}