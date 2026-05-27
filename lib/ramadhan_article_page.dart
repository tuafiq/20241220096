import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class RamadhanArticlePage extends StatelessWidget {
  final Map<String, dynamic> article;

  const RamadhanArticlePage({super.key, required this.article});

  static const Color primaryTeal = Color(0xFF0C5441);
  static const Color accentTeal = Color(0xFF13A884);
  static const Color lightTeal = Color(0xFFE8F5F1);

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      backgroundColor: isDarkMode ? const Color(0xFF121212) : Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: isDarkMode ? const Color(0xFF1E1E1E) : Colors.white,
        foregroundColor: isDarkMode ? accentTeal : primaryTeal,
        title: Text(
          'Artikel Ramadhan',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            fontSize: 16,
            color: isDarkMode ? Colors.white : primaryTeal,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Section
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
              decoration: BoxDecoration(
                color: isDarkMode ? primaryTeal.withOpacity(0.15) : primaryTeal.withOpacity(0.05),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(32),
                  bottomRight: Radius.circular(32),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: accentTeal.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      'Fikih Ramadhan',
                      style: TextStyle(
                        color: accentTeal,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    article['title'] ?? '',
                    style: GoogleFonts.poppins(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: isDarkMode ? accentTeal : primaryTeal,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Icon(Icons.calendar_today_outlined, size: 14, color: isDarkMode ? Colors.grey.shade400 : Colors.grey.shade600),
                      const SizedBox(width: 6),
                      Text(
                        article['date'] ?? '12 Ramadhan 1445 H',
                        style: TextStyle(
                          fontSize: 12,
                          color: isDarkMode ? Colors.grey[400] : Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Content Section
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: (article['sections'] as List<dynamic>?)?.map<Widget>((section) {
                  if (section['type'] == 'text') {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: Text(
                        section['content'] ?? '',
                        style: GoogleFonts.lora(
                          fontSize: 16,
                          color: isDarkMode ? Colors.white70 : Colors.black87,
                          height: 1.8,
                        ),
                      ),
                    );
                  } else if (section['type'] == 'arabic') {
                    return Container(
                      width: double.infinity,
                      margin: const EdgeInsets.only(bottom: 16),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: isDarkMode ? const Color(0xFF1A3E35) : lightTeal,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: primaryTeal.withOpacity(0.1)),
                      ),
                      child: Column(
                        children: [
                          Text(
                            section['content'] ?? '',
                            textAlign: TextAlign.center,
                            textDirection: TextDirection.rtl,
                            style: TextStyle(
                              fontFamily: 'LPMQIsepMisbah',
                              fontSize: 24,
                              color: isDarkMode ? Colors.white : primaryTeal,
                              height: 2.0,
                            ),
                          ),
                          const SizedBox(height: 12),
                          if (section['latin'] != null) ...[
                            Text(
                              section['latin'] ?? '',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.poppins(
                                fontSize: 13,
                                color: isDarkMode ? accentTeal : primaryTeal,
                                fontStyle: FontStyle.italic,
                                fontWeight: FontWeight.w500,
                                height: 1.5,
                              ),
                            ),
                            const SizedBox(height: 8),
                          ],
                          Text(
                            section['translation'] ?? '',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.poppins(
                              fontSize: 13,
                              color: isDarkMode ? Colors.white60 : Colors.black54,
                              fontStyle: FontStyle.italic,
                              height: 1.5,
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                  return const SizedBox.shrink();
                }).toList() ?? [
                  Text(
                    article['content'] ?? '',
                    style: GoogleFonts.lora(
                      fontSize: 16,
                      color: isDarkMode ? Colors.white70 : Colors.black87,
                      height: 1.8,
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
