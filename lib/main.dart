import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Al-Qur\'an NU',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF13A884)),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Layer 1: Full teal/hijau background
          Positioned.fill(
            child: Container(color: const Color(0xFF13A884)),
          ),
          // Layer 2: White dome overlay (menutupi area bawah dome)
          Positioned.fill(
            child: ClipPath(
              clipper: DomeClipper(),
              child: Container(color: Colors.white),
            ),
          ),
          // Content
          LayoutBuilder(
            builder: (context, constraints) {
              // Hitung posisi batas dome (baseY = 28% dari tinggi layar)
              // Tambah sedikit padding agar icon masuk ke area putih
              final double screenHeight = MediaQuery.of(context).size.height;
              final double domeBaseY = screenHeight * 0.28;
              return SafeArea(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      // Spacer agar icon turun ke area putih
                      SizedBox(height: domeBaseY - MediaQuery.of(context).padding.top + 16),
                      // White area content
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Column(
                          children: [
                            _buildMenuGrid(),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Colors.grey,
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_filled),
            label: 'Beranda',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.menu_book),
            label: 'Al-Quran',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.article_outlined),
            label: 'Artikel',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_month_outlined),
            label: 'Kalender',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings_outlined),
            label: 'Pengaturan',
          ),
        ],
      ),
    );
  }

  Widget _buildMenuGrid() {
    return GridView.count(
      crossAxisCount: 4,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 16,
      crossAxisSpacing: 8,
      childAspectRatio: 0.85,
      children: const [
        AlQuranIcon(),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────
// ICON 1: AL-QURAN
// Icon by BZZRINCANTATION - Flaticon (https://www.flaticon.com/free-icons/quran)
// ─────────────────────────────────────────────────────────────
class AlQuranIcon extends StatelessWidget {
  const AlQuranIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 52,
          height: 52,
          decoration: const BoxDecoration(
            color: Color(0xFFE8F5F1),
            shape: BoxShape.circle,
          ),
          padding: const EdgeInsets.all(8),
          child: Image.asset(
            'assets/images/alquran_icon.png',
            fit: BoxFit.contain,
          ),
        ),
        const SizedBox(height: 5),
        const Text(
          'Al-Quran',
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w500,
            color: Color(0xFF333333),
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}


class DomeClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    double w = size.width;
    double h = size.height;

    double baseY = h * 0.28;
    double tipY = h * 0.08;
    double hDiff = baseY - tipY;

    double p1x = w * 0.16;
    double p1y = baseY - hDiff * 0.25;

    double p2x = w * 0.33;
    double p2y = baseY - hDiff * 0.65;

    double p3x = w * 0.5;
    double p3y = tipY;
    double p2x_r = w - p2x;
    double p1x_r = w - p1x;
    path.moveTo(0, baseY);
    path.quadraticBezierTo(0, p1y, p1x, p1y);
    path.quadraticBezierTo(p1x, p2y, p2x, p2y);
    path.cubicTo(
        p2x, p3y + hDiff * 0.1, p3x - w * 0.05, p3y + hDiff * 0.1, p3x, p3y);
    path.cubicTo(
        p3x + w * 0.05, p3y + hDiff * 0.1, p2x_r, p3y + hDiff * 0.1, p2x_r, p2y);
    path.quadraticBezierTo(p1x_r, p2y, p1x_r, p1y);
    path.quadraticBezierTo(w, p1y, w, baseY);
    path.lineTo(w, h);
    path.lineTo(0, h);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => true;
}
