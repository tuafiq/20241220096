import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_fonts/google_fonts.dart';

class SettingsProvider with ChangeNotifier {
  SharedPreferences? _prefs;

  // Defaults
  String _saveLocation = '';
  String _fontSize = 'Sedang'; // Kecil, Sedang, Besar
  String _fontFamily = 'Poppins'; // Poppins, Inter, Roboto
  String _themeModeStr = 'Hijau'; // Hijau, Gelap, Terang

  String get saveLocation => _saveLocation;
  String get fontSize => _fontSize;
  String get fontFamily => _fontFamily;
  String get themeModeStr => _themeModeStr;

  SettingsProvider() {
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    _prefs = await SharedPreferences.getInstance();
    _saveLocation = _prefs?.getString('saveLocation') ?? '';
    _fontSize = _prefs?.getString('fontSize') ?? 'Sedang';
    _fontFamily = _prefs?.getString('fontFamily') ?? 'Poppins';
    _themeModeStr = _prefs?.getString('themeModeStr') ?? 'Hijau';
    notifyListeners();
  }

  Future<void> setSaveLocation(String path) async {
    _saveLocation = path;
    await _prefs?.setString('saveLocation', path);
    notifyListeners();
  }

  Future<void> setFontSize(String size) async {
    _fontSize = size;
    await _prefs?.setString('fontSize', size);
    notifyListeners();
  }

  Future<void> setFontFamily(String font) async {
    _fontFamily = font;
    await _prefs?.setString('fontFamily', font);
    notifyListeners();
  }

  Future<void> setThemeModeStr(String theme) async {
    _themeModeStr = theme;
    await _prefs?.setString('themeModeStr', theme);
    notifyListeners();
  }

  ThemeData get currentTheme {
    Color seedColor = const Color(0xFF13A884); 
    Brightness brightness = Brightness.light;

    if (_themeModeStr == 'Gelap') {
      brightness = Brightness.dark;
    } else if (_themeModeStr == 'Terang') {
      brightness = Brightness.light;
    }

    String? fontFamilyName;
    try {
      fontFamilyName = GoogleFonts.getFont(_fontFamily).fontFamily;
    } catch (e) {
      fontFamilyName = _fontFamily; 
    }

    return ThemeData(
      colorScheme: ColorScheme.fromSeed(seedColor: seedColor, brightness: brightness),
      useMaterial3: true,
      fontFamily: fontFamilyName,
    );
  }

  double get textScaleFactor {
    switch (_fontSize) {
      case 'Kecil':
        return 0.85;
      case 'Besar':
        return 1.2;
      case 'Sedang':
      default:
        return 1.0;
    }
  }
}
