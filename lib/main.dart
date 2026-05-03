import 'package:flutter/material.dart';
import 'dart:math';

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
  String _selectedCity = 'Pamekasan, Kabupaten Pamekasan';

  void _showCitySelectionDialog() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return _CitySelectionSheet(
          cities: indonesiaCities,
          onCitySelected: (String city) {
            setState(() {
              _selectedCity = city;
            });
            Navigator.pop(context);
          },
        );
      },
    );
  }

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
                            const SizedBox(height: 8),
                            _buildLocationRow(),
                            const SizedBox(height: 32),
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

  Widget _buildLocationRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(
          Icons.location_on,
          color: Color(0xFFD32F2F),
          size: 16,
        ),
        const SizedBox(width: 4),
        Flexible(
          child: Text(
            _selectedCity,
            style: const TextStyle(
              fontSize: 13,
              color: Color(0xFF757575),
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        const SizedBox(width: 4),
        GestureDetector(
          onTap: _showCitySelectionDialog,
          child: const Text(
            '(Ganti)',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: Color(0xFF13A884),
            ),
          ),
        ),
      ],
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
// Kiblat icons created by Fahrul Oktaviana - Flaticon (https://www.flaticon.com/free-icons/kiblat)
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
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: const Color(0xFFF4F4F4),
                shape: BoxShape.circle,
                border: Border.all(
                  color: const Color(0xFF13A884),
                  width: 2.5,
                ),
              ),
              child: CustomPaint(
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
    final Paint paint = Paint()..style = PaintingStyle.fill;

    // Draw Red Compass Marks
    final Paint linePaint = Paint()
      ..color = const Color(0xFFFF4747)
      ..strokeWidth = 2.0
      ..strokeCap = StrokeCap.round;

    final double cx = size.width / 2;
    final double cy = size.height / 2;

    // Draw 7 dashes
    final List<double> angles = [0, 45, 90, 135, 180, 225, 315];
    for (var angle in angles) {
      final double rad = angle * pi / 180;
      final double innerRadius = 12.0;
      final double outerRadius = 14.0;
      canvas.drawLine(
        Offset(cx + innerRadius * cos(rad), cy + innerRadius * sin(rad)),
        Offset(cx + outerRadius * cos(rad), cy + outerRadius * sin(rad)),
        linePaint,
      );
    }

    // Draw Red Triangle at Top (270 degrees)
    final Path trianglePath = Path()
      ..moveTo(cx, 3)
      ..lineTo(cx - 3, 8)
      ..lineTo(cx + 3, 8)
      ..close();
    paint.color = const Color(0xFFFF4747);
    canvas.drawPath(trianglePath, paint);

    // Top face (Dark grey)
    final Path topFace = Path()
      ..moveTo(18, 9)
      ..lineTo(10, 13)
      ..lineTo(18, 17)
      ..lineTo(26, 13)
      ..close();
    paint.color = const Color(0xFF4A4A4A);
    canvas.drawPath(topFace, paint);

    // Left face (Light grey)
    final Path leftFace = Path()
      ..moveTo(10, 13)
      ..lineTo(10, 23)
      ..lineTo(18, 27)
      ..lineTo(18, 17)
      ..close();
    paint.color = const Color(0xFFB4B4B4);
    canvas.drawPath(leftFace, paint);

    // Right face (Black / Very dark grey)
    final Path rightFace = Path()
      ..moveTo(26, 13)
      ..lineTo(26, 23)
      ..lineTo(18, 27)
      ..lineTo(18, 17)
      ..close();
    paint.color = const Color(0xFF333333);
    canvas.drawPath(rightFace, paint);

    // Right Face Yellow Band
    final Path rightBand = Path()
      ..moveTo(26, 16)
      ..lineTo(18, 20)
      ..lineTo(18, 22)
      ..lineTo(26, 18)
      ..close();
    paint.color = const Color(0xFFFFD700);
    canvas.drawPath(rightBand, paint);

    // Left Face Door
    final Path door = Path()
      ..moveTo(17, 26.5)
      ..lineTo(13, 24.5)
      ..lineTo(13, 19)
      ..lineTo(17, 21)
      ..close();
    paint.color = const Color(0xFFFFD700);
    canvas.drawPath(door, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

// ─────────────────────────────────────────────────────────────
// ICON 5: TAHLIL & YASIN
// Worship icons created by ariyantodeni - Flaticon (https://www.flaticon.com/free-icons/worship)
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
          padding: const EdgeInsets.all(8),
          child: Image.asset(
            'assets/images/tahlil_icon.png',
            fit: BoxFit.contain,
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

// ─────────────────────────────────────────────────────────────
// ICON 6: MAULID
// Eid mubarak icons created by mnauliady - Flaticon (https://www.flaticon.com/free-icons/eid-mubarak)
// ─────────────────────────────────────────────────────────────
class MaulidIcon extends StatelessWidget {
  const MaulidIcon({super.key});

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
            'assets/images/maulid_icon.png',
            fit: BoxFit.contain,
          ),
        ),
        const SizedBox(height: 5),
        const Text(
          'Maulid',
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
// ICON 7: ZAKAT
// Zakat icons created by Freepik - Flaticon (https://www.flaticon.com/free-icons/zakat)
// ─────────────────────────────────────────────────────────────
class ZakatIcon extends StatelessWidget {
  const ZakatIcon({super.key});

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
            'assets/images/zakat_icon.png',
            fit: BoxFit.contain,
          ),
        ),
        const SizedBox(height: 5),
        const Text(
          'Zakat',
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
// ICON 8: LAINNYA
// More icons created by Pixel perfect - Flaticon (https://www.flaticon.com/free-icons/more)
// ─────────────────────────────────────────────────────────────
class LainnyaIcon extends StatelessWidget {
  const LainnyaIcon({super.key});

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
            child: SizedBox(
              width: 36,
              height: 36,
              child: CustomPaint(
                painter: MoreIconPainter(),
              ),
            ),
          ),
        ),
        const SizedBox(height: 5),
        const Text(
          'Lainnya',
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

class MoreIconPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()..style = PaintingStyle.fill;
    
    // Left half of background
    paint.color = const Color(0xFF50A855);
    canvas.drawArc(
      Rect.fromLTWH(0, 0, size.width, size.height),
      pi / 2,
      pi,
      true,
      paint,
    );

    // Right half of background
    paint.color = const Color(0xFF429147);
    canvas.drawArc(
      Rect.fromLTWH(0, 0, size.width, size.height),
      -pi / 2,
      pi,
      true,
      paint,
    );

    // The three dots
    final double dotRadius = size.width * 0.13;
    final double spacing = size.width * 0.32;
    final double cy = size.height / 2;

    for (int i = -1; i <= 1; i++) {
      final double cx = size.width / 2 + (i * spacing);
      
      // Left half of dot
      paint.color = const Color(0xFFE0E0E0);
      canvas.drawArc(
        Rect.fromCircle(center: Offset(cx, cy), radius: dotRadius),
        pi / 2,
        pi,
        true,
        paint,
      );

      // Right half of dot
      paint.color = Colors.white;
      canvas.drawArc(
        Rect.fromCircle(center: Offset(cx, cy), radius: dotRadius),
        -pi / 2,
        pi,
        true,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
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

const List<String> indonesiaCities = [
  'Ambon, Kota Ambon',
  'Balikpapan, Kota Balikpapan',
  'Banda Aceh, Kota Banda Aceh',
  'Bandar Lampung, Kota Bandar Lampung',
  'Bandung, Kabupaten Bandung',
  'Bandung, Kota Bandung',
  'Bangkalan, Kabupaten Bangkalan',
  'Banjar, Kota Banjar',
  'Banjarmasin, Kota Banjarmasin',
  'Banyuwangi, Kabupaten Banyuwangi',
  'Batam, Kota Batam',
  'Batu, Kota Batu',
  'Bekasi, Kabupaten Bekasi',
  'Bekasi, Kota Bekasi',
  'Bengkulu, Kota Bengkulu',
  'Bima, Kota Bima',
  'Binjai, Kota Binjai',
  'Bitung, Kota Bitung',
  'Blitar, Kabupaten Blitar',
  'Blitar, Kota Blitar',
  'Bogor, Kabupaten Bogor',
  'Bogor, Kota Bogor',
  'Bojonegoro, Kabupaten Bojonegoro',
  'Bondowoso, Kabupaten Bondowoso',
  'Bontang, Kota Bontang',
  'Bukittinggi, Kota Bukittinggi',
  'Cianjur, Kabupaten Cianjur',
  'Cilegon, Kota Cilegon',
  'Cimahi, Kota Cimahi',
  'Cirebon, Kabupaten Cirebon',
  'Cirebon, Kota Cirebon',
  'Denpasar, Kota Denpasar',
  'Depok, Kota Depok',
  'Dumai, Kota Dumai',
  'Garut, Kabupaten Garut',
  'Gorontalo, Kota Gorontalo',
  'Gresik, Kabupaten Gresik',
  'Jakarta Barat, Kota Jakarta Barat',
  'Jakarta Pusat, Kota Jakarta Pusat',
  'Jakarta Selatan, Kota Jakarta Selatan',
  'Jakarta Timur, Kota Jakarta Timur',
  'Jakarta Utara, Kota Jakarta Utara',
  'Jambi, Kota Jambi',
  'Jayapura, Kota Jayapura',
  'Jember, Kabupaten Jember',
  'Jombang, Kabupaten Jombang',
  'Kediri, Kabupaten Kediri',
  'Kediri, Kota Kediri',
  'Kendari, Kota Kendari',
  'Kupang, Kota Kupang',
  'Lamongan, Kabupaten Lamongan',
  'Lhokseumawe, Kota Lhokseumawe',
  'Lubuklinggau, Kota Lubuklinggau',
  'Lumajang, Kabupaten Lumajang',
  'Madiun, Kabupaten Madiun',
  'Madiun, Kota Madiun',
  'Magelang, Kota Magelang',
  'Makassar, Kota Makassar',
  'Malang, Kabupaten Malang',
  'Malang, Kota Malang',
  'Manado, Kota Manado',
  'Mataram, Kota Mataram',
  'Medan, Kota Medan',
  'Mojokerto, Kabupaten Mojokerto',
  'Mojokerto, Kota Mojokerto',
  'Nganjuk, Kabupaten Nganjuk',
  'Ngawi, Kabupaten Ngawi',
  'Pacitan, Kabupaten Pacitan',
  'Padang, Kota Padang',
  'Palangka Raya, Kota Palangka Raya',
  'Palembang, Kota Palembang',
  'Palu, Kota Palu',
  'Pamekasan, Kabupaten Pamekasan',
  'Pangkalpinang, Kota Pangkalpinang',
  'Parepare, Kota Parepare',
  'Pasuruan, Kabupaten Pasuruan',
  'Pasuruan, Kota Pasuruan',
  'Pekalongan, Kota Pekalongan',
  'Pekanbaru, Kota Pekanbaru',
  'Pematangsiantar, Kota Pematangsiantar',
  'Pontianak, Kota Pontianak',
  'Ponorogo, Kabupaten Ponorogo',
  'Probolinggo, Kabupaten Probolinggo',
  'Probolinggo, Kota Probolinggo',
  'Purwokerto, Kabupaten Banyumas',
  'Salatiga, Kota Salatiga',
  'Samarinda, Kota Samarinda',
  'Sampang, Kabupaten Sampang',
  'Semarang, Kota Semarang',
  'Serang, Kota Serang',
  'Sidoarjo, Kabupaten Sidoarjo',
  'Situbondo, Kabupaten Situbondo',
  'Sorong, Kota Sorong',
  'Sukabumi, Kota Sukabumi',
  'Sumenep, Kabupaten Sumenep',
  'Surabaya, Kota Surabaya',
  'Surakarta, Kota Surakarta',
  'Tangerang Selatan, Kota Tangerang Selatan',
  'Tangerang, Kabupaten Tangerang',
  'Tangerang, Kota Tangerang',
  'Tanjungpinang, Kota Tanjungpinang',
  'Tarakan, Kota Tarakan',
  'Tasikmalaya, Kota Tasikmalaya',
  'Tegal, Kota Tegal',
  'Ternate, Kota Ternate',
  'Tuban, Kabupaten Tuban',
  'Tulungagung, Kabupaten Tulungagung',
  'Yogyakarta, Kota Yogyakarta',
];

class _CitySelectionSheet extends StatefulWidget {
  final List<String> cities;
  final Function(String) onCitySelected;

  const _CitySelectionSheet({
    required this.cities,
    required this.onCitySelected,
  });

  @override
  State<_CitySelectionSheet> createState() => _CitySelectionSheetState();
}

class _CitySelectionSheetState extends State<_CitySelectionSheet> {
  String _searchQuery = '';
  late List<String> _filteredCities;

  @override
  void initState() {
    super.initState();
    _filteredCities = widget.cities;
  }

  void _filterCities(String query) {
    setState(() {
      _searchQuery = query;
      _filteredCities = widget.cities
          .where((city) => city.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        top: 16,
        left: 16,
        right: 16,
      ),
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.7,
        child: Column(
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Pilih Kota/Kabupaten',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              onChanged: _filterCities,
              decoration: InputDecoration(
                hintText: 'Cari kota atau kabupaten...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 0),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: _filteredCities.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(_filteredCities[index]),
                    onTap: () => widget.onCitySelected(_filteredCities[index]),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

