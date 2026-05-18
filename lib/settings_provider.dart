import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_fonts/google_fonts.dart';
import 'notification_service.dart';

class SettingsProvider with ChangeNotifier {
  SharedPreferences? _prefs;

  // Defaults
  String _saveLocation = '';
  String _fontSize = 'Sedang'; // Kecil, Sedang, Besar
  String _fontFamily = 'Poppins'; // Poppins, Inter, Roboto
  String _themeModeStr = 'Hijau'; // Hijau, Gelap, Terang
  
  // New Lainnya Defaults
  String _language = 'Indonesia';
  bool _reminderEnabled = false;
  String _reminderTime = '04:00';
  List<String> _doaOrder = []; // List of Doa Titles in order

  String get saveLocation => _saveLocation;
  String get fontSize => _fontSize;
  String get fontFamily => _fontFamily;
  String get themeModeStr => _themeModeStr;
  String get language => _language;
  bool get reminderEnabled => _reminderEnabled;
  String get reminderTime => _reminderTime;
  List<String> get doaOrder => _doaOrder;

  SettingsProvider() {
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    _prefs = await SharedPreferences.getInstance();
    _saveLocation = _prefs?.getString('saveLocation') ?? '';
    _fontSize = _prefs?.getString('fontSize') ?? 'Sedang';
    _fontFamily = _prefs?.getString('fontFamily') ?? 'Poppins';
    _themeModeStr = _prefs?.getString('themeModeStr') ?? 'Hijau';
    _language = _prefs?.getString('language') ?? 'Indonesia';
    _reminderEnabled = _prefs?.getBool('reminderEnabled') ?? false;
    _reminderTime = _prefs?.getString('reminderTime') ?? '04:00';
    _doaOrder = _prefs?.getStringList('doaOrder') ?? [];
    notifyListeners();
    _updateNotification();
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

  Future<void> setLanguage(String lang) async {
    _language = lang;
    await _prefs?.setString('language', lang);
    notifyListeners();
  }

  Future<void> setReminderEnabled(bool enabled) async {
    _reminderEnabled = enabled;
    await _prefs?.setBool('reminderEnabled', enabled);
    notifyListeners();
    _updateNotification();
  }

  Future<void> setReminderTime(String time) async {
    _reminderTime = time;
    await _prefs?.setString('reminderTime', time);
    notifyListeners();
    _updateNotification();
  }

  void _updateNotification() {
    final int notificationId = 100;
    if (_reminderEnabled) {
      final timeParts = _reminderTime.split(':');
      final time = TimeOfDay(
        hour: int.tryParse(timeParts[0]) ?? 4,
        minute: int.tryParse(timeParts[1]) ?? 0,
      );
      NotificationService().scheduleDailyNotification(
        notificationId,
        'Waktunya Berdoa',
        'Mari sempatkan waktu untuk membaca doa hari ini.',
        time,
      );
    } else {
      NotificationService().cancelNotification(notificationId);
    }
  }

  Future<void> setDoaOrder(List<String> order) async {
    _doaOrder = order;
    await _prefs?.setStringList('doaOrder', order);
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
