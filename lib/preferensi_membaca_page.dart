import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'settings_provider.dart';
import 'language_selection_page.dart';

class PreferensiMembacaPage extends StatelessWidget {
  const PreferensiMembacaPage({super.key});

  @override
  Widget build(BuildContext context) {
    final settings = Provider.of<SettingsProvider>(context);
    final isDarkMode = settings.themeModeStr == 'Gelap';

    return Scaffold(
      backgroundColor: isDarkMode ? const Color(0xFF121212) : const Color(0xFFF5F7F8),
      appBar: AppBar(
        title: Text(
          settings.translate('reading_preferences'),
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
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        children: [
          // 1. Ukuran Teks Arab Card
          _buildArabSizeCard(settings, isDarkMode),
          const SizedBox(height: 16),

          // 2. Ukuran Teks Latin Card
          _buildLatinSizeCard(settings, isDarkMode),
          const SizedBox(height: 16),

          // 3. Aktifkan Teks Card
          _buildAktifkanTeksCard(settings, isDarkMode),
          const SizedBox(height: 16),

          // 4. Bahasa Terjemah Al Quran Card
          _buildBahasaTerjemahCard(context, settings, isDarkMode),
          const SizedBox(height: 16),

          // 5. Tampilan Layar ketika Membaca Card
          _buildTampilanLayarCard(settings, isDarkMode),
        ],
      ),
    );
  }

  Widget _buildCardContainer({required Widget child, required bool isDarkMode}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDarkMode ? const Color(0xFF1E1E1E) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDarkMode ? 0.15 : 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: child,
    );
  }

  Widget _buildSectionTitle(String title, bool isDarkMode) {
    return Text(
      title,
      style: GoogleFonts.poppins(
        fontSize: 13,
        fontWeight: FontWeight.bold,
        color: isDarkMode ? Colors.white : const Color(0xFF2D3748),
      ),
    );
  }

