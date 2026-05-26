import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'settings_provider.dart';

class HalamanAlFatihahPage extends StatelessWidget {
  const HalamanAlFatihahPage({super.key});

  final List<String> _options = const [
    'Halaman 0',
    'Halaman 1',
    'Halaman 2',
  ];

  @override
  Widget build(BuildContext context) {
    final settings = Provider.of<SettingsProvider>(context);
    final isDarkMode = settings.themeModeStr == 'Gelap';

    return Scaffold(
      backgroundColor: isDarkMode ? const Color(0xFF121212) : Colors.white,
      appBar: AppBar(
        title: Text(
          'Halaman Surah Al-Fatihah',
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
      body: ListView.separated(
        padding: const EdgeInsets.only(top: 8),
        itemCount: _options.length,
        separatorBuilder: (context, index) => Divider(
          height: 1,
          thickness: 1,
          color: isDarkMode ? Colors.white10 : Colors.grey.shade200,
          indent: 16,
          endIndent: 16,
        ),
        itemBuilder: (context, index) {
          final option = _options[index];
          final isSelected = settings.halamanPermulaanAlFatihah == option;
          
          return InkWell(
            onTap: () {
              settings.setHalamanPermulaanAlFatihah(option);
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    option,
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: isDarkMode ? Colors.white : Colors.black87,
                    ),
                  ),
                  _buildRadio(isSelected),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildRadio(bool isSelected) {
    return Container(
      width: 20,
      height: 20,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: isSelected ? const Color(0xFF13A884) : Colors.grey.shade600,
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
    );
  }
}
