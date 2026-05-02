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
        WiridDoaIcon(),
        JadwalShalatIcon(), 
        KiblatIcon(),       
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
            color: Color(0xFFE8F5F1), 
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
                  color: const Color(0xFF13A884), 
                  width: 2.5,
                ),
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                 
                  Container(
                    width: 4,
                    height: 4,
                    decoration: const BoxDecoration(
                      color: Color(0xFF13A884),
                      shape: BoxShape.circle,
                    ),
                  ),
                  
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
            color: Color(0xFFE8F5F1), 
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
                  color: const Color(0xFF0C9347), 
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
      if (i == 0) continue; 
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

// ─────────────────────────────────────────────────────────────
// ICON 5: TAHLIL & YASIN
// ─────────────────────────────────────────────────────────────
class TahlilIcon extends StatelessWidget {
  const TahlilIcon({super.key});

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
          child: Center(
            child: CustomPaint(
              size: const Size(32, 32),
              painter: TahlilPainter(),
            ),
          ),
        ),
        const SizedBox(height: 5),
        const Text(
          'Tahlil & Yasin',
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

class TahlilPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // Colors
    final skinColor = const Color(0xFFF2D091);
    final robeColor = const Color(0xFF13A884); // NU Green
    final sleeveColor = const Color(0xFF16B992); // Slightly lighter green
    final hairColor = const Color(0xFF3B3B3B);
    final capColor = const Color(0xFF86D945); // Bright green peci
    final matColor = const Color(0xFF283236);
    final collarColor = const Color(0xFFA9B2BC);
    final bgElementColor = const Color(0xFFC0C0C0);

    // 1. Moon & Stars
    final moonBase = Path()..addOval(Rect.fromCircle(center: const Offset(25, 8), radius: 4.5));
    final moonCut = Path()..addOval(Rect.fromCircle(center: const Offset(23.5, 7), radius: 4.5));
    final crescent = Path.combine(PathOperation.difference, moonBase, moonCut);
    canvas.drawPath(crescent, Paint()..color = bgElementColor);

    void drawStar(Offset center) {
      final paint = Paint()
        ..color = bgElementColor
        ..strokeWidth = 1.5
        ..strokeCap = StrokeCap.round;
      canvas.drawLine(Offset(center.dx - 2.5, center.dy), Offset(center.dx + 2.5, center.dy), paint);
      canvas.drawLine(Offset(center.dx, center.dy - 2.5), Offset(center.dx, center.dy + 2.5), paint);
    }
    drawStar(const Offset(6, 8));
    drawStar(const Offset(27, 21));

    // 2. Foot
    final footPath = Path()
      ..moveTo(8, 25)
      ..lineTo(5, 25)
      ..quadraticBezierTo(4, 26, 5, 27)
      ..lineTo(8, 27)
      ..close();
    canvas.drawPath(footPath, Paint()..color = skinColor);

    // 3. Mat
    canvas.drawLine(
      const Offset(4, 27.5),
      const Offset(28, 27.5),
      Paint()
        ..color = matColor
        ..strokeWidth = 2.0
        ..strokeCap = StrokeCap.round,
    );

    // 4. Head
    final headPath = Path()
      ..moveTo(10, 11) // back neck
      ..lineTo(10, 5) // back head
      ..lineTo(13, 4) // top head
      ..lineTo(15, 5) // forehead
      ..lineTo(16, 6) // eye level
      ..lineTo(17.5, 7.5) // nose tip
      ..lineTo(16.5, 8.5) // upper lip
      ..lineTo(17, 9) // lower lip/chin
      ..lineTo(15.5, 11) // front neck
      ..close();
    canvas.drawPath(headPath, Paint()..color = skinColor);

    // 5. Hair
    final hairPath = Path()
      ..moveTo(10, 11)
      ..lineTo(10, 5)
      ..lineTo(13, 4)
      ..lineTo(14, 5)
      ..lineTo(12.5, 6.5) // sideburn
      ..lineTo(12, 8)
      ..lineTo(11, 11)
      ..close();
    canvas.drawPath(hairPath, Paint()..color = hairColor);

    // 6. Cap
    canvas.drawArc(
      Rect.fromLTRB(9.5, 2.5, 14.5, 6.5),
      pi,
      pi,
      true,
      Paint()..color = capColor,
    );
    // Cap bottom rim
    canvas.drawLine(
      const Offset(9.5, 4.5),
      const Offset(14.5, 4.5),
      Paint()
        ..color = matColor
        ..strokeWidth = 1.0
        ..strokeCap = StrokeCap.round,
    );

    // 7. Body
    final bodyPath = Path()
      ..moveTo(10, 11) // back shoulder
      ..quadraticBezierTo(7, 16, 7, 27) // back curve
      ..lineTo(21, 27) // bottom line
      ..quadraticBezierTo(24, 27, 23, 24) // knee curve
      ..lineTo(19, 19) // lap
      ..lineTo(14, 19) // waist fold
      ..lineTo(13, 11) // front chest up to collar
      ..close();
    canvas.drawPath(bodyPath, Paint()..color = robeColor);

    // 8. Collar
    canvas.drawLine(
      const Offset(10, 11),
      const Offset(14, 11.5),
      Paint()
        ..color = collarColor
        ..strokeWidth = 2.5
        ..strokeCap = StrokeCap.round,
    );

    // 9. Hand
    final handPath = Path()
      ..moveTo(19.5, 15.5) // wrist top
      ..lineTo(23, 12) // fingertips
      ..quadraticBezierTo(24, 13, 23.5, 14) // curve
      ..lineTo(20.5, 17.5) // wrist bottom
      ..close();
    canvas.drawPath(handPath, Paint()..color = skinColor);
    // Thumb
    canvas.drawCircle(const Offset(21.5, 13.5), 1.0, Paint()..color = skinColor);

    // 10. Arm
    final armPath = Path()
      ..moveTo(11, 12.5) // shoulder
      ..lineTo(13, 20) // elbow
      ..lineTo(20, 16.5); // wrist
    canvas.drawPath(armPath, Paint()
      ..color = sleeveColor
      ..strokeWidth = 3.5
      ..strokeJoin = StrokeJoin.round
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke);

    // 11. Cuff
    canvas.drawLine(
      const Offset(19.5, 15.5),
      const Offset(20.5, 17.5),
      Paint()
        ..color = collarColor
        ..strokeWidth = 1.5
        ..strokeCap = StrokeCap.round,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
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