  Widget _buildArabSizeCard(SettingsProvider settings, bool isDarkMode) {
    return _buildCardContainer(
      isDarkMode: isDarkMode,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle(settings.translate('arabic_text_size'), isDarkMode),
          const SizedBox(height: 12),
          Row(
            children: [
              GestureDetector(
                onTap: () {
                  settings.setArabFontSize((settings.arabFontSize - 1.0).clamp(18.0, 40.0));
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  child: Text(
                    '—',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: isDarkMode ? Colors.white54 : Colors.black54,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: SliderTheme(
                  data: SliderThemeData(
                    activeTrackColor: const Color(0xFF13A884),
                    inactiveTrackColor: isDarkMode ? Colors.grey[800] : Colors.grey[200],
                    thumbColor: Colors.white,
                    trackHeight: 3.0,
                  ),
                  child: Slider(
                    min: 18.0,
                    max: 40.0,
                    value: settings.arabFontSize,
                    onChanged: (val) {
                      settings.setArabFontSize(val);
                    },
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  settings.setArabFontSize((settings.arabFontSize + 1.0).clamp(18.0, 40.0));
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  child: Text(
                    '+',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: isDarkMode ? Colors.white54 : Colors.black54,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            width: double.infinity,
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Text(
              'بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ',
              style: GoogleFonts.scheherazadeNew(
                fontSize: settings.arabFontSize,
                fontWeight: FontWeight.bold,
                color: isDarkMode ? Colors.white : const Color(0xFF0C5441),
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLatinSizeCard(SettingsProvider settings, bool isDarkMode) {
    return _buildCardContainer(
      isDarkMode: isDarkMode,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle(settings.translate('latin_text_size'), isDarkMode),
          const SizedBox(height: 12),
          Row(
            children: [
              GestureDetector(
                onTap: () {
                  settings.setLatinFontSize((settings.latinFontSize - 1.0).clamp(10.0, 24.0));
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  child: Text(
                    '—',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: isDarkMode ? Colors.white54 : Colors.black54,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: SliderTheme(
                  data: SliderThemeData(
                    activeTrackColor: const Color(0xFF13A884),
                    inactiveTrackColor: isDarkMode ? Colors.grey[800] : Colors.grey[200],
                    thumbColor: Colors.white,
                    trackHeight: 3.0,
                  ),
                  child: Slider(
                    min: 10.0,
                    max: 24.0,
                    value: settings.latinFontSize,
                    onChanged: (val) {
                      settings.setLatinFontSize(val);
                    },
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  settings.setLatinFontSize((settings.latinFontSize + 1.0).clamp(10.0, 24.0));
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  child: Text(
                    '+',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: isDarkMode ? Colors.white54 : Colors.black54,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            width: double.infinity,
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Text(
              'Bismillâhirrahmânirrahîm',
              style: GoogleFonts.poppins(
                fontSize: settings.latinFontSize,
                fontStyle: FontStyle.italic,
                color: const Color(0xFF13A884),
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAktifkanTeksCard(SettingsProvider settings, bool isDarkMode) {
    return _buildCardContainer(
      isDarkMode: isDarkMode,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle(settings.translate('activate_text'), isDarkMode),
          const SizedBox(height: 8),
          ListTile(
            contentPadding: EdgeInsets.zero,
            title: Text(
              settings.translate('transliteration_latin'),
              style: GoogleFonts.poppins(
                fontSize: 13,
                color: isDarkMode ? Colors.white : const Color(0xFF2D3748),
              ),
            ),
            trailing: Switch(
              value: settings.showTransliterasi,
              activeColor: const Color(0xFF13A884),
              onChanged: (val) {
                settings.setShowTransliterasi(val);
              },
            ),
            onTap: () {
              settings.setShowTransliterasi(!settings.showTransliterasi);
            },
          ),
          Divider(height: 1, color: isDarkMode ? Colors.white12 : Colors.grey[200]),
          ListTile(
            contentPadding: EdgeInsets.zero,
            title: Text(
              settings.translate('translation'),
              style: GoogleFonts.poppins(
                fontSize: 13,
                color: isDarkMode ? Colors.white : const Color(0xFF2D3748),
              ),
            ),
            trailing: Switch(
              value: settings.showTerjemah,
              activeColor: const Color(0xFF13A884),
              onChanged: (val) {
                settings.setShowTerjemah(val);
              },
            ),
            onTap: () {
              settings.setShowTerjemah(!settings.showTerjemah);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildBahasaTerjemahCard(BuildContext context, SettingsProvider settings, bool isDarkMode) {
    return _buildCardContainer(
      isDarkMode: isDarkMode,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle(settings.translate('translation_language'), isDarkMode),
          const SizedBox(height: 8),
          ListTile(
            contentPadding: EdgeInsets.zero,
            title: Text(
              settings.translate('choose_language'),
              style: GoogleFonts.poppins(
                fontSize: 13,
                color: isDarkMode ? Colors.white : const Color(0xFF2D3748),
              ),
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  settings.language == 'Inggris' ? 'English' : (settings.language == 'Arab' ? 'العربية' : 'Bahasa Indonesia'),
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: isDarkMode ? Colors.white60 : Colors.grey[500],
                  ),
                ),
                const SizedBox(width: 8),
                Icon(
                  Icons.arrow_forward_ios,
                  size: 14,
                  color: isDarkMode ? Colors.white30 : Colors.grey[400],
                ),
              ],
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const LanguageSelectionPage()),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildTampilanLayarCard(SettingsProvider settings, bool isDarkMode) {
    return _buildCardContainer(
      isDarkMode: isDarkMode,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle(settings.translate('screen_display_reading'), isDarkMode),
          const SizedBox(height: 8),
          ListTile(
            contentPadding: EdgeInsets.zero,
            title: Text(
              settings.translate('screen_keep_on'),
              style: GoogleFonts.poppins(
                fontSize: 13,
                color: isDarkMode ? Colors.white : const Color(0xFF2D3748),
              ),
            ),
            subtitle: Text(
              settings.translate('screen_keep_on_desc'),
              style: GoogleFonts.poppins(
                fontSize: 10,
                color: isDarkMode ? Colors.white54 : Colors.grey[500],
              ),
            ),
            trailing: Switch(
              value: settings.layarTetapAktif,
              activeColor: const Color(0xFF13A884),
              onChanged: (val) {
                settings.setLayarTetapAktif(val);
              },
            ),
            onTap: () {
              settings.setLayarTetapAktif(!settings.layarTetapAktif);
            },
          ),
        ],
      ),
    );
  }
}
