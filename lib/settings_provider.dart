import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_fonts/google_fonts.dart';
import 'notification_service.dart';

class SettingsProvider with ChangeNotifier {
  final SharedPreferences _prefs;

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

  // Dzikir Harian State Counts
  int _countSubhanallah = 33;
  int _countAlhamdulillah = 33;
  int _countAllahuAkbar = 33;
  int _countAstaghfirullah = 1;

  int _lastHeaderIndex = 0; // 0: Location, 1: Quran, 2: Dzikir

  // Al-Quran Settings Defaults
  bool _showWarnaTajwid = true;
  String _selectedQori = 'Al-Husary';
  String _selectedQoriId = '05';
  String _defaultTampilanUtama = 'Baris Per Ayat';
  String _defaultTampilanBaris = 'Selalu Tanya';
  String _halamanPermulaanAlFatihah = 'Halaman 1';
  double _savedAudioSize = 0.0;
  List<String> _downloadedSurahs = [];
  bool _penandaOtomatis = false;
  bool _pengingatMembaca = true;

  String get saveLocation => _saveLocation;
  String get fontSize => _fontSize;
  String get fontFamily => _fontFamily;
  String get themeModeStr => _themeModeStr;
  String get language => _language;
  bool get reminderEnabled => _reminderEnabled;
  String get reminderTime => _reminderTime;
  List<String> get doaOrder => _doaOrder;

  int get countSubhanallah => _countSubhanallah;
  int get countAlhamdulillah => _countAlhamdulillah;
  int get countAllahuAkbar => _countAllahuAkbar;
  int get countAstaghfirullah => _countAstaghfirullah;
  int get lastHeaderIndex => _lastHeaderIndex;

  // Al-Quran Getters
  bool get showWarnaTajwid => _showWarnaTajwid;
  String get selectedQori => _selectedQori;
  String get selectedQoriId => _selectedQoriId;
  String get defaultTampilanUtama => _defaultTampilanUtama;
  String get defaultTampilanBaris => _defaultTampilanBaris;
  String get halamanPermulaanAlFatihah => _halamanPermulaanAlFatihah;
  double get savedAudioSize => _savedAudioSize;
  List<String> get downloadedSurahs => _downloadedSurahs;
  bool get penandaOtomatis => _penandaOtomatis;
  bool get pengingatMembaca => _pengingatMembaca;

  Locale get locale {
    switch (_language) {
      case 'Inggris':
        return const Locale('en');
      case 'Arab':
        return const Locale('ar');
      case 'Indonesia':
      default:
        return const Locale('id');
    }
  }

  SettingsProvider({required SharedPreferences prefs}) : _prefs = prefs {
    _loadSettings();
  }

  void _loadSettings() {
    _saveLocation = _prefs.getString('saveLocation') ?? '';
    _fontSize = _prefs.getString('fontSize') ?? 'Sedang';
    _fontFamily = _prefs.getString('fontFamily') ?? 'Poppins';
    _themeModeStr = _prefs.getString('themeModeStr') ?? 'Hijau';
    _language = _prefs.getString('language') ?? 'Indonesia';
    _reminderEnabled = _prefs.getBool('reminderEnabled') ?? false;
    _reminderTime = _prefs.getString('reminderTime') ?? '04:00';
    _doaOrder = _prefs.getStringList('doaOrder') ?? [];
    
    // Load persisted Dzikir Harian counts
    _countSubhanallah = _prefs.getInt('countSubhanallah') ?? 33;
    _countAlhamdulillah = _prefs.getInt('countAlhamdulillah') ?? 33;
    _countAllahuAkbar = _prefs.getInt('countAllahuAkbar') ?? 33;
    _countAstaghfirullah = _prefs.getInt('countAstaghfirullah') ?? 1;

    _lastHeaderIndex = _prefs.getInt('lastHeaderIndex') ?? 0;

    // Load Al-Quran settings
    _showWarnaTajwid = _prefs.getBool('showWarnaTajwid') ?? true;
    _selectedQori = _prefs.getString('selectedQori') ?? 'Al-Husary';
    _selectedQoriId = _prefs.getString('selectedQoriId') ?? '05';
    _defaultTampilanUtama = _prefs.getString('defaultTampilanUtama') ?? 'Baris Per Ayat';
    _defaultTampilanBaris = _prefs.getString('defaultTampilanBaris') ?? 'Selalu Tanya';
    _halamanPermulaanAlFatihah = _prefs.getString('halamanPermulaanAlFatihah') ?? 'Halaman 1';
    _savedAudioSize = _prefs.getDouble('savedAudioSize') ?? 0.0;
    _downloadedSurahs = _prefs.getStringList('downloadedSurahs') ?? [];
    _penandaOtomatis = _prefs.getBool('penandaOtomatis') ?? false;
    _pengingatMembaca = _prefs.getBool('pengingatMembaca') ?? true;
    
    _updateNotification();
    _updateReadingReminder();
  }

