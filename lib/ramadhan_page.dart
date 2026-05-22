import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart' show DateFormat;
import 'prayer_service.dart';
import 'ramadhan_detail_page.dart';

class RamadhanPage extends StatefulWidget {
  const RamadhanPage({super.key});

  @override
  State<RamadhanPage> createState() => _RamadhanPageState();
}

class _RamadhanPageState extends State<RamadhanPage> with SingleTickerProviderStateMixin {
  final PrayerService _prayerService = PrayerService();
  late TabController _tabController;

  String _selectedProvince = 'Jawa Timur';
  String _selectedCity = 'Kab. Bangkalan';
  int _selectedMonth = DateTime.now().month;
  int _selectedYear = DateTime.now().year;

  List<String> _provinces = [];
  List<String> _cities = [];
  Map<String, dynamic>? _scheduleData;
  bool _isLoading = true;

  Timer? _countdownTimer;
  String _countdownLabel = 'Memuat jadwal...';
  String _countdownTime = '00:00:00';

  static const Color primaryTeal = Color(0xFF0C5441);
  static const Color accentTeal = Color(0xFF13A884);
  static const Color lightTeal = Color(0xFFE8F5F1);
  static const Color goldColor = Color(0xFFD4AF37);
  static const Color backgroundLight = Color(0xFFF9FBFB);

  final List<String> _monthNames = [
    'Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni',
    'Juli', 'Agustus', 'September', 'Oktober', 'November', 'Desember'
  ];

