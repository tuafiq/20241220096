import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'settings_provider.dart';
import 'login_page.dart';
import 'edit_profile_page.dart';
import 'preferensi_membaca_page.dart';
import 'daftar_bookmark_page.dart';
import 'quran_settings_page.dart';
import 'lokasi_adzan_page.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final String _mockUserName = 'Taufiq Hidayat';
  final String _mockUserEmail = 'tuafiq8214829@gmail.com';
  Uint8List? _profileImageBytes;

  void _showThemeSelectionBottomSheet(BuildContext context, SettingsProvider settings) {
    final isDarkMode = settings.themeModeStr == 'Gelap';
    showModalBottomSheet(
      context: context,
      backgroundColor: isDarkMode ? const Color(0xFF1E1E1E) : Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: isDarkMode ? Colors.white24 : Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Pilih Tema Tampilan',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: isDarkMode ? Colors.white : Colors.black87,
                ),
              ),
              const SizedBox(height: 16),
              ListTile(
                leading: Icon(Icons.light_mode, color: isDarkMode ? Colors.white70 : const Color(0xFF13A884)),
                title: Text(
                  'Mode Terang (Hijau)',
                  style: TextStyle(
                    color: isDarkMode ? Colors.white : Colors.black87,
                    fontWeight: settings.themeModeStr == 'Hijau' ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
                trailing: settings.themeModeStr == 'Hijau'
                    ? const Icon(Icons.check_circle, color: Color(0xFF13A884))
                    : null,
                onTap: () {
                  settings.setThemeModeStr('Hijau');
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: Icon(Icons.dark_mode, color: isDarkMode ? const Color(0xFF13A884) : Colors.black54),
                title: Text(
                  'Mode Gelap',
                  style: TextStyle(
                    color: isDarkMode ? Colors.white : Colors.black87,
                    fontWeight: settings.themeModeStr == 'Gelap' ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
                trailing: settings.themeModeStr == 'Gelap'
                    ? const Icon(Icons.check_circle, color: Color(0xFF13A884))
                    : null,
                onTap: () {
                  settings.setThemeModeStr('Gelap');
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final settings = Provider.of<SettingsProvider>(context);
    final isDarkMode = settings.themeModeStr == 'Gelap';

    return Scaffold(
      backgroundColor: isDarkMode ? const Color(0xFF121212) : const Color(0xFFF4F4F4), 
      appBar: AppBar(
        title: const Text(
          'Pengaturan',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
        ),
        backgroundColor: const Color(0xFF13A884), 
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
      ),
      body: ListView(
        children: [
          Container(
            color: isDarkMode ? const Color(0xFF1E1E1E) : Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            child: Row(
              children: [
                if (settings.isLoggedIn)
                  Container(
                    width: 70,
                    height: 70,
                    decoration: BoxDecoration(
                      color: const Color(0xFF0088CC), // Blue color for avatar
                      shape: BoxShape.circle,
                      image: _profileImageBytes != null
                          ? DecorationImage(
                              image: MemoryImage(_profileImageBytes!),
                              fit: BoxFit.cover,
                              )
                          : null,
                    ),
                    child: Center(
                      child: _profileImageBytes == null
                          ? const Text(
                              'T',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 32,
                                fontWeight: FontWeight.w400,
                              ),
                            )
                          : null,
                    ),
                  )
                else
                  Container(
                    width: 70,
                    height: 70,
                    decoration: BoxDecoration(
                      color: isDarkMode ? Colors.grey[800] : Colors.grey[300],
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.person,
                      size: 50,
                      color: isDarkMode ? Colors.grey[600] : Colors.grey,
                    ),
                  ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        settings.isLoggedIn ? _mockUserName : 'Masuk ke Akunmu',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: isDarkMode ? Colors.white : Colors.black87,
                        ),
                      ),
                      if (settings.isLoggedIn) ...[
                        const SizedBox(height: 4),
                        Text(
                          _mockUserEmail,
                          style: TextStyle(
                            fontSize: 14,
                            color: isDarkMode ? Colors.white70 : Colors.black87,
                          ),
                        ),
                      ],
                      const SizedBox(height: 8),
                      if (!settings.isLoggedIn)
                        OutlinedButton(
                          onPressed: () async {
                            final result = await Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const LoginPage()),
                            );
                            if (result == true) {
                              settings.setLoggedIn(true);
                            }
                          },
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            side: BorderSide(color: isDarkMode ? Colors.white24 : Colors.grey),
                          ),
                          child: Text(
                            'Login',
                            style: TextStyle(
                              color: isDarkMode ? Colors.white : Colors.black87,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        )
                      else
                        OutlinedButton(
                          onPressed: () async {
                            final newImageBytes = await Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const EditProfilePage()),
                            );
                            if (newImageBytes != null && newImageBytes is Uint8List) {
                              setState(() {
                                _profileImageBytes = newImageBytes;
                              });
                            }
                          },
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            side: BorderSide(color: isDarkMode ? Colors.white24 : Colors.grey),
                          ),
                          child: Text(
                            'Edit Profil',
                            style: TextStyle(
                              color: isDarkMode ? Colors.white : Colors.black87,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8), 
          Container(
            color: isDarkMode ? const Color(0xFF1E1E1E) : Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Text(
                    'Umum',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: isDarkMode ? Colors.white : Colors.black,
                    ),
                  ),
                ),
                ListTile(
                  leading: Icon(Icons.dark_mode_outlined, color: isDarkMode ? Colors.white70 : Colors.black54),
                  title: Text('Tampilan', style: TextStyle(color: isDarkMode ? Colors.white : Colors.black87)),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
                  onTap: () => _showThemeSelectionBottomSheet(context, settings),
                ),
                Divider(height: 1, indent: 16, endIndent: 16, color: isDarkMode ? Colors.white12 : Colors.grey[200]),
                ListTile(
                  leading: Icon(Icons.text_format, color: isDarkMode ? Colors.white70 : Colors.black54),
                  title: Text(settings.translate('reading_preferences'), style: TextStyle(color: isDarkMode ? Colors.white : Colors.black87)),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const PreferensiMembacaPage()),
                    );
                  },
                ),
                Divider(height: 1, indent: 16, endIndent: 16, color: isDarkMode ? Colors.white12 : Colors.grey[200]),
                ListTile(
                  leading: Icon(Icons.bookmark_border, color: isDarkMode ? Colors.white70 : Colors.black54),
                  title: Text(settings.translate('bookmark_list'), style: TextStyle(color: isDarkMode ? Colors.white : Colors.black87)),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const DaftarBookmarkPage()),
                    );
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Container(
            color: isDarkMode ? const Color(0xFF1E1E1E) : Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Text(
                    'Ibadah',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: isDarkMode ? Colors.white : Colors.black,
                    ),
                  ),
                ),
                ListTile(
                  leading: Icon(Icons.book_outlined, color: isDarkMode ? Colors.white70 : Colors.black54),
                  title: Text('Al-Quran', style: TextStyle(color: isDarkMode ? Colors.white : Colors.black87)),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const QuranSettingsPage()),
                    );
                  },
                ),
                Divider(height: 1, indent: 16, endIndent: 16, color: isDarkMode ? Colors.white12 : Colors.grey[200]),
                ListTile(
                  leading: Icon(Icons.access_time, color: isDarkMode ? Colors.white70 : Colors.black54),
                  title: Text('Lokasi dan pilihan adzan', style: TextStyle(color: isDarkMode ? Colors.white : Colors.black87)),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const LokasiAdzanPage()),
                    );
                  },
                ),

              ],
            ),
          ),
          
          if (settings.isLoggedIn) ...[
            const SizedBox(height: 8),
            Container(
              color: isDarkMode ? const Color(0xFF1E1E1E) : Colors.white,
              padding: const EdgeInsets.all(16.0),
              child: SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () {
                    // Logic to handle logout
                    settings.setLoggedIn(false);
                    setState(() {
                      _profileImageBytes = null;
                    });
                  },
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    side: const BorderSide(color: Colors.grey, width: 1),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Logout',
                    style: TextStyle(
                      color: Color(0xFFE53935), // Red color for logout text
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
