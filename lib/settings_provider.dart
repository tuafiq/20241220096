import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'notification_service.dart';

class SettingsProvider with ChangeNotifier {
  final SharedPreferences _prefs;

  // Defaults
  String _saveLocation = '';
  String _fontSize = 'Sedang'; // Kecil, Sedang, Besar
  String _fontFamily = 'Poppins'; // Poppins, Inter, Roboto
  String _themeModeStr = 'Hijau'; // Hijau, Gelap, Terang
  bool _isLoggedIn = false; // Add login state
  
  // New Lainnya Defaults
  String _language = 'Indonesia';
  bool _reminderEnabled = false;
  String _reminderTime = '04:00';
  List<String> _doaOrder = []; // List of Doa Titles in order
  List<String> _bookmarkedDoas = [];
  List<String> _quranBookmarks = [];
  List<String> _tutorialBookmarks = [];

  // Dzikir Harian State Counts
  int _countSubhanallah = 33;
  int _countAlhamdulillah = 33;
  int _countAllahuAkbar = 33;
  int _countAstaghfirullah = 1;

  // Dzikir Harian Targets
  int _targetSubhanallah = 33;
  int _targetAlhamdulillah = 33;
  int _targetAllahuAkbar = 33;
  int _targetAstaghfirullah = 33;

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

  // New Reading Preferences Fields
  double _arabFontSize = 24.0;
  double _latinFontSize = 13.0;
  bool _showTransliterasi = true;
  bool _showTerjemah = true;
  bool _layarTetapAktif = false;

  // Lokasi & Adzan Settings
  String _currentLocation = 'Pamekasan, Kabupaten Pamekasan';
  String _adzanSound = 'Makkah'; // Makkah, Madinah, Al-Aqsa, Indonesia
  bool _adzanSubuh = true;
  bool _adzanDzuhur = true;
  bool _adzanAshar = true;
  bool _adzanMaghrib = true;
  bool _adzanIsya = true;

  String get saveLocation => _saveLocation;
  String get fontSize => _fontSize;
  String get fontFamily => _fontFamily;
  String get themeModeStr => _themeModeStr;
  bool get isLoggedIn => _isLoggedIn; // Add getter
  String get language => _language;
  bool get reminderEnabled => _reminderEnabled;
  String get reminderTime => _reminderTime;
  List<String> get doaOrder => _doaOrder;
  List<String> get bookmarkedDoas => _bookmarkedDoas;
  List<String> get quranBookmarks => _quranBookmarks;
  List<String> get tutorialBookmarks => _tutorialBookmarks;

  int get countSubhanallah => _countSubhanallah;
  int get countAlhamdulillah => _countAlhamdulillah;
  int get countAllahuAkbar => _countAllahuAkbar;
  int get countAstaghfirullah => _countAstaghfirullah;
  int get lastHeaderIndex => _lastHeaderIndex;

  int get targetSubhanallah => _targetSubhanallah;
  int get targetAlhamdulillah => _targetAlhamdulillah;
  int get targetAllahuAkbar => _targetAllahuAkbar;
  int get targetAstaghfirullah => _targetAstaghfirullah;

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
  double get arabFontSize => _arabFontSize;
  double get latinFontSize => _latinFontSize;
  bool get showTransliterasi => _showTransliterasi;
  bool get showTerjemah => _showTerjemah;
  bool get layarTetapAktif => _layarTetapAktif;

  // Lokasi & Adzan Getters
  String get currentLocation => _currentLocation;
  String get adzanSound => _adzanSound;
  bool get adzanSubuh => _adzanSubuh;
  bool get adzanDzuhur => _adzanDzuhur;
  bool get adzanAshar => _adzanAshar;
  bool get adzanMaghrib => _adzanMaghrib;
  bool get adzanIsya => _adzanIsya;

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
    _isLoggedIn = _prefs.getBool('isLoggedIn') ?? false; // Load state
    _language = _prefs.getString('language') ?? 'Indonesia';
    _reminderEnabled = _prefs.getBool('reminderEnabled') ?? false;
    _reminderTime = _prefs.getString('reminderTime') ?? '04:00';
    _doaOrder = _prefs.getStringList('doaOrder') ?? [];
    _bookmarkedDoas = _prefs.getStringList('bookmarkedDoas') ?? [];
    _quranBookmarks = _prefs.getStringList('quranBookmarks') ?? [];
    _tutorialBookmarks = _prefs.getStringList('tutorialBookmarks') ?? [];
    
