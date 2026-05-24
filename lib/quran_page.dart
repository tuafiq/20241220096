import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'quran_data.dart';
import 'quran_service.dart';
import 'surah_detail_page.dart';
import 'settings_page.dart';

class JuzInfo {
  final int number;
  final String pageRange;
  final int surahCount;
  final int ayatCount;
  final List<int> surahNumbers;

  const JuzInfo({
    required this.number,
    required this.pageRange,
    required this.surahCount,
    required this.ayatCount,
    required this.surahNumbers,
  });
}

const List<JuzInfo> _juzList = [
  JuzInfo(number: 1, pageRange: "Halaman 1 - 21", surahCount: 2, ayatCount: 148, surahNumbers: [1, 2]),
  JuzInfo(number: 2, pageRange: "Halaman 22 - 41", surahCount: 1, ayatCount: 111, surahNumbers: [2]),
  JuzInfo(number: 3, pageRange: "Halaman 42 - 61", surahCount: 2, ayatCount: 126, surahNumbers: [2, 3]),
  JuzInfo(number: 4, pageRange: "Halaman 62 - 81", surahCount: 2, ayatCount: 131, surahNumbers: [3, 4]),
  JuzInfo(number: 5, pageRange: "Halaman 82 - 101", surahCount: 1, ayatCount: 124, surahNumbers: [4]),
  JuzInfo(number: 6, pageRange: "Halaman 102 - 121", surahCount: 2, ayatCount: 110, surahNumbers: [4, 5]),
  JuzInfo(number: 7, pageRange: "Halaman 122 - 141", surahCount: 2, ayatCount: 149, surahNumbers: [5, 6]),
  JuzInfo(number: 8, pageRange: "Halaman 142 - 161", surahCount: 2, ayatCount: 142, surahNumbers: [6, 7]),
  JuzInfo(number: 9, pageRange: "Halaman 162 - 181", surahCount: 2, ayatCount: 159, surahNumbers: [7, 8]),
  JuzInfo(number: 10, pageRange: "Halaman 182 - 201", surahCount: 2, ayatCount: 127, surahNumbers: [8, 9]),
  JuzInfo(number: 11, pageRange: "Halaman 202 - 221", surahCount: 3, ayatCount: 150, surahNumbers: [9, 10, 11]),
  JuzInfo(number: 12, pageRange: "Halaman 222 - 241", surahCount: 2, ayatCount: 170, surahNumbers: [11, 12]),
  JuzInfo(number: 13, pageRange: "Halaman 242 - 261", surahCount: 3, ayatCount: 154, surahNumbers: [12, 13, 14]),
  JuzInfo(number: 14, pageRange: "Halaman 262 - 281", surahCount: 2, ayatCount: 227, surahNumbers: [15, 16]),
  JuzInfo(number: 15, pageRange: "Halaman 282 - 301", surahCount: 2, ayatCount: 185, surahNumbers: [17, 18]),
  JuzInfo(number: 16, pageRange: "Halaman 302 - 321", surahCount: 3, ayatCount: 269, surahNumbers: [18, 19, 20]),
  JuzInfo(number: 17, pageRange: "Halaman 322 - 341", surahCount: 2, ayatCount: 190, surahNumbers: [21, 22]),
  JuzInfo(number: 18, pageRange: "Halaman 342 - 361", surahCount: 3, ayatCount: 202, surahNumbers: [23, 24, 25]),
  JuzInfo(number: 19, pageRange: "Halaman 362 - 381", surahCount: 3, ayatCount: 339, surahNumbers: [25, 26, 27]),
  JuzInfo(number: 20, pageRange: "Halaman 382 - 401", surahCount: 3, ayatCount: 171, surahNumbers: [27, 28, 29]),
  JuzInfo(number: 21, pageRange: "Halaman 402 - 421", surahCount: 5, ayatCount: 178, surahNumbers: [29, 30, 31, 32, 33]),
  JuzInfo(number: 22, pageRange: "Halaman 422 - 441", surahCount: 4, ayatCount: 169, surahNumbers: [33, 34, 35, 36]),
  JuzInfo(number: 23, pageRange: "Halaman 442 - 461", surahCount: 4, ayatCount: 357, surahNumbers: [36, 37, 38, 39]),
  JuzInfo(number: 24, pageRange: "Halaman 462 - 481", surahCount: 3, ayatCount: 175, surahNumbers: [39, 40, 41]),
  JuzInfo(number: 25, pageRange: "Halaman 482 - 501", surahCount: 5, ayatCount: 246, surahNumbers: [41, 42, 43, 44, 45]),
  JuzInfo(number: 26, pageRange: "Halaman 502 - 521", surahCount: 6, ayatCount: 195, surahNumbers: [46, 47, 48, 49, 50, 51]),
  JuzInfo(number: 27, pageRange: "Halaman 522 - 541", surahCount: 7, ayatCount: 399, surahNumbers: [51, 52, 53, 54, 55, 56, 57]),
  JuzInfo(number: 28, pageRange: "Halaman 542 - 561", surahCount: 9, ayatCount: 137, surahNumbers: [58, 59, 60, 61, 62, 63, 64, 65, 66]),
  JuzInfo(number: 29, pageRange: "Halaman 562 - 581", surahCount: 11, ayatCount: 431, surahNumbers: [67, 68, 69, 70, 71, 72, 73, 74, 75, 76, 77]),
  JuzInfo(number: 30, pageRange: "Halaman 582 - 604", surahCount: 37, ayatCount: 564, surahNumbers: [
    78, 79, 80, 81, 82, 83, 84, 85, 86, 87, 88, 89, 90, 91, 92, 93, 94, 95, 96, 97, 98, 99, 100, 101, 102, 103, 104, 105, 106, 107, 108, 109, 110, 111, 112, 113, 114
  ]),
];

