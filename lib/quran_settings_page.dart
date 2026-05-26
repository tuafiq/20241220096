import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'settings_provider.dart';
import 'panduan_tajwid_page.dart';
import 'pilih_qori_page.dart';
import 'halaman_alfatihah_page.dart';

class QuranSettingsPage extends StatefulWidget {
  const QuranSettingsPage({super.key});

  @override
  State<QuranSettingsPage> createState() => _QuranSettingsPageState();
}

class _QuranSettingsPageState extends State<QuranSettingsPage> {





  void _showClearAudioDialog(BuildContext context, SettingsProvider settings) {
    final isDarkMode = settings.themeModeStr == 'Gelap';

    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return Dialog(
          backgroundColor: isDarkMode ? const Color(0xFF1E1E1E) : Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Warning Trash Icon
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    color: Colors.red.shade50.withOpacity(isDarkMode ? 0.1 : 0.8),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Icon(
                      Icons.delete_outline_rounded,
                      color: Colors.redAccent.shade400,
                      size: 32,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                // Dialog Title
                Text(
                  'Hapus Audio',
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: isDarkMode ? Colors.white : const Color(0xFF1A202C),
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                // Dialog Body Text
                Text(
                  'Apakah Anda yakin ingin menghapus semua audio murottal yang telah diunduh?',
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: isDarkMode ? Colors.white70 : const Color(0xFF718096),
                    height: 1.5,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 28),
                // Actions Row
                Row(
                  children: [
                    // Cancel Button
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(context),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          side: BorderSide(
                            color: isDarkMode ? Colors.white24 : Colors.grey.shade300,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          'Batal',
                          style: GoogleFonts.poppins(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: isDarkMode ? Colors.white70 : const Color(0xFF718096),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    // Delete Button
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          settings.clearSavedAudio();
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Row(
                                children: [
                                  const Icon(Icons.check_circle_outline, color: Colors.white),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Text(
                                      'Audio murottal berhasil dihapus.',
                                      style: GoogleFonts.poppins(
                                        color: Colors.white,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              backgroundColor: const Color(0xFF13A884),
                              behavior: SnackBarBehavior.floating,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              duration: const Duration(seconds: 2),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.redAccent.shade400,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          'Hapus',
                          style: GoogleFonts.poppins(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showTajwidInfoDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        int currentPage = 0;
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              backgroundColor: Colors.white,
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
                width: 320,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Menampilkan Opsi Ayat',
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 12),
                    RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        style: GoogleFonts.poppins(
                          fontSize: 13,
                          color: Colors.grey[600],
                          height: 1.4,
                        ),
                        children: const [
                          TextSpan(text: 'Saat mode Quran Tajwid aktif, opsi ayat hanya bisa dibuka dengan '),
                          TextSpan(
                            text: 'menekan dan menahan nomor ayat.',
                            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Carousel Container
                    Container(
                      height: 280,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey.shade200),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: PageView(
                          onPageChanged: (index) {
                            setModalState(() {
                              currentPage = index;
                            });
                          },
                          children: [
                            _buildCarouselSlide1(),
                            _buildCarouselSlide2(),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Indicator Dots
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(2, (index) {
                        return AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          width: currentPage == index ? 20 : 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: currentPage == index
                                ? const Color(0xFF13A884)
                                : Colors.grey.shade300,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        );
                      }),
                    ),
                    const SizedBox(height: 20),
                    // Button "Mengerti"
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton(
                        onPressed: () => Navigator.pop(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF13A884),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          elevation: 0,
                        ),
                        child: Text(
                          'Mengerti',
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  InlineSpan _buildInlineVerseNumber(int number) {
    return WidgetSpan(
      alignment: PlaceholderAlignment.middle,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: Container(
          width: 14,
          height: 14,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: const Color(0xFF13A884), width: 1),
          ),
          child: Center(
            child: Text(
              number.toString(),
              style: const TextStyle(
                fontSize: 8,
                fontWeight: FontWeight.bold,
                color: Color(0xFF13A884),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMockHeader(String type, String title, String ayatCount) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 8),
      margin: const EdgeInsets.only(bottom: 4),
      decoration: BoxDecoration(
        color: const Color(0xFFE8F5F1),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: const Color(0xFF13A884).withOpacity(0.3)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            type,
            style: GoogleFonts.poppins(fontSize: 8, fontWeight: FontWeight.bold, color: const Color(0xFF13A884)),
          ),
          Text(
            title,
            style: GoogleFonts.scheherazadeNew(fontSize: 10, fontWeight: FontWeight.bold, color: const Color(0xFF0C5441)),
          ),
          Text(
            ayatCount,
            style: GoogleFonts.poppins(fontSize: 8, fontWeight: FontWeight.bold, color: const Color(0xFF13A884)),
          ),
        ],
      ),
    );
  }

  Widget _buildMousePointer() {
    return Transform.rotate(
      angle: -0.5,
      child: Stack(
        clipBehavior: Clip.none,
        children: const [
          Icon(Icons.navigation, size: 20, color: Colors.white),
          Positioned(
            top: 1,
            left: 1,
            child: Icon(Icons.navigation, size: 18, color: Colors.black),
          ),
        ],
      ),
    );
  }

  Widget _buildMockQuranPage() {
    final baseStyle = GoogleFonts.scheherazadeNew(
      fontSize: 12.5,
      fontWeight: FontWeight.bold,
      color: const Color(0xFF0C5441),
      height: 1.5,
    );
    final greenStyle = baseStyle.copyWith(color: const Color(0xFF27AE60));
    final pinkStyle = baseStyle.copyWith(color: const Color(0xFFE84393));

    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Surah Al-Falaq Header
          _buildMockHeader('Makkiyah', 'سُورَةُ الْفَلَقِ', '5 Ayat'),
          Text(
            'بِسْمِ اللّٰهِ الرَّحْمٰنِ الرَّحِيْمِ',
            style: baseStyle.copyWith(fontSize: 11),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 2),
          // Al-Falaq text wrap
          Directionality(
            textDirection: TextDirection.rtl,
            child: RichText(
              textAlign: TextAlign.justify,
              text: TextSpan(
                children: [
                  TextSpan(text: 'قُلْ أَعُوذُ بِرَبِّ الْفَلَقِ', style: baseStyle),
                  _buildInlineVerseNumber(1),
                  TextSpan(text: ' مِنْ ', style: baseStyle),
                  TextSpan(text: 'شَرِّ', style: greenStyle),
                  TextSpan(text: ' مَا خَلَقَ', style: baseStyle),
                  _buildInlineVerseNumber(2),
                  TextSpan(text: ' وَمِنْ ', style: baseStyle),
                  TextSpan(text: 'شَرِّ', style: greenStyle),
                  TextSpan(text: ' غَاسِقٍ إِذَا وَقَبَ', style: baseStyle),
                  _buildInlineVerseNumber(3),
                  TextSpan(text: ' وَمِنْ ', style: baseStyle),
                  TextSpan(text: 'شَرِّ', style: greenStyle),
                  TextSpan(text: ' ', style: baseStyle),
                  TextSpan(text: 'النَّفّٰثٰتِ', style: pinkStyle),
                  TextSpan(text: ' فِي الْعُقَدِ', style: baseStyle),
                  _buildInlineVerseNumber(4),
                  TextSpan(text: ' وَمِنْ ', style: baseStyle),
                  TextSpan(text: 'شَرِّ', style: greenStyle),
                  TextSpan(text: ' حَاسِدٍ إِذَا حَسَدَ', style: baseStyle),
                  _buildInlineVerseNumber(5),
                ],
              ),
            ),
          ),
          const SizedBox(height: 6),
          // Surah An-Nas Header
          _buildMockHeader('Makkiyah', 'سُورَةُ النَّاسِ', '6 Ayat'),
          Text(
            'بِسْمِ اللّٰهِ الرَّحْمٰنِ الرَّحِيْمِ',
            style: baseStyle.copyWith(fontSize: 11),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 2),
          // An-Nas text wrap
          Directionality(
            textDirection: TextDirection.rtl,
            child: RichText(
              textAlign: TextAlign.justify,
              text: TextSpan(
                children: [
                  TextSpan(text: 'قُلْ أَعُوذُ بِرَبِّ ', style: baseStyle),
                  TextSpan(text: 'النَّاسِ', style: pinkStyle),
                  _buildInlineVerseNumber(1),
                  TextSpan(text: ' مَلِكِ ', style: baseStyle),
                  TextSpan(text: 'النَّاسِ', style: pinkStyle),
                  _buildInlineVerseNumber(2),
                  TextSpan(text: ' إِلٰهِ ', style: baseStyle),
                  TextSpan(text: 'النَّاسِ', style: pinkStyle),
                  _buildInlineVerseNumber(3),
                  TextSpan(text: ' مِنْ ', style: baseStyle),
                  TextSpan(text: 'شَرِّ', style: greenStyle),
                  TextSpan(text: ' الْوَسْوَاسِ ', style: baseStyle),
                  TextSpan(text: 'الْخَنَّاسِ', style: pinkStyle),
                  _buildInlineVerseNumber(4),
                  TextSpan(text: ' الَّذِي يُوَسْوِسُ فِي صُدُورِ ', style: baseStyle),
                  TextSpan(text: 'النَّاسِ', style: pinkStyle),
                  _buildInlineVerseNumber(5),
                  TextSpan(text: ' مِنَ ', style: baseStyle),
                  TextSpan(text: 'الْجِنَّةِ', style: pinkStyle),
                  TextSpan(text: ' وَ', style: baseStyle),
                  TextSpan(text: 'النَّاسِ', style: pinkStyle),
                  _buildInlineVerseNumber(6),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCarouselSlide1() {
    return Stack(
      children: [
        Positioned.fill(
          child: SingleChildScrollView(
            physics: const NeverScrollableScrollPhysics(),
            child: _buildMockQuranPage(),
          ),
        ),
        // Positioned Pointer pointing to the start of Al-Falaq Verse 2
        Positioned(
          right: 90,
          top: 62,
          child: _buildMousePointer(),
        ),
      ],
    );
  }

  Widget _buildCarouselSlide2() {
    return Stack(
      children: [
        // Background verses
        Positioned.fill(
          child: SingleChildScrollView(
            physics: const NeverScrollableScrollPhysics(),
            child: _buildMockQuranPage(),
          ),
        ),
        // Overlay Mock Bottom Sheet
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.15),
                  blurRadius: 10,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 32,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'QS. Al-Falaq: Ayat 2 (Juz 30)',
                  style: GoogleFonts.poppins(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.black87),
                ),
                const SizedBox(height: 4),
                const Divider(height: 1),
                _buildMockBottomSheetItem(Icons.play_arrow, 'Putar Ayat'),
                _buildMockBottomSheetItem(Icons.share, 'Bagikan'),
                _buildMockBottomSheetItem(Icons.book, 'Lihat Terjemah & Tafsir'),
                _buildMockBottomSheetItem(Icons.bookmark_outline, 'Tandai Terakhir Dibaca'),
                _buildMockBottomSheetItem(Icons.star_border, 'Simpan ke Bookmark'),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMockBottomSheetItem(IconData icon, String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, size: 12, color: const Color(0xFF13A884)),
          const SizedBox(width: 8),
          Text(
            label,
            style: GoogleFonts.poppins(fontSize: 9, color: Colors.black87, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final settings = Provider.of<SettingsProvider>(context);

    // Format size display
    String formattedSize = '${settings.savedAudioSize.toStringAsFixed(0)} B';
    if (settings.savedAudioSize > 1024 * 1024) {
      formattedSize = '${(settings.savedAudioSize / (1024 * 1024)).toStringAsFixed(1)} MB';
    } else if (settings.savedAudioSize > 1024) {
      formattedSize = '${(settings.savedAudioSize / 1024).toStringAsFixed(1)} KB';
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF4F4F4),
      appBar: AppBar(
        title: Text(
          'Pengaturan Al-Quran',
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 18,
          ),
        ),
        backgroundColor: const Color(0xFF13A884),
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Section 1: Quran Tajwid
            _buildSectionHeader('Quran Tajwid'),
            _buildGroupCard([
              _buildSwitchRow(
                title: 'Tampilkan Warna Tajwid',
                value: settings.showWarnaTajwid,
                onChanged: (val) {
                  settings.setShowWarnaTajwid(val);
                  if (val) {
                    _showTajwidInfoDialog(context);
                  }
                },
              ),
              const Divider(height: 1),
              _buildClickableRow(
                title: 'Panduan Tajwid',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const PanduanTajwidPage()),
                  );
                },
              ),
            ]),

            const SizedBox(height: 16),

            // Section 2: Qori' Murottal
            _buildSectionHeader('Qori\' Murottal'),
            _buildGroupCard([
              _buildClickableRow(
                title: 'Pilih Qori',
                value: settings.selectedQori,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const PilihQoriPage()),
                  );
                },
              ),
              const Divider(height: 1),
              _buildClickableRow(
                title: 'Hapus Audio Tersimpan',
                value: formattedSize,
                onTap: () => _showClearAudioDialog(context, settings),
              ),
            ]),

            const SizedBox(height: 16),

            // Section 4: Sesuaikan Halaman Permulaan
            _buildSectionHeader('Sesuaikan Halaman Permulaan'),
            _buildGroupCard([
              _buildClickableRow(
                title: 'Halaman Surah Al-Fatihah',
                value: settings.halamanPermulaanAlFatihah,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const HalamanAlFatihahPage()),
                  );
                },
              ),
            ]),

            const SizedBox(height: 16),

            // Section 5: Ayat Terakhir Dibaca
            _buildSectionHeader('Ayat Terakhir Dibaca'),
            _buildGroupCard([
              _buildSwitchRow(
                title: 'Penanda Otomatis',
                value: settings.penandaOtomatis,
                onChanged: (val) => settings.setPenandaOtomatis(val),
              ),
              const Divider(height: 1),
              _buildSwitchRow(
                title: 'Pengingat Membaca',
                value: settings.pengingatMembaca,
                onChanged: (val) => settings.setPengingatMembaca(val),
              ),
            ]),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8, top: 8),
      child: Text(
        title,
        style: GoogleFonts.poppins(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
    );
  }

  Widget _buildGroupCard(List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: children,
      ),
    );
  }

  Widget _buildSwitchRow({
    required String title,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return InkWell(
      onTap: () => onChanged(!value),
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                title,
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: Colors.black87,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Switch(
              value: value,
              onChanged: onChanged,
              activeColor: const Color(0xFF13A884),
              activeTrackColor: const Color(0xFF13A884).withOpacity(0.3),
              inactiveThumbColor: Colors.grey[200],
              inactiveTrackColor: Colors.grey[300],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildClickableRow({
    required String title,
    String? value,
    required VoidCallback onTap,
  }) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
      title: Text(
        title,
        style: GoogleFonts.poppins(
          fontSize: 14,
          color: Colors.black87,
          fontWeight: FontWeight.w500,
        ),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (value != null) ...[
            Text(
              value,
              style: GoogleFonts.poppins(
                fontSize: 13,
                color: Colors.grey[500],
                fontWeight: FontWeight.w400,
              ),
            ),
            const SizedBox(width: 8),
          ],
          const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
        ],
      ),
      onTap: onTap,
    );
  }
}
