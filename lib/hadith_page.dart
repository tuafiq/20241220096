import 'package:flutter/material.dart';
import 'hadith_service.dart';
import 'hadith_chapters_page.dart';
import 'hadith_list_page.dart';
import 'hadith_search_results_page.dart';
import 'language_selection_page.dart';
import 'about_app_page.dart';
import 'notification_hadith_page.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:share_plus/share_plus.dart';
import 'package:flutter/services.dart';
import 'dart:math';
import 'package:provider/provider.dart';
import 'settings_provider.dart';

class HadithPage extends StatefulWidget {
  const HadithPage({super.key});

  @override
  State<HadithPage> createState() => _HadithPageState();
}

class _HadithPageState extends State<HadithPage> {
  int _currentIndex = 0;
  bool _isEditMode = false;
  String _activeBookmarkTab = 'Semua';
  final Set<int> _selectedBookmarks = {};
  final HadithService _hadithService = HadithService();
  String searchQuery = '';
  List<String> _searchHistory = ['kunci shalat', 'niat puasa', 'keutamaan ilmu'];
  String _textSize = 'Sedang';

  final List<Map<String, dynamic>> narrators = [
    {'id': 'bukhari', 'name': 'Shahih Bukhari', 'count': '7.008 Hadis', 'icon': Icons.menu_book},
    {'id': 'muslim', 'name': 'Shahih Muslim', 'count': '5.362 Hadis', 'icon': Icons.menu_book},
    {'id': 'abu-daud', 'name': 'Sunan Abu Daud', 'count': '4.590 Hadis', 'icon': Icons.lightbulb_outline},
    {'id': 'tirmidzi', 'name': 'Jami\' At-Tirmidzi', 'count': '3.891 Hadis', 'icon': Icons.edit_note},
    {'id': 'nasai', 'name': 'Sunan An-Nasa\'i', 'count': '5.662 Hadis', 'icon': Icons.star_border},
    {'id': 'ibnu-majah', 'name': 'Sunan Ibnu Majah', 'count': '4.332 Hadis', 'icon': Icons.menu_book_outlined},
    {'id': 'malik', 'name': 'Al-Muwaththa\' Malik', 'count': '1.594 Hadis', 'icon': Icons.mosque_outlined},
    {'id': 'ahmad', 'name': 'Musnad Ahmad', 'count': '15.070 Hadis', 'icon': Icons.history_edu},
    {'id': 'darimi', 'name': 'Sunan Ad-Darimi', 'count': '3.367 Hadis', 'icon': Icons.article_outlined},
  ];

  List<Map<String, dynamic>> get _allBookmarks => BookmarkManager().bookmarks;

