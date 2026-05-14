import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutAppPage extends StatelessWidget {
  const AboutAppPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF0C5441),
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Tentang Aplikasi',
          style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
          child: Column(
            children: [
              // Logo section (Screen 12)
              Container(
                width: 100,
                height: 100,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 20,
                      offset: Offset(0, 10),
                    ),
                  ],
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        '60',
                        style: TextStyle(
                          color: Color(0xFF13A884),
                          fontWeight: FontWeight.bold,
                          fontSize: 22,
                        ),
                      ),
                      Icon(Icons.menu_book, color: const Color(0xFF13A884), size: 32),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 32),
              const Text(
                'Aplikasi Hadis Digital',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
              ),
              const SizedBox(height: 8),
              Text(
                'v1.0.0',
                style: TextStyle(color: Colors.grey[600], fontSize: 14),
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: 280,
                child: Text(
                  'Aplikasi untuk membaca dan mencari hadis dari 9 perawi dengan total lebih dari 50.000 hadis.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey[600], fontSize: 14, height: 1.6),
                ),
              ),
              const SizedBox(height: 48),
              
              // Info List (Screen 12)
              _buildAboutItem(Icons.person_outline, 'Developer', 'superXdev', 'https://github.com/superXdev'),
              _buildAboutItem(Icons.public, 'Sumber Data', 'https://hadits.in', 'https://hadits.in'),
              _buildAboutItem(Icons.api, 'API', 'hadits-api.superxdev.repl.co', 'https://github.com/gadingnst/hadith-api'),
              _buildAboutItem(Icons.verified_user_outlined, 'Lisensi', 'MIT License', 'https://opensource.org/licenses/MIT'),
              
              const SizedBox(height: 60),
              Text(
                '© 2024 Aplikasi Hadis Digital',
                style: TextStyle(color: Colors.grey[400], fontSize: 13),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAboutItem(IconData icon, String title, String subtitle, String url) {
    return InkWell(
      onTap: () async {
        final Uri uri = Uri.parse(url);
        if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
          // Error handling
        }
      },
      child: Padding(
        padding: const EdgeInsets.only(bottom: 24),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: const BoxDecoration(
                color: Color(0xFFF0F9F6),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: const Color(0xFF13A884), size: 22),
            ),
            const SizedBox(width: 20),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(color: Color(0xFF13A884), fontSize: 14),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
