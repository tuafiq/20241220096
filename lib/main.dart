import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:math';
import 'package:url_launcher/url_launcher.dart';
import 'dart:ui';
import 'package:google_fonts/google_fonts.dart';
import 'wirid_doa_page.dart';
import 'dzikir_card.dart';
import 'prayer_schedule_page.dart';
import 'quran_page.dart';
import 'surah_detail_page.dart';
import 'qibla_page.dart';
import 'calendar_page.dart';
import 'settings_page.dart';
import 'tahlil_yasin_page.dart';
import 'article_page.dart';
import 'article_model.dart';
import 'article_service.dart';
import 'package:hijri/hijri_calendar.dart';
import 'hadith_page.dart';
import 'tutorial_ibadah_page.dart';
import 'kajian_video_page.dart';
import 'ramadhan_page.dart';
import 'quran_data.dart';
import 'wirid_detail_page.dart';
import 'wirid_data.dart';
import 'doa_data.dart';
import 'article_detail_page.dart';
import 'doa_detail_page.dart';


import 'package:provider/provider.dart';
import 'settings_provider.dart';
import 'notification_service.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationService().init();
  final prefs = await SharedPreferences.getInstance();

  runApp(
    ChangeNotifierProvider(
      create: (context) => SettingsProvider(prefs: prefs),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<SettingsProvider>(
      builder: (context, settings, child) {
        return MaterialApp(
          title: 'Al-Qur\'an NU',
          debugShowCheckedModeBanner: false,
          theme: settings.currentTheme,
          locale: settings.locale,
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale('id'),
            Locale('en'),
            Locale('ar'),
          ],
          builder: (context, child) {
            return Directionality(
              textDirection: TextDirection.ltr,
              child: MediaQuery(
                data: MediaQuery.of(context).copyWith(
                  textScaler: TextScaler.linear(settings.textScaleFactor),
                ),
                child: child!,
              ),
            );
          },
          home: const HomePage(),
        );
      },
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  int _currentHeaderIndex = 999;
  bool _isHoldingHeader = false;
  late PageController _headerPageController;
  late PageController _bannerPageController;
  int _currentBannerIndex = 0;
  bool _isHoldingBanner = false;
  String _currentLocation = 'Pamekasan, Kabupaten Pamekasan';
  Map<String, String> _todaySchedule = {
    'Subuh': '04:25',
    'Dzuhur': '11:45',
    'Ashar': '15:00',
    'Maghrib': '17:45',
    'Isya': '18:55',
  };

  Timer? _timer;
  DateTime _currentTime = DateTime.now();
  String _nextPrayerName = 'Maghrib';
  String _nextPrayerTimeStr = '17:20';
  Duration _timeUntilNextPrayer = Duration.zero;
  DateTime? _lastFetchDate;
  
  final ArticleService _articleService = ArticleService();
  List<Article> _homeArticles = [];
  bool _isArticlesLoading = true;
  String? _homeArticlesError;

  List<String> _favoriteSurahs = [];
  List<String> _completedSurahs = [];
  List<String> _memorizedAyats = [];
  List<String> _studiedJuz = [];
  String _lastReadSurah = '';
  int _lastReadVerse = 0;
  int _lastReadSurahNumber = 0;

  @override
  void initState() {
    super.initState();
    _loadQuranProgress();
    final settings = Provider.of<SettingsProvider>(context, listen: false);
    _currentHeaderIndex = 999 + settings.lastHeaderIndex;
    _headerPageController = PageController(initialPage: _currentHeaderIndex);
    _bannerPageController = PageController(initialPage: 1000, viewportFraction: 0.9);
    _updateTime();
    _fetchPrayerTimes(_currentLocation);
    _loadHomeArticles();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _updateTime();
      if (mounted && timer.tick % 2 == 0 && !_isHoldingHeader) {
        if (_headerPageController.hasClients) {
          final nextPage = _headerPageController.page!.round() + 1;
          _headerPageController.animateToPage(
            nextPage,
            duration: const Duration(milliseconds: 600),
            curve: Curves.easeInOutCubic,
          );
        }
      }
      if (mounted && timer.tick % 4 == 0 && !_isHoldingBanner) {
        if (_bannerPageController.hasClients) {
          final nextBannerPage = _bannerPageController.page!.round() + 1;
          _bannerPageController.animateToPage(
            nextBannerPage,
            duration: const Duration(milliseconds: 600),
            curve: Curves.easeInOutCubic,
          );
        }
      }
    });
  }

  Future<void> _loadQuranProgress() async {
    final prefs = await SharedPreferences.getInstance();
    if (mounted) {
      setState(() {
        _favoriteSurahs = prefs.getStringList('favoriteSurahs') ?? [];
        _completedSurahs = prefs.getStringList('completedSurahs') ?? [];
        _memorizedAyats = prefs.getStringList('memorizedAyats') ?? [];
        _studiedJuz = prefs.getStringList('studiedJuz') ?? [];
        _lastReadSurah = prefs.getString('lastReadSurah') ?? '';
        _lastReadVerse = prefs.getInt('lastReadVerse') ?? 0;
        _lastReadSurahNumber = prefs.getInt('lastReadSurahNumber') ?? 0;
      });
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _headerPageController.dispose();
    _bannerPageController.dispose();
    super.dispose();
  }

  void _updateTime() {
    final now = DateTime.now();
    
    // Auto-refresh schedule at midnight
    if (_lastFetchDate != null && 
        (now.day != _lastFetchDate!.day || now.month != _lastFetchDate!.month || now.year != _lastFetchDate!.year)) {
      _fetchPrayerTimes(_currentLocation);
    }
    _lastFetchDate = now;
    final schedule = <String, DateTime>{};
    _todaySchedule.forEach((key, value) {
      try {
        final parts = value.split(':');
        schedule[key] = DateTime(
          now.year,
          now.month,
          now.day,
          int.parse(parts[0]),
          int.parse(parts[1]),
        );
      } catch (e) {
        // Fallback jika format waktu salah
      }
    });

    if (schedule.isEmpty) return;

    String nextName = 'Subuh';
    DateTime nextTime = schedule['Subuh']!.add(const Duration(days: 1)); // Default ke Subuh besok jika sudah melewati Isya

    for (var entry in schedule.entries) {
      if (now.isBefore(entry.value)) {
        nextName = entry.key;
        nextTime = entry.value;
        break;
      }
    }

    if (mounted) {
      setState(() {
        _currentTime = now;
        _nextPrayerName = nextName;
        _nextPrayerTimeStr = '${nextTime.hour.toString().padLeft(2, '0')}:${nextTime.minute.toString().padLeft(2, '0')}';
        _timeUntilNextPrayer = nextTime.difference(now);
      });
    }
  }

  Future<void> _fetchPrayerTimes(String location) async {
    try {
      String cityName = location.contains(',') ? location.split(',').last.trim() : location;
      cityName = cityName.replaceAll('Kabupaten ', '').replaceAll('Kota ', '').trim();
      
      final searchUrl = Uri.parse('https://api.myquran.com/v2/sholat/kota/cari/$cityName');
      final searchResponse = await http.get(searchUrl);
      
      if (searchResponse.statusCode == 200) {
        final searchData = json.decode(searchResponse.body);
        if (searchData['status'] == true && (searchData['data'] as List).isNotEmpty) {
          final cityId = searchData['data'][0]['id'];
          
          final now = DateTime.now();
          final scheduleUrl = Uri.parse('https://api.myquran.com/v2/sholat/jadwal/$cityId/${now.year}/${now.month}/${now.day}');
          final scheduleResponse = await http.get(scheduleUrl);
          
          if (scheduleResponse.statusCode == 200) {
            final scheduleData = json.decode(scheduleResponse.body);
            if (scheduleData['status'] == true) {
              final jadwal = scheduleData['data']['jadwal'];
              if (mounted) {
                setState(() {
                  _todaySchedule = {
                    'Subuh': jadwal['subuh'],
                    'Dzuhur': jadwal['dzuhur'],
                    'Ashar': jadwal['ashar'],
                    'Maghrib': jadwal['maghrib'],
                    'Isya': jadwal['isya'],
                  };
                });
              }
            }
          }
        }
      }
    } catch (e) {
      debugPrint('Error fetching prayer times: $e');
    }
  }

  String _getFormattedDate(DateTime date) {
    const List<String> bulan = [
      '', 'Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni',
      'Juli', 'Agustus', 'September', 'Oktober', 'November', 'Desember'
    ];
    return '${date.day} ${bulan[date.month]} ${date.year}';
  }

  String _getHijriDate(DateTime date) {
    final h = HijriCalendar.fromDate(date);
    const months = [
      'Muharram', 'Safar', 'Rabi\'ul Awal', 'Rabi\'ul Akhir',
      'Jumadil Awal', 'Jumadil Akhir', 'Rajab', 'Sya\'ban',
      'Ramadhan', 'Syawal', 'Dzulqa\'dah', 'Dzulhijjah'
    ];
    return '${h.hDay} ${months[h.hMonth - 1]} ${h.hYear}';
  }

  final List<String> _indonesianCities = [
    'Kabupaten Aceh Barat', 'Kabupaten Aceh Barat Daya', 'Kabupaten Aceh Besar', 'Kabupaten Aceh Jaya', 'Kabupaten Aceh Selatan', 'Kabupaten Aceh Singkil', 'Kabupaten Aceh Tamiang', 'Kabupaten Aceh Tengah', 'Kabupaten Aceh Tenggara', 'Kabupaten Aceh Timur', 'Kabupaten Aceh Utara', 'Kabupaten Agam', 'Kabupaten Alor', 'Kabupaten Asahan', 'Kabupaten Asmat', 'Kabupaten Badung', 'Kabupaten Balangan', 'Kabupaten Bandung', 'Kabupaten Bandung Barat', 'Kabupaten Banggai', 'Kabupaten Banggai Kepulauan', 'Kabupaten Banggai Laut', 'Kabupaten Bangka', 'Kabupaten Bangka Barat', 'Kabupaten Bangka Selatan', 'Kabupaten Bangka Tengah', 'Kabupaten Bangkalan', 'Kabupaten Bangli', 'Kabupaten Banjar', 'Kabupaten Banjarnegara', 'Kabupaten Bantaeng', 'Kabupaten Bantul', 'Kabupaten Banyu Asin', 'Kabupaten Banyumas', 'Kabupaten Banyuwangi', 'Kabupaten Barito Kuala', 'Kabupaten Barito Selatan', 'Kabupaten Barito Timur', 'Kabupaten Barito Utara', 'Kabupaten Barru', 'Kabupaten Batang', 'Kabupaten Batang Hari', 'Kabupaten Batu Bara', 'Kabupaten Bekasi', 'Kabupaten Belitung', 'Kabupaten Belitung Timur', 'Kabupaten Belu', 'Kabupaten Bener Meriah', 'Kabupaten Bengkalis', 'Kabupaten Bengkayang', 'Kabupaten Bengkulu Selatan', 'Kabupaten Bengkulu Tengah', 'Kabupaten Bengkulu Utara', 'Kabupaten Berau', 'Kabupaten Biak Numfor', 'Kabupaten Bima', 'Kabupaten Bintan', 'Kabupaten Bireuen', 'Kabupaten Blitar', 'Kabupaten Blora', 'Kabupaten Boalemo', 'Kabupaten Bogor', 'Kabupaten Bojonegoro', 'Kabupaten Bolaang Mongondow', 'Kabupaten Bolaang Mongondow Selatan', 'Kabupaten Bolaang Mongondow Timur', 'Kabupaten Bolaang Mongondow Utara', 'Kabupaten Bombana', 'Kabupaten Bondowoso', 'Kabupaten Bone', 'Kabupaten Bone Bolango', 'Kabupaten Boven Digoel', 'Kabupaten Boyolali', 'Kabupaten Brebes', 'Kabupaten Buleleng', 'Kabupaten Bulukumba', 'Kabupaten Bulungan', 'Kabupaten Bungo', 'Kabupaten Buol', 'Kabupaten Buru', 'Kabupaten Buru Selatan', 'Kabupaten Buton', 'Kabupaten Buton Selatan', 'Kabupaten Buton Tengah', 'Kabupaten Buton Utara', 'Kabupaten Ciamis', 'Kabupaten Cianjur', 'Kabupaten Cilacap', 'Kabupaten Cirebon', 'Kabupaten Dairi', 'Kabupaten Deiyai', 'Kabupaten Deli Serdang', 'Kabupaten Demak', 'Kabupaten Dharmasraya', 'Kabupaten Dogiyai', 'Kabupaten Dompu', 'Kabupaten Donggala', 'Kabupaten Empat Lawang', 'Kabupaten Ende', 'Kabupaten Enrekang', 'Kabupaten Fak-Fak', 'Kabupaten Flores Timur', 'Kabupaten Garut', 'Kabupaten Gayo Lues', 'Kabupaten Gianyar', 'Kabupaten Gorontalo', 'Kabupaten Gorontalo Utara', 'Kabupaten Gowa', 'Kabupaten Gresik', 'Kabupaten Grobogan', 'Kabupaten Gunung Kidul', 'Kabupaten Gunung Mas', 'Kabupaten Halmahera Barat', 'Kabupaten Halmahera Selatan', 'Kabupaten Halmahera Tengah', 'Kabupaten Halmahera Timur', 'Kabupaten Halmahera Utara', 'Kabupaten Hulu Sungai Selatan', 'Kabupaten Hulu Sungai Tengah', 'Kabupaten Hulu Sungai Utara', 'Kabupaten Humbang Hasundutan', 'Kabupaten Indragiri Hilir', 'Kabupaten Indragiri Hulu', 'Kabupaten Indramayu', 'Kabupaten Intan Jaya', 'Kabupaten Jayapura', 'Kabupaten Jayawijaya', 'Kabupaten Jember', 'Kabupaten Jembrana', 'Kabupaten Jeneponto', 'Kabupaten Jepara', 'Kabupaten Jombang', 'Kabupaten Kaimana', 'Kabupaten Kampar', 'Kabupaten Kapuas', 'Kabupaten Kapuas Hulu', 'Kabupaten Karang Asem', 'Kabupaten Karanganyar', 'Kabupaten Karawang', 'Kabupaten Karimun', 'Kabupaten Karo', 'Kabupaten Katingan', 'Kabupaten Kaur', 'Kabupaten Kayong Utara', 'Kabupaten Kebumen', 'Kabupaten Kediri', 'Kabupaten Keerom', 'Kabupaten Kendal', 'Kabupaten Kepahiang', 'Kabupaten Kepulauan Anambas', 'Kabupaten Kepulauan Aru', 'Kabupaten Kepulauan Mentawai', 'Kabupaten Kepulauan Meranti', 'Kabupaten Kepulauan Sangihe', 'Kabupaten Kepulauan Selayar', 'Kabupaten Kepulauan Seribu', 'Kabupaten Kepulauan Sula', 'Kabupaten Kepulauan Talaud', 'Kabupaten Kepulauan Yapen', 'Kabupaten Kerinci', 'Kabupaten Ketapang', 'Kabupaten Klaten', 'Kabupaten Klungkung', 'Kabupaten Kolaka', 'Kabupaten Kolaka Timur', 'Kabupaten Kolaka Utara', 'Kabupaten Konawe', 'Kabupaten Konawe Kepulauan', 'Kabupaten Konawe Selatan', 'Kabupaten Konawe Utara', 'Kabupaten Kota Baru', 'Kabupaten Kotawaringin Barat', 'Kabupaten Kotawaringin Timur', 'Kabupaten Kuantan Singingi', 'Kabupaten Kubu Raya', 'Kabupaten Kudus', 'Kabupaten Kulon Progo', 'Kabupaten Kuningan', 'Kabupaten Kupang', 'Kabupaten Kutai Barat', 'Kabupaten Kutai Kartanegara', 'Kabupaten Kutai Timur', 'Kabupaten Labuhan Batu', 'Kabupaten Labuhan Batu Selatan', 'Kabupaten Labuhan Batu Utara', 'Kabupaten Lahat', 'Kabupaten Lamandau', 'Kabupaten Lamongan', 'Kabupaten Lampung Barat', 'Kabupaten Lampung Selatan', 'Kabupaten Lampung Tengah', 'Kabupaten Lampung Timur', 'Kabupaten Lampung Utara', 'Kabupaten Landak', 'Kabupaten Langkat', 'Kabupaten Lanny Jaya', 'Kabupaten Lebak', 'Kabupaten Lebong', 'Kabupaten Lembata', 'Kabupaten Lima Puluh Kota', 'Kabupaten Lingga', 'Kabupaten Lombok Barat', 'Kabupaten Lombok Tengah', 'Kabupaten Lombok Timur', 'Kabupaten Lombok Utara', 'Kabupaten Lumajang', 'Kabupaten Luwu', 'Kabupaten Luwu Timur', 'Kabupaten Luwu Utara', 'Kabupaten Madiun', 'Kabupaten Magelang', 'Kabupaten Magetan', 'Kabupaten Mahakam Hulu', 'Kabupaten Majalengka', 'Kabupaten Majene', 'Kabupaten Malaka', 'Kabupaten Malang', 'Kabupaten Malinau', 'Kabupaten Maluku Barat Daya', 'Kabupaten Maluku Tengah', 'Kabupaten Maluku Tenggara', 'Kabupaten Maluku Tenggara Barat', 'Kabupaten Mamasa', 'Kabupaten Mamberamo Raya', 'Kabupaten Mamberamo Tengah', 'Kabupaten Mamuju', 'Kabupaten Mamuju Tengah', 'Kabupaten Mamuju Utara', 'Kabupaten Mandailing Natal', 'Kabupaten Manggarai', 'Kabupaten Manggarai Barat', 'Kabupaten Manggarai Timur', 'Kabupaten Manokwari', 'Kabupaten Manokwari Selatan', 'Kabupaten Mappi', 'Kabupaten Maros', 'Kabupaten Maybrat', 'Kabupaten Melawi', 'Kabupaten Mempawah', 'Kabupaten Merangin', 'Kabupaten Merauke', 'Kabupaten Mesuji', 'Kabupaten Mimika', 'Kabupaten Minahasa', 'Kabupaten Minahasa Selatan', 'Kabupaten Minahasa Tenggara', 'Kabupaten Minahasa Utara', 'Kabupaten Mojokerto', 'Kabupaten Morowali', 'Kabupaten Morowali Utara', 'Kabupaten Muara Enim', 'Kabupaten Muaro Jambi', 'Kabupaten Mukomuko', 'Kabupaten Muna', 'Kabupaten Muna Barat', 'Kabupaten Murung Raya', 'Kabupaten Musi Banyu Asin', 'Kabupaten Musi Rawas', 'Kabupaten Musi Rawas Utara', 'Kabupaten Nabire', 'Kabupaten Nagan Raya', 'Kabupaten Nagekeo', 'Kabupaten Natuna', 'Kabupaten Nduga', 'Kabupaten Ngada', 'Kabupaten Nganjuk', 'Kabupaten Ngawi', 'Kabupaten Nias', 'Kabupaten Nias Barat', 'Kabupaten Nias Selatan', 'Kabupaten Nias Utara', 'Kabupaten Nunukan', 'Kabupaten Ogan Ilir', 'Kabupaten Ogan Komering Ilir', 'Kabupaten Ogan Komering Ulu', 'Kabupaten Ogan Komering Ulu Selatan', 'Kabupaten Ogan Komering Ulu Timur', 'Kabupaten Pacitan', 'Kabupaten Padang Lawas', 'Kabupaten Padang Lawas Utara', 'Kabupaten Padang Pariaman', 'Kabupaten Pakpak Bharat', 'Kabupaten Pamekasan', 'Kabupaten Pandeglang', 'Kabupaten Pangandaran', 'Kabupaten Pangkajene Dan Kepulauan', 'Kabupaten Paniai', 'Kabupaten Parigi Moutong', 'Kabupaten Pasaman', 'Kabupaten Pasaman Barat', 'Kabupaten Paser', 'Kabupaten Pasuruan', 'Kabupaten Pati', 'Kabupaten Pegunungan Arfak', 'Kabupaten Pegunungan Bintang', 'Kabupaten Pekalongan', 'Kabupaten Pelalawan', 'Kabupaten Pemalang', 'Kabupaten Penajam Paser Utara', 'Kabupaten Penukal Abab Lematang Ilir', 'Kabupaten Pesawaran', 'Kabupaten Pesisir Barat', 'Kabupaten Pesisir Selatan', 'Kabupaten Pidie', 'Kabupaten Pidie Jaya', 'Kabupaten Pinrang', 'Kabupaten Pohuwato', 'Kabupaten Polewali Mandar', 'Kabupaten Ponorogo', 'Kabupaten Poso', 'Kabupaten Pringsewu', 'Kabupaten Probolinggo', 'Kabupaten Pulang Pisau', 'Kabupaten Pulau Morotai', 'Kabupaten Pulau Taliabu', 'Kabupaten Puncak', 'Kabupaten Puncak Jaya', 'Kabupaten Purbalingga', 'Kabupaten Purwakarta', 'Kabupaten Purworejo', 'Kabupaten Raja Ampat', 'Kabupaten Rejang Lebong', 'Kabupaten Rembang', 'Kabupaten Rokan Hilir', 'Kabupaten Rokan Hulu', 'Kabupaten Rote Ndao', 'Kabupaten Sabu Raijua', 'Kabupaten Sambas', 'Kabupaten Samosir', 'Kabupaten Sampang', 'Kabupaten Sanggau', 'Kabupaten Sarmi', 'Kabupaten Sarolangun', 'Kabupaten Sekadau', 'Kabupaten Seluma', 'Kabupaten Semarang', 'Kabupaten Seram Bagian Barat', 'Kabupaten Seram Bagian Timur', 'Kabupaten Serang', 'Kabupaten Serdang Bedagai', 'Kabupaten Seruyan', 'Kabupaten Siak', 'Kabupaten Siau Tagulandang Biaro', 'Kabupaten Sidenreng Rappang', 'Kabupaten Sidoarjo', 'Kabupaten Sigi', 'Kabupaten Sijunjung', 'Kabupaten Sikka', 'Kabupaten Simalungun', 'Kabupaten Simeulue', 'Kabupaten Sinjai', 'Kabupaten Sintang', 'Kabupaten Situbondo', 'Kabupaten Sleman', 'Kabupaten Solok', 'Kabupaten Solok Selatan', 'Kabupaten Soppeng', 'Kabupaten Sorong', 'Kabupaten Sorong Selatan', 'Kabupaten Sragen', 'Kabupaten Subang', 'Kabupaten Sukabumi', 'Kabupaten Sukamara', 'Kabupaten Sukoharjo', 'Kabupaten Sumba Barat', 'Kabupaten Sumba Barat Daya', 'Kabupaten Sumba Tengah', 'Kabupaten Sumba Timur', 'Kabupaten Sumbawa', 'Kabupaten Sumbawa Barat', 'Kabupaten Sumedang', 'Kabupaten Sumenep', 'Kabupaten Supiori', 'Kabupaten Tabalong', 'Kabupaten Tabanan', 'Kabupaten Takalar', 'Kabupaten Tambrauw', 'Kabupaten Tana Tidung', 'Kabupaten Tana Toraja', 'Kabupaten Tanah Bumbu', 'Kabupaten Tanah Datar', 'Kabupaten Tanah Laut', 'Kabupaten Tangerang', 'Kabupaten Tanggamus', 'Kabupaten Tanjung Jabung Barat', 'Kabupaten Tanjung Jabung Timur', 'Kabupaten Tapanuli Selatan', 'Kabupaten Tapanuli Tengah', 'Kabupaten Tapanuli Utara', 'Kabupaten Tapin', 'Kabupaten Tasikmalaya', 'Kabupaten Tebo', 'Kabupaten Tegal', 'Kabupaten Teluk Bintuni', 'Kabupaten Teluk Wondama', 'Kabupaten Temanggung', 'Kabupaten Timor Tengah Selatan', 'Kabupaten Timor Tengah Utara', 'Kabupaten Toba Samosir', 'Kabupaten Tojo Una-Una', 'Kabupaten Toli-Toli', 'Kabupaten Tolikara', 'Kabupaten Toraja Utara', 'Kabupaten Trenggalek', 'Kabupaten Tuban', 'Kabupaten Tulang Bawang Barat', 'Kabupaten Tulangbawang', 'Kabupaten Tulungagung', 'Kabupaten Wajo', 'Kabupaten Wakatobi', 'Kabupaten Waropen', 'Kabupaten Way Kanan', 'Kabupaten Wonogiri', 'Kabupaten Wonosobo', 'Kabupaten Yahukimo', 'Kabupaten Yalimo', 'Kota Ambon', 'Kota Balikpapan', 'Kota Banda Aceh', 'Kota Bandar Lampung', 'Kota Bandung', 'Kota Banjar', 'Kota Banjar Baru', 'Kota Banjarmasin', 'Kota Batam', 'Kota Batu', 'Kota Baubau', 'Kota Bekasi', 'Kota Bengkulu', 'Kota Bima', 'Kota Binjai', 'Kota Bitung', 'Kota Blitar', 'Kota Bogor', 'Kota Bontang', 'Kota Bukittinggi', 'Kota Cilegon', 'Kota Cimahi', 'Kota Cirebon', 'Kota Denpasar', 'Kota Depok', 'Kota Dumai', 'Kota Gorontalo', 'Kota Gunungsitoli', 'Kota Jakarta Barat', 'Kota Jakarta Pusat', 'Kota Jakarta Selatan', 'Kota Jakarta Timur', 'Kota Jakarta Utara', 'Kota Jambi', 'Kota Jayapura', 'Kota Kediri', 'Kota Kendari', 'Kota Kotamobagu', 'Kota Kupang', 'Kota Langsa', 'Kota Lhokseumawe', 'Kota Lubuk Linggau', 'Kota Madiun', 'Kota Magelang', 'Kota Makassar', 'Kota Malang', 'Kota Manado', 'Kota Mataram', 'Kota Medan', 'Kota Metro', 'Kota Mojokerto', 'Kota Padang', 'Kota Padang Panjang', 'Kota Padang Sidempuan', 'Kota Pagar Alam', 'Kota Palangka Raya', 'Kota Palembang', 'Kota Palopo', 'Kota Palu', 'Kota Pangkal Pinang', 'Kota Pare-Pare', 'Kota Pariaman', 'Kota Pasuruan', 'Kota Payakumbuh', 'Kota Pekalongan', 'Kota Pekanbaru', 'Kota Pematang Siantar', 'Kota Pontianak', 'Kota Prabumulih', 'Kota Probolinggo', 'Kota Sabang', 'Kota Salatiga', 'Kota Samarinda', 'Kota Sawah Lunto', 'Kota Semarang', 'Kota Serang', 'Kota Sibolga', 'Kota Singkawang', 'Kota Solok', 'Kota Sorong', 'Kota Subulussalam', 'Kota Sukabumi', 'Kota Sungai Penuh', 'Kota Surabaya', 'Kota Surakarta', 'Kota Tangerang', 'Kota Tangerang Selatan', 'Kota Tanjung Balai', 'Kota Tanjung Pinang', 'Kota Tarakan', 'Kota Tasikmalaya', 'Kota Tebing Tinggi', 'Kota Tegal', 'Kota Ternate', 'Kota Tidore Kepulauan', 'Kota Tomohon', 'Kota Tual', 'Kota Yogyakarta'
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    if (index == 0) {
      _loadQuranProgress();
    }
  }

  void _showLocationPicker() {
    String searchQuery = '';
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            final filteredCities = _indonesianCities
                .where((city) => city.toLowerCase().contains(searchQuery.toLowerCase()))
                .toList();

            return Container(
              height: MediaQuery.of(context).size.height * 0.8,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: Column(
                children: [
                  const SizedBox(height: 12),
                  Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    child: Text(
                      'Pilih Kota/Kabupaten',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF13A884),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: TextField(
                      autofocus: true,
                      decoration: InputDecoration(
                        hintText: 'Cari kota atau kabupaten...',
                        prefixIcon: const Icon(Icons.search, color: Color(0xFF13A884)),
                        filled: true,
                        fillColor: Colors.grey[100],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(vertical: 0),
                      ),
                      onChanged: (value) {
                        setModalState(() {
                          searchQuery = value;
                        });
                      },
                    ),
                  ),
                  const SizedBox(height: 12),
                  Expanded(
                    child: ListView.separated(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      itemCount: filteredCities.length,
                      separatorBuilder: (context, index) => Divider(
                        color: Colors.grey[100],
                        height: 1,
                        indent: 50,
                      ),
                      itemBuilder: (context, index) {
                        final city = filteredCities[index];
                        final isSelected = city == _currentLocation;
                        return ListTile(
                          leading: Icon(
                            Icons.location_on_outlined,
                            color: isSelected ? const Color(0xFF13A884) : Colors.grey[400],
                            size: 22,
                          ),
                          title: Text(
                            city,
                            style: TextStyle(
                              fontSize: 15,
                              color: isSelected ? const Color(0xFF13A884) : Colors.black87,
                              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                            ),
                          ),
                          trailing: isSelected
                              ? const Icon(Icons.check_circle, color: Color(0xFF13A884), size: 20)
                              : null,
                          onTap: () {
                            setState(() {
                              _currentLocation = city;
                            });
                            _fetchPrayerTimes(city);
                            Navigator.pop(context);
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildLocationHeader({Key? key}) {
    const primaryGreen = Color(0xFF13A884);
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Container(
      key: key,
      width: double.infinity,
      height: 200,
      decoration: BoxDecoration(
        color: isDarkMode ? const Color(0xFF1E1E1E) : Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          // Background Illustration (Lower height for landscape feel)
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Opacity(
              opacity: 0.4,
              child: Image.asset(
                'assets/images/mosque_widget_bg.png',
                fit: BoxFit.cover,
                height: 120, // Increased height to match taller container
              ),
            ),
          ),
          // Content
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Top Row: Title and Location (Combined to save vertical space)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Image.asset(
                          'assets/images/logo_el_maqam.png',
                          height: 24,
                          width: 24,
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          'MMU Ulul Maqam',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: primaryGreen,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(width: 8),
                    Flexible(
                      child: GestureDetector(
                        onTap: _showLocationPicker,
                        behavior: HitTestBehavior.opaque,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            const Icon(Icons.location_on, color: primaryGreen, size: 14),
                            const SizedBox(width: 4),
                            Flexible(
                              child: Text(
                                _currentLocation.split(',').first.trim(),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: isDarkMode ? Colors.white70 : const Color(0xFF2D3436),
                                ),
                              ),
                            ),
                            const SizedBox(width: 4),
                            Icon(Icons.keyboard_arrow_down_rounded, color: Colors.grey[400], size: 14),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                // Center Divider with Icon (Compact)
                Row(
                  children: [
                    Expanded(child: Divider(color: isDarkMode ? Colors.white10 : Colors.grey[150], thickness: 1)),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Icon(Icons.wb_sunny_rounded, size: 14, color: primaryGreen.withOpacity(0.4)),
                    ),
                    Expanded(child: Divider(color: isDarkMode ? Colors.white10 : Colors.grey[150], thickness: 1)),
                  ],
                ),
                // Prayer Time Section (More landscape-oriented)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _nextPrayerName,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: primaryGreen,
                          ),
                        ),
                        RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: _nextPrayerTimeStr,
                                style: const TextStyle(
                                  fontSize: 34,
                                  fontWeight: FontWeight.w900,
                                  color: primaryGreen,
                                ),
                              ),
                              const TextSpan(
                                text: ' WIB',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: primaryGreen,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: primaryGreen.withOpacity(0.08),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            '- ${_timeUntilNextPrayer.inHours.toString().padLeft(2, '0')} : ${(_timeUntilNextPrayer.inMinutes % 60).toString().padLeft(2, '0')} : ${(_timeUntilNextPrayer.inSeconds % 60).toString().padLeft(2, '0')}',
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: primaryGreen,
                              fontFeatures: [FontFeature.tabularFigures()],
                            ),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${_getFormattedDate(_currentTime)} / ${_getHijriDate(_currentTime)}',
                          style: TextStyle(
                            fontSize: 10,
                            color: isDarkMode ? Colors.white60 : Colors.grey[600],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Subtle Decoration Icon (Smaller and less intrusive)
          Positioned(
            right: -10,
            bottom: -10,
            child: Opacity(
              opacity: 0.05,
              child: Icon(Icons.nightlight_round, size: 60, color: primaryGreen),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuranHeaderCard({Key? key}) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedIndex = 1; // Directs user to the Al-Quran Page
        });
      },
      child: Container(
        key: key,
        width: double.infinity,
        height: 200,
        decoration: BoxDecoration(
          color: isDarkMode ? const Color(0xFF1E1E1E) : Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 15,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 1. Top White Bar
            Container(
              height: 46,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 32,
                        height: 32,
                        decoration: const BoxDecoration(
                          color: Color(0xFF0C5441),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.menu_book,
                          color: Colors.white,
                          size: 16,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Al-Quran',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: isDarkMode ? Colors.white70 : const Color(0xFF2C3E50),
                        ),
                      ),
                    ],
                  ),
                  Icon(
                    Icons.more_vert,
                    color: isDarkMode ? Colors.white60 : Colors.grey[750],
                    size: 20,
                  ),
                ],
              ),
            ),
            // 2. Middle Green Section (Inset Card)
            GestureDetector(
              onTap: () {
                if (_lastReadSurahNumber != 0) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SurahDetailPage(nomor: _lastReadSurahNumber),
                    ),
                  ).then((_) {
                    _loadQuranProgress();
                  });
                } else {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const QuranPage(useApi: true),
                    ),
                  ).then((_) {
                    _loadQuranProgress();
                  });
                }
              },
              child: Container(
                height: 82,
                margin: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: const Color(0xFF0C5441),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Stack(
                  children: [
                    // Mosque/Islamic pattern background image for depth
                    Positioned.fill(
                      child: Opacity(
                        opacity: 0.15,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: Image.asset(
                            'assets/images/islamic_pattern_bg.png',
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    // Content
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Terakhir Dibaca',
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.9),
                                  fontSize: 10,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                _lastReadSurah.isNotEmpty
                                    ? _lastReadSurah
                                    : 'Belum ada riwayat',
                                style: GoogleFonts.outfit(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 1),
                              Text(
                                _lastReadSurah.isNotEmpty
                                    ? 'Ayat $_lastReadVerse'
                                    : 'Tandai terakhir dibaca',
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.8),
                                  fontSize: 10,
                                ),
                              ),
                            ],
                          ),
                          // Rehal image
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.asset(
                              'assets/images/quran_rehal.png',
                              fit: BoxFit.cover,
                              height: 62,
                              width: 62,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // 3. Bottom White Bar (3 Progress Indicators Row)
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                alignment: Alignment.center,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildProgressIndicatorItem(
                      Icons.school_rounded,
                      '${_completedSurahs.length}',
                      'Surah Selesai',
                    ),
                    _buildProgressIndicatorItem(
                      Icons.star_rounded,
                      '${_memorizedAyats.length}',
                      'Ayat Dihafal',
                    ),
                    _buildProgressIndicatorItem(
                      Icons.bookmark_rounded,
                      '${_studiedJuz.length}',
                      'Juz Dipelajari',
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressIndicatorItem(IconData icon, String value, String label) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: const BoxDecoration(
            color: Color(0xFF0C5441),
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            color: Colors.white,
            size: 16,
          ),
        ),
        const SizedBox(width: 6),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              value,
              style: GoogleFonts.outfit(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: isDarkMode ? const Color(0xFF13A884) : const Color(0xFF0C5441),
                height: 1.1,
              ),
            ),
            Text(
              label,
              style: const TextStyle(
                fontSize: 9,
                fontWeight: FontWeight.w500,
                color: Color(0xFF7F8C8D),
              ),
            ),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      backgroundColor: isDarkMode ? const Color(0xFF121212) : Colors.white,
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          // Index 0: Beranda (Home)
          Container(
            color: isDarkMode ? const Color(0xFF121212) : const Color(0xFFF9F9F9), // Base background color (light grey/white)
            child: SingleChildScrollView(
              child: Stack(
                children: [
                  // Green Header Background (Adjusted height for better proportions)
                  Container(
                    height: 300,
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Color(0xFF2A8B74), Color(0xFF13A884), Color(0xFF0C5441)],
                      ),
                    ),
                  ),
                  // Content Overlay
                  SafeArea(
                    bottom: false,
                    child: Column(
                      children: [
                        const SizedBox(height: 15),
                        // Widget Hari Ini Header
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 14),
                          child: SizedBox(
                            height: 200,
                            child: Listener(
                              onPointerDown: (_) {
                                setState(() {
                                  _isHoldingHeader = true;
                                });
                              },
                              onPointerUp: (_) {
                                setState(() {
                                  _isHoldingHeader = false;
                                });
                              },
                              onPointerCancel: (_) {
                                setState(() {
                                  _isHoldingHeader = false;
                                });
                              },
                              child: PageView.builder(
                                controller: _headerPageController,
                                onPageChanged: (index) {
                                  setState(() {
                                    _currentHeaderIndex = index;
                                  });
                                  context.read<SettingsProvider>().setLastHeaderIndex(index % 3);
                                },
                              itemBuilder: (context, index) {
                                final pageIndex = index % 3;
                                switch (pageIndex) {
                                  case 0:
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 6),
                                      child: _buildLocationHeader(key: const ValueKey('location_header')),
                                    );
                                  case 1:
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 6),
                                      child: _buildQuranHeaderCard(key: const ValueKey('quran_header')),
                                    );
                                  case 2:
                                  default:
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 6),
                                      child: DzikirCard(
                                        key: const ValueKey('dzikir_header'),
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => const WiridDoaPage(initialIndex: 0),
                                            ),
                                          );
                                        },
                                      ),
                                    );
                                }
                              },
                            ),
                          ),
                        ),
                      ),
                        const SizedBox(height: 12),
                        // Indicator Panel (Chevron arrows + active dot indicators)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            GestureDetector(
                              onTap: () {
                                if (_headerPageController.hasClients) {
                                  _headerPageController.animateToPage(
                                    _currentHeaderIndex - 1,
                                    duration: const Duration(milliseconds: 600),
                                    curve: Curves.easeInOutCubic,
                                  );
                                }
                              },
                              behavior: HitTestBehavior.opaque,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                child: Icon(
                                  Icons.arrow_back_ios_new_rounded,
                                  size: 14,
                                  color: isDarkMode ? Colors.white30 : Colors.grey[400],
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: List.generate(3, (index) {
                                final isActive = (_currentHeaderIndex % 3) == index;
                                return AnimatedContainer(
                                  duration: const Duration(milliseconds: 300),
                                  margin: const EdgeInsets.symmetric(horizontal: 4),
                                  width: 8,
                                  height: 8,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: isActive
                                        ? const Color(0xFF13A884)
                                        : (isDarkMode ? Colors.white24 : const Color(0xFF13A884).withOpacity(0.2)),
                                  ),
                                );
                              }),
                            ),
                            const SizedBox(width: 8),
                            GestureDetector(
                              onTap: () {
                                if (_headerPageController.hasClients) {
                                  _headerPageController.animateToPage(
                                    _currentHeaderIndex + 1,
                                    duration: const Duration(milliseconds: 600),
                                    curve: Curves.easeInOutCubic,
                                  );
                                }
                              },
                              behavior: HitTestBehavior.opaque,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                child: Icon(
                                  Icons.arrow_forward_ios_rounded,
                                  size: 14,
                                  color: isDarkMode ? Colors.white30 : Colors.grey[400],
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 18),
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 16),
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: isDarkMode ? const Color(0xFF1E1E1E) : Colors.white,
                            borderRadius: BorderRadius.circular(30),
                            boxShadow: [
                              BoxShadow(
                                color: isDarkMode ? Colors.black.withOpacity(0.2) : Colors.black.withOpacity(0.08),
                                blurRadius: 20,
                                offset: const Offset(0, 10),
                              ),
                            ],
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 32),
                          child: _buildMenuGrid(),
                        ),
                        const SizedBox(height: 24),
                        _buildHomeSearchBar(),
                        const SizedBox(height: 24),
                        _buildHomeNewsSection(),
                        const SizedBox(height: 20),
                        _buildBannerCarousel(),
                        const SizedBox(height: 12),
                        _buildBannerIndicators(),
                        const SizedBox(height: 24),
                        _buildAksesCepatSection(),
                        const SizedBox(height: 24),
                        _buildKutipanInspiratifSection(),
                        const SizedBox(height: 24),
                        _buildVideoTutorialSection(),
                        const SizedBox(height: 24),
                        _buildAgendaTerdekatSection(),
                        const SizedBox(height: 100),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Index 1: Al-Quran (Bottom Nav - Local Data)
          const QuranPage(useApi: false),
          // Index 2: Artikel
          const ArticlePage(),
          // Index 3: Kalender
          const CalendarPage(),
          // Index 4: Pengaturan
          const SettingsPage(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        backgroundColor: isDarkMode ? const Color(0xFF1E1E1E) : Colors.white,
        selectedItemColor: const Color(0xFF13A884),
        unselectedItemColor: isDarkMode ? Colors.white30 : Colors.grey,
        showUnselectedLabels: true,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_filled),
            label: 'Beranda',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.menu_book),
            label: 'Al-Quran',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.article_outlined),
            label: 'Artikel',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_month_outlined),
            label: 'Kalender',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings_outlined),
            label: 'Pengaturan',
          ),
        ],
      ),
    );
  }

  Future<void> _loadHomeArticles() async {
    if (mounted) {
      setState(() {
        _isArticlesLoading = true;
        _homeArticlesError = null;
      });
    }
    try {
      // Try Firanda first
      var result = await _articleService.getArticles('fir', page: 1);
      
      // Fallback to Konsultasi Syariah if fir fails or returns empty list
      if (result['success'] == false || (result['articles'] as List).isEmpty) {
        result = await _articleService.getArticles('ks', page: 1);
      }

      if (mounted) {
        setState(() {
          final List<Article> articles = result['articles'] ?? [];
          final filtered = articles.where((article) {
            final title = article.title.toLowerCase();
            return !title.contains('menjaga keistiqamahan') &&
                   !title.contains('istiqomah dalam ketaatan');
          }).toList();
          _homeArticles = filtered.take(3).toList();
          if (_homeArticles.isEmpty) {
            _homeArticlesError = result['error'] ?? 'Gagal memuat berita';
          } else {
            _homeArticlesError = null;
          }
          _isArticlesLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _homeArticlesError = 'Terjadi kesalahan: $e';
          _isArticlesLoading = false;
        });
      }
    }
  }

  Widget _buildHomeNewsSection() {
    const primaryGreen = Color(0xFF13A884);
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Berita Terbaru',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: isDarkMode ? Colors.white : const Color(0xFF2D3436),
                ),
              ),
              TextButton(
                onPressed: () => _onItemTapped(2),
                child: const Text('Lihat Semua', style: TextStyle(color: primaryGreen)),
              ),
            ],
          ),
        ),
        if (_isArticlesLoading)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 24),
            child: Center(child: CircularProgressIndicator(color: primaryGreen)),
          )
        else if (_homeArticles.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 24),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    _homeArticlesError ?? 'Gagal memuat berita',
                    style: TextStyle(color: isDarkMode ? Colors.white60 : Colors.grey[600], fontSize: 14),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton.icon(
                    onPressed: _loadHomeArticles,
                    icon: const Icon(Icons.refresh, size: 16, color: Colors.white),
                    label: const Text('Coba Lagi', style: TextStyle(color: Colors.white, fontSize: 12)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryGreen,
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
        else
          ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _homeArticles.length,
            separatorBuilder: (context, index) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final article = _homeArticles[index];
              return Container(
                decoration: BoxDecoration(
                  color: isDarkMode ? const Color(0xFF1E1E1E) : Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: isDarkMode ? Colors.black.withOpacity(0.15) : Colors.black.withOpacity(0.04),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(8),
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      article.image,
                      width: 80,
                      height: 80,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                          Container(width: 80, height: 80, color: isDarkMode ? Colors.grey[800] : Colors.grey[200]),
                    ),
                  ),
                  title: Text(
                    article.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: isDarkMode ? Colors.white : Colors.black87,
                    ),
                  ),
                  subtitle: Text(
                    article.contentSnippet,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 12,
                      color: isDarkMode ? Colors.white60 : Colors.black54,
                    ),
                  ),
                  onTap: () => _onItemTapped(2), // Go to full news page
                ),
              );
            },
          ),
      ],
    );
  }

  Widget _buildMenuGrid() {
    return GridView.count(
      crossAxisCount: 4, // 4 kolom sesuai gambar referensi
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 16,
      crossAxisSpacing: 8,
      childAspectRatio: 0.85,
      children: [
        AlQuranIcon(onTap: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const QuranPage(useApi: true)),
          );
          _loadQuranProgress();
        }),
        const WiridDoaIcon(),
        const JadwalShalatIcon(), // Icon jam yang baru kita buat
        const KiblatIcon(),       // Tambahkan placeholder jika ingin melengkapi
        const TahlilIcon(),
        const MaulidIcon(),
        const TutorialIbadahIcon(),
        const RamadhanIcon(),
      ],
    );
  }

  Widget _buildHomeSearchBar() {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: GestureDetector(
        onTap: () => _showGlobalSearch(context),
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: isDarkMode ? const Color(0xFF1E1E1E) : const Color(0xFFF2F4F5),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isDarkMode ? Colors.white.withOpacity(0.08) : Colors.transparent,
            ),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            children: [
              Icon(
                Icons.search,
                color: isDarkMode ? Colors.white60 : Colors.grey[600],
                size: 20,
              ),
              const SizedBox(width: 12),
              Text(
                'Cari doa, wirid, artikel',
                style: TextStyle(
                  fontSize: 14,
                  color: isDarkMode ? Colors.white54 : Colors.grey[500],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showGlobalSearch(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return const GlobalSearchModal();
      },
    );
  }

  Widget _buildBannerCarousel() {
    return SizedBox(
      height: 130,
      child: PageView.builder(
        controller: _bannerPageController,
        itemCount: 10000,
        onPageChanged: (index) {
          setState(() {
            _currentBannerIndex = index % 4;
          });
        },
        itemBuilder: (context, index) {
          final actualIndex = index % 4;
          return Listener(
            onPointerDown: (_) => setState(() => _isHoldingBanner = true),
            onPointerUp: (_) => setState(() => _isHoldingBanner = false),
            child: _buildBannerCard(actualIndex),
          );
        },
      ),
    );
  }

  Widget _buildBannerCard(int index) {
    switch (index) {
      case 0:
        return _buildZakatBanner();
      case 1:
        return _buildBsnBanner();
      case 2:
        return _buildArticleBanner();
      case 3:
        return _buildPrayerBanner();
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildBannerIndicators() {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final primaryGreen = const Color(0xFF13A884);
    
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(4, (index) {
        final isSelected = _currentBannerIndex == index;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: isSelected ? 16 : 8,
          height: 8,
          decoration: BoxDecoration(
            color: isSelected 
                ? primaryGreen 
                : (isDarkMode ? Colors.white24 : const Color(0xFFE2E8F0)),
            borderRadius: BorderRadius.circular(4),
          ),
        );
      }),
    );
  }

  Widget _buildAksesCepatSection() {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Text(
            'Akses Cepat',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: isDarkMode ? Colors.white : const Color(0xFF2D3436),
            ),
          ),
        ),
        const SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Row(
            children: [
              Expanded(
                child: _buildAksesCepatCard(
                  icon: Icons.calendar_month,
                  title: 'Jadwal\nKegiatan',
                  onTap: () => _onItemTapped(3),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildAksesCepatCard(
                  icon: Icons.school,
                  title: 'Ilmu\nBermanfaat',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const TutorialIbadahPage()),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAksesCepatCard({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    const primaryGreen = Color(0xFF13A884);
    
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
        decoration: BoxDecoration(
          color: isDarkMode ? const Color(0xFF1E1E1E) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: isDarkMode ? Colors.black.withOpacity(0.15) : Colors.black.withOpacity(0.04),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: isDarkMode ? const Color(0xFF0F362C) : const Color(0xFFE8F5F1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: primaryGreen,
                size: 20,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: isDarkMode ? Colors.white : const Color(0xFF2D3436),
                height: 1.3,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildKutipanInspiratifSection() {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    const primaryGreen = Color(0xFF13A884);
    
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isDarkMode ? const Color(0xFF132A24) : const Color(0xFFEAF4F1),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Kutipan Inspiratif',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: primaryGreen,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '“',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: primaryGreen,
                          height: 0.9,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          '"ilmu tanpa amal ibarat pohon tanpa buah,\ndan amal tanpa ilmu ibarat perjalanan tanpa arah."',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                            color: isDarkMode ? Colors.white.withOpacity(0.8) : const Color(0xFF2D3436),
                            height: 1.4,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Padding(
                    padding: const EdgeInsets.only(left: 20),
                    child: Text(
                      '- Imam Al-Ghazali',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: primaryGreen,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            SizedBox(
              width: 90,
              height: 80,
              child: CustomPaint(
                painter: LanternPainter(color: primaryGreen),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVideoTutorialSection() {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    const primaryGreen = Color(0xFF13A884);
    
    final videos = [
      {
        'title': 'Vlog Haji Khusus: Dari Haramain Menuju Masjidil Haram',
        'category': 'Ibadah Haji',
        'duration': '03:10',
        'videoId': 'W3ebQEEecm0',
      },
      {
        'title': 'Vlog Haji Tarwiyah di Mina: Aktivitas Jemaah Haji Plus',
        'category': 'Ibadah Haji',
        'duration': '07:07',
        'videoId': 'xK09lG3wp5Y',
      },
      {
        'title': 'Sejarah, Fiqih, Akidah & Hikmah Dari Syariat Qurban',
        'category': 'Syariah & Ubudiyah',
        'duration': '72:11',
        'videoId': 'Ndy1wRvajzg',
      },
      {
        'title': 'Ayat-Ayat Perekat Cinta Pasangan Suami Istri',
        'category': 'Keluarga & Muamalah',
        'duration': '89:39',
        'videoId': 'vxgQvrr_tvE',
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          child: GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const KajianVideoPage()),
              );
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      width: 4,
                      height: 18,
                      decoration: BoxDecoration(
                        color: const Color(0xFFB85C38),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Video',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: isDarkMode ? Colors.white : const Color(0xFF1E1E1E),
                      ),
                    ),
                  ],
                ),
                Icon(
                  Icons.chevron_right,
                  color: isDarkMode ? Colors.white54 : Colors.black54,
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 4),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Row(
            children: [
              ...videos.map((vid) {
                final videoId = vid['videoId']!;
                final videoUrl = 'https://www.youtube.com/watch?v=$videoId';
                
                return Padding(
                  padding: const EdgeInsets.only(right: 16, bottom: 8),
                  child: GestureDetector(
                    onTap: () async {
                      final Uri uri = Uri.parse(videoUrl);
                      if (await canLaunchUrl(uri)) {
                        await launchUrl(uri, mode: LaunchMode.externalApplication);
                      } else {
                        if (!mounted) return;
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Tidak dapat membuka link: $videoUrl')),
                        );
                      }
                    },
                    child: Container(
                      width: 160,
                      height: 175,
                      decoration: BoxDecoration(
                        color: isDarkMode ? const Color(0xFF1E1E1E) : Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: isDarkMode ? Colors.black.withOpacity(0.2) : Colors.black.withOpacity(0.05),
                            blurRadius: 6,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Stack(
                            children: [
                              ClipRRect(
                                borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                                child: Image.network(
                                  'https://img.youtube.com/vi/$videoId/mqdefault.jpg',
                                  height: 95,
                                  width: 160,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) => Container(
                                    height: 95,
                                    width: 160,
                                    decoration: const BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [Color(0xFF0F5A47), Color(0xFF13A884)],
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                      ),
                                    ),
                                    child: const Center(
                                      child: Icon(Icons.play_circle_fill, color: Colors.white, size: 36),
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                right: 8,
                                bottom: 8,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: Colors.black.withOpacity(0.7),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Text(
                                    vid['duration']!,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 9,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  vid['category']!,
                                  style: TextStyle(
                                    fontSize: 9,
                                    color: isDarkMode ? Colors.white54 : Colors.grey[600],
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  vid['title']!,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                    color: isDarkMode ? Colors.white : const Color(0xFF2D3436),
                                    height: 1.3,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }),
              Padding(
                padding: const EdgeInsets.only(right: 8, bottom: 8),
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const KajianVideoPage()),
                    );
                  },
                  child: SizedBox(
                    width: 100,
                    height: 175,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            color: primaryGreen,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: primaryGreen.withOpacity(0.3),
                                blurRadius: 8,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.chevron_right,
                            color: Colors.white,
                            size: 24,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Lihat Semua',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: isDarkMode ? Colors.white : const Color(0xFF2D3436),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAgendaTerdekatSection() {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    const primaryGreen = Color(0xFF13A884);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Agenda Terdekat',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: isDarkMode ? Colors.white : const Color(0xFF2D3436),
                ),
              ),
              TextButton(
                onPressed: () => _onItemTapped(3),
                style: TextButton.styleFrom(
                  minimumSize: Size.zero,
                  padding: EdgeInsets.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: const Text('Lihat Semua', style: TextStyle(color: primaryGreen, fontSize: 13)),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: GestureDetector(
            onTap: () => _onItemTapped(3),
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isDarkMode ? const Color(0xFF1E1E1E) : Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: isDarkMode ? Colors.black.withOpacity(0.15) : Colors.black.withOpacity(0.04),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      color: isDarkMode ? const Color(0xFF0F362C) : const Color(0xFFE8F5F1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '25',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: primaryGreen,
                            height: 1.1,
                          ),
                        ),
                        Text(
                          'MEI 2024',
                          style: TextStyle(
                            fontSize: 8,
                            fontWeight: FontWeight.bold,
                            color: primaryGreen,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Kajian Rutin Sabtu Pagi',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: isDarkMode ? Colors.white : const Color(0xFF2D3436),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(Icons.access_time, size: 12, color: isDarkMode ? Colors.white54 : Colors.grey[600]),
                            const SizedBox(width: 4),
                            Text(
                              '08.00 - 10.00 WIB',
                              style: TextStyle(
                                fontSize: 10,
                                color: isDarkMode ? Colors.white54 : Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 2),
                        Row(
                          children: [
                            Icon(Icons.location_on, size: 12, color: isDarkMode ? Colors.white54 : Colors.grey[600]),
                            const SizedBox(width: 4),
                            Text(
                              'Aula MMU Ulul Maqam',
                              style: TextStyle(
                                fontSize: 10,
                                color: isDarkMode ? Colors.white54 : Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: isDarkMode ? const Color(0xFF0F362C) : const Color(0xFFE8F5F1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      'Akan Datang',
                      style: TextStyle(
                        fontSize: 9,
                        fontWeight: FontWeight.bold,
                        color: primaryGreen,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPhotoIllustration(String assetPath) {
    return Container(
      width: 95,
      height: 90,
      margin: const EdgeInsets.only(left: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white, width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 6,
            offset: const Offset(2, 2),
          ),
        ],
        image: DecorationImage(
          image: AssetImage(assetPath),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _buildZakatBannerIllustration() {
    return _buildPhotoIllustration('assets/images/banner_staff.jpg');
  }

  Widget _buildBsnBannerIllustration() {
    return _buildPhotoIllustration('assets/images/banner_group_teal.jpg');
  }

  Widget _buildArticleBannerIllustration() {
    return _buildPhotoIllustration('assets/images/banner_male_students.jpg');
  }

  Widget _buildPrayerBannerIllustration() {
    return _buildPhotoIllustration('assets/images/banner_female_students.jpg');
  }

  Widget _buildZakatBanner() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 6),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFF0F5A47),
            Color(0xFF13A884),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Text(
                          'DEWAN GURU',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 8,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        'MMU Ulul Maqam',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.8),
                          fontSize: 8,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'Ustadz & Ustadzah',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Para pendidik dan pengabdi yang mengajar dengan keikhlasan di Madrasah Miftahul Ulum Ulul Maqam.',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.9),
                      fontSize: 9,
                      height: 1.2,
                    ),
                  ),
                ],
              ),
            ),
            _buildZakatBannerIllustration(),
          ],
        ),
      ),
    );
  }

  Widget _buildBsnBanner() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 6),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFF7CA695),
            Color(0xFFA5C2B4),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Text(
                          'IKSAUMA',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 8,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        'Ikatan Santri Ulul Maqam',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.8),
                          fontSize: 8,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'BUKBER (Buka Bersama)',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Menjalin ukhuwah dan kebersamaan dalam indahnya berbagi di bulan suci.',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.9),
                      fontSize: 9,
                      height: 1.2,
                    ),
                  ),
                ],
              ),
            ),
            _buildBsnBannerIllustration(),
          ],
        ),
      ),
    );
  }

  Widget _buildArticleBanner() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 6),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFFE07A5F),
            Color(0xFFF4A261),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Text(
                          'IKSAUMA',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 8,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        'Ikatan Santri Ulul Maqam',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.8),
                          fontSize: 8,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'IKSAUMA Putra',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Wadah silaturahmi, kreasi, dan ukhuwah santri putra Yayasan Pendidikan El-Maqam.',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.9),
                      fontSize: 9,
                      height: 1.2,
                    ),
                  ),
                ],
              ),
            ),
            _buildArticleBannerIllustration(),
          ],
        ),
      ),
    );
  }

  Widget _buildPrayerBanner() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 6),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFF264653),
            Color(0xFF2A9D8F),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Text(
                          'IKSAUMA',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 8,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        'Ikatan Santri Ulul Maqam',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.8),
                          fontSize: 8,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'IKSAUMA Putri',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Wadah silaturahmi, kreasi, dan ukhuwah santriwati Yayasan Pendidikan El-Maqam.',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.9),
                      fontSize: 9,
                      height: 1.2,
                    ),
                  ),
                ],
              ),
            ),
            _buildPrayerBannerIllustration(),
          ],
        ),
      ),
    );
  }

}

