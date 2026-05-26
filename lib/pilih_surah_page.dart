import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'quran_data.dart';
import 'settings_provider.dart';

class PilihSurahPage extends StatefulWidget {
  final SurahModel currentSurah;
  const PilihSurahPage({super.key, required this.currentSurah});

  @override
  State<PilihSurahPage> createState() => _PilihSurahPageState();
}

class _PilihSurahPageState extends State<PilihSurahPage> {
  final TextEditingController _searchController = TextEditingController();
  List<SurahModel> _allSurahs = [];
  List<SurahModel> _filteredSurahs = [];
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _allSurahs = QuranData.listSurah;
    _filteredSurahs = _allSurahs;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterSurahs(String query) {
    setState(() {
      _searchQuery = query;
      if (query.isEmpty) {
        _filteredSurahs = _allSurahs;
      } else {
        _filteredSurahs = _allSurahs
            .where((s) => s.namaLatin.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final settings = Provider.of<SettingsProvider>(context);
    final isDarkMode = settings.themeModeStr == 'Gelap';

    return Scaffold(
      backgroundColor: isDarkMode ? const Color(0xFF121212) : Colors.white,
      appBar: AppBar(
        titleSpacing: 0,
        title: Text(
          'Pilih Surah',
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
        backgroundColor: const Color(0xFF13A884),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.chevron_left, color: Colors.white, size: 28),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          // Search box
          Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
            decoration: BoxDecoration(
              color: isDarkMode ? const Color(0xFF1E1E1E) : const Color(0xFFF2F4F5),
              borderRadius: BorderRadius.circular(10),
            ),
            child: TextField(
              controller: _searchController,
              onChanged: _filterSurahs,
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: isDarkMode ? Colors.white : Colors.black87,
              ),
              decoration: InputDecoration(
                icon: Icon(
                  Icons.search,
                  color: isDarkMode ? Colors.grey[500] : Colors.grey[600],
                  size: 20,
                ),
                hintText: 'Cari surah',
                hintStyle: GoogleFonts.poppins(
                  fontSize: 14,
                  color: isDarkMode ? Colors.grey[600] : Colors.grey[500],
                ),
                border: InputBorder.none,
                isDense: true,
              ),
            ),
          ),
          
          // Surah list
          Expanded(
            child: ListView.separated(
              itemCount: _filteredSurahs.length,
              separatorBuilder: (context, index) => Divider(
                height: 1,
                color: isDarkMode ? Colors.grey[850] : Colors.grey[200],
              ),
              itemBuilder: (context, index) {
                final surah = _filteredSurahs[index];
                return ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  title: Text(
                    '${surah.nomor}. ${surah.namaLatin}',
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: isDarkMode ? Colors.white : Colors.black87,
                    ),
                  ),
                  onTap: () {
                    Navigator.pop(context, surah);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