String _toArabicNumerals(int number) {
  final Map<String, String> arabicDigits = {
    '0': '٠',
    '1': '١',
    '2': '٢',
    '3': '٣',
    '4': '٤',
    '5': '٥',
    '6': '٦',
    '7': '٧',
    '8': '٨',
    '9': '٩',
  };
  return number.toString().split('').map((char) => arabicDigits[char] ?? char).join();
}

class QuranPage extends StatefulWidget {
  final bool useApi;
  const QuranPage({super.key, this.useApi = false});

  @override
  State<QuranPage> createState() => _QuranPageState();
}

class _QuranPageState extends State<QuranPage> {
  List<SurahModel> _surahs = [];
  bool _isLoading = false;
  String _errorMessage = '';
  String _searchQuery = '';
  final QuranService _quranService = QuranService();

  // Tabs: 0 for Surah, 1 for Juz
  int _activeTab = 0;
  int? _expandedJuz; // Which Juz is expanded inline

  final FocusNode _searchFocusNode = FocusNode();

  // Formatting controls
  bool _showTranslation = false; // false = Lafal, true = Terjemahan

  // Favorites & Progress
  List<String> _favoriteJuz = [];
  List<String> _favoriteSurahs = [];
  List<String> _completedSurahs = [];
  List<String> _memorizedAyats = [];
  List<String> _studiedJuz = [];

  @override
  void initState() {
    super.initState();
    _fetchData();
    _loadFavorites();
  }

  @override
  void dispose() {
    _searchFocusNode.dispose();
    super.dispose();
  }