class GlobalSearchModal extends StatefulWidget {
  const GlobalSearchModal({super.key});

  @override
  State<GlobalSearchModal> createState() => _GlobalSearchModalState();
}

class _GlobalSearchModalState extends State<GlobalSearchModal> {
  final TextEditingController _searchController = TextEditingController();
  final ArticleService _articleService = ArticleService();
  String _query = '';
  String _activeTab = 'Semua';
  List<DoaModel> _filteredDoas = [];
  List<WiridCategory> _filteredWirids = [];
  List<Article> _filteredArticles = [];
  bool _isLoadingArticles = false;
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _onSearchChanged() {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 350), () {
      final q = _searchController.text.trim();
      if (q != _query) {
        setState(() {
          _query = q;
        });
        _performSearch();
      }
    });
  }

  Future<void> _performSearch() async {
    if (_query.isEmpty) {
      setState(() {
        _filteredDoas = [];
        _filteredWirids = [];
        _filteredArticles = [];
      });
      return;
    }

    final lowerQuery = _query.toLowerCase();

    final matchingDoas = DoaData.listDoaHarian.where((doa) {
      return doa.title.toLowerCase().contains(lowerQuery) ||
             doa.translation.toLowerCase().contains(lowerQuery) ||
             doa.arabic.contains(_query);
    }).toList();

    final matchingWirids = wiridData.where((category) {
      final titleMatch = category.title.toLowerCase().contains(lowerQuery);
      final subtitleMatch = category.subtitle.toLowerCase().contains(lowerQuery);
      final itemsMatch = category.items.any((item) =>
          item.arabic.contains(_query) ||
          item.latin.toLowerCase().contains(lowerQuery) ||
          item.translation.toLowerCase().contains(lowerQuery));
      return titleMatch || subtitleMatch || itemsMatch;
    }).toList();

    setState(() {
      _filteredDoas = matchingDoas;
      _filteredWirids = matchingWirids;
    });

    setState(() {
      _isLoadingArticles = true;
    });

    try {
      final result = await _articleService.getArticles('fir', query: _query);
      var articles = result['articles'] as List<Article>? ?? [];
      
      if (articles.isEmpty) {
        final resultKs = await _articleService.getArticles('ks', query: _query);
        articles = resultKs['articles'] as List<Article>? ?? [];
      }

      if (mounted) {
        setState(() {
          _filteredArticles = articles;
          _isLoadingArticles = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoadingArticles = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    const primaryGreen = Color(0xFF13A884);
    
    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      decoration: BoxDecoration(
        color: isDarkMode ? const Color(0xFF121212) : Colors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      padding: EdgeInsets.only(
        top: 16,
        left: 16,
        right: 16,
        bottom: MediaQuery.of(context).viewInsets.bottom + 16,
      ),
      child: Column(
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: isDarkMode ? Colors.white24 : Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: isDarkMode ? const Color(0xFF1E1E1E) : const Color(0xFFF2F4F5),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: TextField(
                    controller: _searchController,
                    autofocus: true,
                    style: TextStyle(
                      color: isDarkMode ? Colors.white : Colors.black87,
                      fontSize: 15,
                    ),
                    decoration: InputDecoration(
                      prefixIcon: Icon(
                        Icons.search,
                        color: isDarkMode ? Colors.white60 : Colors.grey[600],
                      ),
                      suffixIcon: _searchController.text.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.clear, size: 18),
                              onPressed: () {
                                _searchController.clear();
                                setState(() {
                                  _query = '';
                                  _filteredDoas = [];
                                  _filteredWirids = [];
                                  _filteredArticles = [];
                                });
                              },
                            )
                          : null,
                      hintText: 'Cari doa, wirid, artikel...',
                      hintStyle: TextStyle(
                        color: isDarkMode ? Colors.white38 : Colors.grey[500],
                        fontSize: 15,
                      ),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text(
                  'Batal',
                  style: TextStyle(
                    color: primaryGreen,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildTabButton('Semua'),
                _buildTabButton('Doa'),
                _buildTabButton('Wirid'),
                _buildTabButton('Artikel'),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: _query.isEmpty
                ? _buildEmptyState('Ketik kata kunci untuk memulai pencarian')
                : _buildResultsList(),
          ),
        ],
      ),
    );
  }

  Widget _buildTabButton(String name) {
    final isSelected = _activeTab == name;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    const primaryGreen = Color(0xFF13A884);
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: ChoiceChip(
        label: Text(
          name,
          style: TextStyle(
            color: isSelected
                ? Colors.white
                : (isDarkMode ? Colors.white70 : Colors.black87),
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            fontSize: 13,
          ),
        ),
        selected: isSelected,
        onSelected: (selected) {
          if (selected) {
            setState(() {
              _activeTab = name;
            });
          }
        },
        selectedColor: primaryGreen,
        backgroundColor: isDarkMode ? const Color(0xFF1E1E1E) : const Color(0xFFF2F4F5),
        checkmarkColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 6),
      ),
    );
  }

  Widget _buildEmptyState(String message) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search_off_outlined,
              size: 48,
              color: isDarkMode ? Colors.white24 : Colors.grey[400],
            ),
            const SizedBox(height: 12),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: isDarkMode ? Colors.white54 : Colors.grey[600],
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResultsList() {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    
    final showDoa = _activeTab == 'Semua' || _activeTab == 'Doa';
    final showWirid = _activeTab == 'Semua' || _activeTab == 'Wirid';
    final showArticles = _activeTab == 'Semua' || _activeTab == 'Artikel';

    final List<Widget> listItems = [];

    if (showDoa && _filteredDoas.isNotEmpty) {
      listItems.add(_buildHeader('Doa Harian (${_filteredDoas.length})'));
      for (final doa in _filteredDoas) {
        listItems.add(_buildDoaRow(doa));
      }
    }

    if (showWirid && _filteredWirids.isNotEmpty) {
      listItems.add(_buildHeader('Wirid (${_filteredWirids.length})'));
      for (final category in _filteredWirids) {
        listItems.add(_buildWiridRow(category));
      }
    }

    if (showArticles) {
      if (_isLoadingArticles) {
        listItems.add(
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 24),
            child: Center(
              child: CircularProgressIndicator(color: Color(0xFF13A884)),
            ),
          ),
        );
      } else if (_filteredArticles.isNotEmpty) {
        listItems.add(_buildHeader('Artikel (${_filteredArticles.length})'));
        for (final article in _filteredArticles) {
          listItems.add(_buildArticleRow(article));
        }
      }
    }

    if (listItems.isEmpty) {
      if (_isLoadingArticles && _activeTab == 'Artikel') {
        return const Center(
          child: CircularProgressIndicator(color: Color(0xFF13A884)),
        );
      }
      return _buildEmptyState('Tidak ada hasil ditemukan untuk "$_query"');
    }

    return ListView.separated(
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: listItems.length,
      separatorBuilder: (context, index) {
        if (listItems[index] is _HeaderWidget || (index + 1 < listItems.length && listItems[index + 1] is _HeaderWidget)) {
          return const SizedBox.shrink();
        }
        return Divider(
          color: isDarkMode ? Colors.white10 : Colors.grey[200],
          height: 1,
        );
      },
      itemBuilder: (context, index) => listItems[index],
    );
  }

  Widget _buildHeader(String title) {
    return _HeaderWidget(title: title);
  }

  Widget _buildDoaRow(DoaModel doa) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return ListTile(
      leading: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: isDarkMode ? const Color(0xFF1F2E2A) : const Color(0xFFE8F5F1),
          shape: BoxShape.circle,
        ),
        child: const Icon(Icons.bookmark_border, color: Color(0xFF13A884), size: 18),
      ),
      title: Text(
        doa.title,
        style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
      ),
      subtitle: Text(
        doa.translation,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(fontSize: 12, color: isDarkMode ? Colors.white54 : Colors.grey[600]),
      ),
      trailing: const Icon(Icons.arrow_forward_ios, size: 12, color: Colors.grey),
      onTap: () {
        Navigator.pop(context);
        final idx = DoaData.listDoaHarian.indexOf(doa);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DoaDetailPage(
              doa: doa,
              doaList: DoaData.listDoaHarian,
              currentIndex: idx >= 0 ? idx : 0,
            ),
          ),
        );
      },
    );
  }

  Widget _buildWiridRow(WiridCategory category) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return ListTile(
      leading: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: isDarkMode ? const Color(0xFF1F2E2A) : const Color(0xFFE8F5F1),
          shape: BoxShape.circle,
        ),
        child: const Icon(Icons.menu_book, color: Color(0xFF13A884), size: 18),
      ),
      title: Text(
        category.title,
        style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
      ),
      subtitle: Text(
        category.subtitle,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(fontSize: 12, color: isDarkMode ? Colors.white54 : Colors.grey[600]),
      ),
      trailing: const Icon(Icons.arrow_forward_ios, size: 12, color: Colors.grey),
      onTap: () {
        Navigator.pop(context);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => WiridDetailPage(category: category),
          ),
        );
      },
    );
  }

  Widget _buildArticleRow(Article article) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return ListTile(
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(6),
        child: article.thumbnail.isNotEmpty
            ? Image.network(
                article.thumbnail,
                width: 36,
                height: 36,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  width: 36,
                  height: 36,
                  color: const Color(0xFFE8F5F1),
                  child: const Icon(Icons.article_outlined, color: Color(0xFF13A884), size: 18),
                ),
              )
            : Container(
                width: 36,
                height: 36,
                color: const Color(0xFFE8F5F1),
                child: const Icon(Icons.article_outlined, color: Color(0xFF13A884), size: 18),
              ),
      ),
      title: Text(
        article.title,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13, height: 1.3),
      ),
      subtitle: Text(
        article.contentSnippet,
        style: TextStyle(fontSize: 11, color: isDarkMode ? Colors.white54 : Colors.grey[500]),
      ),
      trailing: const Icon(Icons.arrow_forward_ios, size: 12, color: Colors.grey),
      onTap: () {
        Navigator.pop(context);
        final portalId = article.type.isNotEmpty ? article.type : (article.url.contains('firanda') ? 'fir' : 'ks');
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ArticleDetailPage(
              portalId: portalId,
              articleId: article.id,
              articleTitle: article.title,
              articleUrl: article.url,
              articleSource: portalId == 'fir' ? 'Firanda.com' : 'Konsultasi Syariah',
            ),
          ),
        );
      },
    );
  }
}