  final List<Map<String, dynamic>> _ramadhanMenu = [
    {
      'title': 'Doa Menyambut Bulan Ramadhan',
      'arabic': 'اَللَّهُمَّ سَلِّمْنِيْ مِنْ رَمَضَانَ، وَسَلِّمْ رَمَضَانَ لِيْ، وَتَسَلَّمْهُ مِنِّيْ مُتَقَبَّلًا',
      'latin': 'Allâhumma sallimnî min ramadlâna wa sallim ramadlâna lî wa tasallamhu minnî mutaqabbalan',
      'translation': 'Ya Allah, sampaikan aku (dengan selamat menuju bulan) Ramadhan. Sampaikanlah Ramadhan kepadaku, dan terimalah amal-amalku (di bulan Ramadhan).',
    },
    {
      'title': 'Niat Puasa Ramadhan Sebulan Penuh',
      'arabic': 'نَوَيْتُ صَوْمَ جَمِيعِ شَهْرِ رَمَضَانِ هٰذِهِ السَّنَةِ تَقْلِيْدًا لِلْإِمَامِ مَالِكٍ فَرْضًا لِلّٰهِ تَعَالَى',
      'latin': 'Nawaitu shauma jamî\'i syahri ramadlâni hâdzihis sanati taqlîdan lil imâmi mâlikin fardlan lillâhi ta\'âlâ',
      'translation': 'Aku niat berpuasa di sepanjang bulan Ramadhan tahun ini dengan mengikuti Imam Malik, fardhu karena Allah.',
    },
    {
      'title': 'Niat Puasa Ramadhan',
      'arabic': 'نَوَيْتُ صَوْمَ غَدٍ عَنْ أَدَاءِ فَرْضِ شَهْرِ رَمَضَانَ هٰذِهِ السَّنَةِ لِلّٰهِ تَعَالَى',
      'latin': 'Nawaitu shauma ghadin \'an adâ\'i fardli syahri ramadlâna hâdzihis sanati lillâhi ta\'âlâ',
      'translation': 'Aku niat berpuasa esok hari untuk menunaikan fardhu di bulan Ramadhan tahun ini, karena Allah Ta\'ala.',
    },
    {
      'title': 'Doa usai Buka Puasa',
      'arabic': 'اَللّٰهُمَّ لَكَ صُمْتُ وَعَلَى رِزْقِكَ أَفْطَرْتُ ذَهَبَ الظَّمَأُ وَابْتَلَّتِ الْعُرُوْقُ وَثَبَتَ الْأَجْرُ إِنْ شَاءَ اللّٰهُ تَعَالَى',
      'latin': 'Allâhumma laka shumtu wa \'alâ rizqika afthartu dzahaba-dh-dhama\'u wabtalatil \'urûqu wa tsabatal ajru insyâ-allâh ta\'âlâ',
      'translation': 'Ya Allah, untuk-Mulah aku berpuasa, atas rezekimulah aku berbuka. Telah sirna rasa dahaga, urat-urat telah basah, dan (semoga) pahala telah ditetapkan, insyaallah.',
    },
    {
      'title': 'Niat Shalat Tarawih',
      'arabic': '',
      'latin': '',
      'translation': '',
      'sections': [
        {
          'subtitle': 'Sebagai Imam',
          'arabic': 'أُصَلِّيْ سُنَّةَ التَّرَاوِيْحِ رَكْعَتَيْنِ مُسْتَقْبِلَ الْقِبْلَةِ أَدَاءً إِمَامًا لِلّٰهِ تَعَالَى',
          'latin': 'Ushallî sunnatat tarâwîhi rak\'atayni mustaqbilal qiblati adâ\'an imâman lillâhi ta\'âlâ.',
          'translation': 'Aku menyengaja shalat sunnah tarawih dua rakaat dengan menghadap kiblat, tunai sebagai imam karena Allah ta\'ala.',
        },
        {
          'subtitle': 'Sebagai Makmum',
          'arabic': 'أُصَلِّيْ سُنَّةَ التَّرَاوِيْحِ رَكْعَتَيْنِ مُسْتَقْبِلَ الْقِبْلَةِ أَدَاءً مَأْمُوْمًا لِلّٰهِ تَعَالَى',
          'latin': 'Ushallî sunnatat tarâwîhi rak\'atayni mustaqbilal qiblati adâ\'an ma\'mûman lillâhi ta\'âlâ.',
          'translation': 'Aku menyengaja shalat sunnah tarawih dua rakaat dengan menghadap kiblat, tunai sebagai makmum karena Allah ta\'ala.',
        },
        {
          'subtitle': 'Sendirian',
          'arabic': 'أُصَلِّيْ سُنَّةَ التَّرَاوِيْحِ رَكْعَتَيْنِ مُسْتَقْبِلَ الْقِبْلَةِ أَدَاءً لِلّٰهِ تَعَالَى',
          'latin': 'Ushallî sunnatat tarâwîhi rak\'atayni mustaqbilal qiblati adâ\'an lillâhi ta\'âlâ.',
          'translation': 'Aku menyengaja shalat sunnah tarawih dua rakaat dengan menghadap kiblat, tunai karena Allah ta\'ala.',
        },
      ]
    },
    {
      'title': 'Bilal Tarawih dan Jawabannya',
      'arabic': '',
      'latin': '',
      'translation': '',
      'sections': [
        {
          'subtitle': 'الصلاة ١\nDua rakaat shalat ke-1',
          'arabic': 'صَلُّوْا سُنَّةَ التَّرَاوِيْحِ رَكْعَتَيْنِ جَامِعَةً رَحِمَكُمُ اللّٰهُ (رَحِمَكُمُ اللّٰهُ)\n\nاَللّٰهُمَّ صَلِّ عَلَى سَيِّدِنَا مُحَمَّدٍ (اَللّٰهُمَّ صَلِّ وَسَلِّمْ عَلَيْهِ)',
          'latin': 'Seruan bilal: Shallû sunnatat tarâwîhi rak\'ataini jâmi\'atan rahimakumullâh.\n(Jawaban jamaah: Rahimakumullâh)\n\nSeruan bilal: Allâhumma shalli \'alâ sayyidinâ Muhammad(in).\n(Jawaban jamaah: Allâhumma shalli wa sallim \'alaih)',
          'translation': 'Shalatlah sunnah tarawih dua rakaat secara berjamaah. Semoga Allah merahmati kalian semua.\n(Semoga Allah merahmati kalian semua)\n\nYa Allah, limpahkanlah rahmat dan takzim kepada Baginda Nabi Muhammad.\n(Ya Allah, limpahkanlah rahmat dan keselamatan kepada beliau)',
        },
        {
          'subtitle': 'الصلاة ٢\nDua rakaat shalat ke-2',
          'arabic': 'فَضْلًا مِنَ اللّٰهِ تَعَالَى وَنِعْمَةً (وَمَغْفِرَةً وَنِعْمَةً)\n\nاَللّٰهُمَّ صَلِّ عَلَى سَيِّدِنَا مُحَمَّدٍ (اَللّٰهُمَّ صَلِّ وَسَلِّمْ عَلَيْهِ)',
          'latin': 'Seruan bilal: Fadl-lan mina-Llâhi ta\'âlâ wa ni\'mah.\n(Jawaban jamaah: Wa maghfiratan wa ni\'mah)\n\nSeruan bilal: Allâhumma shalli \'alâ sayyidinâ Muhammad(in).\n(Jawaban jamaah: Allâhumma shalli wa sallim \'alaih)',
          'translation': 'Kita berharap karunia dan kenikmatan dari Allah ta\'ala.\n([Berharap pula] ampunan dan kenikmatan)\n\nYa Allah, limpahkanlah rahmat dan takzim kepada Baginda Nabi Muhammad.\n(Ya Allah, limpahkanlah rahmat dan keselamatan kepada beliau)',
        },
        {
          'subtitle': 'الصلاة ٣\nDua rakaat shalat ke-3',
          'arabic': 'اَلْخَلِيْفَةُ الْأُوْلَى سَيِّدُنَا أَبُوْ بَكْرِ الصِّدِّيْقُ (رَضِيَ اللّٰهُ عَنْهُ)\n\nاَللّٰهُمَّ صَلِّ عَلَى سَيِّدِنَا مُحَمَّدٍ (اَللّٰهُمَّ صَلِّ وَسَلِّمْ عَلَيْهِ)',
          'latin': 'Seruan bilal: Al-khalîfatul ûlâ sayyidunâ Abû Bakrnish-Shiddîq.\n(Jawaban jamaah: Radliyallâhu \'anh)\n\nSeruan bilal: Allâhumma shalli \'alâ sayyidinâ Muhammad(in).\n(Jawaban jamaah: Allâhumma shalli wa sallim \'alaih)',
          'translation': 'Khalifah pertama Sayyidina Abu Bakar ash-Shiddiq.\n(Semoga Allah meridhainya)\n\nYa Allah, limpahkanlah rahmat dan takzim kepada Baginda Nabi Muhammad.\n(Ya Allah, limpahkanlah rahmat dan keselamatan kepada beliau)',
        },
        {
          'subtitle': 'الصلاة ٤\nDua rakaat shalat ke-4',
          'arabic': 'فَضْلًا مِنَ اللّٰهِ تَعَالَى وَنِعْمَةً (وَمَغْفِرَةً وَنِعْمَةً)\n\nاَللّٰهُمَّ صَلِّ عَلَى سَيِّدِنَا مُحَمَّدٍ (اَللّٰهُمَّ صَلِّ وَسَلِّمْ عَلَيْهِ)',
          'latin': 'Seruan bilal: Fadl-lan mina-Llâhi ta\'âlâ wa ni\'mah.\n(Jawaban jamaah: Wa maghfiratan wa ni\'mah)\n\nSeruan bilal: Allâhumma shalli \'alâ sayyidinâ Muhammad(in).\n(Jawaban jamaah: Allâhumma shalli wa sallim \'alaih)',
          'translation': 'Kita berharap karunia dan kenikmatan dari Allah ta\'ala.\n([Berharap pula] ampunan dan kenikmatan)\n\nYa Allah, limpahkanlah rahmat dan takzim kepada Baginda Nabi Muhammad.\n(Ya Allah, limpahkanlah rahmat dan keselamatan kepada beliau)',
        },
        {
          'subtitle': 'الصلاة ٥\nDua rakaat shalat ke-5',
          'arabic': 'اَلْخَلِيْفَةُ الثَّانِيَةُ سَيِّدُنَا عُمَرُ ابْنُ الْخَطَّابِ (رَضِيَ اللّٰهُ عَنْهُ)\n\nاَللّٰهُمَّ صَلِّ عَلَى سَيِّدِنَا مُحَمَّدٍ (اَللّٰهُمَّ صَلِّ وَسَلِّمْ عَلَيْهِ)',
          'latin': 'Seruan bilal: Al-khalîfatuts-tsâniyah sayyidunâ \'Umar ibnu Khaththâb.\n(Jawaban jamaah: Radliyallâhu \'anh)\n\nSeruan bilal: Allâhumma shalli \'alâ sayyidinâ Muhammad(in).\n(Jawaban jamaah: Allâhumma shalli wa sallim \'alaih)',
          'translation': 'Khalifah kedua Sayyidina Umar bin Khattab.\n(Semoga Allah meridhainya)\n\nYa Allah, limpahkanlah rahmat dan takzim kepada Baginda Nabi Muhammad.\n(Ya Allah, limpahkanlah rahmat dan keselamatan kepada beliau)',
        },
        {
          'subtitle': 'الصلاة ٦\nDua rakaat shalat ke-6',
          'arabic': 'فَضْلًا مِنَ اللّٰهِ تَعَالَى وَنِعْمَةً (وَمَغْفِرَةً وَنِعْمَةً)\n\nاَللّٰهُمَّ صَلِّ عَلَى سَيِّدِنَا مُحَمَّدٍ (اَللّٰهُمَّ صَلِّ وَسَلِّمْ عَلَيْهِ)',
          'latin': 'Seruan bilal: Fadl-lan mina-Llâhi ta\'âlâ wa ni\'mah.\n(Jawaban jamaah: Wa maghfiratan wa ni\'mah)\n\nSeruan bilal: Allâhumma shalli \'alâ sayyidinâ Muhammad(in).\n(Jawaban jamaah: Allâhumma shalli wa sallim \'alaih)',
          'translation': 'Kita berharap karunia dan kenikmatan dari Allah ta\'ala.\n([Berharap pula] ampunan dan kenikmatan)\n\nYa Allah, limpahkanlah rahmat dan takzim kepada Baginda Nabi Muhammad.\n(Ya Allah, limpahkanlah rahmat dan keselamatan kepada beliau)',
        },
        {
          'subtitle': 'الصلاة ٧\nDua rakaat shalat ke-7',
          'arabic': 'اَلْخَلِيْفَةُ الثَّالِثَةُ سَيِّدُنَا عُثْمَانُ بْنُ عَفَّانِ (رَضِيَ اللّٰهُ عَنْهُ)\n\nاَللّٰهُمَّ صَلِّ عَلَى سَيِّدِنَا مُحَمَّدٍ (اَللّٰهُمَّ صَلِّ وَسَلِّمْ عَلَيْهِ)',
          'latin': 'Seruan bilal: Al-khalîfatuts tsâlitsah sayyidunâ \'Utsmân ibnu \'Affân radliyallâhu \'anh.\n(Jawaban jamaah: Radliyallâhu \'anh)\n\nSeruan bilal: Allâhumma shalli \'alâ sayyidinâ Muhammad(in).\n(Jawaban jamaah: Allâhumma shalli wa sallim \'alaih)',
          'translation': 'Khalifah ketiga Sayyidina Utsman bin Affan.\n(Semoga Allah meridhainya)\n\nYa Allah, limpahkanlah rahmat dan takzim kepada Baginda Nabi Muhammad.\n(Ya Allah, limpahkanlah rahmat dan keselamatan kepada beliau)',
        },
        {
          'subtitle': 'الصلاة ٨\nDua rakaat shalat ke-8',
          'arabic': 'فَضْلًا مِنَ اللّٰهِ تَعَالَى وَنِعْمَةً (وَمَغْفِرَةً وَنِعْمَةً)\n\nاَللّٰهُمَّ صَلِّ عَلَى سَيِّدِنَا مُحَمَّدٍ (اَللّٰهُمَّ صَلِّ وَسَلِّمْ عَلَيْهِ)',
          'latin': 'Seruan bilal: Fadl-lan mina-Llâhi ta\'âlâ wa ni\'mah.\n(Jawaban jamaah: Wa maghfiratan wa ni\'mah)\n\nSeruan bilal: Allâhumma shalli \'alâ sayyidinâ Muhammad(in).\n(Jawaban jamaah: Allâhumma shalli wa sallim \'alaih)',
          'translation': 'Kita berharap karunia dan kenikmatan dari Allah ta\'ala.\n([Berharap pula] ampunan dan kenikmatan)\n\nYa Allah, limpahkanlah rahmat dan takzim kepada Baginda Nabi Muhammad.\n(Ya Allah, limpahkanlah rahmat dan keselamatan kepada beliau)',
        },
        {
          'subtitle': 'الصلاة ٩\nDua rakaat shalat ke-9',
          'arabic': 'اَلْخَلِيْفَةُ الرَّابِعَةُ سَيِّدُنَا عَلِيُّ بْنُ أَبِيْ طَالِبٍ (كَرَّمَ اللّٰهُ وَجْهَهُ)\n\nاَللّٰهُمَّ صَلِّ عَلَى سَيِّدِنَا مُحَمَّدٍ (اَللّٰهُمَّ صَلِّ وَسَلِّمْ عَلَيْهِ)',
          'latin': 'Seruan bilal: Al-khalîfatur râbi\'ah sayyidunâ \'Aliyyun-nibnu Abî Thâlibin.\n(Jawaban jamaah: Karrama-Llâhu wajhah)\n\nSeruan bilal: Allâhumma shalli \'alâ sayyidinâ Muhammad(in).\n(Jawaban jamaah: Allâhumma shalli wa sallim \'alaih)',
          'translation': 'Khalifah keempat Sayyidina Ali bin Abi Thalib.\n(Semoga Allah memuliakan wajahnya)\n\nYa Allah, limpahkanlah rahmat dan takzim kepada Baginda Nabi Muhammad.\n(Ya Allah, limpahkanlah rahmat dan keselamatan kepada beliau)',
        },
        {
          'subtitle': 'الصلاة ١٠\nDua rakaat shalat ke-10',
          'arabic': 'اٰخِرُ التَّرَاوِيْحِ أَجَرَكُمُ اللّٰهُ (اٰمِيْنَ يَارَبَّ الْعَالَمِيْنَ)\n\nاَللّٰهُمَّ صَلِّ عَلَى سَيِّدِنَا مُحَمَّدٍ (اَللّٰهُمَّ صَلِّ وَسَلِّمْ عَلَيْهِ)',
          'latin': 'Seruan bilal: Âkhirut tarâwîhi ajarakumullâh.\n(Jawaban jamaah: Âmîn yâ Rabbal \'âlamîn)\n\nSeruan bilal: Allâhumma shalli \'alâ sayyidinâ Muhammad(in).\n(Jawaban jamaah: Allâhumma shalli wa sallim \'alaih)',
          'translation': 'Ini adalah penghujung shalat tarawih. Semoga Allah memberi kalian pahala.\n(Semoga Allah mengabulkan, wahai Tuhan semesta alam)\n\nYa Allah, limpahkanlah rahmat dan takzim kepada Baginda Nabi Muhammad.\n(Ya Allah, limpahkanlah rahmat dan keselamatan kepada beliau)',
        },
        {
          'subtitle': 'صلاة الوتر\nShalat Witir',
          'arabic': 'صَلُّوْا سُنَّةَ الْوِتْرِ ثَلَاثَ رَكَعَاتٍ جَامِعَةً رَحِمَكُمُ اللّٰهُ (رَحِمَكُمُ اللّٰهُ)\n\nاَللّٰهُمَّ صَلِّ عَلَى سَيِّدِنَا مُحَمَّدٍ (اَللّٰهُمَّ صَلِّ وَسَلِّمْ عَلَيْهِ)',
          'latin': 'Seruan bilal: Shallû sunnatal witri tsalâtsa raka\'âtin jâmi\'atan rahimakumullâh.\n(Jawaban jamaah: Rahimakumullâh)\n\nSeruan bilal: Allâhumma shalli \'alâ sayyidinâ Muhammad(in).\n(Jawaban jamaah: Allâhumma shalli wa sallim \'alaih)',
          'translation': 'Shalatlah sunnah witir tiga rakaat secara berjamaah. Semoga Allah merahmati kalian semua.\n(Semoga Allah merahmati kalian semua)\n\nYa Allah, limpahkanlah rahmat dan takzim kepada Baginda Nabi Muhammad.\n(Ya Allah, limpahkanlah rahmat dan keselamatan kepada beliau)',
        }
      ]
    },
    {'title': 'Doa Kamilin Bakda Tarawih', 'arabic': '', 'latin': '', 'translation': ''},
    {'title': 'Niat Shalat Witir', 'arabic': '', 'latin': '', 'translation': ''},
    {'title': 'Wirid dan Doa Bakda Witir', 'arabic': '', 'latin': '', 'translation': ''},
    {'title': 'Doa ketika Sahur', 'arabic': '', 'latin': '', 'translation': ''},
    {'title': 'Bacaan Lailatul Qadar', 'arabic': '', 'latin': '', 'translation': ''},
    {'title': 'Niat Zakat Fitrah', 'arabic': '', 'latin': '', 'translation': ''},
    {'title': 'Doa Menerima Zakat Fitrah', 'arabic': '', 'latin': '', 'translation': ''},
    {'title': 'Doa Malam Idul Fitri', 'arabic': '', 'latin': '', 'translation': ''},
    {'title': 'Lafal Takbiran Idul Fitri', 'arabic': '', 'latin': '', 'translation': ''},
    {'title': 'Niat Shalat Idul Fitri', 'arabic': '', 'latin': '', 'translation': ''},
    {'title': 'Bacaan Bilal Shalat Idul Fitri', 'arabic': '', 'latin': '', 'translation': ''},
  ];

  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadInitialData();
  }

  @override
  void dispose() {
    _countdownTimer?.cancel();
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadInitialData() async {
    setState(() => _isLoading = true);
    try {
      final provinces = await _prayerService.getProvinces();
      setState(() => _provinces = provinces);
      await _loadCities(_selectedProvince);
      await _loadSchedule();
      _startCountdown();
    } catch (e) {
      _showError(e.toString());
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _loadCities(String province) async {
    try {
      final cities = await _prayerService.getCities(province);
      setState(() {
        _cities = cities;
        if (!_cities.contains(_selectedCity)) {
          _selectedCity = _cities.isNotEmpty ? _cities.first : '';
        }
      });
    } catch (e) {
      _showError(e.toString());
    }
  }

  Future<void> _loadSchedule() async {
    setState(() => _isLoading = true);
    try {
      final data = await _prayerService.getMonthlySchedule(
        province: _selectedProvince,
        city: _selectedCity,
        month: _selectedMonth,
        year: _selectedYear,
      );
      setState(() {
        _scheduleData = data;
        _calculateCountdown();
      });
    } catch (e) {
      _showError(e.toString());
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _showError(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Gagal memuat data: $message'),
        backgroundColor: Colors.redAccent,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _startCountdown() {
    _countdownTimer?.cancel();
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        _calculateCountdown();
      }
    });
  }

  void _calculateCountdown() {
    if (_scheduleData == null) return;
    final List<dynamic> schedules = _scheduleData!['jadwal'] ?? [];
    if (schedules.isEmpty) return;

    final now = DateTime.now();
    final todayStr = DateFormat('yyyy-MM-dd').format(now);
    final tomorrowStr = DateFormat('yyyy-MM-dd').format(now.add(const Duration(days: 1)));

    dynamic todayEntry;
    dynamic tomorrowEntry;

    for (var entry in schedules) {
      final entryDate = entry['tanggal_lengkap'];
      if (entryDate == todayStr) {
        todayEntry = entry;
      } else if (entryDate == tomorrowStr) {
        tomorrowEntry = entry;
      }
    }

    if (todayEntry == null) {
      if (mounted) {
        setState(() {
          _countdownLabel = 'Jadwal Hari Ini Tidak Tersedia';
          _countdownTime = '-- : -- : --';
        });
      }
      return;
    }

    DateTime parseTime(String dateStr, String timeStr) {
      final parts = timeStr.split(':');
      final dateParts = dateStr.split('-');
      return DateTime(
        int.parse(dateParts[0]),
        int.parse(dateParts[1]),
        int.parse(dateParts[2]),
        int.parse(parts[0]),
        int.parse(parts[1]),
      );
    }

    try {
      final imsakToday = parseTime(todayStr, todayEntry['imsak']);
      final maghribToday = parseTime(todayStr, todayEntry['maghrib']);

      String label = '';
      DateTime targetTime;

      if (now.isBefore(imsakToday)) {
        label = 'Menuju Sahur (Imsak)';
        targetTime = imsakToday;
      } else if (now.isBefore(maghribToday)) {
        label = 'Menuju Buka Puasa (Maghrib)';
        targetTime = maghribToday;
      } else {
        label = 'Menuju Sahur (Imsak) Besok';
        if (tomorrowEntry != null) {
          targetTime = parseTime(tomorrowStr, tomorrowEntry['imsak']);
        } else {
          targetTime = imsakToday.add(const Duration(days: 1));
        }
      }

      final diff = targetTime.difference(now);
      final hours = diff.inHours.toString().padLeft(2, '0');
      final minutes = (diff.inMinutes % 60).toString().padLeft(2, '0');
      final seconds = (diff.inSeconds % 60).toString().padLeft(2, '0');

      if (mounted) {
        setState(() {
          _countdownLabel = label;
          _countdownTime = '$hours : $minutes : $seconds';
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _countdownLabel = 'Kesalahan Memformat Waktu';
          _countdownTime = '-- : -- : --';
        });
      }
    }
  }

  void _showSearchPicker({
    required String title,
    required List<String> items,
    required String currentValue,
    required Function(String) onSelected,
  }) {
    String searchQuery = "";
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            final filteredItems = items
                .where((item) => item.toLowerCase().contains(searchQuery.toLowerCase()))
                .toList();

            return Container(
              height: MediaQuery.of(context).size.height * 0.75,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
              ),
              child: Column(
                children: [
                  const SizedBox(height: 12),
                  Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: primaryTeal,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: TextField(
                      onChanged: (value) {
                        setModalState(() {
                          searchQuery = value;
                        });
                      },
                      decoration: InputDecoration(
                        hintText: "Cari...",
                        prefixIcon: const Icon(Icons.search, color: primaryTeal),
                        filled: true,
                        fillColor: Colors.grey.shade100,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(vertical: 0),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Expanded(
                    child: filteredItems.isEmpty
                        ? const Center(
                            child: Text(
                              'Tidak ditemukan',
                              style: TextStyle(color: Colors.grey),
                            ),
                          )
                        : ListView.builder(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            itemCount: filteredItems.length,
                            itemBuilder: (context, index) {
                              final item = filteredItems[index];
                              final isSelected = item == currentValue;
                              return ListTile(
                                title: Text(
                                  item,
                                  style: TextStyle(
                                    color: isSelected ? primaryTeal : Colors.black87,
                                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                  ),
                                ),
                                trailing: isSelected
                                    ? const Icon(Icons.check_circle, color: primaryTeal)
                                    : null,
                                onTap: () {
                                  onSelected(item);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundLight,
      body: Column(
        children: [
          _buildPremiumHeader(),
          _buildTabBar(),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildImsakiyahTab(),
                _buildDuasTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPremiumHeader() {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [primaryTeal, Color(0xFF07382B)],
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Navigation Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios, color: Colors.white, size: 20),
                    onPressed: () => Navigator.pop(context),
                  ),
                  Text(
                    'Ramadhan Kareem',
                    style: GoogleFonts.outfit(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Icon(Icons.nightlight_round, color: goldColor, size: 22),
                ],
              ),
              const SizedBox(height: 16),
              // Countdown & Icon Row
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.white24),
                    ),
                    child: Image.asset(
                      'assets/images/ramadhan_icon.png',
                      height: 52,
                      width: 52,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) =>
                          const Icon(Icons.mosque_outlined, color: goldColor, size: 45),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _countdownLabel,
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.85),
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _countdownTime,
                          style: GoogleFonts.outfit(
                            color: goldColor,
                            fontSize: 26,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 1,
                            fontFeatures: [const FontFeature.tabularFigures()],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              // Location selectors
              Row(
                children: [
                  Expanded(
                    child: _buildLocationSelector(
                      icon: Icons.location_on,
                      label: 'Provinsi',
                      value: _selectedProvince,
                      onTap: () => _showSearchPicker(
                        title: 'Pilih Provinsi',
                        items: _provinces,
                        currentValue: _selectedProvince,
                        onSelected: (val) {
                          setState(() => _selectedProvince = val);
                          _loadCities(val).then((_) => _loadSchedule());
                        },
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildLocationSelector(
                      icon: Icons.map,
                      label: 'Kab/Kota',
                      value: _selectedCity,
                      onTap: () => _showSearchPicker(
                        title: 'Pilih Kabupaten/Kota',
                        items: _cities,
                        currentValue: _selectedCity,
                        onSelected: (val) {
                          setState(() => _selectedCity = val);
                          _loadSchedule();
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLocationSelector({
    required IconData icon,
    required String label,
    required String value,
    required VoidCallback onTap,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withOpacity(0.75),
            fontSize: 11,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 4),
        GestureDetector(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.12),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.white12),
            ),
            child: Row(
              children: [
                Icon(icon, color: goldColor, size: 14),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    value,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const Icon(Icons.keyboard_arrow_down, color: Colors.white60, size: 16),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTabBar() {
    return Container(
      color: Colors.white,
      child: TabBar(
        controller: _tabController,
        labelColor: primaryTeal,
        unselectedLabelColor: Colors.grey,
        indicatorColor: accentTeal,
        indicatorWeight: 3,
        labelStyle: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 14),
        tabs: const [
          Tab(text: 'Jadwal Imsakiyah'),
          Tab(text: 'Niat & Doa'),
        ],
      ),
    );
  }

  Widget _buildImsakiyahTab() {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(color: accentTeal),
      );
    }

    if (_scheduleData == null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 48, color: Colors.redAccent),
            const SizedBox(height: 12),
            const Text(
              'Gagal memuat jadwal Imsakiyah',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: _loadSchedule,
              style: ElevatedButton.styleFrom(backgroundColor: primaryTeal),
              child: const Text('Coba Lagi', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      );
    }

    final List<dynamic> schedules = _scheduleData!['jadwal'] ?? [];
    if (schedules.isEmpty) {
      return const Center(child: Text('Jadwal tidak tersedia'));
    }

    final todayStr = DateFormat('yyyy-MM-dd').format(DateTime.now());

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: schedules.length,
      itemBuilder: (context, index) {
        final day = schedules[index];
        final isToday = day['tanggal_lengkap'] == todayStr;

        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isToday ? goldColor : Colors.grey.shade100,
              width: isToday ? 2.0 : 1.0,
            ),
            boxShadow: [
              BoxShadow(
                color: isToday ? goldColor.withOpacity(0.12) : Colors.black.withOpacity(0.02),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Theme(
            data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
            child: ExpansionTile(
              initiallyExpanded: isToday,
              leading: Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: isToday ? goldColor : lightTeal,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    day['tanggal'].toString(),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: isToday ? Colors.white : primaryTeal,
                      fontSize: 15,
                    ),
                  ),
                ),
              ),
              title: Row(
                children: [
                  Text(
                    '${day['hari']}, ${day['tanggal']} ${_monthNames[_selectedMonth - 1]}',
                    style: TextStyle(
                      fontWeight: isToday ? FontWeight.bold : FontWeight.w600,
                      color: isToday ? goldColor : Colors.black87,
                      fontSize: 14,
                    ),
                  ),
                  if (isToday) ...[
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: goldColor,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Text(
                        'Hari Ini',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 9,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
              subtitle: Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildCompactTime('Imsak', day['imsak'], isToday),
                    _buildCompactTime('Subuh', day['subuh'], isToday),
                    _buildCompactTime('Buka Puasa', day['maghrib'], isToday),
                  ],
                ),
              ),
              children: [
                const Divider(height: 1, color: Colors.black12, indent: 16, endIndent: 16),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildDetailTime('Terbit', day['terbit']),
                      _buildDetailTime('Dhuha', day['dhuha']),
                      _buildDetailTime('Dzuhur', day['dzuhur']),
                      _buildDetailTime('Ashar', day['ashar']),
                      _buildDetailTime('Isya', day['isya']),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildCompactTime(String label, String time, bool isToday) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 10,
            color: Colors.grey.shade500,
            fontWeight: FontWeight.w500,
          ),
        ),
        Text(
          time,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.bold,
            color: isToday ? primaryTeal : Colors.black87,
          ),
        ),
      ],
    );
  }

  Widget _buildDetailTime(String label, String time) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 10, color: Colors.grey.shade500),
        ),
        const SizedBox(height: 4),
        Text(
          time,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: primaryTeal,
          ),
        ),
      ],
    );
  }

  Widget _buildChip(String label, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(icon, size: 16, color: primaryTeal),
          const SizedBox(width: 6),
          Text(
            label,
            style: const TextStyle(
              fontSize: 13,
              color: Colors.black87,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDuasTab() {
    return Column(
      children: [
        // Horizontal Chips Scroll
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              _buildChip('Artikel Ramadhan', Icons.article_outlined),
              const SizedBox(width: 8),
              _buildChip('Khutbah Ramadhan', Icons.menu_book),
              const SizedBox(width: 8),
              _buildChip('Kumpulan Doa', Icons.collections_bookmark_outlined),
            ],
          ),
        ),

        // Search Bar
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: TextField(
            onChanged: (val) => setState(() => _searchQuery = val),
            decoration: InputDecoration(
              hintText: 'Cari',
              hintStyle: const TextStyle(color: Colors.grey),
              prefixIcon: const Icon(Icons.search, color: Colors.grey),
              filled: true,
              fillColor: Colors.grey.shade100,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(vertical: 0),
            ),
          ),
        ),

        // List Items
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            itemCount: _ramadhanMenu.length,
            separatorBuilder: (context, index) => Divider(
              color: Colors.grey.shade300,
              height: 1,
            ),
            itemBuilder: (context, index) {
              final menu = _ramadhanMenu[index];
              if (_searchQuery.isNotEmpty &&
                  !menu['title']!.toLowerCase().contains(_searchQuery.toLowerCase())) {
                return const SizedBox.shrink();
              }
              
              return InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => RamadhanDetailPage(
                        menuList: _ramadhanMenu,
                        initialIndex: index,
                      ),
                    ),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: Row(
                    children: [
                      SizedBox(
                        width: 32,
                        child: Center(
                          child: Text(
                            '${index + 1}',
                            style: const TextStyle(
                              color: primaryTeal,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          menu['title']!,
                          style: const TextStyle(
                            color: Colors.black87,
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      const Icon(
                        Icons.arrow_forward_ios,
                        size: 16,
                        color: Colors.black54,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
