import 'package:flutter/material.dart';
import 'dart:math' as math;

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
    return const Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        AlQuranIcon(),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────
// ICON 1: AL-QURAN
// ─────────────────────────────────────────────────────────────
class AlQuranIcon extends StatelessWidget {
  const AlQuranIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 64,
          height: 64,
          decoration: BoxDecoration(
            color: const Color(0xFFE8F5F1), // mint/teal muda
            shape: BoxShape.circle,
          ),
          child: CustomPaint(
            size: const Size(64, 64),
            painter: AlQuranPainter(),
          ),
        ),
        const SizedBox(height: 6),
        const Text(
          'Al-Quran',
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w500,
            color: Color(0xFF333333),
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

class AlQuranPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final double cx = size.width / 2;
    final double cy = size.height / 2;

    // ── COLORS ──
    final Color tealColor = const Color(0xFF118C70); // Dark Teal for cover and rehal
    final Color pageColor = const Color(0xFFF8E3C5); // Cream/Light Orange for pages
    final Color lineColor = const Color(0xFFD67A58); // Orange/Brown for text
    final Color bookmarkColor = const Color(0xFFF4A261); // Orange for bookmark

    // ── REHAL (Book Stand) ──
    final rehalPaint = Paint()
      ..color = tealColor
      ..style = PaintingStyle.fill;

    // Base legs (X-like shape)
    final rehalBase = Path();
    rehalBase.moveTo(cx - 14, cy + 20); // bottom left
    rehalBase.lineTo(cx - 8, cy + 20); // bottom left inner
    rehalBase.lineTo(cx, cy + 12);     // center cross
    rehalBase.lineTo(cx + 8, cy + 20); // bottom right inner
    rehalBase.lineTo(cx + 14, cy + 20); // bottom right
    rehalBase.lineTo(cx + 6, cy + 9);  // right under book
    rehalBase.lineTo(cx - 6, cy + 9);  // left under book
    rehalBase.close();
    canvas.drawPath(rehalBase, rehalPaint);

    // Support bar
    final rehalBar = RRect.fromRectAndRadius(
      Rect.fromCenter(center: Offset(cx, cy + 9), width: 34, height: 4),
      const Radius.circular(2),
    );
    canvas.drawRRect(rehalBar, rehalPaint);

    // ── BUKU AL-QURAN COVER ──
    final coverPaint = Paint()
      ..color = tealColor
      ..style = PaintingStyle.fill;
    
    final coverPath = Path();
    coverPath.moveTo(cx, cy + 11); // Spine bottom
    coverPath.quadraticBezierTo(cx - 10, cy + 5, cx - 21, cy + 9); // Left bottom curve
    coverPath.lineTo(cx - 21, cy - 5); // Left edge
    coverPath.quadraticBezierTo(cx - 10, cy - 9, cx, cy - 3); // Left top curve
    coverPath.quadraticBezierTo(cx + 10, cy - 9, cx + 21, cy - 5); // Right top curve
    coverPath.lineTo(cx + 21, cy + 9); // Right edge
    coverPath.quadraticBezierTo(cx + 10, cy + 5, cx, cy + 11); // Right bottom curve
    coverPath.close();
    canvas.drawPath(coverPath, coverPaint);

    // ── PAGES ──
    final pagePaint = Paint()
      ..color = pageColor
      ..style = PaintingStyle.fill;
    
    final pagePath = Path();
    pagePath.moveTo(cx, cy + 9); // Spine bottom
    pagePath.quadraticBezierTo(cx - 10, cy + 3, cx - 19, cy + 7); // Left bottom curve
    pagePath.lineTo(cx - 19, cy - 3); // Left edge
    pagePath.quadraticBezierTo(cx - 10, cy - 7, cx, cy - 1); // Left top curve
    pagePath.quadraticBezierTo(cx + 10, cy - 7, cx + 19, cy - 3); // Right top curve
    pagePath.lineTo(cx + 19, cy + 7); // Right edge
    pagePath.quadraticBezierTo(cx + 10, cy + 3, cx, cy + 9); // Right bottom curve
    pagePath.close();
    canvas.drawPath(pagePath, pagePaint);

    // Center fold line
    final foldPaint = Paint()
      ..color = const Color(0xFFE8CBA3) // Slightly darker cream
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;
    canvas.drawLine(Offset(cx, cy - 1), Offset(cx, cy + 9), foldPaint);

    // ── TEXT LINES ──
    final linePaint = Paint()
      ..color = lineColor
      ..strokeWidth = 1.2
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    void drawCurvedLine(double yOffset) {
      final leftLine = Path();
      leftLine.moveTo(cx - 3, cy + yOffset);
      leftLine.quadraticBezierTo(cx - 10, cy - 4 + yOffset, cx - 16, cy + 1 + yOffset);
      canvas.drawPath(leftLine, linePaint);

      final rightLine = Path();
      rightLine.moveTo(cx + 3, cy + yOffset);
      rightLine.quadraticBezierTo(cx + 10, cy - 4 + yOffset, cx + 16, cy + 1 + yOffset);
      canvas.drawPath(rightLine, linePaint);
    }

    drawCurvedLine(-1.5);
    drawCurvedLine(2.0);
    drawCurvedLine(5.5);

    // ── BOOKMARK ──
    final bookmarkPaint = Paint()
      ..color = bookmarkColor
      ..style = PaintingStyle.fill;
    
    final bookmarkPath = Path();
    bookmarkPath.moveTo(cx - 1.5, cy + 7);
    bookmarkPath.lineTo(cx + 1.5, cy + 7);
    bookmarkPath.lineTo(cx + 1.5, cy + 14);
    bookmarkPath.lineTo(cx, cy + 16); // Pointy tip
    bookmarkPath.lineTo(cx - 1.5, cy + 14);
    bookmarkPath.close();
    canvas.drawPath(bookmarkPath, bookmarkPaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}


// ─────────────────────────────────────────────────────────────
// DOME CLIPPER (masjid silhouette header)
// ─────────────────────────────────────────────────────────────
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