class _HeaderWidget extends StatelessWidget {
  final String title;
  const _HeaderWidget({required this.title});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Container(
      width: double.infinity,
      color: isDarkMode ? const Color(0xFF1A1A1A) : Colors.grey[50],
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: isDarkMode ? Colors.white60 : Colors.grey[700],
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// ICON 1: AL-QURAN
// Icon by BZZRINCANTATION - Flaticon (https://www.flaticon.com/free-icons/quran)
// ─────────────────────────────────────────────────────────────
class AlQuranIcon extends StatelessWidget {
  final VoidCallback? onTap;
  const AlQuranIcon({super.key, this.onTap});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return GestureDetector(
      onTap: onTap ?? () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const QuranPage(useApi: true)),
        );
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: isDarkMode ? const Color(0xFF0F362C) : const Color(0xFFE8F5F1),
              shape: BoxShape.circle,
            ),
            padding: const EdgeInsets.all(8),
            child: CustomPaint(
              painter: QuranIconPainter(),
            ),
          ),
          const SizedBox(height: 5),
          Text(
            'Al-Quran',
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w500,
              color: isDarkMode ? Colors.white70 : const Color(0xFF333333),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// ICON 2: WIRID & DOA
// ─────────────────────────────────────────────────────────────
class WiridDoaIcon extends StatelessWidget {
  const WiridDoaIcon({super.key});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final settings = context.watch<SettingsProvider>();
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const WiridDoaPage(initialIndex: 0)),
        );
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: isDarkMode ? const Color(0xFF0F362C) : const Color(0xFFE8F5F1),
              shape: BoxShape.circle,
            ),
            padding: const EdgeInsets.all(8),
            child: Image.asset(
              'assets/images/wirid_doa_icon.png',
              fit: BoxFit.contain,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            settings.translate('title'),
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w500,
              color: isDarkMode ? Colors.white70 : const Color(0xFF333333),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// ICON 3: JADWAL SHALAT
// Icon by Ghozi Muhtarom - Flaticon (https://www.flaticon.com/free-icons/prayer)
// ─────────────────────────────────────────────────────────────
class JadwalShalatIcon extends StatelessWidget {
  const JadwalShalatIcon({super.key});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const PrayerSchedulePage()),
        );
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: isDarkMode ? const Color(0xFF0F362C) : const Color(0xFFE8F5F1),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: isDarkMode ? const Color(0xFF1E1E1E) : Colors.white,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: const Color(0xFF13A884),
                    width: 2.5,
                  ),
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      width: 4,
                      height: 4,
                      decoration: const BoxDecoration(
                        color: Color(0xFF13A884),
                        shape: BoxShape.circle,
                      ),
                    ),
                    Positioned(
                      top: 4,
                      child: Container(
                        width: 2,
                        height: 12,
                        decoration: BoxDecoration(
                          color: const Color(0xFF13A884),
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                    Positioned(
                      right: 6,
                      child: Container(
                        width: 10,
                        height: 2,
                        decoration: BoxDecoration(
                          color: const Color(0xFF13A884),
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 5),
          Text(
            'Jadwal Shalat',
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w500,
              color: isDarkMode ? Colors.white70 : const Color(0xFF333333),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// ICON 4: KIBLAT
// Kiblat icons created by Fahrul Oktaviana - Flaticon (https://www.flaticon.com/free-icons/kiblat)
// ─────────────────────────────────────────────────────────────
class KiblatIcon extends StatelessWidget {
  const KiblatIcon({super.key});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const QiblaPage()),
        );
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: isDarkMode ? const Color(0xFF0F362C) : const Color(0xFFE8F5F1),
              shape: BoxShape.circle,
            ),
            padding: const EdgeInsets.all(8),
            child: Image.asset(
              'assets/images/kiblat_icon.png',
              fit: BoxFit.contain,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            'Kiblat',
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w500,
              color: isDarkMode ? Colors.white70 : const Color(0xFF333333),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}


// ─────────────────────────────────────────────────────────────
// ICON 5: TAHLIL & YASIN
// Worship icons created by ariyantodeni - Flaticon (https://www.flaticon.com/free-icons/worship)
// ─────────────────────────────────────────────────────────────
class TahlilIcon extends StatelessWidget {
  const TahlilIcon({super.key});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => TahlilYasinPage(initialIndex: 0)),
        );
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: isDarkMode ? const Color(0xFF0F362C) : const Color(0xFFE8F5F1),
              shape: BoxShape.circle,
            ),
            padding: const EdgeInsets.all(8),
            child: Image.asset(
              'assets/images/tahlil_icon.png',
              fit: BoxFit.contain,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            'Tahlil & Yasin',
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w500,
              color: isDarkMode ? Colors.white70 : const Color(0xFF333333),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// ICON 6: HADIS
// Eid mubarak icons created by mnauliady - Flaticon (https://www.flaticon.com/free-icons/eid-mubarak)
// ─────────────────────────────────────────────────────────────
class MaulidIcon extends StatelessWidget {
  const MaulidIcon({super.key});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const HadithPage()),
        );
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: isDarkMode ? const Color(0xFF0F362C) : const Color(0xFFE8F5F1),
              shape: BoxShape.circle,
            ),
            padding: const EdgeInsets.all(8),
            child: Image.asset(
              'assets/images/maulid_icon.png',
              fit: BoxFit.contain,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            'Hadis',
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w500,
              color: isDarkMode ? Colors.white70 : const Color(0xFF333333),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// ICON 7: TUTORIAL IBADAH
// Arabic icons created by MEDZ - Flaticon (https://www.flaticon.com/free-icons/arabic)
// ─────────────────────────────────────────────────────────────
class TutorialIbadahIcon extends StatelessWidget {
  const TutorialIbadahIcon({super.key});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const TutorialIbadahPage()),
        );
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: isDarkMode ? const Color(0xFF0F362C) : const Color(0xFFE8F5F1),
              shape: BoxShape.circle,
            ),
            padding: const EdgeInsets.all(8),
            child: Image.asset(
              'assets/images/zakat_icon.png',
              fit: BoxFit.contain,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            'Tutorial Ibadah',
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w500,
              color: isDarkMode ? Colors.white70 : const Color(0xFF333333),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// ICON 8: KHUTBAH (Previously Lainnya)
// Mosque icons created by BZZRINCANTATION - Flaticon (https://www.flaticon.com/free-icons/mosque)
// ─────────────────────────────────────────────────────────────
class RamadhanIcon extends StatelessWidget {
  const RamadhanIcon({super.key});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const RamadhanPage()),
        );
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: isDarkMode ? const Color(0xFF0F362C) : const Color(0xFFE8F5F1),
              shape: BoxShape.circle,
            ),
            padding: const EdgeInsets.all(8),
            child: Image.asset(
              'assets/images/ramadhan_icon.png',
              fit: BoxFit.contain,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            'Ramadhan',
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w500,
              color: isDarkMode ? Colors.white70 : const Color(0xFF333333),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}