    // Load persisted Dzikir Harian counts
    _countSubhanallah = _prefs.getInt('countSubhanallah') ?? 33;
    _countAlhamdulillah = _prefs.getInt('countAlhamdulillah') ?? 33;
    _countAllahuAkbar = _prefs.getInt('countAllahuAkbar') ?? 33;
    _countAstaghfirullah = _prefs.getInt('countAstaghfirullah') ?? 1;

    // Load persisted Dzikir Harian targets
    _targetSubhanallah = _prefs.getInt('targetSubhanallah') ?? 33;
    _targetAlhamdulillah = _prefs.getInt('targetAlhamdulillah') ?? 33;
    _targetAllahuAkbar = _prefs.getInt('targetAllahuAkbar') ?? 34; // default to 34 to match the image
    _targetAstaghfirullah = _prefs.getInt('targetAstaghfirullah') ?? 33;

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

    // Load Reading Preferences
    _arabFontSize = _prefs.getDouble('arabFontSize') ?? 24.0;
    _latinFontSize = _prefs.getDouble('latinFontSize') ?? 13.0;
    _showTransliterasi = _prefs.getBool('showTransliterasi') ?? true;
    _showTerjemah = _prefs.getBool('showTerjemah') ?? true;
    _layarTetapAktif = _prefs.getBool('layarTetapAktif') ?? false;
    
    // Load Lokasi & Adzan Settings
    _currentLocation = _prefs.getString('currentLocation') ?? 'Pamekasan, Kabupaten Pamekasan';
    _adzanSound = _prefs.getString('adzanSound') ?? 'Makkah';
    _adzanSubuh = _prefs.getBool('adzanSubuh') ?? true;
    _adzanDzuhur = _prefs.getBool('adzanDzuhur') ?? true;
    _adzanAshar = _prefs.getBool('adzanAshar') ?? true;
    _adzanMaghrib = _prefs.getBool('adzanMaghrib') ?? true;
    _adzanIsya = _prefs.getBool('adzanIsya') ?? true;

    _updateNotification();
    _updateReadingReminder();
    
    // Check if we need to fetch/schedule for a new month
    _rescheduleAdzans();
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
      'theme_mode': 'Tema Tampilan',
      'theme_mode_desc': 'Atur tema terang atau gelap',
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
      'theme_mode_dialog': 'Pilih Tema Tampilan',
      'close': 'Tutup',
      'wirid': 'Wirid',
      'doa_harian': 'Doa Harian',
      'appearance': 'Tampilan',
      'reading_preferences': 'Preferensi Membaca',
      'bookmark_list': 'Daftar Bookmark',
      'arabic_text_size': 'Ukuran Teks Arab',
      'latin_text_size': 'Ukuran Teks Latin',
      'activate_text': 'Aktifkan Teks',
      'transliteration_latin': 'Transliterasi (Latin)',
      'translation': 'Terjemah',
      'translation_language': 'Bahasa Terjemah Al Quran',
      'choose_language': 'Pilih Bahasa',
      'screen_display_reading': 'Tampilan Layar ketika Membaca',
      'screen_keep_on': 'Layar Tetap Aktif',
      "screen_keep_on_desc": "Mencegah layar HP mati/redup saat membaca Al-Qur'an",
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
      'theme_mode': 'Theme Mode',
      'theme_mode_desc': 'Adjust light or dark theme',
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
      'theme_mode_dialog': 'Select Theme Mode',
      'close': 'Close',
      'wirid': 'Wirid',
      'doa_harian': 'Daily Prayer',
      'appearance': 'Appearance',
      'reading_preferences': 'Reading Preferences',
      'bookmark_list': 'Bookmark List',
      'arabic_text_size': 'Arabic Text Size',
      'latin_text_size': 'Latin Text Size',
      'activate_text': 'Activate Text',
      'transliteration_latin': 'Transliteration (Latin)',
      'translation': 'Translation',
      'translation_language': 'Al Quran Translation Language',
      'choose_language': 'Choose Language',
      'screen_display_reading': 'Screen Display when Reading',
      'screen_keep_on': 'Keep Screen On',
      "screen_keep_on_desc": "Prevent the phone screen from sleeping/dimming while reading Al-Qur'an",
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
      'theme_mode': 'وضع المظهر',
      'theme_mode_desc': 'ضبط المظهر الفاتح أو الداكن',
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
      'theme_mode_dialog': 'اختر وضع المظهر',
      'close': 'إغلاق',
      'wirid': 'الأوراد',
      'doa_harian': 'الأدعية اليومية',
      'appearance': 'المظهر',
      'reading_preferences': 'تفضيلات القراءة',
      'bookmark_list': 'قائمة الإشارات المرجعية',
      'arabic_text_size': 'حجم النص العربي',
      'latin_text_size': 'حجم النص اللاتيني',
      'activate_text': 'تفعيل النص',
      'transliteration_latin': 'الكتابة الصوتية (لاتينية)',
      'translation': 'الترجمة',
      'translation_language': 'لغة ترجمة القرآن',
      'choose_language': 'اختر اللغة',
      'screen_display_reading': 'شاشة العرض عند القراءة',
      'screen_keep_on': 'إبقاء الشاشة نشطة',
      'screen_keep_on_desc': 'منع شاشة الهاتف من الإغلاق/التعتيم أثناء قراءة القرآن',
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