  static const Map<String, Map<String, String>> _localizedValues = {
    'Indonesia': {
      'title': 'Wirid & Doa',
      'subtitle': 'Kumpulan wirid dan doa harian',
      'search_hint': 'Cari doa...',
      'settings': 'Pengaturan',
      'font_size': 'Ukuran Font Teks',
      'font_size_desc': 'Atur ukuran teks',
      'font_style': 'Jenis Font',
      'font_style_desc': 'Pilih jenis font',
      'others': 'Lainnya',
      'reminder': 'Pengingat Doa',
      'reminder_desc': 'Atur pengingat doa harian',
      'language': 'Bahasa',
      'language_desc': 'Pilih bahasa aplikasi',
      'about': 'Tentang Aplikasi',
      'about_desc': 'Informasi versi dan developer',
      'lang_dialog': 'Pilih Bahasa',
      'font_size_dialog': 'Pilih Ukuran Font',
      'font_style_dialog': 'Pilih Jenis Font',
      'close': 'Tutup',
      'wirid': 'Wirid',
      'doa_harian': 'Doa Harian',
      'appearance': 'Tampilan',
    },
    'Inggris': {
      'title': 'Wirid & Prayer',
      'subtitle': 'Collection of daily wirid and prayers',
      'search_hint': 'Search prayer...',
      'settings': 'Settings',
      'font_size': 'Text Font Size',
      'font_size_desc': 'Adjust text size',
      'font_style': 'Font Family',
      'font_style_desc': 'Choose font family',
      'others': 'Others',
      'reminder': 'Prayer Reminder',
      'reminder_desc': 'Set daily prayer reminder',
      'language': 'Language',
      'language_desc': 'Choose app language',
      'about': 'About App',
      'about_desc': 'Version and developer info',
      'lang_dialog': 'Select Language',
      'font_size_dialog': 'Select Font Size',
      'font_style_dialog': 'Select Font Family',
      'close': 'Close',
      'wirid': 'Wirid',
      'doa_harian': 'Daily Prayer',
      'appearance': 'Appearance',
    },
    'Arab': {
      'title': 'الورد والأدعية',
      'subtitle': 'مجموعة من الأوراد والأدعية اليومية',
      'search_hint': 'البحث عن الدعاء...',
      'settings': 'الإعدادات',
      'font_size': 'حجم الخط',
      'font_size_desc': 'ضبط حجم النص',
      'font_style': 'نوع الخط',
      'font_style_desc': 'اختر نوع الخط',
      'others': 'أخرى',
      'reminder': 'تذكير بالدعاء',
      'reminder_desc': 'ضبط التذكير اليومي بالدعاء',
      'language': 'اللغة',
      'language_desc': 'اختر لغة التطبيق',
      'about': 'عن التطبيق',
      'about_desc': 'معلومات الإصدار والمطور',
      'lang_dialog': 'اختر اللغة',
      'font_size_dialog': 'اختر حجم الخط',
      'font_style_dialog': 'اختر نوع الخط',
      'close': 'إغلاق',
      'wirid': 'الأوراد',
      'doa_harian': 'الأدعية اليومية',
      'appearance': 'المظهر',
    },
  };

  String translate(String key) {
    String lang = _language;
    if (lang == 'English' || lang == 'Inggris') {
      lang = 'Inggris';
    } else if (lang == 'العربية' || lang == 'Arab') {
      lang = 'Arab';
    }
    return _localizedValues[lang]?[key] ?? _localizedValues['Indonesia']![key]!;
  }

  Future<void> setSaveLocation(String path) async {
    _saveLocation = path;
    await _prefs.setString('saveLocation', path);
    notifyListeners();
  }

  Future<void> setFontSize(String size) async {
    _fontSize = size;
    await _prefs.setString('fontSize', size);
    notifyListeners();
  }

  Future<void> setFontFamily(String font) async {
    _fontFamily = font;
    await _prefs.setString('fontFamily', font);
    notifyListeners();
  }

  Future<void> setThemeModeStr(String theme) async {
    _themeModeStr = theme;
    await _prefs.setString('themeModeStr', theme);
    notifyListeners();
  }

  Future<void> setLanguage(String lang) async {
    _language = lang;
    await _prefs.setString('language', lang);
    notifyListeners();
  }

  Future<void> setReminderEnabled(bool enabled) async {
    _reminderEnabled = enabled;
    await _prefs.setBool('reminderEnabled', enabled);
    notifyListeners();
    _updateNotification();
  }

