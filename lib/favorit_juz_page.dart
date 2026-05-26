import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'settings_provider.dart';
import 'juz_detail_page.dart';
import 'quran_page.dart';

class FavoritJuzPage extends StatefulWidget {
  const FavoritJuzPage({super.key});

  @override
  State<FavoritJuzPage> createState() => _FavoritJuzPageState();
}

class _FavoritJuzPageState extends State<FavoritJuzPage>
    with TickerProviderStateMixin {
  List<String> _favoriteJuz = [];
  bool _isLoading = true;
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeOut,
    );
    _loadFavorites();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  Future<void> _loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _favoriteJuz = prefs.getStringList('favoriteJuz') ?? [];
      _isLoading = false;
    });
    _fadeController.forward(from: 0);
  }

  Future<void> _removeFavoriteJuz(int juzNumber) async {
    HapticFeedback.lightImpact();
    final prefs = await SharedPreferences.getInstance();
    final list = List<String>.from(_favoriteJuz);
    list.remove(juzNumber.toString());
    await prefs.setStringList('favoriteJuz', list);
    setState(() {
      _favoriteJuz = list;
    });
  }

  Future<void> _clearAllFavorites() async {
    HapticFeedback.mediumImpact();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('favoriteJuz', []);
    setState(() {
      _favoriteJuz = [];
    });
  }

  void _showClearAllDialog(bool isDarkMode) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => Dialog(
        backgroundColor: isDarkMode ? const Color(0xFF1E1E1E) : Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Icon
              Container(
                width: 68,
                height: 68,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.red.shade300, Colors.red.shade600],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.red.withOpacity(0.3),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: const Icon(Icons.delete_sweep_rounded,
                    color: Colors.white, size: 32),
              ),
              const SizedBox(height: 20),
              Text(
                'Hapus Semua Favorit?',
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: isDarkMode ? Colors.white : const Color(0xFF1A202C),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              Text(
                'Semua ${_favoriteJuz.length} Juz yang kamu favoritkan akan dihapus dari daftar ini.',
                style: GoogleFonts.poppins(
                  fontSize: 13,
                  color: isDarkMode ? Colors.white60 : const Color(0xFF718096),
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 28),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        side: BorderSide(
                            color: isDarkMode
                                ? Colors.white24
                                : Colors.grey.shade300),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                      child: Text(
                        'Batal',
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: isDarkMode
                              ? Colors.white70
                              : const Color(0xFF718096),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        _clearAllFavorites();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Row(
                              children: [
                                const Icon(Icons.check_circle_outline,
                                    color: Colors.white, size: 18),
                                const SizedBox(width: 8),
                                Text(
                                  'Semua juz favorit dihapus.',
                                  style: GoogleFonts.poppins(
                                      fontSize: 13, color: Colors.white),
                                ),
                              ],
                            ),
                            backgroundColor: const Color(0xFF13A884),
                            behavior: SnackBarBehavior.floating,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            margin: const EdgeInsets.all(16),
                            duration: const Duration(seconds: 2),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red.shade500,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                      child: Text(
                        'Hapus Semua',
                        style: GoogleFonts.poppins(
                            fontSize: 14, fontWeight: FontWeight.bold),
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

  String _toArabicNumerals(int number) {
    const Map<String, String> arabicDigits = {
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
    return number
        .toString()
        .split('')
        .map((char) => arabicDigits[char] ?? char)
        .join();
  }

  @override
  Widget build(BuildContext context) {
    final settings = Provider.of<SettingsProvider>(context);
    final isDarkMode = settings.themeModeStr == 'Gelap';

    final favoriteJuzList = juzList
        .where((juz) => _favoriteJuz.contains(juz.number.toString()))
        .toList();

    return Scaffold(
      backgroundColor:
          isDarkMode ? const Color(0xFF121212) : const Color(0xFFF0F4F3),
      body: Column(
        children: [
          _buildGradientHeader(isDarkMode, favoriteJuzList.length),
          Expanded(
            child: _isLoading
                ? const Center(
                    child: CircularProgressIndicator(
                        color: Color(0xFF13A884)))
                : favoriteJuzList.isEmpty
                    ? _buildEmptyState(isDarkMode)
                    : FadeTransition(
                        opacity: _fadeAnimation,
                        child: ListView.builder(
                          padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
                          itemCount: favoriteJuzList.length,
                          itemBuilder: (context, index) {
                            final juz = favoriteJuzList[index];
                            return _buildSwipeableCard(
                                juz, isDarkMode, index);
                          },
                        ),
                      ),
          ),
        ],
      ),
    );
  }

  Widget _buildGradientHeader(bool isDarkMode, int count) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF0C5441), Color(0xFF13A884), Color(0xFF1EC99C)],
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(28),
          bottomRight: Radius.circular(28),
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // App Bar row
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios_new,
                        color: Colors.white, size: 20),
                    onPressed: () => Navigator.pop(context),
                  ),
                  Expanded(
                    child: Text(
                      'Juz Favorit',
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ),
                  if (count > 0)
                    TextButton.icon(
                      onPressed: () => _showClearAllDialog(isDarkMode),
                      icon: const Icon(Icons.delete_sweep_rounded,
                          color: Colors.white70, size: 18),
                      label: Text(
                        'Hapus Semua',
                        style: GoogleFonts.poppins(
                          color: Colors.white70,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 6),
                        backgroundColor: Colors.white.withOpacity(0.12),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                    ),
                ],
              ),
            ),
            // Stats banner
            Padding(
              padding:
                  const EdgeInsets.only(left: 20, right: 20, bottom: 24),
              child: Row(
                children: [
                  _buildStatChip(
                    icon: Icons.star_rounded,
                    label: '$count Juz Favorit',
                    isDarkMode: isDarkMode,
                  ),
                  const SizedBox(width: 10),
                  _buildStatChip(
                    icon: Icons.menu_book_rounded,
                    label: '30 Total Juz',
                    isDarkMode: isDarkMode,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatChip(
      {required IconData icon,
      required String label,
      required bool isDarkMode}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.2)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Colors.white, size: 14),
          const SizedBox(width: 6),
          Text(
            label,
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSwipeableCard(JuzInfo juz, bool isDarkMode, int index) {
    return Dismissible(
      key: Key('juz_${juz.number}'),
      direction: DismissDirection.endToStart,
      onDismissed: (_) => _removeFavoriteJuz(juz.number),
      background: Container(
        margin: const EdgeInsets.symmetric(vertical: 7),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.red.shade300, Colors.red.shade600],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.delete_rounded, color: Colors.white, size: 28),
            const SizedBox(height: 4),
            Text(
              'Hapus',
              style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
      child: _buildJuzCard(juz, isDarkMode, index),
    );
  }

  Widget _buildJuzCard(JuzInfo juz, bool isDarkMode, int index) {
    // Gradient accent colors cycling per card
    final List<List<Color>> accentGradients = [
      [const Color(0xFF0C5441), const Color(0xFF13A884)],
      [const Color(0xFF1565C0), const Color(0xFF42A5F5)],
      [const Color(0xFF6A1B9A), const Color(0xFFAB47BC)],
      [const Color(0xFFE65100), const Color(0xFFFF9800)],
      [const Color(0xFF1B5E20), const Color(0xFF66BB6A)],
    ];
    final gradient = accentGradients[index % accentGradients.length];

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 7),
      decoration: BoxDecoration(
        color: isDarkMode ? const Color(0xFF1C1C1E) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: isDarkMode
                ? Colors.black.withOpacity(0.3)
                : Colors.black.withOpacity(0.06),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
        border: Border.all(
          color: isDarkMode ? Colors.white.withOpacity(0.06) : Colors.transparent,
        ),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => JuzDetailPage(juzNumber: juz.number),
            ),
          );
          _loadFavorites();
        },
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              // Left accent bar + number badge
              Stack(
                clipBehavior: Clip.none,
                children: [
                  // Rehal image
                  ClipRRect(
                    borderRadius: BorderRadius.circular(14),
                    child: Image.asset(
                      'assets/images/quran_rehal.png',
                      width: 76,
                      height: 76,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        width: 76,
                        height: 76,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: gradient,
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: const Icon(Icons.menu_book,
                            color: Colors.white, size: 32),
                      ),
                    ),
                  ),
                  // Juz number badge at bottom-right of image
                  Positioned(
                    bottom: -6,
                    right: -6,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 7, vertical: 3),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: gradient,
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: gradient[1].withOpacity(0.4),
                            blurRadius: 6,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Text(
                        '${juz.number}',
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 11,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 16),
              // Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            'Juz ${_toArabicNumerals(juz.number)}',
                            style: GoogleFonts.poppins(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                              color: isDarkMode
                                  ? Colors.white
                                  : const Color(0xFF0C5441),
                            ),
                          ),
                        ),
                        // Star unfavorite button
                        GestureDetector(
                          onTap: () => _removeFavoriteJuz(juz.number),
                          child: Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: isDarkMode
                                  ? const Color(0xFF3E2D00)
                                  : Colors.amber.shade50,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.star_rounded,
                                color: Colors.amber, size: 18),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(Icons.auto_stories_outlined,
                            size: 13,
                            color: isDarkMode
                                ? Colors.white38
                                : Colors.grey.shade500),
                        const SizedBox(width: 4),
                        Text(
                          juz.pageRange,
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            color: isDarkMode
                                ? Colors.white54
                                : Colors.grey.shade500,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        _buildInfoPill(
                          label: '${juz.surahCount} Surah',
                          gradient: gradient,
                          isDarkMode: isDarkMode,
                        ),
                        const SizedBox(width: 8),
                        _buildInfoPill(
                          label: '${juz.ayatCount} Ayat',
                          gradient: gradient,
                          isDarkMode: isDarkMode,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 4),
              Icon(
                Icons.arrow_forward_ios_rounded,
                size: 14,
                color: isDarkMode ? Colors.white24 : Colors.grey.shade300,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoPill(
      {required String label,
      required List<Color> gradient,
      required bool isDarkMode}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3),
      decoration: BoxDecoration(
        gradient: isDarkMode
            ? null
            : LinearGradient(
                colors: [gradient[0].withOpacity(0.08), gradient[1].withOpacity(0.12)],
              ),
        color: isDarkMode ? Colors.white.withOpacity(0.08) : null,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDarkMode
              ? Colors.white.withOpacity(0.08)
              : gradient[0].withOpacity(0.2),
        ),
      ),
      child: Text(
        label,
        style: GoogleFonts.poppins(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: isDarkMode ? Colors.white60 : gradient[0],
        ),
      ),
    );
  }

  Widget _buildEmptyState(bool isDarkMode) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 110,
              height: 110,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    const Color(0xFF13A884).withOpacity(0.12),
                    const Color(0xFF0C5441).withOpacity(0.06),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Icon(
                  Icons.star_outline_rounded,
                  size: 52,
                  color: isDarkMode
                      ? const Color(0xFF13A884).withOpacity(0.6)
                      : const Color(0xFF13A884),
                ),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Belum Ada Juz Favorit',
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: isDarkMode ? Colors.white : const Color(0xFF1A202C),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Tandai Juz favoritmu dengan menekan tombol ⭐ di halaman daftar Juz.',
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontSize: 13,
                color: isDarkMode ? Colors.white54 : Colors.grey.shade500,
                height: 1.6,
              ),
            ),
            const SizedBox(height: 28),
            ElevatedButton.icon(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.arrow_back_rounded, size: 18),
              label: Text(
                'Pergi ke Daftar Juz',
                style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w600, fontSize: 13),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF13A884),
                foregroundColor: Colors.white,
                elevation: 0,
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 13),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