  Future<void> setLoggedIn(bool loggedIn) async {
    _isLoggedIn = loggedIn;
    await _prefs.setBool('isLoggedIn', loggedIn);
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
      _countSubhanallah = (_countSubhanallah + 1) > _targetSubhanallah ? 0 : _countSubhanallah + 1;
      await _prefs.setInt('countSubhanallah', _countSubhanallah);
    } else if (type == 'alhamdulillah') {
      _countAlhamdulillah = (_countAlhamdulillah + 1) > _targetAlhamdulillah ? 0 : _countAlhamdulillah + 1;
      await _prefs.setInt('countAlhamdulillah', _countAlhamdulillah);
    } else if (type == 'allahu_akbar') {
      _countAllahuAkbar = (_countAllahuAkbar + 1) > _targetAllahuAkbar ? 0 : _countAllahuAkbar + 1;
      await _prefs.setInt('countAllahuAkbar', _countAllahuAkbar);
    } else if (type == 'astaghfirullah') {
      _countAstaghfirullah = (_countAstaghfirullah + 1) > _targetAstaghfirullah ? 0 : _countAstaghfirullah + 1;
      await _prefs.setInt('countAstaghfirullah', _countAstaghfirullah);
    }
    notifyListeners();
  }

  Future<void> decrementDzikir(String type) async {
    if (type == 'subhanallah') {
      _countSubhanallah = (_countSubhanallah - 1) < 0 ? 0 : _countSubhanallah - 1;
      await _prefs.setInt('countSubhanallah', _countSubhanallah);
    } else if (type == 'alhamdulillah') {
      _countAlhamdulillah = (_countAlhamdulillah - 1) < 0 ? 0 : _countAlhamdulillah - 1;
      await _prefs.setInt('countAlhamdulillah', _countAlhamdulillah);
    } else if (type == 'allahu_akbar') {
      _countAllahuAkbar = (_countAllahuAkbar - 1) < 0 ? 0 : _countAllahuAkbar - 1;
      await _prefs.setInt('countAllahuAkbar', _countAllahuAkbar);
    } else if (type == 'astaghfirullah') {
      _countAstaghfirullah = (_countAstaghfirullah - 1) < 0 ? 0 : _countAstaghfirullah - 1;
      await _prefs.setInt('countAstaghfirullah', _countAstaghfirullah);
    }
    notifyListeners();
  }

  Future<void> setTargetDzikir(String type, int target) async {
    if (type == 'subhanallah') {
      _targetSubhanallah = target;
      await _prefs.setInt('targetSubhanallah', target);
    } else if (type == 'alhamdulillah') {
      _targetAlhamdulillah = target;
      await _prefs.setInt('targetAlhamdulillah', target);
    } else if (type == 'allahu_akbar') {
      _targetAllahuAkbar = target;
      await _prefs.setInt('targetAllahuAkbar', target);
    } else if (type == 'astaghfirullah') {
      _targetAstaghfirullah = target;
      await _prefs.setInt('targetAstaghfirullah', target);
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

  Future<void> setArabFontSize(double size) async {
    _arabFontSize = size;
    await _prefs.setDouble('arabFontSize', size);
    notifyListeners();
  }

  Future<void> setLatinFontSize(double size) async {
    _latinFontSize = size;
    await _prefs.setDouble('latinFontSize', size);
    notifyListeners();
  }

  Future<void> setShowTransliterasi(bool val) async {
    _showTransliterasi = val;
    await _prefs.setBool('showTransliterasi', val);
    notifyListeners();
  }

  Future<void> setShowTerjemah(bool val) async {
    _showTerjemah = val;
    await _prefs.setBool('showTerjemah', val);
    notifyListeners();
  }

  Future<void> setLayarTetapAktif(bool value) async {
    _layarTetapAktif = value;
    await _prefs.setBool('layarTetapAktif', value);
    notifyListeners();
  }

  // Lokasi & Adzan Setters
  Future<void> setCurrentLocation(String value) async {
    if (_currentLocation != value) {
      _currentLocation = value;
      await _prefs.setString('currentLocation', value);
      notifyListeners();
      _rescheduleAdzans();
    }
  }

  Future<void> setAdzanSound(String value) async {
    _adzanSound = value;
    await _prefs.setString('adzanSound', value);
    notifyListeners();
    _rescheduleAdzans(skipFetch: true);
  }

  Future<void> setAdzanSubuh(bool value) async {
    _adzanSubuh = value;
    await _prefs.setBool('adzanSubuh', value);
    notifyListeners();
    _rescheduleAdzans(skipFetch: true);
  }

  Future<void> setAdzanDzuhur(bool value) async {
    _adzanDzuhur = value;
    await _prefs.setBool('adzanDzuhur', value);
    notifyListeners();
    _rescheduleAdzans(skipFetch: true);
  }

  Future<void> setAdzanAshar(bool value) async {
    _adzanAshar = value;
    await _prefs.setBool('adzanAshar', value);
    notifyListeners();
    _rescheduleAdzans(skipFetch: true);
  }

  Future<void> setAdzanMaghrib(bool value) async {
    _adzanMaghrib = value;
    await _prefs.setBool('adzanMaghrib', value);
    notifyListeners();
    _rescheduleAdzans(skipFetch: true);
  }

  Future<void> setAdzanIsya(bool value) async {
    _adzanIsya = value;
    await _prefs.setBool('adzanIsya', value);
    notifyListeners();
    _rescheduleAdzans(skipFetch: true);
  }

  Future<void> _rescheduleAdzans({bool skipFetch = false}) async {
    final now = DateTime.now();
    await NotificationService().cancelAllAdzans();

    List<dynamic> monthlySchedule = [];
    final cachedScheduleStr = _prefs.getString('monthlyScheduleCache');
    final cachedMonth = _prefs.getInt('monthlyScheduleMonth');
    
    // Check if we need to fetch new data (if forced, or cache is missing, or month has changed)
    if (!skipFetch || cachedScheduleStr == null || cachedMonth != now.month) {
      try {
        String cityName = _currentLocation.contains(',') ? _currentLocation.split(',').last.trim() : _currentLocation;
        cityName = cityName.replaceAll('Kabupaten ', '').replaceAll('Kota ', '').trim();
        
        final searchUrl = Uri.parse('https://api.myquran.com/v2/sholat/kota/cari/$cityName');
        final searchResponse = await http.get(searchUrl);
        
        if (searchResponse.statusCode == 200) {
          final searchData = json.decode(searchResponse.body);
          if (searchData['status'] == true && (searchData['data'] as List).isNotEmpty) {
            final cityId = searchData['data'][0]['id'];
            
            final scheduleUrl = Uri.parse('https://api.myquran.com/v2/sholat/jadwal/$cityId/${now.year}/${now.month.toString().padLeft(2, "0")}');
            final scheduleResponse = await http.get(scheduleUrl);
            
            if (scheduleResponse.statusCode == 200) {
              final scheduleData = json.decode(scheduleResponse.body);
              if (scheduleData['status'] == true) {
                monthlySchedule = scheduleData['data']['jadwal'];
                await _prefs.setString('monthlyScheduleCache', json.encode(monthlySchedule));
                await _prefs.setInt('monthlyScheduleMonth', now.month);
              }
            }
          }
        }
      } catch (e) {
        debugPrint('Error fetching monthly schedule: $e');
      }
    }

    // Load from cache if API failed or we skipped fetch
    if (monthlySchedule.isEmpty && _prefs.getString('monthlyScheduleCache') != null) {
      try {
        monthlySchedule = json.decode(_prefs.getString('monthlyScheduleCache')!);
      } catch (e) {
        debugPrint('Error parsing cached schedule: $e');
      }
    }

    if (monthlySchedule.isEmpty) return;

    // Schedule all future adzans for this month
    for (var dayData in monthlySchedule) {
      final dateStr = dayData['date'] as String; // e.g. "2026-05-01"
      final parts = dateStr.split('-');
      final year = int.parse(parts[0]);
      final month = int.parse(parts[1]);
      final day = int.parse(parts[2]);

      void schedulePrayer(String name, String timeStr, bool enabled, int prayerIndex) {
        if (!enabled) return;
        final timeParts = timeStr.split(':');
        final prayerTime = DateTime(year, month, day, int.parse(timeParts[0]), int.parse(timeParts[1]));
        
        if (prayerTime.isAfter(now)) {
          final id = 1000 + (day * 10) + prayerIndex; // Unique ID for each prayer in a month
          NotificationService().scheduleAdzan(
            id,
            'Adzan $name',
            'Waktunya sholat $name untuk wilayah ${_currentLocation.split(",").first}',
            prayerTime,
            _adzanSound,
          );
        }
      }

      schedulePrayer('Subuh', dayData['subuh'], _adzanSubuh, 0);
      schedulePrayer('Dzuhur', dayData['dzuhur'], _adzanDzuhur, 1);
      schedulePrayer('Ashar', dayData['ashar'], _adzanAshar, 2);
      schedulePrayer('Maghrib', dayData['maghrib'], _adzanMaghrib, 3);
      schedulePrayer('Isya', dayData['isya'], _adzanIsya, 4);
    }
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

  bool isDoaBookmarked(String title) {
    return _bookmarkedDoas.contains(title);
  }

  Future<void> toggleDoaBookmark(String title) async {
    if (_bookmarkedDoas.contains(title)) {
      _bookmarkedDoas.remove(title);
    } else {
      _bookmarkedDoas.add(title);
    }
    await _prefs.setStringList('bookmarkedDoas', _bookmarkedDoas);
    notifyListeners();
  }

  bool isQuranBookmarked(String bookmarkJson) {
    return _quranBookmarks.contains(bookmarkJson);
  }

  Future<void> toggleQuranBookmark(String bookmarkJson) async {
    if (_quranBookmarks.contains(bookmarkJson)) {
      _quranBookmarks.remove(bookmarkJson);
    } else {
      _quranBookmarks.add(bookmarkJson);
    }
    await _prefs.setStringList('quranBookmarks', _quranBookmarks);
    notifyListeners();
  }

  bool isTutorialBookmarked(String title) {
    return _tutorialBookmarks.contains(title);
  }

  Future<void> toggleTutorialBookmark(String title) async {
    if (_tutorialBookmarks.contains(title)) {
      _tutorialBookmarks.remove(title);
    } else {
      _tutorialBookmarks.add(title);
    }
    await _prefs.setStringList('tutorialBookmarks', _tutorialBookmarks);
    notifyListeners();
  }
}