Widget _buildPlaceholder(String title) {
  return Column(
    mainAxisSize: MainAxisSize.min,
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Container(
        width: 52,
        height: 52,
        decoration: const BoxDecoration(
          color: Color(0xFFE8F5F1),
          shape: BoxShape.circle,
        ),
      ),
      const SizedBox(height: 5),
      Text(
        title,
        style: const TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w500,
          color: Color(0xFF333333),
        ),
        textAlign: TextAlign.center,
      ),
    ],
  );
}

class DomeClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    double w = size.width;
    double h = size.height;

    double baseY = h * 0.28;
    double tipY = h * 0.08;
    double hDiff = baseY - tipY;

    double p1x = w * 0.16;
    double p1y = baseY - hDiff * 0.25;

    double p2x = w * 0.33;
    double p2y = baseY - hDiff * 0.65;

    double p3x = w * 0.5;
    double p3y = tipY;
    double p2x_r = w - p2x;
    double p1x_r = w - p1x;
    path.moveTo(0, baseY);
    path.quadraticBezierTo(0, p1y, p1x, p1y);
    path.quadraticBezierTo(p1x, p2y, p2x, p2y);
    path.cubicTo(
        p2x, p3y + hDiff * 0.1, p3x - w * 0.05, p3y + hDiff * 0.1, p3x, p3y);
    path.cubicTo(
        p3x + w * 0.05, p3y + hDiff * 0.1, p2x_r, p3y + hDiff * 0.1, p2x_r, p2y);
    path.quadraticBezierTo(p1x_r, p2y, p1x_r, p1y);
    path.quadraticBezierTo(w, p1y, w, baseY);
    path.lineTo(w, h - 24);
    path.quadraticBezierTo(w, h, w - 24, h);
    path.lineTo(24, h);
    path.quadraticBezierTo(0, h, 0, h - 24);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => true;
}

class QuranIconPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()..style = PaintingStyle.fill;
    final double w = size.width;
    final double h = size.height;

    // 1. Draw Rehal (Stand) - Reddish Brown
    paint.color = const Color(0xFFA63D2D);
    final Path rehalPath = Path()
      ..moveTo(w * 0.1, h * 0.75)
      ..lineTo(w * 0.45, h * 0.55)
      ..lineTo(w * 0.55, h * 0.55)
      ..lineTo(w * 0.9, h * 0.75)
      ..lineTo(w * 0.95, h * 0.88)
      ..lineTo(w * 0.75, h * 0.88)
      ..lineTo(w * 0.5, h * 0.72)
      ..lineTo(w * 0.25, h * 0.88)
      ..lineTo(w * 0.05, h * 0.88)
      ..close();
    canvas.drawPath(rehalPath, paint);

    // 2. Draw Quran Cover - Green
    paint.color = const Color(0xFF429B46);
    final Path coverPath = Path()
      ..moveTo(w * 0.1, h * 0.15)
      ..lineTo(w * 0.5, h * 0.35)
      ..lineTo(w * 0.9, h * 0.15)
      ..lineTo(w * 0.95, h * 0.55)
      ..lineTo(w * 0.5, h * 0.75)
      ..lineTo(w * 0.05, h * 0.55)
      ..close();
    canvas.drawPath(coverPath, paint);

    // 3. Draw Pages - White/Light Grey
    paint.color = Colors.white;
    final Path leftPage = Path()
      ..moveTo(w * 0.15, h * 0.18)
      ..quadraticBezierTo(w * 0.3, h * 0.1, w * 0.48, h * 0.32)
      ..lineTo(w * 0.48, h * 0.68)
      ..quadraticBezierTo(w * 0.3, h * 0.48, w * 0.15, h * 0.53)
      ..close();
    canvas.drawPath(leftPage, paint);

    final Path rightPage = Path()
      ..moveTo(w * 0.85, h * 0.18)
      ..quadraticBezierTo(w * 0.7, h * 0.1, w * 0.52, h * 0.32)
      ..lineTo(w * 0.52, h * 0.68)
      ..quadraticBezierTo(w * 0.7, h * 0.48, w * 0.85, h * 0.53)
      ..close();
    canvas.drawPath(rightPage, paint);

    // 4. Draw Lines (Text) - Black
    final Paint linePaint = Paint()
      ..color = Colors.black87
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2
      ..strokeCap = StrokeCap.round;

    // Left page lines
    for (int i = 0; i < 4; i++) {
      double yOff = i * h * 0.08;
      canvas.drawPath(
        Path()
          ..moveTo(w * 0.22, h * 0.25 + yOff)
          ..quadraticBezierTo(w * 0.32, h * 0.2 + yOff, w * 0.42, h * 0.3 + yOff),
        linePaint
      );
    }

    // Right page lines
    for (int i = 0; i < 4; i++) {
      double yOff = i * h * 0.08;
      canvas.drawPath(
        Path()
          ..moveTo(w * 0.78, h * 0.25 + yOff)
          ..quadraticBezierTo(w * 0.68, h * 0.2 + yOff, w * 0.58, h * 0.3 + yOff),
        linePaint
      );
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

class LanternPainter extends CustomPainter {
  final Color color;
  LanternPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    
    final double lCenterX = w * 0.65;
    final double lCenterY = h * 0.55;
    final double lWidth = w * 0.30;
    final double lHeight = h * 0.60;
    
    final paintLantern = Paint()
      ..color = color
      ..style = PaintingStyle.fill;
      
    final paintLanternStroke = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.3;

    final paintGlow = Paint()
      ..color = const Color(0xFFFFFDF0)
      ..style = PaintingStyle.fill;

    final paintHighlight = Paint()
      ..color = const Color(0xFFFFD700)
      ..style = PaintingStyle.fill;

    // 1. Hanging loop at top
    canvas.drawCircle(
      Offset(lCenterX, lCenterY - lHeight * 0.5),
      lWidth * 0.22,
      Paint()
        ..color = color.withOpacity(0.4)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5,
    );

    // 2. Cap/dome
    final pathCap = Path()
      ..moveTo(lCenterX - lWidth * 0.4, lCenterY - lHeight * 0.3)
      ..quadraticBezierTo(lCenterX, lCenterY - lHeight * 0.52, lCenterX + lWidth * 0.4, lCenterY - lHeight * 0.3)
      ..close();
    canvas.drawPath(pathCap, paintLantern);

    // 3. Glass body background glow & border
    final rectBody = Rect.fromLTRB(
      lCenterX - lWidth * 0.32,
      lCenterY - lHeight * 0.3,
      lCenterX + lWidth * 0.32,
      lCenterY + lHeight * 0.28,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(rectBody, Radius.circular(lWidth * 0.15)),
      paintGlow,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(rectBody, Radius.circular(lWidth * 0.15)),
      paintLanternStroke,
    );

    // 4. Glowing core
    canvas.drawCircle(
      Offset(lCenterX, lCenterY),
      lWidth * 0.20,
      Paint()
        ..color = const Color(0xFFFFE082).withOpacity(0.8)
        ..style = PaintingStyle.fill
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2),
    );

    // 5. Vertical lines & arches in glass
    final archPaint = Paint()
      ..color = color.withOpacity(0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;
    
    final pathArch1 = Path()
      ..moveTo(lCenterX - lWidth * 0.2, lCenterY + lHeight * 0.28)
      ..lineTo(lCenterX - lWidth * 0.2, lCenterY - lHeight * 0.1)
      ..quadraticBezierTo(lCenterX, lCenterY - lHeight * 0.25, lCenterX + lWidth * 0.2, lCenterY - lHeight * 0.1)
      ..lineTo(lCenterX + lWidth * 0.2, lCenterY + lHeight * 0.28);
    canvas.drawPath(pathArch1, archPaint);

    final pathCenterLine = Path()
      ..moveTo(lCenterX, lCenterY - lHeight * 0.3)
      ..lineTo(lCenterX, lCenterY + lHeight * 0.28);
    canvas.drawPath(pathCenterLine, archPaint);

    // 6. Base
    final pathBase = Path()
      ..moveTo(lCenterX - lWidth * 0.45, lCenterY + lHeight * 0.28)
      ..lineTo(lCenterX + lWidth * 0.45, lCenterY + lHeight * 0.28)
      ..lineTo(lCenterX + lWidth * 0.35, lCenterY + lHeight * 0.38)
      ..lineTo(lCenterX - lWidth * 0.35, lCenterY + lHeight * 0.38)
      ..close();
    canvas.drawPath(pathBase, paintLantern);

    // 7. Leaf clusters wrapping the base
    final paintLeafDark = Paint()
      ..color = const Color(0xFF0F664F)
      ..style = PaintingStyle.fill;
    final paintLeafLight = Paint()
      ..color = const Color(0xFF26A683)
      ..style = PaintingStyle.fill;

    // Left leaves
    final pathLeaf1 = Path()
      ..moveTo(lCenterX - lWidth * 0.5, lCenterY + lHeight * 0.38)
      ..quadraticBezierTo(lCenterX - lWidth * 1.0, lCenterY + lHeight * 0.2, lCenterX - lWidth * 0.5, lCenterY - lHeight * 0.05)
      ..quadraticBezierTo(lCenterX - lWidth * 0.2, lCenterY + lHeight * 0.2, lCenterX - lWidth * 0.5, lCenterY + lHeight * 0.38)
      ..close();
    canvas.drawPath(pathLeaf1, paintLeafDark);

    final pathLeaf2 = Path()
      ..moveTo(lCenterX - lWidth * 0.2, lCenterY + lHeight * 0.38)
      ..quadraticBezierTo(lCenterX - lWidth * 0.6, lCenterY + lHeight * 0.15, lCenterX - lWidth * 0.3, lCenterY - lHeight * 0.12)
      ..quadraticBezierTo(lCenterX - lWidth * 0.0, lCenterY + lHeight * 0.15, lCenterX - lWidth * 0.2, lCenterY + lHeight * 0.38)
      ..close();
    canvas.drawPath(pathLeaf2, paintLeafLight);

    // Right leaves
    final pathLeaf3 = Path()
      ..moveTo(lCenterX + lWidth * 0.2, lCenterY + lHeight * 0.38)
      ..quadraticBezierTo(lCenterX + lWidth * 0.6, lCenterY + lHeight * 0.15, lCenterX + lWidth * 0.3, lCenterY - lHeight * 0.12)
      ..quadraticBezierTo(lCenterX + lWidth * 0.0, lCenterY + lHeight * 0.15, lCenterX + lWidth * 0.2, lCenterY + lHeight * 0.38)
      ..close();
    canvas.drawPath(pathLeaf3, paintLeafLight);

    final pathLeaf4 = Path()
      ..moveTo(lCenterX + lWidth * 0.5, lCenterY + lHeight * 0.38)
      ..quadraticBezierTo(lCenterX + lWidth * 1.0, lCenterY + lHeight * 0.2, lCenterX + lWidth * 0.5, lCenterY - lHeight * 0.05)
      ..quadraticBezierTo(lCenterX + lWidth * 0.2, lCenterY + lHeight * 0.2, lCenterX + lWidth * 0.5, lCenterY + lHeight * 0.38)
      ..close();
    canvas.drawPath(pathLeaf4, paintLeafDark);

    // 8. Sparkles
    _drawStar(canvas, Offset(w * 0.18, h * 0.55), 2.5, paintHighlight);
    _drawStar(canvas, Offset(w * 0.25, h * 0.28), 4.0, paintHighlight);
    _drawStar(canvas, Offset(w * 0.32, h * 0.45), 2.0, paintHighlight);
    _drawStar(canvas, Offset(lCenterX + lWidth * 0.8, lCenterY - lHeight * 0.3), 3.0, paintHighlight);
  }

  void _drawStar(Canvas canvas, Offset center, double size, Paint paint) {
    final path = Path()
      ..moveTo(center.dx, center.dy - size)
      ..quadraticBezierTo(center.dx, center.dy, center.dx + size, center.dy)
      ..quadraticBezierTo(center.dx, center.dy, center.dx, center.dy + size)
      ..quadraticBezierTo(center.dx, center.dy, center.dx - size, center.dy)
      ..quadraticBezierTo(center.dx, center.dy, center.dx, center.dy - size)
      ..close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}


