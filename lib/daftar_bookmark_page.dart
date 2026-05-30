import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'settings_provider.dart';
import 'surah_detail_page.dart';
import 'doa_detail_page.dart';
import 'doa_data.dart';
import 'tutorial_detail_page.dart';
import 'tutorial_service.dart';
import 'tutorial_model.dart';

class DaftarBookmarkPage extends StatelessWidget {
  const DaftarBookmarkPage({super.key});

  @override
  Widget build(BuildContext context) {
    final settings = Provider.of<SettingsProvider>(context);
    final isDarkMode = settings.themeModeStr == 'Gelap';

    return Scaffold(
      backgroundColor: isDarkMode ? const Color(0xFF121212) : const Color(0xFFF4F4F4),
      appBar: AppBar(
        title: const Text(
          'Daftar Bookmark',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
        ),
        backgroundColor: const Color(0xFF13A884),
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            _buildBookmarkCard(
              context,
              number: '1',
              title: 'Ayat Al-Quran',
              dataCount: settings.quranBookmarks.length,
              isDarkMode: isDarkMode,
              onTap: () {
                if (settings.quranBookmarks.isNotEmpty) {
                  _showQuranBookmarks(context, settings);
                }
              },
            ),
            const SizedBox(height: 16),
            _buildBookmarkCard(
              context,
              number: '2',
              title: 'Wirid & Doa',
              dataCount: settings.bookmarkedDoas.length,
              isDarkMode: isDarkMode,
              onTap: () {
                if (settings.bookmarkedDoas.isNotEmpty) {
                  _showSimpleBookmarks(context, 'Wirid & Doa', settings.bookmarkedDoas, isDarkMode, (item) {
                     // We can just pop for now, or navigate to detail if we have the full list
                     Navigator.pop(context);
                  });
                }
              },
            ),
            const SizedBox(height: 16),
            _buildBookmarkCard(
              context,
              number: '3',
              title: 'Tutorial Ibadah',
              dataCount: settings.tutorialBookmarks.length,
              isDarkMode: isDarkMode,
              onTap: () {
                if (settings.tutorialBookmarks.isNotEmpty) {
                  _showSimpleBookmarks(context, 'Tutorial Ibadah', settings.tutorialBookmarks, isDarkMode, (item) {
                     Navigator.pop(context);
                  });
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showQuranBookmarks(BuildContext context, SettingsProvider settings) {
    final isDarkMode = settings.themeModeStr == 'Gelap';
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Scaffold(
          backgroundColor: isDarkMode ? const Color(0xFF121212) : const Color(0xFFF4F4F4),
          appBar: AppBar(
            title: const Text('Bookmark Ayat Al-Quran', style: TextStyle(color: Colors.white, fontSize: 16)),
            backgroundColor: const Color(0xFF13A884),
            iconTheme: const IconThemeData(color: Colors.white),
          ),
          body: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: settings.quranBookmarks.length,
            itemBuilder: (context, index) {
              final parts = settings.quranBookmarks[index].split('|');
              if (parts.length != 3) return const SizedBox();
              
              final surahName = parts[1];
              final ayatNum = parts[2];
              
              return Card(
                color: isDarkMode ? const Color(0xFF1E1E1E) : Colors.white,
                margin: const EdgeInsets.only(bottom: 12),
                child: ListTile(
                  leading: const Icon(Icons.bookmark, color: Color(0xFF13A884)),
                  title: Text('QS. $surahName', style: TextStyle(color: isDarkMode ? Colors.white : Colors.black87, fontWeight: FontWeight.bold)),
                  subtitle: Text('Ayat $ayatNum', style: TextStyle(color: isDarkMode ? Colors.white70 : Colors.black54)),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SurahDetailPage(
                          nomor: int.parse(parts[0]),
                          initialVerse: int.parse(ayatNum),
                        ),
                      ),
                    );
                  },
                  trailing: IconButton(
                    icon: const Icon(Icons.delete_outline, color: Colors.red),
                    onPressed: () {
                      settings.toggleQuranBookmark(settings.quranBookmarks[index]);
                      if (settings.quranBookmarks.isEmpty) Navigator.pop(context);
                    },
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  void _showSimpleBookmarks(BuildContext context, String title, List<String> items, bool isDarkMode, Function(String) onTap) {
    final settings = Provider.of<SettingsProvider>(context, listen: false);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => StatefulBuilder(
          builder: (context, setStateLocal) {
            final currentItems = title == 'Wirid & Doa' ? settings.bookmarkedDoas : settings.tutorialBookmarks;
            return Scaffold(
              backgroundColor: isDarkMode ? const Color(0xFF121212) : const Color(0xFFF4F4F4),
              appBar: AppBar(
                title: Text('Bookmark $title', style: const TextStyle(color: Colors.white, fontSize: 16)),
                backgroundColor: const Color(0xFF13A884),
                iconTheme: const IconThemeData(color: Colors.white),
              ),
              body: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: currentItems.length,
                itemBuilder: (context, index) {
                  final item = currentItems[index];
                  return Card(
                    color: isDarkMode ? const Color(0xFF1E1E1E) : Colors.white,
                    margin: const EdgeInsets.only(bottom: 12),
                    child: ListTile(
                      leading: const Icon(Icons.bookmark, color: Color(0xFF13A884)),
                      title: Text(item, style: TextStyle(color: isDarkMode ? Colors.white : Colors.black87, fontWeight: FontWeight.bold)),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete_outline, color: Colors.red),
                        onPressed: () {
                          if (title == 'Wirid & Doa') {
                            settings.toggleDoaBookmark(item);
                          } else {
                            settings.toggleTutorialBookmark(item);
                          }
                          setStateLocal(() {});
                          if (currentItems.isEmpty) Navigator.pop(context);
                        },
                      ),
                      onTap: () async {
                        if (title == 'Wirid & Doa') {
                          try {
                            final doa = DoaData.listDoaHarian.firstWhere((d) => d.title == item);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => DoaDetailPage(
                                  doa: doa,
                                  doaList: DoaData.listDoaHarian,
                                  currentIndex: DoaData.listDoaHarian.indexOf(doa),
                                ),
                              ),
                            );
                          } catch (_) {
                            // If not found in listDoaHarian, it might be Tahlil or Ramadhan. 
                            // For simplicity, we just show a snackbar if not found.
                            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Detail tidak ditemukan')));
                          }
                        } else {
                          // Tutorial Ibadah
                          showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (context) => const Center(child: CircularProgressIndicator(color: Color(0xFF13A884))),
                          );
                          
                          try {
                            final service = TutorialService();
                            final niat = await service.getNiatSholat();
                            final bacaan = await service.getBacaanSholat();
                            final ayatKursi = await service.getAyatKursi();
                            
                            final allTutorials = [...niat, ...bacaan, ...ayatKursi];
                            final tutorial = allTutorials.firstWhere((t) => t.name == item);
                            
                            Navigator.pop(context); // close dialog
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => TutorialDetailPage(
                                  item: tutorial,
                                  allItems: allTutorials,
                                  currentIndex: allTutorials.indexOf(tutorial),
                                ),
                              ),
                            );
                          } catch (_) {
                            Navigator.pop(context); // close dialog
                            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Gagal memuat tutorial')));
                          }
                        }
                      },
                    ),
                  );
                },
              ),
            );
          }
        ),
      ),
    );
  }

  Widget _buildBookmarkCard(
    BuildContext context, {
    required String number,
    required String title,
    required int dataCount,
    required bool isDarkMode,
    required VoidCallback onTap,
  }) {
    final subtitle = dataCount == 0 
        ? 'Belum Ada Data Tersimpan' 
        : '$dataCount Data Tersimpan';

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: isDarkMode ? const Color(0xFF1E1E1E) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            if (!isDarkMode)
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 60,
              height: 80,
              decoration: BoxDecoration(
                color: isDarkMode ? const Color(0xFF13A884).withOpacity(0.2) : const Color(0xFFE8F7F3),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  bottomLeft: Radius.circular(12),
                ),
              ),
              alignment: Alignment.center,
              child: Text(
                number,
                style: const TextStyle(
                  color: Color(0xFF13A884),
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: isDarkMode ? Colors.white : const Color(0xFF2C3E50),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 14,
                      color: isDarkMode ? Colors.white54 : Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
