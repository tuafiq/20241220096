import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'settings_provider.dart';

class DzikirCard extends StatelessWidget {
  final VoidCallback? onTap;
  const DzikirCard({super.key, this.onTap});

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsProvider>();

    Widget cardContent = Container(
      width: double.infinity,
      height: 200,
      decoration: BoxDecoration(
        color: const Color(0xFF0C5441),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // 1. Top Bar
          Padding(
            padding: const EdgeInsets.only(left: 16, right: 16, top: 12, bottom: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Left Icon (Tasbih) inside translucent circle
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.15),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: CustomPaint(
                      size: const Size(18, 18),
                      painter: TasbihPainter(),
                    ),
                  ),
                ),
                // Center Title
                Text(
                  'Dzikir Harian',
                  style: GoogleFonts.outfit(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                // Right Icon (Refresh) inside translucent circle
                GestureDetector(
                  onTap: settings.resetDzikirCounts,
                  behavior: HitTestBehavior.opaque,
                  child: Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.15),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.refresh_rounded,
                      color: Colors.white,
                      size: 18,
                    ),
                  ),
                ),
              ],
            ),
          ),
          // 2. Middle Row (4 counters)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildDhikrCircle(
                  'Subhanallah',
                  settings.countSubhanallah,
                  33,
                  () => settings.incrementDzikir('subhanallah'),
                ),
                _buildDhikrCircle(
                  'Alhamdulillah',
                  settings.countAlhamdulillah,
                  33,
                  () => settings.incrementDzikir('alhamdulillah'),
                ),
                _buildDhikrCircle(
                  'Allahu Akbar',
                  settings.countAllahuAkbar,
                  33,
                  () => settings.incrementDzikir('allahu_akbar'),
                ),
                _buildDhikrCircle(
                  'Astaghfirullah',
                  settings.countAstaghfirullah,
                  33,
                  () => settings.incrementDzikir('astaghfirullah'),
                ),
              ],
            ),
          ),
          const Spacer(),
          // 3. Bottom Panel (Inset Card with Quote & Lantern)
          Container(
            height: 56,
            margin: const EdgeInsets.only(left: 12, right: 12, bottom: 12),
            decoration: BoxDecoration(
              color: const Color(0xFF084435),
              borderRadius: BorderRadius.circular(16),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Stack(
                children: [
                  // Subtle mosque/islamic pattern background image for depth if available
                  Positioned.fill(
                    child: Opacity(
                      opacity: 0.08,
                      child: Image.asset(
                        'assets/images/islamic_pattern_bg.png',
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => const SizedBox(),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Row(
                      children: [
                        Icon(
                          Icons.format_quote_rounded,
                          color: Colors.white.withOpacity(0.5),
                          size: 18,
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            'Ingatlah Allah, hati menjadi tenang. (QS. Ar-Ra\'d : 28)',
                            style: GoogleFonts.outfit(
                              color: Colors.white.withOpacity(0.9),
                              fontSize: 10.5,
                              fontWeight: FontWeight.w400,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        // Mosque lantern illustration on the right
                        SizedBox(
                          width: 24,
                          height: 36,
                          child: CustomPaint(
                            painter: LanternPainter(),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );

    if (onTap != null) {
      return GestureDetector(
        onTap: onTap,
        child: cardContent,
      );
    }
    return cardContent;
  }

  Widget _buildDhikrCircle(String label, int count, int maxCount, VoidCallback onTap) {
    double progress = count / maxCount;
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                width: 44,
                height: 44,
                child: CircularProgressIndicator(
                  value: progress,
                  strokeWidth: 3.5,
                  backgroundColor: Colors.white.withOpacity(0.15),
                  valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              ),
              Text(
                '$count',
                style: GoogleFonts.outfit(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            label,
            style: GoogleFonts.outfit(
              fontSize: 10,
              fontWeight: FontWeight.w500,
              color: Colors.white.withOpacity(0.9),
            ),
          ),
        ],
      ),
    );
  }
}

class TasbihPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;
    final double radius = size.width / 2;
    final double beadRadius = 1.5;
    final int beadCount = 18;
    for (int i = 0; i < beadCount; i++) {
      final double angle = (i * 2 * pi / beadCount) - pi / 2;
      final double x = radius + (radius - 3) * cos(angle);
      final double y = radius + (radius - 3) * sin(angle);
      canvas.drawCircle(Offset(x, y), beadRadius, paint);
    }
    // Small tassel at bottom
    final tasselPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;
    canvas.drawLine(Offset(radius, radius * 2 - 3), Offset(radius, radius * 2 + 1), tasselPaint);
    canvas.drawCircle(Offset(radius, radius * 2 + 2), beadRadius, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class LanternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFE2F0D9)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;
    final fillPaint = Paint()
      ..color = const Color(0xFFE2F0D9).withOpacity(0.15)
      ..style = PaintingStyle.fill;
    
    final double w = size.width;
    final double h = size.height;
    
    final path = Path();
    
    // Top dome cap
    path.moveTo(w / 2, 2);
    path.quadraticBezierTo(w / 2 - 5, 8, w / 2 - 7, 12);
    path.lineTo(w / 2 + 7, 12);
    path.quadraticBezierTo(w / 2 + 5, 8, w / 2, 2);
    
    // Main lantern body outline
    path.moveTo(w / 2 - 7, 12);
    path.lineTo(w / 2 - 11, 24);
    path.quadraticBezierTo(w / 2 - 11, 32, w / 2 - 7, h - 8);
    path.lineTo(w / 2 + 7, h - 8);
    path.quadraticBezierTo(w / 2 + 11, 32, w / 2 + 11, 24);
    path.lineTo(w / 2 + 7, 12);
    
    // Base cap
    path.moveTo(w / 2 - 7, h - 8);
    path.lineTo(w / 2 - 9, h - 2);
    path.lineTo(w / 2 + 9, h - 2);
    path.lineTo(w / 2 + 7, h - 8);
    
    canvas.drawPath(path, fillPaint);
    canvas.drawPath(path, paint);
    
    // Glass panes inner dividers
    canvas.drawLine(Offset(w / 2, 12), Offset(w / 2, h - 8), paint);
    canvas.drawLine(Offset(w / 2 - 4, 16), Offset(w / 2 - 3, h - 8), paint);
    canvas.drawLine(Offset(w / 2 + 4, 16), Offset(w / 2 + 3, h - 8), paint);
    
    // Small glowing flame circle in the center
    final flamePaint = Paint()
      ..color = const Color(0xFFFFF2CC)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(Offset(w / 2, h / 2 + 2), 3.5, flamePaint);
    
    // Glow effect
    final glowPaint = Paint()
      ..color = const Color(0xFFFFF2CC).withOpacity(0.3)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(Offset(w / 2, h / 2 + 2), 7, glowPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
