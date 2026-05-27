import 'package:flutter/material.dart';
import 'hadith_list_page.dart';
import 'hadith_service.dart';

class HadithChaptersPage extends StatefulWidget {
  final Map<String, dynamic> narrator;

  const HadithChaptersPage({super.key, required this.narrator});

  @override
  State<HadithChaptersPage> createState() => _HadithChaptersPageState();
}

class _HadithChaptersPageState extends State<HadithChaptersPage> {
  // Mock chapters based on the screenshot
  final List<Map<String, dynamic>> chapters = [
    {'id': 1, 'name': 'Kitab Ilmu', 'count': '112 Hadis'},
    {'id': 2, 'name': 'Kitab Iman', 'count': '144 Hadis'},
    {'id': 3, 'name': 'Kitab Thaharah', 'count': '184 Hadis'},
    {'id': 4, 'name': 'Kitab Shalat', 'count': '412 Hadis'},
    {'id': 5, 'name': 'Kitab Jumu\'ah', 'count': '56 Hadis'},
    {'id': 6, 'name': 'Kitab Zakat', 'count': '127 Hadis'},
    {'id': 7, 'name': 'Kitab Puasa', 'count': '159 Hadis'},
    {'id': 8, 'name': 'Kitab Haji', 'count': '98 Hadis'},
  ];

  bool _isBookmarked = false;

  @override
  void initState() {
    super.initState();
    _isBookmarked = BookmarkManager().isBabBookmarked(widget.narrator['id']);
  }

  void _toggleBookmark() {
    setState(() {
      if (_isBookmarked) {
        BookmarkManager().removeBookmark(widget.narrator['id']);
      } else {
        BookmarkManager().addBabBookmark(widget.narrator);
      }
      _isBookmarked = !_isBookmarked;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(_isBookmarked ? 'Bab disimpan ke bookmark' : 'Bab dihapus dari bookmark'),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const primaryGreen = Color(0xFF13A884);
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDarkMode ? const Color(0xFF121212) : const Color(0xFFF9F9F9),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0C5441),
        title: Text(widget.narrator['name'], style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: Icon(_isBookmarked ? Icons.bookmark : Icons.bookmark_border, color: _isBookmarked ? Colors.orange : Colors.white), 
            onPressed: _toggleBookmark
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Narrator Info Header (Screen 2)
            Container(
              padding: const EdgeInsets.all(24),
              color: isDarkMode ? const Color(0xFF1E1E1E) : Colors.white,
              child: Column(
                children: [
                  Row(
                    children: [
                      Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          color: const Color(0xFF0C5441),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(widget.narrator['icon'], color: Colors.white, size: 30),
                      ),
                      const SizedBox(width: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.narrator['name'],
                            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: isDarkMode ? Colors.white : Colors.black87),
                          ),
                          Text(
                            widget.narrator['count'],
                            style: TextStyle(color: isDarkMode ? Colors.grey[400] : Colors.grey[600], fontSize: 14),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Salah satu kitab hadis Sittah yang disusun oleh imam ${widget.narrator['name'].split(' ').last} rahimahullah.',
                    style: TextStyle(color: isDarkMode ? Colors.grey[400] : Colors.grey[600], fontSize: 13, height: 1.5),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 8),
            
            // Chapters List
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.all(16),
              itemCount: chapters.length,
              itemBuilder: (context, index) {
                final chapter = chapters[index];
                return _buildChapterCard(context, chapter);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChapterCard(BuildContext context, Map<String, dynamic> chapter) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: isDarkMode ? const Color(0xFF1E1E1E) : Colors.white,
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
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: const Color(0xFF13A884),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Center(
            child: Text(
              '${chapter['id']}',
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
        ),
        title: Text(
          chapter['name'],
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: isDarkMode ? Colors.white : Colors.black87),
        ),
        subtitle: Text(
          chapter['count'],
          style: TextStyle(color: isDarkMode ? Colors.grey[400] : Colors.grey[600], fontSize: 13),
        ),
        trailing: const Icon(Icons.chevron_right, color: Colors.grey, size: 20),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => HadithListPage(
                narratorId: widget.narrator['id'],
                narratorName: chapter['name'],
              ),
            ),
          );
        },
      ),
    );
  }
}
