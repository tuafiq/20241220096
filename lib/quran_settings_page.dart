import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'settings_provider.dart';

class QuranSettingsPage extends StatefulWidget {
  const QuranSettingsPage({super.key});

  @override
  State<QuranSettingsPage> createState() => _QuranSettingsPageState();
}

class _QuranSettingsPageState extends State<QuranSettingsPage> {
  // Available Reciters list
  final List<Map<String, String>> _qoriList = [
    {'name': 'Al-Husary', 'id': '05'},
    {'name': 'Abdullah Al-Juhany', 'id': '01'},
    {'name': 'Abdul-Muhsin Al-Qasim', 'id': '02'},
    {'name': 'Abdurrahman As-Sudais', 'id': '03'},
    {'name': 'Ibrahim Al-Dossari', 'id': '04'},
    {'name': 'Yasser Al-Dosari', 'id': '06'},
  ];

  void _showQoriSelection(BuildContext context, SettingsProvider settings) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Text(
                  'Pilih Qori Murottal',
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF0C5441),
                  ),
                ),
              ),
              const Divider(),
              Flexible(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: _qoriList.length,
                  itemBuilder: (context, index) {
                    final qori = _qoriList[index];
                    final isSelected = settings.selectedQoriId == qori['id'];
                    return ListTile(
                      title: Text(
                        qori['name']!,
                        style: GoogleFonts.poppins(
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                          color: isSelected ? const Color(0xFF13A884) : Colors.black87,
                        ),
                      ),
                      trailing: isSelected
                          ? const Icon(Icons.check_circle, color: Color(0xFF13A884))
                          : null,
                      onTap: () {
                        settings.setSelectedQori(qori['name']!, qori['id']!);
                        Navigator.pop(context);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showTampilanUtamaSelection(BuildContext context, SettingsProvider settings) {
    final options = ['Baris Per Ayat', 'Halaman'];
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Text(
                  'Default Tampilan Utama',
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF0C5441),
                  ),
                ),
              ),
              const Divider(),
              ...options.map((opt) {
                final isSelected = settings.defaultTampilanUtama == opt;
                return ListTile(
                  title: Text(
                    opt,
                    style: GoogleFonts.poppins(
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      color: isSelected ? const Color(0xFF13A884) : Colors.black87,
                    ),
                  ),
                  trailing: isSelected
                      ? const Icon(Icons.check_circle, color: Color(0xFF13A884))
                      : null,
                  onTap: () {
                    settings.setDefaultTampilanUtama(opt);
                    Navigator.pop(context);
                  },
                );
              }),
            ],
          ),
        );
      },
    );
  }

  void _showTampilanBarisSelection(BuildContext context, SettingsProvider settings) {
    final options = ['Selalu Tanya', 'Tampilkan Terjemahan', 'Hanya Arab', 'Arab & Latin'];
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Text(
                  'Default Tampilan Baris',
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF0C5441),
                  ),
                ),
              ),
              const Divider(),
              Flexible(
                child: ListView(
                  shrinkWrap: true,
                  children: options.map((opt) {
                    final isSelected = settings.defaultTampilanBaris == opt;
                    return ListTile(
                      title: Text(
                        opt,
                        style: GoogleFonts.poppins(
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                          color: isSelected ? const Color(0xFF13A884) : Colors.black87,
                        ),
                      ),
                      trailing: isSelected
                          ? const Icon(Icons.check_circle, color: Color(0xFF13A884))
                          : null,
                      onTap: () {
                        settings.setDefaultTampilanBaris(opt);
                        Navigator.pop(context);
                      },
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showHalamanPermulaanSelection(BuildContext context, SettingsProvider settings) {
    final options = ['Halaman 1', 'Halaman 2', 'Halaman 3', 'Halaman 4', 'Halaman 5'];
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Text(
                  'Halaman Surah Al-Fatihah',
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF0C5441),
                  ),
                ),
              ),
              const Divider(),
              Flexible(
                child: ListView(
                  shrinkWrap: true,
                  children: options.map((opt) {
                    final isSelected = settings.halamanPermulaanAlFatihah == opt;
                    return ListTile(
                      title: Text(
                        opt,
                        style: GoogleFonts.poppins(
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                          color: isSelected ? const Color(0xFF13A884) : Colors.black87,
                        ),
                      ),
                      trailing: isSelected
                          ? const Icon(Icons.check_circle, color: Color(0xFF13A884))
                          : null,
                      onTap: () {
                        settings.setHalamanPermulaanAlFatihah(opt);
                        Navigator.pop(context);
                      },
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showPanduanTajwid(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.6,
          maxChildSize: 0.9,
          minChildSize: 0.4,
          expand: false,
          builder: (context, scrollController) {
            return Container(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 50,
                      height: 5,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                  Text(
                    'Panduan Tajwid Warna',
                    style: GoogleFonts.poppins(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF0C5441),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Pewarnaan ayat membantu Anda membaca Al-Qur\'an dengan hukum tajwid yang benar.',
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      color: Colors.grey[600],
                    ),
                  ),
                  const Divider(height: 24),
                  Expanded(
                    child: ListView(
                      controller: scrollController,
                      children: [
                        _buildTajwidGuideItem(
                          'Ikhfa / Ghunnah',
                          'Mendengung pada pangkal hidung selama 2 harakat.',
                          const Color(0xFF27AE60),
                        ),
                        _buildTajwidGuideItem(
                          'Idgham / Iqlab',
                          'Meleburkan suara huruf ke huruf berikutnya.',
                          const Color(0xFF2980B9),
                        ),
                        _buildTajwidGuideItem(
                          'Qalqalah',
                          'Pantulan suara ketika sukun atau waqaf.',
                          const Color(0xFFE67E22),
                        ),
                        _buildTajwidGuideItem(
                          'Mad Wajib / Jaiz',
                          'Memanjangkan bacaan 4-5 harakat.',
                          const Color(0xFFC0392B),
                        ),
                        _buildTajwidGuideItem(
                          'Mad Thabi\'i / Mad Asli',
                          'Memanjangkan bacaan sebanyak 2 harakat.',
                          const Color(0xFF8E44AD),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildTajwidGuideItem(String title, String desc, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: color.withOpacity(0.15),
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: color, width: 1.5),
            ),
            child: Center(
              child: Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
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
                  title,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  desc,
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showClearAudioDialog(BuildContext context, SettingsProvider settings) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            'Hapus Audio',
            style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
          ),
          content: Text(
            'Apakah Anda yakin ingin menghapus semua audio murottal yang telah diunduh?',
            style: GoogleFonts.poppins(fontSize: 14),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Batal',
                style: GoogleFonts.poppins(color: Colors.grey),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                settings.clearSavedAudio();
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Audio murottal berhasil dihapus.',
                      style: GoogleFonts.poppins(),
                    ),
                    backgroundColor: const Color(0xFF13A884),
                    duration: const Duration(seconds: 2),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                foregroundColor: Colors.white,
              ),
              child: Text(
                'Hapus',
                style: GoogleFonts.poppins(),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final settings = Provider.of<SettingsProvider>(context);

    // Format size display
    String formattedSize = '${settings.savedAudioSize.toStringAsFixed(0)} B';
    if (settings.savedAudioSize > 1024 * 1024) {
      formattedSize = '${(settings.savedAudioSize / (1024 * 1024)).toStringAsFixed(1)} MB';
    } else if (settings.savedAudioSize > 1024) {
      formattedSize = '${(settings.savedAudioSize / 1024).toStringAsFixed(1)} KB';
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF4F4F4),
      appBar: AppBar(
        title: Text(
          'Pengaturan Al-Quran',
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 18,
          ),
        ),
        backgroundColor: const Color(0xFF13A884),
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Section 1: Quran Tajwid
            _buildSectionHeader('Quran Tajwid'),
            _buildGroupCard([
              _buildSwitchRow(
                title: 'Tampilkan Warna Tajwid',
                value: settings.showWarnaTajwid,
                onChanged: (val) => settings.setShowWarnaTajwid(val),
              ),
              const Divider(height: 1),
              _buildClickableRow(
                title: 'Panduan Tajwid',
                onTap: () => _showPanduanTajwid(context),
              ),
            ]),

            const SizedBox(height: 16),

            // Section 2: Qori' Murottal
            _buildSectionHeader('Qori\' Murottal'),
            _buildGroupCard([
              _buildClickableRow(
                title: 'Pilih Qori',
                value: settings.selectedQori,
                onTap: () => _showQoriSelection(context, settings),
              ),
              const Divider(height: 1),
              _buildClickableRow(
                title: 'Hapus Audio Tersimpan',
                value: formattedSize,
                onTap: () => _showClearAudioDialog(context, settings),
              ),
            ]),

            const SizedBox(height: 16),

            // Section 3: Tampilan
            _buildSectionHeader('Tampilan'),
            _buildGroupCard([
              _buildClickableRow(
                title: 'Default Tampilan Utama',
                value: settings.defaultTampilanUtama,
                onTap: () => _showTampilanUtamaSelection(context, settings),
              ),
              const Divider(height: 1),
              _buildClickableRow(
                title: 'Default Tampilan Baris',
                value: settings.defaultTampilanBaris,
                onTap: () => _showTampilanBarisSelection(context, settings),
              ),
            ]),

            const SizedBox(height: 16),

            // Section 4: Sesuaikan Halaman Permulaan
            _buildSectionHeader('Sesuaikan Halaman Permulaan'),
            _buildGroupCard([
              _buildClickableRow(
                title: 'Halaman Surah Al-Fatihah',
                value: settings.halamanPermulaanAlFatihah,
                onTap: () => _showHalamanPermulaanSelection(context, settings),
              ),
            ]),

            const SizedBox(height: 16),

            // Section 5: Ayat Terakhir Dibaca
            _buildSectionHeader('Ayat Terakhir Dibaca'),
            _buildGroupCard([
              _buildSwitchRow(
                title: 'Penanda Otomatis',
                value: settings.penandaOtomatis,
                onChanged: (val) => settings.setPenandaOtomatis(val),
              ),
              const Divider(height: 1),
              _buildSwitchRow(
                title: 'Pengingat Membaca',
                value: settings.pengingatMembaca,
                onChanged: (val) => settings.setPengingatMembaca(val),
              ),
            ]),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8, top: 8),
      child: Text(
        title,
        style: GoogleFonts.poppins(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
    );
  }

  Widget _buildGroupCard(List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: children,
      ),
    );
  }

  Widget _buildSwitchRow({
    required String title,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              title,
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: Colors.black87,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: const Color(0xFF13A884),
            activeTrackColor: const Color(0xFF13A884).withOpacity(0.3),
            inactiveThumbColor: Colors.grey[200],
            inactiveTrackColor: Colors.grey[300],
          ),
        ],
      ),
    );
  }

  Widget _buildClickableRow({
    required String title,
    String? value,
    required VoidCallback onTap,
  }) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
      title: Text(
        title,
        style: GoogleFonts.poppins(
          fontSize: 14,
          color: Colors.black87,
          fontWeight: FontWeight.w500,
        ),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (value != null) ...[
            Text(
              value,
              style: GoogleFonts.poppins(
                fontSize: 13,
                color: Colors.grey[500],
                fontWeight: FontWeight.w400,
              ),
            ),
            const SizedBox(width: 8),
          ],
          const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
        ],
      ),
      onTap: onTap,
    );
  }
}
