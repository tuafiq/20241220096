import 'dart:math';
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
          
          LayoutBuilder(
            builder: (context, constraints) {
              
              final double screenHeight = MediaQuery.of(context).size.height;
              final double domeBaseY = screenHeight * 0.28;
              return SafeArea(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                    
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
      crossAxisCount: 4, // 4 kolom sesuai gambar referensi
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 16,
      crossAxisSpacing: 8,
      childAspectRatio: 0.85,
      children: const [
        AlQuranIcon(),
        WiridDoaIcon(),
        JadwalShalatIcon(), // Icon jam yang baru kita buat
        KiblatIcon(),       // Tambahkan placeholder jika ingin melengkapi
        TahlilIcon(),
        MaulidIcon(),
        ZakatIcon(),
        LainnyaIcon(),
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

// ─────────────────────────────────────────────────────────────
// ICON 2: WIRID & DOA
// ─────────────────────────────────────────────────────────────
class WiridDoaIcon extends StatelessWidget {
  const WiridDoaIcon({super.key});

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
            'assets/images/wirid_doa_icon.png',
            fit: BoxFit.contain,
          ),
        ),
        const SizedBox(height: 5),
        const Text(
          'Wirid & Doa',
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

// ─────────────────────────────────────────────────────────────
// ICON 3: JADWAL SHALAT
// Icon by Ghozi Muhtarom - Flaticon (https://www.flaticon.com/free-icons/prayer)
// ─────────────────────────────────────────────────────────────
class JadwalShalatIcon extends StatelessWidget {
  const JadwalShalatIcon({super.key});

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
            color: Color(0xFFE8F5F1), // Background lingkaran luar (soft green)
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                border: Border.all(
                  color: const Color(0xFF13A884), // Warna hijau NU
                  width: 2.5,
                ),
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Titik tengah jam
                  Container(
                    width: 4,
                    height: 4,
                    decoration: const BoxDecoration(
                      color: Color(0xFF13A884),
                      shape: BoxShape.circle,
                    ),
                  ),
                  // Jarum Menit (Panjang - Menghadap ke atas)
                  Positioned(
                    top: 4,
                    child: Container(
                      width: 2,
                      height: 12,
                      decoration: BoxDecoration(
                        color: const Color(0xFF13A884),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  // Jarum Jam (Pendek - Menghadap ke samping)
                  Positioned(
                    right: 6,
                    child: Container(
                      width: 10,
                      height: 2,
                      decoration: BoxDecoration(
                        color: const Color(0xFF13A884),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 5),
        const Text(
          'Jadwal Shalat',
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

// ─────────────────────────────────────────────────────────────
// ICON 4: KIBLAT
// Icon by Fahrul Oktaviana - Flaticon (https://www.flaticon.com/free-icons/kiblat)
// ─────────────────────────────────────────────────────────────
class KiblatIcon extends StatelessWidget {
  const KiblatIcon({super.key});

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
            color: Color(0xFFE8F5F1), // Background lingkaran luar
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: const Color(0xFFF4F4F4),
                shape: BoxShape.circle,
                border: Border.all(
                  color: const Color(0xFF0C9347), // Green border
                  width: 3.0,
                ),
              ),
              child: CustomPaint(
                size: const Size(32, 32),
                painter: KiblatPainter(),
              ),
            ),
          ),
        ),
        const SizedBox(height: 5),
        const Text(
          'Kiblat',
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

class KiblatPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;

    // Ticks
    final tickPaint = Paint()
      ..color = const Color(0xFFF94343)
      ..strokeWidth = 2.0
      ..strokeCap = StrokeCap.round;

    for (int i = 0; i < 8; i++) {
      if (i == 0) continue; // Skip top tick for the arrow
      final angle = i * pi / 4 - pi / 2;
      final start = Offset(
        cx + cos(angle) * (cx - 7),
        cy + sin(angle) * (cy - 7),
      );
      final end = Offset(
        cx + cos(angle) * (cx - 3),
        cy + sin(angle) * (cy - 3),
      );
      canvas.drawLine(start, end, tickPaint);
    }

    // Red Arrow
    final arrowPath = Path()
      ..moveTo(cx, 3.5)
      ..lineTo(cx - 3.5, 9.5)
      ..lineTo(cx + 3.5, 9.5)
      ..close();

    final arrowPaint = Paint()
      ..color = const Color(0xFFF94343)
      ..style = PaintingStyle.fill;
    canvas.drawPath(arrowPath, arrowPaint);

    // Kaaba
    final kw = 7.0; // half width
    final kh = 7.5; // half height
    final kcx = cx;
    final kcy = cy + 1.5;

    final p1 = Offset(kcx, kcy - kh);
    final p2 = Offset(kcx - kw, kcy - kh + 3.5);
    final p3 = Offset(kcx, kcy - kh + 7);
    final p4 = Offset(kcx + kw, kcy - kh + 3.5);
    final p5 = Offset(kcx, kcy + kh);
    final p6 = Offset(kcx - kw, kcy + kh - 3.5);
    final p7 = Offset(kcx + kw, kcy + kh - 3.5);

    // Top
    final topFace = Path()..moveTo(p1.dx, p1.dy)..lineTo(p2.dx, p2.dy)..lineTo(p3.dx, p3.dy)..lineTo(p4.dx, p4.dy)..close();
    canvas.drawPath(topFace, Paint()..color = const Color(0xFF4B4B4B));

    // Left
    final leftFace = Path()..moveTo(p2.dx, p2.dy)..lineTo(p3.dx, p3.dy)..lineTo(p5.dx, p5.dy)..lineTo(p6.dx, p6.dy)..close();
    canvas.drawPath(leftFace, Paint()..color = const Color(0xFF3B3B3B));

    // Right
    final rightFace = Path()..moveTo(p3.dx, p3.dy)..lineTo(p4.dx, p4.dy)..lineTo(p7.dx, p7.dy)..lineTo(p5.dx, p5.dy)..close();
    canvas.drawPath(rightFace, Paint()..color = const Color(0xFF2B2B2B));

    // Left Band
    final lBand = Path()
      ..moveTo(kcx - kw, kcy - kh + 3.5 + 2.5) // TL
      ..lineTo(kcx, kcy - kh + 7 + 2.5) // TR
      ..lineTo(kcx, kcy - kh + 7 + 5.5) // BR
      ..lineTo(kcx - kw, kcy - kh + 3.5 + 5.5) // BL
      ..close();
    canvas.drawPath(lBand, Paint()..color = const Color(0xFFD9D9D9));

    // Right Band
    final rBand = Path()
      ..moveTo(kcx, kcy - kh + 7 + 2.5) // TL
      ..lineTo(kcx + kw, kcy - kh + 3.5 + 2.5) // TR
      ..lineTo(kcx + kw, kcy - kh + 3.5 + 5.5) // BR
      ..lineTo(kcx, kcy - kh + 7 + 5.5) // BL
      ..close();
    canvas.drawPath(rBand, Paint()..color = const Color(0xFFC9C9C9));

    // Door
    final door = Path()
      ..moveTo(kcx - 5, kcy + 1.5)
      ..lineTo(kcx - 2, kcy + 3)
      ..lineTo(kcx - 2, kcy + 6.5)
      ..lineTo(kcx - 5, kcy + 5)
      ..close();
    canvas.drawPath(door, Paint()..color = const Color(0xFFF9C000));

    // Gold marks
    final goldPaint = Paint()
      ..color = const Color(0xFFF9C000)
      ..strokeWidth = 1.0
      ..style = PaintingStyle.fill;
    
    final g1 = Path()
      ..moveTo(kcx + 2, kcy + 2.8)
      ..lineTo(kcx + 3, kcy + 2.3)
      ..lineTo(kcx + 3, kcy + 3.3)
      ..lineTo(kcx + 2, kcy + 3.8)
      ..close();
    canvas.drawPath(g1, goldPaint);

    final g2 = Path()
      ..moveTo(kcx + 4.5, kcy + 1.5)
      ..lineTo(kcx + 6.5, kcy + 0.5)
      ..lineTo(kcx + 6.5, kcy + 1.5)
      ..lineTo(kcx + 4.5, kcy + 2.5)
      ..close();
    canvas.drawPath(g2, goldPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class TahlilIcon extends StatelessWidget {
  const TahlilIcon({super.key});
  @override Widget build(BuildContext context) => _buildPlaceholder('Tahlil');
}

class MaulidIcon extends StatelessWidget {
  const MaulidIcon({super.key});
  @override Widget build(BuildContext context) => _buildPlaceholder('Maulid');
}

class ZakatIcon extends StatelessWidget {
  const ZakatIcon({super.key});
  @override Widget build(BuildContext context) => _buildPlaceholder('Zakat');
}

class LainnyaIcon extends StatelessWidget {
  const LainnyaIcon({super.key});
  @override Widget build(BuildContext context) => _buildPlaceholder('Lainnya');
}

Widget _buildPlaceholder(String title) {
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
      ),
      const SizedBox(height: 5),
      Text(
        title,
        style: const TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w500,
          color: Color(0xFF333333),
        ),
        textAlign: TextAlign.center,
      ),
    ],
  );
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