  Future<void> setReminderTime(String time) async {
    _reminderTime = time;
    await _prefs.setString('reminderTime', time);
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

  void _updateReadingReminder() {
    final int notificationId = 101;
    if (_pengingatMembaca) {
      const time = TimeOfDay(hour: 18, minute: 30);
      NotificationService().scheduleDailyNotification(
        notificationId,
        'Membaca Al-Quran',
        'Mari sempatkan waktu untuk membaca Al-Quran hari ini.',
        time,
      );
    } else {
      NotificationService().cancelNotification(notificationId);
    }
  }

  Future<void> setDoaOrder(List<String> order) async {
    _doaOrder = order;
    await _prefs.setStringList('doaOrder', order);
    notifyListeners();
  }

  Future<void> setLastHeaderIndex(int index) async {
    _lastHeaderIndex = index;
    await _prefs.setInt('lastHeaderIndex', index);
    notifyListeners();
  }

  Future<void> incrementDzikir(String type) async {
    if (type == 'subhanallah') {
      _countSubhanallah = (_countSubhanallah + 1) > 33 ? 0 : _countSubhanallah + 1;
      await _prefs.setInt('countSubhanallah', _countSubhanallah);
    } else if (type == 'alhamdulillah') {
      _countAlhamdulillah = (_countAlhamdulillah + 1) > 33 ? 0 : _countAlhamdulillah + 1;
      await _prefs.setInt('countAlhamdulillah', _countAlhamdulillah);
    } else if (type == 'allahu_akbar') {
      _countAllahuAkbar = (_countAllahuAkbar + 1) > 33 ? 0 : _countAllahuAkbar + 1;
      await _prefs.setInt('countAllahuAkbar', _countAllahuAkbar);
    } else if (type == 'astaghfirullah') {
      _countAstaghfirullah = (_countAstaghfirullah + 1) > 33 ? 0 : _countAstaghfirullah + 1;
      await _prefs.setInt('countAstaghfirullah', _countAstaghfirullah);
    }
    notifyListeners();
  }

  Future<void> resetDzikirCounts() async {
    _countSubhanallah = 0;
    _countAlhamdulillah = 0;
    _countAllahuAkbar = 0;
    _countAstaghfirullah = 0;
    await _prefs.setInt('countSubhanallah', 0);
    await _prefs.setInt('countAlhamdulillah', 0);
    await _prefs.setInt('countAllahuAkbar', 0);
    await _prefs.setInt('countAstaghfirullah', 0);
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

  // Al-Quran Setters
  Future<void> setShowWarnaTajwid(bool show) async {
    _showWarnaTajwid = show;
    await _prefs.setBool('showWarnaTajwid', show);
    notifyListeners();
  }

  Future<void> setSelectedQori(String qori, String qoriId) async {
    _selectedQori = qori;
    _selectedQoriId = qoriId;
    await _prefs.setString('selectedQori', qori);
    await _prefs.setString('selectedQoriId', qoriId);
    notifyListeners();
  }

  Future<void> setDefaultTampilanUtama(String style) async {
    _defaultTampilanUtama = style;
    await _prefs.setString('defaultTampilanUtama', style);
    notifyListeners();
  }

  Future<void> setDefaultTampilanBaris(String style) async {
    _defaultTampilanBaris = style;
    await _prefs.setString('defaultTampilanBaris', style);
    notifyListeners();
  }

  Future<void> setHalamanPermulaanAlFatihah(String page) async {
    _halamanPermulaanAlFatihah = page;
    await _prefs.setString('halamanPermulaanAlFatihah', page);
    notifyListeners();
  }

  Future<void> setSavedAudioSize(double size) async {
    _savedAudioSize = size;
    await _prefs.setDouble('savedAudioSize', size);
    notifyListeners();
  }

  Future<void> clearSavedAudio() async {
    _savedAudioSize = 0.0;
    _downloadedSurahs.clear();
    await _prefs.setDouble('savedAudioSize', 0.0);
    await _prefs.setStringList('downloadedSurahs', []);
    notifyListeners();
  }

  Future<void> addDownloadedSurah(int number, double size) async {
    final strNumber = number.toString();
    if (!_downloadedSurahs.contains(strNumber)) {
      _downloadedSurahs.add(strNumber);
      _savedAudioSize += size;
      await _prefs.setStringList('downloadedSurahs', _downloadedSurahs);
      await _prefs.setDouble('savedAudioSize', _savedAudioSize);
      notifyListeners();
    }
  }

  Future<void> setPenandaOtomatis(bool value) async {
    _penandaOtomatis = value;
    await _prefs.setBool('penandaOtomatis', value);
    notifyListeners();
  }

  Future<void> setPengingatMembaca(bool value) async {
    _pengingatMembaca = value;
    await _prefs.setBool('pengingatMembaca', value);
    _updateReadingReminder();
    notifyListeners();
  }
}