  Future<void> _loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _favoriteJuz = prefs.getStringList('favoriteJuz') ?? [];
      _favoriteSurahs = prefs.getStringList('favoriteSurahs') ?? [];
      _completedSurahs = prefs.getStringList('completedSurahs') ?? [];
      _memorizedAyats = prefs.getStringList('memorizedAyats') ?? [];
      _studiedJuz = prefs.getStringList('studiedJuz') ?? [];
    });
  }

  Future<void> _toggleFavoriteJuz(int juzNumber) async {
    final prefs = await SharedPreferences.getInstance();
    final list = List<String>.from(_favoriteJuz);
    final strNum = juzNumber.toString();
    if (list.contains(strNum)) {
      list.remove(strNum);
    } else {
      list.add(strNum);
    }
    await prefs.setStringList('favoriteJuz', list);
    setState(() {
      _favoriteJuz = list;
    });
  }

  Future<void> _toggleStudiedJuz(int juzNumber) async {
    final prefs = await SharedPreferences.getInstance();
    final list = List<String>.from(_studiedJuz);
    final strNum = juzNumber.toString();
    if (list.contains(strNum)) {
      list.remove(strNum);
    } else {
      list.add(strNum);
    }
    await prefs.setStringList('studiedJuz', list);
    setState(() {
      _studiedJuz = list;
    });
  }

  Future<void> _fetchData() async {
    if (!widget.useApi) {
      setState(() {
        _surahs = QuranData.listSurah;
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      final surahs = await _quranService.getSurahList();
      if (mounted) {
        setState(() {
          _surahs = surahs;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = e.toString();
          _isLoading = false;
        });
      }
    }
  }

  void _onSearch(String query) {
    setState(() {
      _searchQuery = query;
    });
  }

  List<SurahModel> get _filteredSurahs {
    final list = widget.useApi ? _surahs : QuranData.listSurah;
    if (_searchQuery.isEmpty) return list;

    return list
        .where((surah) =>
            surah.namaLatin.toLowerCase().contains(_searchQuery.toLowerCase()) ||
            surah.nama.contains(_searchQuery) ||
            surah.arti.toLowerCase().contains(_searchQuery.toLowerCase()))
        .toList();
  }

  List<JuzInfo> get _filteredJuzList {
    if (_searchQuery.isEmpty) return _juzList;

    final query = _searchQuery.toLowerCase();
    final allSurahs = widget.useApi ? _surahs : QuranData.listSurah;

    return _juzList.where((juz) {
      if ('juz ${juz.number}'.contains(query) || juz.number.toString() == query) {
        return true;
      }
      final matchingSurahs = allSurahs.where((surah) =>
          juz.surahNumbers.contains(surah.nomor) &&
          (surah.namaLatin.toLowerCase().contains(query) ||
              surah.nama.contains(query) ||
              surah.arti.toLowerCase().contains(query)));
      return matchingSurahs.isNotEmpty;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),
      body: Column(
        children: [
          _buildPremiumHeader(),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator(color: Color(0xFF13A884)))
                : _errorMessage.isNotEmpty
                    ? _buildErrorState()
                    : _activeTab == 0
                        ? _buildSurahTabContent()
                        : _buildJuzTabContent(),
          ),
        ],
      ),
    );
  }

  Widget _buildSurahTabContent() {
    final filteredSurahs = _filteredSurahs;
    return ListView(
      padding: const EdgeInsets.only(bottom: 24),
      children: [
        if (_searchQuery.isEmpty) _buildSurahBannerCard(),
        _buildListHeaderAndControls(),
        if (filteredSurahs.isEmpty)
          _buildEmptyState()
        else
          ListView.separated(
            padding: EdgeInsets.zero,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: filteredSurahs.length,
            separatorBuilder: (context, index) => Divider(
              color: Colors.grey[200],
              height: 1,
              indent: 80,
            ),
            itemBuilder: (context, index) {
              return _buildSurahItem(filteredSurahs[index]);
            },
          ),
      ],
    );
  }

  Widget _buildJuzTabContent() {
    final filteredJuz = _filteredJuzList;
    return ListView(
      padding: const EdgeInsets.only(bottom: 24),
      children: [
        _buildListHeaderAndControls(),
        if (filteredJuz.isEmpty)
          _buildEmptyState()
        else
          ListView.builder(
            padding: EdgeInsets.zero,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: filteredJuz.length,
            itemBuilder: (context, index) {
              return _buildJuzListItem(filteredJuz[index]);
            },
          ),
      ],
    );
  }

  Widget _buildPremiumHeader() {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF0C5441), Color(0xFF13A884)],
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Column(
          children: [
            const SizedBox(height: 12),
            // App Bar Row
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white, size: 24),
                    onPressed: () => Navigator.pop(context),
                  ),
                  Column(
                    children: [
                       Text(
                        'Al-Quran',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                      const SizedBox(height: 2),
                      const Text(
                        'Temukan Surah atau Juz favoritmu',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  IconButton(
                    icon: const Icon(Icons.settings, color: Colors.white, size: 24),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const SettingsPage()),
                      );
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            // Search Bar
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: TextField(
                focusNode: _searchFocusNode,
                onChanged: _onSearch,
                style: const TextStyle(color: Colors.black87),
                decoration: InputDecoration(
                  hintText: 'Cari surah, arti, atau juz...',
                  hintStyle: TextStyle(color: Colors.grey[400]),
                  prefixIcon: const Icon(Icons.search, color: Color(0xFF13A884)),
                  suffixIcon: Container(
                    margin: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.tune, color: Color(0xFF13A884), size: 18),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(vertical: 14),
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Tab Selector
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(15),
                ),
                padding: const EdgeInsets.all(4),
                child: Row(
                  children: [
                    Expanded(
                      child: _buildTabItem(
                        index: 0,
                        title: 'Surah',
                        icon: Icons.menu_book,
                      ),
                    ),
                    Expanded(
                      child: _buildTabItem(
                        index: 1,
                        title: 'Juz',
                        icon: Icons.bookmark,
                      ),
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

  Widget _buildTabItem({required int index, required String title, required IconData icon}) {
    final bool isActive = _activeTab == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          _activeTab = index;
          _searchQuery = '';
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: isActive ? const Color(0xFF0C5441) : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: isActive ? Colors.white : const Color(0xFF0C5441),
              size: 18,
            ),
            const SizedBox(width: 8),
            Text(
              title,
              style: TextStyle(
                color: isActive ? Colors.white : const Color(0xFF0C5441),
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSurahBannerCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 15,
            offset: const Offset(0, 6),
          ),
        ],
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.asset(
                    'assets/images/quran_rehal.png',
                    width: 80,
                    height: 80,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) => Container(
                      width: 80,
                      height: 80,
                      color: Colors.teal.shade50,
                      child: const Icon(Icons.menu_book, color: Color(0xFF13A884), size: 36),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Al-Quran Al-Karim',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF0C5441),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '114 Surah • 30 Juz',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey.shade600,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE8F5F1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Text(
                          'Membaca Al-Quran dengan mudah',
                          style: TextStyle(
                            color: Color(0xFF13A884),
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Divider(color: Colors.grey[200], height: 1),
            const SizedBox(height: 12),
            Row(
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
          ],
        ),
      ),
    );
  }

  Widget _buildProgressIndicatorItem(IconData icon, String value, String label) {
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
                color: const Color(0xFF0C5441),
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

  Widget _buildJuzListItem(JuzInfo juz) {
    final bool isExpanded = _expandedJuz == juz.number;
    final bool isFavorite = _favoriteJuz.contains(juz.number.toString());
    final bool isStudied = _studiedJuz.contains(juz.number.toString());
    final allSurahs = widget.useApi ? _surahs : QuranData.listSurah;

    // Get Surahs belonging to this Juz
    final juzSurahs = allSurahs.where((s) => juz.surahNumbers.contains(s.nomor)).toList();

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 15,
            offset: const Offset(0, 6),
          ),
        ],
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Column(
        children: [
          // Header Card (InkWell)
          InkWell(
            onTap: () {
              setState(() {
                _expandedJuz = isExpanded ? null : juz.number;
              });
            },
            borderRadius: BorderRadius.circular(20),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Quran Rehal Image on the left
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.asset(
                      'assets/images/quran_rehal.png',
                      width: 80,
                      height: 80,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) => Container(
                        width: 80,
                        height: 80,
                        color: Colors.teal.shade50,
                        child: const Icon(Icons.menu_book, color: Color(0xFF13A884), size: 36),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  // Info on the right
                  Expanded(
                    child: Stack(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Juz ${_toArabicNumerals(juz.number)}',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF0C5441),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              juz.pageRange,
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.grey.shade600,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              '${juz.surahCount} Surah • ${juz.ayatCount} Ayat',
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 6),
                            // Favorite Button
                            Wrap(
                              spacing: 8,
                              runSpacing: 6,
                              children: [
                                TextButton.icon(
                                  onPressed: () => _toggleFavoriteJuz(juz.number),
                                  icon: Icon(
                                    isFavorite ? Icons.star : Icons.star_border,
                                    color: isFavorite ? Colors.amber[800] : const Color(0xFF13A884),
                                    size: 16,
                                  ),
                                  label: Text(
                                    'Favorit',
                                    style: TextStyle(
                                      color: isFavorite ? Colors.amber[800] : const Color(0xFF13A884),
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  style: TextButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                                    backgroundColor: isFavorite ? Colors.amber.shade50 : const Color(0xFFE8F5F1),
                                    minimumSize: Size.zero,
                                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                ),
                                TextButton.icon(
                                  onPressed: () => _toggleStudiedJuz(juz.number),
                                  icon: Icon(
                                    isStudied ? Icons.bookmark : Icons.bookmark_border,
                                    color: const Color(0xFF13A884),
                                    size: 16,
                                  ),
                                  label: Text(
                                    isStudied ? 'Dipelajari' : 'Pelajari',
                                    style: const TextStyle(
                                      color: Color(0xFF13A884),
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  style: TextButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                                    backgroundColor: const Color(0xFFE8F5F1),
                                    minimumSize: Size.zero,
                                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        // Expansion Chevron in the top right corner
                        Positioned(
                          right: 0,
                          top: 0,
                          child: Icon(
                            isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                            color: const Color(0xFF13A884),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Expanded Surah list inside the card
          if (isExpanded) ...[
            Container(
              decoration: const BoxDecoration(
                color: Color(0xFFFBFBFB),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
              ),
              child: Column(
                children: [
                  Divider(color: Colors.grey[100], height: 1),
                  ListView.separated(
                    padding: EdgeInsets.zero,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: juzSurahs.length,
                    separatorBuilder: (context, index) => Divider(
                      color: Colors.grey[100],
                      height: 1,
                      indent: 80,
                    ),
                    itemBuilder: (context, index) {
                      return _buildSurahItem(juzSurahs[index]);
                    },
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildListHeaderAndControls() {
    final String titleText = _activeTab == 0 ? "Daftar Surah" : "Daftar Juz";
    final String countText = _activeTab == 0 ? "114 Surah" : "30 Juz";

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Row 1: Title and Count
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                titleText,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0C5441),
                ),
              ),
              Text(
                countText,
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey.shade600,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          // Row 2: Controls (Toggles)
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              // Terjemahan vs Lafal Toggle
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                padding: const EdgeInsets.all(2),
                child: Row(
                  children: [
                    _buildToggleItem(
                      title: 'Terjemahan',
                      icon: Icons.translate,
                      isSelected: _showTranslation,
                      onTap: () => setState(() => _showTranslation = true),
                    ),
                    _buildToggleItem(
                      title: 'Lafal',
                      icon: Icons.waves,
                      isSelected: !_showTranslation,
                      onTap: () => setState(() => _showTranslation = false),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildToggleItem({
    required String title,
    required IconData icon,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF0C5441) : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 14,
              color: isSelected ? Colors.white : Colors.grey.shade600,
            ),
            const SizedBox(width: 6),
            Text(
              title,
              style: TextStyle(
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: isSelected ? Colors.white : Colors.grey.shade600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSurahItem(SurahModel surah) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
      leading: Container(
        width: 32,
        height: 32,
        decoration: const BoxDecoration(
          color: Color(0xFFE8F5F1),
          shape: BoxShape.circle,
        ),
        child: Center(
          child: Text(
            _toArabicNumerals(surah.nomor),
            style: GoogleFonts.scheherazadeNew(
              color: const Color(0xFF13A884),
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),
      ),
      title: Text(
        surah.namaLatin,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 16,
          color: Colors.black87,
        ),
      ),
      subtitle: Text(
        _showTranslation
            ? surah.arti
            : '${surah.tempatTurun.toUpperCase()} • ${surah.jumlahAyat} AYAT',
        style: TextStyle(
          color: Colors.grey[600],
          fontSize: 12,
        ),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            surah.nama,
            style: GoogleFonts.scheherazadeNew(
              fontSize: 24,
              color: const Color(0xFF13A884),
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(width: 8),
          const Icon(
            Icons.chevron_right,
            color: Color(0xFF13A884),
            size: 20,
          ),
        ],
      ),
      onTap: () async {
        // Navigate to Surah Detail page
        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SurahDetailPage(nomor: surah.nomor),
          ),
        );
        _loadFavorites();
      },
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 80, color: Colors.redAccent),
          const SizedBox(height: 16),
          Text(
            'Gagal mengambil data',
            style: TextStyle(color: Colors.grey[800], fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Text(
              _errorMessage,
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey[600], fontSize: 14),
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: _fetchData,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF13A884),
              foregroundColor: Colors.white,
            ),
            child: const Text('Coba Lagi'),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search_off, size: 60, color: Colors.grey[300]),
            const SizedBox(height: 16),
            Text(
              'Item tidak ditemukan',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBookmarkHeader() {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF0C5441), Color(0xFF13A884)],
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Column(
          children: [
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white, size: 24),
                    onPressed: () => Navigator.pop(context),
                  ),
                  Column(
                    children: [
                      Text(
                        'Bookmark Saya',
                        style: GoogleFonts.outfit(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Daftar Juz yang kamu favoritkan',
                        style: GoogleFonts.outfit(
                          color: Colors.white70,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  IconButton(
                    icon: const Icon(Icons.bookmark, color: Colors.white, size: 24),
                    onPressed: () {},
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBookmarkTabContent() {
    final bookmarkedJuz = _juzList.where((juz) => _favoriteJuz.contains(juz.number.toString())).toList();
    final allSurahs = widget.useApi ? _surahs : QuranData.listSurah;
    final bookmarkedSurahs = allSurahs.where((surah) => _favoriteSurahs.contains(surah.nomor.toString())).toList();

    if (bookmarkedJuz.isEmpty && bookmarkedSurahs.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 80, horizontal: 32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.bookmark_border, size: 80, color: Colors.grey[300]),
              const SizedBox(height: 16),
              Text(
                'Belum ada bookmark',
                style: TextStyle(
                  color: Colors.grey[800],
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Tandai Surah atau Juz favoritmu untuk menyimpannya di sini.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.grey[500],
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return ListView(
      padding: const EdgeInsets.only(bottom: 24, top: 12),
      children: [
        if (bookmarkedSurahs.isNotEmpty) ...[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: Text(
              'Surah Terbookmark',
              style: GoogleFonts.outfit(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF0C5441),
              ),
            ),
          ),
          ListView.builder(
            padding: EdgeInsets.zero,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: bookmarkedSurahs.length,
            itemBuilder: (context, index) {
              return _buildSurahItem(bookmarkedSurahs[index]);
            },
          ),
          const SizedBox(height: 16),
        ],
        if (bookmarkedJuz.isNotEmpty) ...[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: Text(
              'Juz Terbookmark',
              style: GoogleFonts.outfit(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF0C5441),
              ),
            ),
          ),
          ListView.builder(
            padding: EdgeInsets.zero,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: bookmarkedJuz.length,
            itemBuilder: (context, index) {
              return _buildJuzListItem(bookmarkedJuz[index]);
            },
          ),
        ],
      ],
    );
  }

}
