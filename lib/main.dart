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

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Warna hijau dasar seperti pada gambar
      backgroundColor: const Color(0xFF13A884),
      body: Stack(
        children: [
          // Latar belakang putih dengan bentuk kubah (dome) di bagian atas
          Positioned.fill(
            child: ClipPath(
              clipper: DomeClipper(),
              child: Container(
                color: Colors.white,
                // Konten aplikasi selanjutnya akan ditambahkan di sini
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// CustomClipper untuk membuat bentuk lengkungan masjid yang presisi
class DomeClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    double w = size.width;
    double h = size.height;
    
    // Titik referensi Y (atur tinggi kubah di sini)
    double baseY = h * 0.28; 
    double tipY = h * 0.08;
    double hDiff = baseY - tipY;
    
    // Titik koordinat X dan Y untuk sudut-sudut tajam ke dalam (inward corners)
    // Proporsi ini disesuaikan untuk membentuk 2 lengkungan di sisi + 1 pucuk kubah
    double p1x = w * 0.16;
    double p1y = baseY - hDiff * 0.25;
    
    double p2x = w * 0.33;
    double p2y = baseY - hDiff * 0.65;
    
    double p3x = w * 0.5;
    double p3y = tipY;

    // Titik simetris untuk sebelah kanan
    double p2x_r = w - p2x;
    double p1x_r = w - p1x;
    
    path.moveTo(0, baseY);
    
    // 1. Lengkungan Kiri Bawah (Lobe 1)
    // Melengkung keluar (bulge out) ke arah titik sudut pertama (p1)
    path.quadraticBezierTo(
      0, p1y, 
      p1x, p1y
    );
    
    // 2. Lengkungan Kiri Tengah (Lobe 2)
    // Melengkung keluar lagi menuju titik sudut kedua (p2)
    path.quadraticBezierTo(
      p1x, p2y, 
      p2x, p2y
    );
    
    // 3. Lengkungan Kiri Atas menuju Puncak (Lobe 3)
    // Membentuk kurva Ogee (khas kubah masjid) yang meruncing ke ujung
    path.cubicTo(
      p2x, p3y + hDiff * 0.1, 
      p3x - w * 0.05, p3y + hDiff * 0.1, 
      p3x, p3y
    );
    
    // 4. Lengkungan Kanan Atas turun dari Puncak
    // Simetris dari lengkungan kiri atas
    path.cubicTo(
      p3x + w * 0.05, p3y + hDiff * 0.1, 
      p2x_r, p3y + hDiff * 0.1, 
      p2x_r, p2y
    );
    
    // 5. Lengkungan Kanan Tengah (Lobe 2 Kanan)
    path.quadraticBezierTo(
      p1x_r, p2y, 
      p1x_r, p1y
    );
    
    // 6. Lengkungan Kanan Bawah (Lobe 1 Kanan)
    path.quadraticBezierTo(
      w, p1y, 
      w, baseY
    );
    
    // Menutup shape ke bawah layar hingga menutupi seluruh background
    path.lineTo(w, h);
    path.lineTo(0, h);
    path.close();
    
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => true;
}
