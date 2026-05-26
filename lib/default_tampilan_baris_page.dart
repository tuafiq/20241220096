import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'settings_provider.dart';

class DefaultTampilanBarisPage extends StatelessWidget {
  const DefaultTampilanBarisPage({super.key});

  @override
  Widget build(BuildContext context) {
    final settings = Provider.of<SettingsProvider>(context);
    final isDarkMode = settings.themeModeStr == 'Gelap';

    return Scaffold(
      backgroundColor: isDarkMode ? const Color(0xFF121212) : Colors.white,
      appBar: AppBar(
        title: Text(
          'Default Tampilan Baris',
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
        backgroundColor: const Color(0xFF13A884),
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
        centerTitle: false,
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 8),
        children: [
          _buildOptionRow('Mode Surah', 'Mode Surah', settings, isDarkMode),
          Divider(height: 1, thickness: 1, color: isDarkMode ? Colors.white10 : Colors.grey.shade200),
          _buildOptionRow('Mode Juz', 'Mode Juz', settings, isDarkMode),
          Divider(height: 1, thickness: 1, color: isDarkMode ? Colors.white10 : Colors.grey.shade200),
          _buildOptionRow('Selalu Tanya', 'Selalu Tanya', settings, isDarkMode),
          Divider(height: 1, thickness: 1, color: isDarkMode ? Colors.white10 : Colors.grey.shade200),
        ],
      ),
    );
  }

  Widget _buildOptionRow(String title, String valueKey, SettingsProvider settings, bool isDarkMode) {
    final isSelected = settings.halamanPermulaanAlFatihah == valueKey;
    return InkWell(
      onTap: () {
        settings.setHalamanPermulaanAlFatihah(valueKey);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: isSelected ? FontWeight.w500 : FontWeight.w400,
                color: isSelected
                    ? const Color(0xFF0C5441)
                    : (isDarkMode ? Colors.white70 : Colors.black87),
              ),
            ),
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? const Color(0xFF13A884) : Colors.grey.shade400,
                  width: 2,
                ),
              ),
              child: isSelected
                  ? Center(
                      child: Container(
                        width: 10,
                        height: 10,
                        decoration: const BoxDecoration(
                          color: Color(0xFF13A884),
                          shape: BoxShape.circle,
                        ),
                      ),
                    )
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}
