import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class KitabPage extends StatefulWidget {
  const KitabPage({super.key});

  @override
  State<KitabPage> createState() => _KitabPageState();
}

class _KitabPageState extends State<KitabPage> {
  bool _isEditing = false;
  bool _isLoading = true;

  // Struktur data kitab default
  List<Map<String, dynamic>> _sections = [
    {
      'title': 'Sifir',
      'icon': Icons.menu_book.codePoint,
      'color': 0xFF13A884, // primaryGreen
      'items': [
        {'time': "Kelas A", 'desc': "Tempat teks kitab apa aja"},
        {'time': "Kelas B", 'desc': "Tempat teks kitab apa aja"},
      ]
    },
    {
      'title': 'Ibtidaiyah',
      'icon': Icons.auto_stories.codePoint,
      'color': 0xFF2196F3, // Colors.blue
      'items': [
        {'time': "Kelas 1", 'desc': "Tempat teks kitab apa aja"},
        {'time': "Kelas 2", 'desc': "Tempat teks kitab apa aja"},
        {'time': "Kelas 3", 'desc': "Tempat teks kitab apa aja"},
        {'time': "Kelas 5", 'desc': "Tempat teks kitab apa aja"},
        {'time': "Kelas 6", 'desc': "Tempat teks kitab apa aja"},
      ]
    },
    {
      'title': 'Tsanawiyah',
      'icon': Icons.library_books.codePoint,
      'color': 0xFFFF9800, // Colors.orange
      'items': [
        {'time': "Kelas 1", 'desc': "Tempat teks kitab apa aja"},
        {'time': "Kelas 2", 'desc': "Tempat teks kitab apa aja"},
        {'time': "Kelas 3", 'desc': "Tempat teks kitab apa aja"},
      ]
    },
    {
      'title': 'Aliyah',
      'icon': Icons.school.codePoint,
      'color': 0xFF9C27B0, // Colors.purple
      'items': [
        {'time': "Kelas 1", 'desc': "Tempat teks kitab apa aja"},
        {'time': "Kelas 2", 'desc': "Tempat teks kitab apa aja"},
      ]
    }
  ];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final prefs = await SharedPreferences.getInstance();
    final String? savedData = prefs.getString('kitab_data_v2');
    if (savedData != null) {
      try {
        final List<dynamic> decoded = jsonDecode(savedData);
        setState(() {
          _sections = decoded.map((e) => Map<String, dynamic>.from(e)).toList();
        });
      } catch (e) {
        // Fallback to default if error
      }
    }
    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _saveData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('kitab_data_v2', jsonEncode(_sections));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Data kitab berhasil disimpan')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final primaryGreen = const Color(0xFF13A884);
    final bgColor = isDarkMode ? const Color(0xFF121212) : Colors.grey[50];
    final cardColor = isDarkMode ? const Color(0xFF1E1E1E) : Colors.white;
    final textColor = isDarkMode ? Colors.white : const Color(0xFF2D3436);
    final subtitleColor = isDarkMode ? Colors.white70 : Colors.grey.shade600;

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: primaryGreen,
        title: Text(
          _isEditing ? 'Edit Kitab' : 'Kitab yang Dipelajari',
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 18),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(_isEditing ? Icons.check : Icons.edit),
            tooltip: _isEditing ? 'Simpan' : 'Edit Data',
            onPressed: () {
              setState(() {
                if (_isEditing) {
                  _saveData();
                }
                _isEditing = !_isEditing;
              });
            },
          )
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  for (int sIndex = 0; sIndex < _sections.length; sIndex++) ...[
                    _buildSectionTitle(_sections[sIndex], textColor),
                    const SizedBox(height: 12),
                    _buildKitabCard(
                      sectionIndex: sIndex,
                      sectionData: _sections[sIndex],
                      cardColor: cardColor,
                      textColor: textColor,
                      subtitleColor: subtitleColor,
                    ),
                    const SizedBox(height: 24),
                  ]
                ],
              ),
            ),
    );
  }

  Widget _buildSectionTitle(Map<String, dynamic> section, Color textColor) {
    final iconColor = Color(section['color'] as int);
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: iconColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(IconData(section['icon'] as int, fontFamily: 'MaterialIcons'), color: iconColor, size: 20),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            section['title'],
            style: GoogleFonts.poppins(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildKitabCard({
    required int sectionIndex,
    required Map<String, dynamic> sectionData,
    required Color cardColor,
    required Color textColor,
    required Color subtitleColor,
  }) {
    final items = List<Map<String, dynamic>>.from(sectionData['items']);
    final iconColor = Color(sectionData['color'] as int);

    return Container(
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          for (int i = 0; i < items.length; i++) ...[
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: _isEditing
                  ? _buildEditRow(sectionIndex, i, items[i], iconColor, textColor)
                  : _buildDisplayRow(items[i], iconColor, textColor, subtitleColor),
            ),
            if (i < items.length - 1 || _isEditing)
              Divider(height: 1, color: subtitleColor.withOpacity(0.1), indent: 16, endIndent: 16),
          ],
          if (_isEditing)
            InkWell(
              onTap: () {
                setState(() {
                  _sections[sectionIndex]['items'].add({'time': '', 'desc': ''});
                });
              },
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.add_circle_outline, color: iconColor, size: 20),
                    const SizedBox(width: 8),
                    Text(
                      'Tambah Kelas/Kitab',
                      style: GoogleFonts.poppins(color: iconColor, fontWeight: FontWeight.bold, fontSize: 13),
                    )
                  ],
                ),
              ),
            )
        ],
      ),
    );
  }

  Widget _buildDisplayRow(Map<String, dynamic> item, Color iconColor, Color textColor, Color subtitleColor) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 90,
          padding: const EdgeInsets.only(top: 2),
          child: Text(
            item['time'] ?? '',
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.bold,
              color: iconColor,
              fontSize: 12,
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            item['desc'] ?? '',
            style: GoogleFonts.poppins(
              color: textColor,
              fontSize: 12,
              height: 1.4,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildEditRow(int sectionIndex, int itemIndex, Map<String, dynamic> item, Color iconColor, Color textColor) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 2,
          child: TextFormField(
            initialValue: item['time'],
            style: GoogleFonts.poppins(color: iconColor, fontSize: 12, fontWeight: FontWeight.bold),
            decoration: InputDecoration(
              hintText: 'Kelas',
              hintStyle: TextStyle(color: iconColor.withOpacity(0.5)),
              isDense: true,
              contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            ),
            onChanged: (val) {
              _sections[sectionIndex]['items'][itemIndex]['time'] = val;
            },
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          flex: 4,
          child: TextFormField(
            initialValue: item['desc'],
            style: GoogleFonts.poppins(color: textColor, fontSize: 12),
            maxLines: null,
            decoration: InputDecoration(
              hintText: 'Nama Kitab',
              hintStyle: TextStyle(color: textColor.withOpacity(0.3)),
              isDense: true,
              contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            ),
            onChanged: (val) {
              _sections[sectionIndex]['items'][itemIndex]['desc'] = val;
            },
          ),
        ),
        IconButton(
          icon: const Icon(Icons.delete_outline, color: Colors.red, size: 20),
          onPressed: () {
            setState(() {
              _sections[sectionIndex]['items'].removeAt(itemIndex);
            });
          },
        )
      ],
    );
  }
}
