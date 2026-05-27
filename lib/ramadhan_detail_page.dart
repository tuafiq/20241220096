import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class RamadhanDetailPage extends StatefulWidget {
  final List<Map<String, dynamic>> menuList;
  final int initialIndex;

  const RamadhanDetailPage({
    Key? key,
    required this.menuList,
    required this.initialIndex,
  }) : super(key: key);

  @override
  State<RamadhanDetailPage> createState() => _RamadhanDetailPageState();
}

class _RamadhanDetailPageState extends State<RamadhanDetailPage> {
  static const Color primaryTeal = Color(0xFF0C5441);
  static const Color accentTeal = Color(0xFF13A884);
  double _fontSizeMultiplier = 1.0;
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
  }

  void _nextItem() {
    if (_currentIndex < widget.menuList.length - 1) {
      setState(() {
        _currentIndex++;
      });
    }
  }

  void _previousItem() {
    if (_currentIndex > 0) {
      setState(() {
        _currentIndex--;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentMenu = widget.menuList[_currentIndex];
    final total = widget.menuList.length;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      backgroundColor: isDarkMode ? const Color(0xFF121212) : Colors.white,
      appBar: AppBar(
        backgroundColor: primaryTeal,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline, color: Colors.white),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.bookmark_border, color: Colors.white),
            onPressed: () {},
          ),
          IconButton(
            icon: const Text('aA', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
            onPressed: () {
              setState(() {
                if (_fontSizeMultiplier < 1.5) {
                  _fontSizeMultiplier += 0.25;
                } else {
                  _fontSizeMultiplier = 1.0;
                }
              });
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Header Section (1/17 and Title)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
            decoration: BoxDecoration(
              color: isDarkMode ? const Color(0xFF1E1E1E) : Colors.white,
              border: Border(bottom: BorderSide(color: isDarkMode ? Colors.white10 : Colors.black12)),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back_ios, size: 16, color: primaryTeal),
                      onPressed: _currentIndex > 0 ? _previousItem : null,
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                    Text(
                      '${_currentIndex + 1}/$total',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: isDarkMode ? Colors.white70 : Colors.black87,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.arrow_forward_ios, size: 16, color: primaryTeal),
                      onPressed: _currentIndex < total - 1 ? _nextItem : null,
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  currentMenu['title']!,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: isDarkMode ? Colors.white : Colors.black,
                  ),
                ),
              ],
            ),
          ),
          
          // Content Section
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (currentMenu.containsKey('sections') && currentMenu['sections'] != null)
                    ...List.generate(currentMenu['sections'].length, (index) {
                      final section = currentMenu['sections'][index];
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          if (index > 0)
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              child: Divider(color: isDarkMode ? Colors.white10 : Colors.black12, height: 1),
                            ),
                          Text(
                            section['subtitle'] ?? '',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: isDarkMode ? Colors.orange[300]! : const Color(0xFF8D6E63), // Brownish color as in image
                            ),
                          ),
                          const SizedBox(height: 16),
                          if (section['arabic']?.isNotEmpty == true) ...[
                            Text(
                              section['arabic'],
                              textAlign: TextAlign.right,
                              textDirection: TextDirection.rtl,
                              style: GoogleFonts.amiri(
                                fontSize: 26 * _fontSizeMultiplier,
                                height: 2.0,
                                fontWeight: FontWeight.bold,
                                color: isDarkMode ? const Color(0xFFE0E0E0) : Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 24),
                          ],
                          if (section['latin']?.isNotEmpty == true) ...[
                            Text(
                              section['latin'],
                              style: TextStyle(
                                fontSize: 14 * _fontSizeMultiplier,
                                color: isDarkMode ? accentTeal : primaryTeal,
                                height: 1.5,
                              ),
                            ),
                            const SizedBox(height: 20),
                          ],
                          if (section['translation']?.isNotEmpty == true) ...[
                            Text(
                              section['translation'],
                              style: TextStyle(
                                fontSize: 14 * _fontSizeMultiplier,
                                color: isDarkMode ? Colors.white70 : Colors.grey.shade800,
                                height: 1.5,
                              ),
                            ),
                          ],
                        ],
                      );
                    })
                  else ...[
                    if (currentMenu['arabic']?.isNotEmpty == true) ...[
                      Text(
                        currentMenu['arabic'],
                        textAlign: TextAlign.right,
                        textDirection: TextDirection.rtl,
                        style: GoogleFonts.amiri(
                          fontSize: 26 * _fontSizeMultiplier,
                          height: 2.0,
                          fontWeight: FontWeight.bold,
                          color: isDarkMode ? const Color(0xFFE0E0E0) : Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 24),
                    ],
                    if (currentMenu['latin']?.isNotEmpty == true) ...[
                      Text(
                        currentMenu['latin'],
                        style: TextStyle(
                          fontSize: 14 * _fontSizeMultiplier,
                          color: isDarkMode ? accentTeal : primaryTeal,
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                    if (currentMenu['translation']?.isNotEmpty == true) ...[
                      Text(
                        currentMenu['translation'],
                        style: TextStyle(
                          fontSize: 14 * _fontSizeMultiplier,
                          color: isDarkMode ? Colors.white70 : Colors.grey.shade800,
                          height: 1.5,
                        ),
                      ),
                    ],
                  ],
                ],
              ),
            ),
          ),

        ],
      ),
    );
  }
}