  void _navigateToRandomHadith() async {
    final randomNarrator = narrators[Random().nextInt(narrators.length)];
    final randomNum = Random().nextInt(50) + 1;
    
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator(color: Color(0xFF13A884))),
    );

    final hadith = await _hadithService.getHadithDetail(randomNarrator['id'], randomNum);
    
    if (mounted) {
      Navigator.pop(context);
      if (hadith != null) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => HadithDetailPage(
            hadith: hadith,
            narratorId: randomNarrator['id'],
            narratorName: randomNarrator['name'],
          )),
        ).then((_) => setState(() {})); // Refresh when back
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    const primaryGreen = Color(0xFF13A884);
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDarkMode ? const Color(0xFF121212) : const Color(0xFFF9F9F9),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0C5441),
        elevation: 0,
        centerTitle: true,
        title: Text(
          _getPageTitle(),
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
        ),
        leading: Builder(
          builder: (context) => IconButton(
            icon: Icon(
              (_currentIndex == 2 && _isEditMode) ? Icons.arrow_back : Icons.menu,
              color: Colors.white,
            ),
            onPressed: () {
              if (_currentIndex == 2 && _isEditMode) {
                setState(() => _isEditMode = false);
              } else {
                Scaffold.of(context).openDrawer();
              }
            },
          ),
        ),
        actions: const [],
      ),
      body: IndexedStack(
        index: _currentIndex,
        children: [
          _buildKoleksiTab(), // Tab 0
          _buildCariTab(), // Tab 1
          _buildBookmarkTab(), // Tab 2
        ],
      ),
      drawer: _buildDrawer(context),
      bottomNavigationBar: _isEditMode ? null : BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: primaryGreen,
        unselectedItemColor: Colors.grey,
        currentIndex: _currentIndex,
        onTap: (index) => setState(() {
          _currentIndex = index;
          _isEditMode = false; // Reset edit mode when switching tabs
        }),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.grid_view_rounded), label: 'Koleksi'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Cari'),
          BottomNavigationBarItem(icon: Icon(Icons.bookmark_border), label: 'Bookmark'),
        ],
      ),
    );
  }

  String _getPageTitle() {
    switch (_currentIndex) {
      case 0: return 'Koleksi Hadis';
      case 1: return 'Cari Hadis';
      case 2: return _isEditMode ? 'Daftar Bookmark' : 'Bookmark';
      default: return 'Hadis';
    }
  }

  Widget _buildKoleksiTab() {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: TextField(
            onChanged: (value) => setState(() => searchQuery = value),
            decoration: InputDecoration(
              hintText: 'Cari perawi...',
              prefixIcon: const Icon(Icons.search, color: Colors.grey),
              filled: true,
              fillColor: isDarkMode ? const Color(0xFF1E1E1E) : Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(vertical: 0),
            ),
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            itemCount: narrators.length,
            itemBuilder: (context, index) {
              final narrator = narrators[index];
              if (searchQuery.isNotEmpty && !narrator['name'].toLowerCase().contains(searchQuery.toLowerCase())) {
                return const SizedBox.shrink();
              }
              return _buildNarratorCard(narrator, index + 1);
            },
          ),
        ),
        _buildBannerCard(),
      ],
    );
  }

  Widget _buildCariTab() {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final List<String> popularSearches = ['shalat', 'puasa', 'iman', 'zakat', 'sabar', 'sedekah', 'niat', 'jihad'];

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            decoration: InputDecoration(
              hintText: 'Cari hadis (Indonesia/Arab/Keyword)...',
              hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
              suffixIcon: const Icon(Icons.search, color: Colors.grey),
              filled: true,
              fillColor: isDarkMode ? const Color(0xFF1E1E1E) : Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: isDarkMode ? Colors.white10 : Colors.grey[200]!),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: isDarkMode ? Colors.white10 : Colors.grey[200]!),
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
            onSubmitted: (value) => _performSearch(value),
          ),
          const SizedBox(height: 32),
          Text(
            'Pencarian Populer',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: isDarkMode ? Colors.white : Colors.black87),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: popularSearches.map((tag) => _buildSearchTag(tag)).toList(),
          ),
          const SizedBox(height: 32),
          Text(
            'Riwayat Pencarian',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: isDarkMode ? Colors.white : Colors.black87),
          ),
          const SizedBox(height: 16),
          ..._searchHistory.map((history) => _buildHistoryItem(history)).toList(),
        ],
      ),
    );
  }

  void _performSearch(String query) {
    if (query.isNotEmpty) {
      setState(() {
        if (!_searchHistory.contains(query)) {
          _searchHistory.insert(0, query);
        }
      });
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => HadithSearchResultsPage(query: query)),
      );
    }
  }

  Widget _buildSearchTag(String tag) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return InkWell(
      onTap: () => _performSearch(tag),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isDarkMode ? const Color(0xFF1A3E35) : const Color(0xFFF0F9F6),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          tag,
          style: const TextStyle(color: Color(0xFF13A884), fontSize: 14),
        ),
      ),
    );
  }

  Widget _buildHistoryItem(String text) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Icon(Icons.history, color: Colors.grey[400], size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: InkWell(
              onTap: () => _performSearch(text),
              child: Text(
                text,
                style: TextStyle(fontSize: 14, color: isDarkMode ? Colors.white70 : Colors.black87),
              ),
            ),
          ),
          IconButton(
            icon: Icon(Icons.close, color: Colors.grey[400], size: 18),
            onPressed: () {
              setState(() {
                _searchHistory.remove(text);
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildPengaturanTab() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.settings_outlined, size: 64, color: Colors.grey[300]),
          const SizedBox(height: 16),
          Text(
            'Pengaturan Kosong',
            style: TextStyle(color: Colors.grey[400], fontSize: 16),
          ),
        ],
      ),
    );
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
            trailing: settingsProvider.fontSize == size ? const Icon(Icons.check, color: Color(0xFF13A884)) : null,
            onTap: () {
              settingsProvider.setFontSize(size);
              Navigator.pop(context);
            },
          )).toList(),
        ),
      ),
    );
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Apakah Anda yakin ingin keluar?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Batal')),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              // Implementation for logout logic
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Berhasil keluar')),
              );
            },
            child: const Text('Logout', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsItem(String title, {String? value, Widget? trailing, VoidCallback? onTap}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        margin: const EdgeInsets.only(bottom: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey[100]!),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                title,
                style: const TextStyle(fontSize: 15, color: Colors.black87),
              ),
            ),
            if (value != null)
              Text(
                value,
                style: TextStyle(fontSize: 14, color: Colors.grey[500]),
              ),
            if (trailing != null) trailing,
            if (onTap != null && trailing == null)
              Icon(Icons.chevron_right, color: Colors.grey[400], size: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildAboutItem(IconData icon, String title, String subtitle) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: const BoxDecoration(
              color: Color(0xFFF0F9F6),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: const Color(0xFF13A884), size: 20),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: const TextStyle(color: Color(0xFF13A884), fontSize: 13),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBookmarkTab() {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final bookmarks = _allBookmarks.where((item) {
      if (_activeBookmarkTab == 'Semua') return true;
      return item['type'] == _activeBookmarkTab;
    }).toList();

    return Column(
      children: [
        if (!_isEditMode)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildCategoryTab('Semua', _activeBookmarkTab == 'Semua', () => setState(() => _activeBookmarkTab = 'Semua')),
                _buildCategoryTab('Hadis', _activeBookmarkTab == 'Hadis', () => setState(() => _activeBookmarkTab = 'Hadis')),
                _buildCategoryTab('Bab', _activeBookmarkTab == 'Bab', () => setState(() => _activeBookmarkTab = 'Bab')),
              ],
            ),
          ),
        
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (_isEditMode)
                Text('${bookmarks.length} item', style: const TextStyle(color: Colors.grey))
              else
                const SizedBox.shrink(),
              TextButton(
                onPressed: () => setState(() {
                  _isEditMode = !_isEditMode;
                  if (!_isEditMode) _selectedBookmarks.clear();
                }),
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                  backgroundColor: isDarkMode ? const Color(0xFF2C2C2C) : Colors.white,
                  side: BorderSide(color: isDarkMode ? Colors.white10 : Colors.grey[200]!),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                child: Text(_isEditMode ? 'Batal' : 'Pilih', style: TextStyle(color: isDarkMode ? Colors.white : Colors.black87, fontWeight: FontWeight.w500)),
              ),
            ],
          ),
        ),

        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: bookmarks.length,
            itemBuilder: (context, index) {
              final item = bookmarks[index];
              final isSelected = _selectedBookmarks.contains(item['id']);
              
              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                decoration: BoxDecoration(
                  color: isSelected 
                      ? (isDarkMode ? Colors.grey[900] : Colors.grey[100]) 
                      : (isDarkMode ? const Color(0xFF1E1E1E) : Colors.white),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.02),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  onTap: () {
                    if (_isEditMode) {
                      setState(() {
                        if (isSelected) {
                          _selectedBookmarks.remove(item['id']);
                        } else {
                          _selectedBookmarks.add(item['id']);
                        }
                      });
                    } else {
                      if (item['type'] == 'Hadis') {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => HadithDetailPage(
                              hadith: item['hadith'],
                              narratorId: item['narratorId'],
                              narratorName: item['narrator'],
                            ),
                          ),
                        ).then((_) => setState(() {})); // Refresh when back
                      } else {
                        // Untuk tipe 'Bab'
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => HadithChaptersPage(
                              narrator: item['narratorData'],
                            ),
                          ),
                        ).then((_) => setState(() {}));
                      }
                    }
                  },
                  leading: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: const Color(0xFF0C5441),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Icons.mosque, color: Colors.white, size: 20),
                  ),
                  title: Text(
                    item['narrator'],
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: isDarkMode ? Colors.white : Colors.black87),
                  ),
                  subtitle: Text(
                    item['detail'],
                    style: TextStyle(color: isDarkMode ? Colors.grey[400] : Colors.grey[600], fontSize: 13),
                  ),
                  trailing: _isEditMode
                      ? Checkbox(
                          value: isSelected,
                          activeColor: const Color(0xFF13A884),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                          onChanged: (val) {
                            setState(() {
                              if (val == true) {
                                _selectedBookmarks.add(item['id']);
                              } else {
                                _selectedBookmarks.remove(item['id']);
                              }
                            });
                          },
                        )
                      : IconButton(
                          icon: const Icon(
                            Icons.star,
                            color: Colors.orange,
                          ),
                          onPressed: () {
                            setState(() {
                              if (item['type'] == 'Hadis') {
                                BookmarkManager().removeBookmark(item['narratorId'], number: item['hadith']['number']);
                              } else {
                                BookmarkManager().removeBookmark(item['narratorId']);
                              }
                            });
                          },
                        ),
                ),
              );
            },
          ),
        ),
        if (_isEditMode)
          Padding(
            padding: const EdgeInsets.all(24),
            child: SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () => _showDeleteDialog(context, _selectedBookmarks.length),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  side: const BorderSide(color: Colors.red, width: 1.2),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                icon: const Icon(Icons.delete_outline, color: Colors.red),
                label: Text(
                  _selectedBookmarks.isEmpty ? 'Hapus Semua' : 'Hapus Terpilih (${_selectedBookmarks.length})',
                  style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold, fontSize: 15),
                ),
              ),
            ),
          ),
      ],
    );
  }

  void _showDeleteDialog(BuildContext context, int count) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(count == 0 ? 'Hapus Semua' : 'Hapus Terpilih'),
        content: Text(count == 0 
          ? 'Apakah Anda yakin ingin menghapus semua bookmark?' 
          : 'Apakah Anda yakin ingin menghapus $count item yang dipilih?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Batal')),
          TextButton(
            onPressed: () {
              setState(() {
                final manager = BookmarkManager();
                if (count == 0) {
                  manager.clearBookmarks();
                } else {
                  final toRemove = BookmarkManager().bookmarks.where((b) => _selectedBookmarks.contains(b['id'])).toList();
                  for (var b in toRemove) {
                    if (b['type'] == 'Hadis') {
                      manager.removeBookmark(b['narratorId'], number: b['hadith']['number']);
                    } else {
                      manager.removeBookmark(b['narratorId']);
                    }
                  }
                }
                _isEditMode = false;
                _selectedBookmarks.clear();
              });
              Navigator.pop(context);
            },
            child: const Text('Hapus', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryTab(String label, bool isActive, VoidCallback onTap) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
        decoration: BoxDecoration(
          color: isActive 
              ? (isDarkMode ? const Color(0xFF1A3E35) : const Color(0xFFF0F9F6)) 
              : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isActive ? const Color(0xFF13A884) : Colors.grey[500],
            fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
            fontSize: 14,
          ),
        ),
      ),
    );
  }

  Widget _buildNarratorCard(Map<String, dynamic> narrator, int index) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: isDarkMode ? const Color(0xFF1E1E1E) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: isDarkMode ? const Color(0xFF1A3E35) : const Color(0xFFF0F9F6),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(narrator['icon'], color: const Color(0xFF13A884), size: 24),
        ),
        title: Text(
          narrator['name'],
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: isDarkMode ? Colors.white : Colors.black87),
        ),
        subtitle: Text(
          narrator['count'],
          style: TextStyle(color: isDarkMode ? Colors.grey[400] : Colors.grey[600], fontSize: 13),
        ),
        trailing: const Icon(Icons.chevron_right, color: Colors.grey, size: 20),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => HadithChaptersPage(narrator: narrator),
            ),
          );
        },
      ),
    );
  }

  Widget _buildBannerCard() {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.fromLTRB(16, 8, 16, 24),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFF0C5441),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0C5441).withOpacity(0.2),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Hadis Hari Ini',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.65,
                child: const Text(
                  'Dapatkan satu hadis setiap hari untuk tuntunan iman anda.',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                    height: 1.4,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: 140,
                height: 48,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white.withOpacity(0.1),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    side: const BorderSide(color: Colors.white30, width: 1.2),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const NotificationHadithPage()),
                    );
                  },
                  child: const Text(
                    'Lihat Hadis',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                ),
              ),
            ],
          ),
          Positioned(
            right: 0,
            bottom: 0,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 10,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: const Icon(Icons.shuffle, color: Color(0xFF0C5441), size: 30),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawer(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final primaryGreen = const Color(0xFF13A884);
    final darkGreen = const Color(0xFF0C5441);
    final settingsProvider = Provider.of<SettingsProvider>(context, listen: false);

    return Drawer(
      backgroundColor: darkGreen, // Whole drawer background is dark green
      child: Column(
        children: [
          // Drawer Header
          SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        width: 70,
                        height: 70,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(color: Colors.lightGreenAccent.withOpacity(0.5), blurRadius: 20, spreadRadius: 2)
                          ],
                        ),
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('60', style: TextStyle(color: primaryGreen, fontWeight: FontWeight.bold, fontSize: 18)),
                              Icon(Icons.menu_book, color: primaryGreen, size: 20),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Aplikasi Hadis Digital', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                            const SizedBox(height: 4),
                            const Text('Belajar, Pahami, Amalkan ✨', style: TextStyle(color: Colors.white70, fontSize: 11)),
                            const SizedBox(height: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: primaryGreen,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Text('v1.0.0', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  // Row for Toggles
                  IntrinsicHeight(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.white24),
                            ),
                            child: Row(
                              children: [
                                Icon(isDarkMode ? Icons.nightlight_round : Icons.wb_sunny, color: Colors.amber, size: 18),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Text('Mode Terang', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                                      Text(isDarkMode ? 'Nonaktif' : 'Aktif', style: const TextStyle(color: Colors.white70, fontSize: 8)),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 20,
                                  width: 30,
                                  child: Transform.scale(
                                    scale: 0.7,
                                    child: Switch(
                                      value: !isDarkMode,
                                      activeColor: Colors.white,
                                      activeTrackColor: primaryGreen,
                                      padding: EdgeInsets.zero,
                                      onChanged: (val) {
                                        if (isDarkMode) {
                                          settingsProvider.setThemeModeStr('Hijau');
                                        } else {
                                          settingsProvider.setThemeModeStr('Gelap');
                                        }
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: InkWell(
                            onTap: () => _showTextSizeDialog(settingsProvider),
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: Colors.white24),
                              ),
                              child: Row(
                                children: [
                                  const Text('Aa', style: TextStyle(color: Colors.lightGreenAccent, fontSize: 16, fontWeight: FontWeight.bold)),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        const Text('Ukuran Font', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                                        Text('${settingsProvider.fontSize} (${settingsProvider.fontSize == 'Kecil' ? '85%' : settingsProvider.fontSize == 'Besar' ? '120%' : '100%'})', style: const TextStyle(color: Colors.white70, fontSize: 8)),
                                      ],
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
              ),
            ),
          ),
          // Drawer Menu List in white container
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: isDarkMode ? const Color(0xFF1E1E1E) : Colors.white,
                borderRadius: const BorderRadius.only(topLeft: Radius.circular(24), topRight: Radius.circular(24)),
              ),
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                children: [
                  _buildDrawerItem(Icons.home, 'Beranda', () {
                    Navigator.pop(context);
                    Navigator.popUntil(context, (route) => route.isFirst);
                  }, isActive: true),
                  _buildDrawerItem(Icons.grid_view_rounded, 'Koleksi', () {
                    Navigator.pop(context);
                    setState(() => _currentIndex = 0);
                  }),
                  _buildDrawerItem(Icons.search, 'Cari', () {
                    Navigator.pop(context);
                    setState(() => _currentIndex = 1);
                  }),
                  _buildDrawerItem(Icons.bookmark_border, 'Bookmark', () {
                    Navigator.pop(context);
                    setState(() => _currentIndex = 2);
                  }),
                  
                  Divider(height: 32, indent: 16, endIndent: 16, color: isDarkMode ? Colors.white10 : Colors.grey[200]),
                  
                  _buildDrawerItem(Icons.info_outline, 'Tentang Aplikasi', () {
                    Navigator.pop(context);
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const AboutAppPage()));
                  }),
                  _buildDrawerItem(Icons.help_outline, 'Bantuan', () async {
                    Navigator.pop(context);
                    final Uri url = Uri.parse('https://hadits.in/panduan');
                    if (!await launchUrl(url)) {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Tidak dapat membuka panduan')));
                    }
                  }),
                  
                  Divider(height: 32, indent: 16, endIndent: 16, color: isDarkMode ? Colors.white10 : Colors.grey[200]),
                  
                  _buildExitDrawerItem(context),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showExitDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Keluar Halaman'),
        content: const Text('Apakah Anda yakin ingin keluar dari halaman?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Batal')),
          TextButton(
            onPressed: () {
              // Menutup dialog dan kembali ke halaman utama (Beranda)
              Navigator.of(context).popUntil((route) => route.isFirst);
            },
            child: const Text('Keluar', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerItem(IconData icon, String title, VoidCallback onTap, {bool isActive = false}) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final primaryGreen = const Color(0xFF13A884);
    final bgColor = isActive ? primaryGreen.withOpacity(0.1) : Colors.transparent;
    final textColor = isActive ? primaryGreen : (isDarkMode ? Colors.white70 : Colors.black87);
    final iconColor = isActive ? primaryGreen : (isDarkMode ? Colors.grey[400] : Colors.grey[700]);

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Stack(
        children: [
          if (isActive)
            Positioned(
              left: 0,
              top: 8,
              bottom: 8,
              child: Container(width: 4, decoration: BoxDecoration(color: primaryGreen, borderRadius: BorderRadius.circular(4))),
            ),
          ListTile(
            leading: Icon(icon, color: iconColor, size: 24),
            title: Text(title, style: TextStyle(color: textColor, fontSize: 15, fontWeight: isActive ? FontWeight.bold : FontWeight.w500)),
            trailing: Icon(Icons.chevron_right, color: isDarkMode ? Colors.white24 : Colors.grey[300], size: 20),
            onTap: onTap,
            contentPadding: const EdgeInsets.symmetric(horizontal: 20),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ],
      ),
    );
  }

  Widget _buildExitDrawerItem(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.red.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(color: Colors.red.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
          child: const Icon(Icons.logout, color: Colors.red, size: 20),
        ),
        title: const Text('Keluar', style: TextStyle(color: Colors.red, fontSize: 15, fontWeight: FontWeight.bold)),
        trailing: const Icon(Icons.chevron_right, color: Colors.red, size: 20),
        onTap: () {
          Navigator.pop(context);
          _showExitDialog(context);
        },
        contentPadding: const EdgeInsets.symmetric(horizontal: 20),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}
