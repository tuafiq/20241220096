import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'settings_provider.dart';
import 'tutorial_model.dart';
import 'tutorial_service.dart';
import 'tutorial_detail_page.dart';

class TutorialIbadahPage extends StatefulWidget {
  const TutorialIbadahPage({super.key});

  @override
  State<TutorialIbadahPage> createState() => _TutorialIbadahPageState();
}

class _TutorialIbadahPageState extends State<TutorialIbadahPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TutorialService _tutorialService = TutorialService();
  
  late Future<List<TutorialModel>> _niatFuture;
  late Future<List<TutorialModel>> _bacaanFuture;
  late Future<List<TutorialModel>> _ayatKursiFuture;

  final Color primaryGreen = const Color(0xFF149177);
  final Color backgroundLight = const Color(0xFFF8F9F9);

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        setState(() {});
      }
    });
    _niatFuture = _tutorialService.getNiatSholat();
    _bacaanFuture = _tutorialService.getBacaanSholat();
    _ayatKursiFuture = _tutorialService.getAyatKursi();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  String _getSubtitle(String name) {
    if (name.contains('Iftitah')) return 'Doa pembuka dalam sholat';
    if (name.contains('Fatihah')) return 'Surah Al-Fatihah';
    if (name.contains('Ruku')) return 'Doa ketika ruku\'';
    if (name.contains('Sujud') && !name.contains('Dua Sujud')) return 'Doa ketika sujud';
    if (name.contains('Dua Sujud')) return 'Doa di antara dua sujud';
    if (name.contains('Tasyahud Awal')) return 'Tasyahud pertama';
    if (name.contains('Tasyahud Akhir')) return 'Tasyahud terakhir';
    if (name.contains('Salam')) return 'Penutup sholat';
    if (name.contains('Ayat Kursi')) return 'Fadhilah Ayat Kursi';
    if (name.contains('Niat')) return 'Niat menjalankan sholat';
    return 'Panduan ibadah sholat';
  }

  void _showTextSizeDialog(SettingsProvider settingsProvider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Pilih Ukuran Teks'),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: ['Kecil', 'Sedang', 'Besar'].map((size) => ListTile(
            title: Text(size),
            trailing: settingsProvider.fontSize == size ? const Icon(Icons.check, color: Color(0xFF149177)) : null,
            onTap: () {
              settingsProvider.setFontSize(size);
              Navigator.pop(context);
            },
          )).toList(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final settingsProvider = Provider.of<SettingsProvider>(context);
    return Scaffold(
      backgroundColor: isDarkMode ? const Color(0xFF121212) : backgroundLight,
      appBar: AppBar(
        backgroundColor: isDarkMode ? const Color(0xFF1E1E1E) : Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: isDarkMode ? Colors.white : const Color(0xFF2D3436)),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Tutorial Ibadah',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold, 
            color: isDarkMode ? Colors.white : const Color(0xFF2D3436),
            fontSize: 18,
          ),
        ),
        actions: [
          IconButton(
            icon: Text(
              'Aa',
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: isDarkMode ? Colors.white : const Color(0xFF2D3436),
              ),
            ),
            onPressed: () => _showTextSizeDialog(settingsProvider),
          ),
          IconButton(
            icon: Icon(
              isDarkMode ? Icons.nightlight_round : Icons.wb_sunny,
              color: isDarkMode ? Colors.white : const Color(0xFF2D3436),
            ),
            onPressed: () {
              if (isDarkMode) {
                settingsProvider.setThemeModeStr('Hijau');
              } else {
                settingsProvider.setThemeModeStr('Gelap');
              }
            },
          ),
          const SizedBox(width: 8),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Container(
            color: isDarkMode ? const Color(0xFF1E1E1E) : Colors.white,
            child: TabBar(
              controller: _tabController,
              indicatorColor: primaryGreen,
              indicatorWeight: 3,
              indicatorSize: TabBarIndicatorSize.label,
              labelColor: primaryGreen,
              unselectedLabelColor: Colors.grey[400],
              labelStyle: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 13),
              unselectedLabelStyle: GoogleFonts.poppins(fontWeight: FontWeight.w500, fontSize: 13),
              tabs: [
                _buildTab('Niat Sholat', 0),
                _buildTab('Bacaan Sholat', 1),
                _buildTab('Ayat Kursi', 2),
              ],
            ),
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildListSection(_niatFuture),
          _buildListSection(_bacaanFuture),
          _buildListSection(_ayatKursiFuture),
        ],
      ),
    );
  }

  Widget _buildTab(String text, int index) {
    return Tab(
      child: Text(text, style: GoogleFonts.poppins()),
    );
  }

  Widget _buildListSection(Future<List<TutorialModel>> future) {
    return FutureBuilder<List<TutorialModel>>(
      future: future,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator(color: primaryGreen));
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('Data tidak ditemukan'));
        }

        final items = snapshot.data!;
        return ListView.builder(
          padding: const EdgeInsets.all(20),
          itemCount: items.length,
          itemBuilder: (context, index) {
            final item = items[index];
            return _buildTutorialCard(item, index, items);
          },
        );
      },
    );
  }

  Widget _buildTutorialCard(TutorialModel item, int index, List<TutorialModel> allItems) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: isDarkMode ? const Color(0xFF1E1E1E) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => TutorialDetailPage(
                  item: item,
                  allItems: allItems,
                  currentIndex: index,
                ),
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            child: Row(
              children: [
                Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: primaryGreen,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      '${index + 1}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.name,
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                          color: isDarkMode ? Colors.white : const Color(0xFF2D3436),
                        ),
                      ),
                      Text(
                        _getSubtitle(item.name),
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          color: isDarkMode ? Colors.grey[400] : Colors.grey[500],
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(Icons.chevron_right_rounded, color: primaryGreen.withOpacity(0.5)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}


