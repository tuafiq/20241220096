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
                  fontSize: 16,
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
                    fontSize: 14,
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
                    fontSize: 14,
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

  Widget _buildSectionHeader(String title, bool isDarkMode) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20, top: 18, bottom: 8),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: isDarkMode ? Colors.white : Colors.black87,
        ),
      ),
    );
  }

  Widget _buildMenuCard({required List<Widget> children, required bool isDarkMode}) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: isDarkMode ? const Color(0xFF1E1E1E) : Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: children,
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    required bool isDarkMode,
    bool showDivider = true,
  }) {
    return Column(
      children: [
        ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          leading: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: isDarkMode ? const Color(0xFF13A884).withOpacity(0.2) : const Color(0xFFE8F6F3),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: const Color(0xFF13A884), size: 20),
          ),
          title: Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 14,
              color: isDarkMode ? Colors.white : Colors.black87,
            ),
          ),
          subtitle: Text(
            subtitle,
            style: TextStyle(
              fontSize: 11,
              color: isDarkMode ? Colors.white60 : Colors.grey[600],
            ),
          ),
          trailing: Icon(Icons.arrow_forward_ios, size: 12, color: isDarkMode ? Colors.white54 : Colors.grey[400]),
          onTap: onTap,
        ),
        if (showDivider)
          Divider(
            height: 1,
            thickness: 1,
            indent: 64,
            endIndent: 16,
            color: isDarkMode ? Colors.white12 : Colors.grey[100],
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final settings = Provider.of<SettingsProvider>(context);
    final isDarkMode = settings.themeModeStr == 'Gelap';

    return Scaffold(
      backgroundColor: isDarkMode ? const Color(0xFF121212) : const Color(0xFFF9F9F9),
      body: Stack(
        children: [
          // Green Background Header with Gradient and Mosque
          Container(
            height: 200,
            width: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF20BFA0),
                  Color(0xFF13A884),
                ],
              ),
            ),
            child: Stack(
              children: [
                Positioned(
                  right: -10,
                  bottom: -10,
                  child: Opacity(
                    opacity: 0.15,
                    child: Image.asset(
                      'assets/images/mosque_widget_bg.png',
                      height: 120,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) => const SizedBox(),
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Texts
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        'Pengaturan',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 2),
                      Text(
                        'Sesuaikan aplikasi sesuai kebutuhanmu',
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                ),
                
                // Main Content List
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.only(bottom: 30),
                    children: [
                      // Profile Card
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 20),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: isDarkMode ? const Color(0xFF1E1E1E) : Colors.white,
                          borderRadius: BorderRadius.circular(14),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.04),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            // Avatar
                            if (settings.isLoggedIn)
                              Stack(
                                alignment: Alignment.bottomRight,
                                children: [
                                  Container(
                                    width: 56,
                                    height: 56,
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF0088CC),
                                      shape: BoxShape.circle,
                                      image: settings.profileImageBytes != null
                                          ? DecorationImage(
                                              image: MemoryImage(settings.profileImageBytes!),
                                              fit: BoxFit.cover,
                                            )
                                          : null,
                                    ),
                                    child: Center(
                                      child: (!settings.isLoggedIn || settings.profileImageBytes == null)
                                        ? Text(
                                            settings.isLoggedIn && settings.userName.isNotEmpty
                                                ? settings.userName[0].toUpperCase()
                                                : 'T',
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 24,
                                              fontWeight: FontWeight.w400,
                                            ),
                                          )
                                        : null,
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.all(3),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      shape: BoxShape.circle,
                                      border: Border.all(color: Colors.white, width: 2),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.1),
                                          blurRadius: 2,
                                        ),
                                      ],
                                    ),
                                    child: const Icon(Icons.camera_alt_outlined, size: 10, color: Color(0xFF13A884)),
                                  ),
                                ],
                              )
                            else
                              Container(
                                width: 56,
                                height: 56,
                                decoration: BoxDecoration(
                                  color: isDarkMode ? Colors.grey[800] : Colors.grey[200],
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(Icons.person, size: 32, color: isDarkMode ? Colors.grey[600] : Colors.grey[400]),
                              ),
                            const SizedBox(width: 12),
                            // User Info
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    settings.isLoggedIn ? settings.userName : 'Masuk ke Akunmu',
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      color: isDarkMode ? Colors.white : Colors.black87,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    settings.isLoggedIn ? settings.userEmail : 'Login untuk pengalaman terbaik',
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: isDarkMode ? Colors.white60 : Colors.grey[600],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 8),
                            // Action Button (Login or Edit Profil)
                            if (!settings.isLoggedIn)
                              ElevatedButton(
                                onPressed: () async {
                                  final result = await Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => const LoginPage()),
                                  );
                                  if (result == true) {
                                    settings.setLoggedIn(true);
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF13A884),
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
                                  minimumSize: const Size(0, 32),
                                  elevation: 0,
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: const [
                                    Text('Login', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 11)),
                                    SizedBox(width: 2),
                                    Icon(Icons.arrow_forward_ios, size: 10),
                                  ],
                                ),
                              )
                            else
                              OutlinedButton.icon(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => const EditProfilePage()),
                                  );
                                },
                                icon: const Icon(Icons.edit_outlined, size: 12, color: Color(0xFF13A884)),
                                label: const Text(
                                  'Edit Profil',
                                  style: TextStyle(
                                    color: Color(0xFF13A884),
                                    fontWeight: FontWeight.w600,
                                    fontSize: 11,
                                  ),
                                ),
                                style: OutlinedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(horizontal: 8),
                                  minimumSize: const Size(0, 32),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  side: const BorderSide(color: Color(0xFF13A884)),
                                ),
                              ),
                          ],
                        ),
                      ),
                      
                      const SizedBox(height: 8),
                      
                      // Umum Section
                      _buildSectionHeader('Umum', isDarkMode),
                      _buildMenuCard(
                        isDarkMode: isDarkMode,
                        children: [
                          _buildMenuItem(
                            icon: Icons.dark_mode_outlined,
                            title: 'Tampilan',
                            subtitle: 'Atur tema, ukuran teks, dan lainnya',
                            onTap: () => _showThemeSelectionBottomSheet(context, settings),
                            isDarkMode: isDarkMode,
                          ),
                          _buildMenuItem(
                            icon: Icons.text_format,
                            title: 'Preferensi Membaca',
                            subtitle: 'Atur terjemahan, bahasa, dan lainnya',
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => const PreferensiMembacaPage()),
                              );
                            },
                            isDarkMode: isDarkMode,
                          ),
                          _buildMenuItem(
                            icon: Icons.bookmark,
                            title: 'Daftar Bookmark',
                            subtitle: 'Kelola dan lihat bookmark kamu',
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => const DaftarBookmarkPage()),
                              );
                            },
                            isDarkMode: isDarkMode,
                            showDivider: false,
                          ),
                        ],
                      ),
                      
                      const SizedBox(height: 8),
                      
                      // Ibadah Section
                      _buildSectionHeader('Ibadah', isDarkMode),
                      _buildMenuCard(
                        isDarkMode: isDarkMode,
                        children: [
                          _buildMenuItem(
                            icon: Icons.menu_book_outlined,
                            title: 'Al-Quran',
                            subtitle: 'Pengaturan bacaan Al-Quran',
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => const QuranSettingsPage()),
                              );
                            },
                            isDarkMode: isDarkMode,
                          ),
                          _buildMenuItem(
                            icon: Icons.access_time,
                            title: 'Lokasi dan pilihan adzan',
                            subtitle: 'Atur lokasi dan suara adzan',
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => const LokasiAdzanPage()),
                              );
                            },
                            isDarkMode: isDarkMode,
                            showDivider: false,
                          ),
                        ],
                      ),

                      // Logout Button
                      if (settings.isLoggedIn) ...[
                        const SizedBox(height: 24),
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 20),
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: () {
                              settings.logout();
                            },
                            icon: const Icon(Icons.power_settings_new, color: Color(0xFFE53935), size: 18),
                            label: const Text(
                              'Logout',
                              style: TextStyle(
                                color: Color(0xFFE53935),
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: isDarkMode ? const Color(0xFF1E1E1E) : Colors.white,
                              foregroundColor: const Color(0xFFE53935),
                              elevation: 1,
                              shadowColor: Colors.black.withOpacity(0.05),
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                                side: BorderSide(
                                  color: isDarkMode ? Colors.white12 : Colors.grey[200]!,
                                  width: 1,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

