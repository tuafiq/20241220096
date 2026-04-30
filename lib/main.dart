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
      backgroundColor: const Color(0xFF13A884),
      body: Stack(
        children: [
          Positioned.fill(
            child: ClipPath(
              clipper: DomeClipper(),
              child: Container(
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: const Color(0xFF13A884),
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
    path.quadraticBezierTo(
      0, p1y, 
      p1x, p1y
    );
    path.quadraticBezierTo(
      p1x, p2y, 
      p2x, p2y
    );
    path.cubicTo(
      p2x, p3y + hDiff * 0.1, 
      p3x - w * 0.05, p3y + hDiff * 0.1, 
      p3x, p3y
    );
    path.cubicTo(
      p3x + w * 0.05, p3y + hDiff * 0.1, 
      p2x_r, p3y + hDiff * 0.1, 
      p2x_r, p2y
    );
    path.quadraticBezierTo(
      p1x_r, p2y, 
      p1x_r, p1y
    );
    path.quadraticBezierTo(
      w, p1y, 
      w, baseY
    );
    path.lineTo(w, h);
    path.lineTo(0, h);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => true;
}
