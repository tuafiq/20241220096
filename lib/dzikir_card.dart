import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'settings_provider.dart';
import 'wirid_doa_localizations.dart';

class DzikirCard extends StatelessWidget {
  final VoidCallback? onTap;
  const DzikirCard({super.key, this.onTap});

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsProvider>();
    final lang = settings.language;

    return LayoutBuilder(
      builder: (context, constraints) {
        final double availableHeight = constraints.maxHeight;
        final bool isCompact = availableHeight > 0 && availableHeight <= 220;

        Widget cardContent = Container(
          width: double.infinity,
          height: isCompact ? 200 : null,
          decoration: BoxDecoration(
            color: const Color(0xFF052F24),
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.12),
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
                padding: EdgeInsets.only(
                  left: 16,
                  right: 16,
                  top: isCompact ? 8 : 12,
                  bottom: isCompact ? 4 : 8,
                ),
                child: Row(
                  children: [
                    // Left Icon (Tasbih) inside translucent circle
                    Container(
                      width: isCompact ? 28 : 34,
                      height: isCompact ? 28 : 34,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.08),
                        shape: BoxShape.circle,
                        border: Border.all(color: const Color(0xFFFFD700).withOpacity(0.3), width: 1),
                      ),
                      child: Center(
                        child: CustomPaint(
                          size: Size(isCompact ? 16 : 20, isCompact ? 16 : 20),
                          painter: TasbihPainter(),
                        ),
                      ),
                    ),
                    const Spacer(),
                    // Center Title & Ornament
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          WiridDoaLocalizations.translate('Dzikir Harian', lang),
                          style: GoogleFonts.outfit(
                            fontSize: isCompact ? 16 : 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        if (!isCompact) ...[
                          const SizedBox(height: 2),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: 24,
                                height: 0.8,
                                color: const Color(0xFFFFD700).withOpacity(0.3),
                              ),
                              const SizedBox(width: 6),
                              Transform.rotate(
                                angle: pi / 4,
                                child: Container(
                                  width: 4,
                                  height: 4,
                                  color: const Color(0xFFFFD700),
                                ),
                              ),
                              const SizedBox(width: 6),
                              Container(
                                width: 24,
                                height: 0.8,
                                color: const Color(0xFFFFD700).withOpacity(0.3),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            WiridDoaLocalizations.translate('Dekatkan diri kepada Allah setiap hari', lang),
                            style: GoogleFonts.outfit(
                              fontSize: 10,
                              color: Colors.white60,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ],
                    ),
                    const Spacer(),
                    // Right Icon (Reset)
                    GestureDetector(
                      onTap: () {
                        _showResetConfirmation(context, settings);
                      },
                      behavior: HitTestBehavior.opaque,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.refresh_rounded,
                            color: Colors.white70,
                            size: isCompact ? 18 : 22,
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'Reset',
                            style: GoogleFonts.outfit(
                              color: Colors.white70,
                              fontSize: isCompact ? 9 : 10,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // 2. Middle Row (4 counter cards)
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: isCompact ? 2 : 4,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildDhikrCard(
                      context,
                      'subhanallah',
                      'Subhanallah',
                      'سُبْحَانَ اللهِ',
                      settings.countSubhanallah,
                      settings.targetSubhanallah,
                      settings,
                      isCompact,
                    ),
                    _buildDhikrCard(
                      context,
                      'alhamdulillah',
                      'Alhamdulillah',
                      'الْحَمْدُ للهِ',
                      settings.countAlhamdulillah,
                      settings.targetAlhamdulillah,
                      settings,
                      isCompact,
                    ),
                    _buildDhikrCard(
                      context,
                      'allahu_akbar',
                      'Allahu Akbar',
                      'اللهُ أَكْبَرُ',
                      settings.countAllahuAkbar,
                      settings.targetAllahuAkbar,
                      settings,
                      isCompact,
                    ),
                    _buildDhikrCard(
                      context,
                      'astaghfirullah',
                      'Astaghfirullah',
                      'أَسْتَغْفِرُ اللهَ',
                      settings.countAstaghfirullah,
                      settings.targetAstaghfirullah,
                      settings,
                      isCompact,
                    ),
                  ],
                ),
              ),

              if (!isCompact) ...[
                const SizedBox(height: 16),
                // 3. Bottom Panel (Instruction Bar)
                Container(
                  height: 32,
                  margin: const EdgeInsets.only(left: 12, right: 12, bottom: 12),
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.04),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.white.withOpacity(0.05), width: 0.8),
                  ),
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildBottomInfoItem(Icons.touch_app_outlined, WiridDoaLocalizations.translate('Ketuk + untuk menambah', lang)),
                        _buildDotDivider(),
                        _buildBottomInfoItem(Icons.touch_app_outlined, WiridDoaLocalizations.translate('Ketuk - untuk mengurangi', lang)),
                        _buildDotDivider(),
                        _buildBottomInfoItem(Icons.track_changes, WiridDoaLocalizations.translate('Tahan untuk target', lang)),
                      ],
                    ),
                  ),
                ),
              ],
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
      },
    );
  }

  Widget _buildDhikrCard(
    BuildContext context,
    String type,
    String label,
    String calligraphy,
    int count,
    int target,
    SettingsProvider settings,
    bool isCompact,
  ) {

    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        padding: EdgeInsets.symmetric(vertical: isCompact ? 6 : 8, horizontal: 4),
        decoration: BoxDecoration(
          color: const Color(0xFF04241B),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: const Color(0xFF13A884).withOpacity(0.12),
            width: 1.0,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Calligraphy Badge
            GestureDetector(
              onTap: () => settings.incrementDzikir(type),
              child: CalligraphyBadge(text: calligraphy, isCompact: isCompact),
            ),
            SizedBox(height: isCompact ? 4 : 8),

            // Count and Target numbers (enclosing gauge removed)
            GestureDetector(
              onTap: () => settings.incrementDzikir(type),
              onLongPress: () {
                _showSetTargetDialog(context, type, label, target, settings);
              },
              child: SizedBox(
                width: isCompact ? 50 : 60,
                height: isCompact ? 42 : 52,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '$count',
                      style: GoogleFonts.outfit(
                        fontSize: isCompact ? 16 : 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      'Target $target',
                      style: GoogleFonts.outfit(
                        fontSize: isCompact ? 7.5 : 8.5,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFFFFD700).withOpacity(0.8),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: isCompact ? 4 : 8),

            // Dzikir Name Label
            Text(
              WiridDoaLocalizations.translate(label, settings.language),
              style: GoogleFonts.outfit(
                fontSize: isCompact ? 9.5 : 11,
                fontWeight: FontWeight.w600,
                color: Colors.white.withOpacity(0.9),
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: isCompact ? 4 : 8),

            // Pill Incrementor/Decrementor Bar
            Container(
              height: isCompact ? 22 : 26,
              width: isCompact ? 56 : 64,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.06),
                borderRadius: BorderRadius.circular(13),
                border: Border.all(color: Colors.white.withOpacity(0.12), width: 0.8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  GestureDetector(
                    onTap: () {
                      settings.decrementDzikir(type);
                    },
                    behavior: HitTestBehavior.opaque,
                    child: SizedBox(
                      width: isCompact ? 20 : 24,
                      height: isCompact ? 22 : 26,
                      child: Center(
                        child: Icon(Icons.remove, color: Colors.white70, size: isCompact ? 10 : 12),
                      ),
                    ),
                  ),
                  Container(
                    width: 0.8,
                    height: 12,
                    color: Colors.white.withOpacity(0.12),
                  ),
                  GestureDetector(
                    onTap: () {
                      settings.incrementDzikir(type);
                    },
                    behavior: HitTestBehavior.opaque,
                    child: SizedBox(
                      width: isCompact ? 20 : 24,
                      height: isCompact ? 22 : 26,
                      child: Center(
                        child: Icon(Icons.add, color: Colors.white70, size: isCompact ? 10 : 12),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomInfoItem(IconData icon, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: const Color(0xFFFFD700).withOpacity(0.6), size: 12),
        const SizedBox(width: 4),
        Text(
          text,
          style: GoogleFonts.outfit(
            color: Colors.white60,
            fontSize: 9,
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }

  Widget _buildDotDivider() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Container(
        width: 3,
        height: 3,
        decoration: const BoxDecoration(
          color: Colors.white24,
          shape: BoxShape.circle,
        ),
      ),
    );
  }

  void _showResetConfirmation(BuildContext context, SettingsProvider settings) {
    showDialog(
      context: context,
      builder: (context) {
        final isDarkMode = Theme.of(context).brightness == Brightness.dark;
        return AlertDialog(
          backgroundColor: isDarkMode ? const Color(0xFF1E1E1E) : Colors.white,
          title: Text(
            settings.language == 'Inggris' ? 'Reset Counter' : (settings.language == 'Arab' ? 'إعادة ضبط العداد' : 'Reset Hitungan'),
            style: TextStyle(
              color: isDarkMode ? Colors.white : Colors.black87,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          content: Text(
            settings.language == 'Inggris' 
                ? 'Are you sure you want to reset all counts to 0?' 
                : (settings.language == 'Arab' ? 'هل أنت متأكد من إعادة تعيين جميع العدادات إلى ٠؟' : 'Apakah Anda yakin ingin menyetel ulang semua hitungan dzikir ke 0?'),
            style: TextStyle(
              color: isDarkMode ? Colors.white70 : Colors.black54,
              fontSize: 14,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                settings.language == 'Inggris' ? 'Cancel' : (settings.language == 'Arab' ? 'إلغاء' : 'Batal'),
                style: const TextStyle(color: Colors.grey),
              ),
            ),
            TextButton(
              onPressed: () {
                settings.resetDzikirCounts();
                Navigator.pop(context);
              },
              child: Text(
                settings.language == 'Inggris' ? 'Reset' : (settings.language == 'Arab' ? 'إعادة ضبط' : 'Reset'),
                style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showSetTargetDialog(BuildContext context, String type, String displayName, int currentTarget, SettingsProvider settings) {
    final controller = TextEditingController(text: currentTarget.toString());
    showDialog(
      context: context,
      builder: (context) {
        final isDarkMode = Theme.of(context).brightness == Brightness.dark;
        final name = WiridDoaLocalizations.translate(displayName, settings.language);
        return AlertDialog(
          backgroundColor: isDarkMode ? const Color(0xFF1E1E1E) : Colors.white,
          title: Text(
            settings.language == 'Inggris'
                ? 'Set Target for $name'
                : (settings.language == 'Arab' ? 'تعيين الهدف لـ $name' : 'Atur Target $name'),
            style: TextStyle(
              color: isDarkMode ? Colors.white : Colors.black87,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          content: TextField(
            controller: controller,
            keyboardType: TextInputType.number,
            autofocus: true,
            style: TextStyle(color: isDarkMode ? Colors.white : Colors.black87),
            decoration: InputDecoration(
              hintText: 'Masukkan target...',
              hintStyle: TextStyle(color: isDarkMode ? Colors.white30 : Colors.grey),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: const Color(0xFF13A884).withOpacity(0.5)),
              ),
              focusedBorder: const UnderlineInputBorder(
                borderSide: BorderSide(color: Color(0xFF13A884)),
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                settings.language == 'Inggris' ? 'Cancel' : (settings.language == 'Arab' ? 'إلغاء' : 'Batal'),
                style: const TextStyle(color: Colors.grey),
              ),
            ),
            TextButton(
              onPressed: () {
                final target = int.tryParse(controller.text) ?? currentTarget;
                if (target > 0) {
                  settings.setTargetDzikir(type, target);
                }
                Navigator.pop(context);
              },
              child: Text(
                settings.language == 'Inggris' ? 'Save' : (settings.language == 'Arab' ? 'حفظ' : 'Simpan'),
                style: const TextStyle(color: Color(0xFF13A884), fontWeight: FontWeight.bold),
              ),
            ),
          ],
        );
      },
    );
  }
}

class CalligraphyBadge extends StatelessWidget {
  final String text;
  final bool isCompact;
  const CalligraphyBadge({super.key, required this.text, this.isCompact = false});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: OctagonPainter(),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: isCompact ? 4 : 8, vertical: isCompact ? 3 : 5),
        child: Text(
          text,
          style: GoogleFonts.amiri(
            color: const Color(0xFFFFD700), // bright gold
            fontSize: isCompact ? 9 : 10,
            fontWeight: FontWeight.bold,
          ),
          maxLines: 1,
        ),
      ),
    );
  }
}

class OctagonPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFFFD700).withOpacity(0.6)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.8;

    final double w = size.width;
    final double h = size.height;
    final double inset = 4.0; // corner inset

    final path = Path()
      ..moveTo(inset, 0)
      ..lineTo(w - inset, 0)
      ..lineTo(w, inset)
      ..lineTo(w, h - inset)
      ..lineTo(w - inset, h)
      ..lineTo(inset, h)
      ..lineTo(0, h - inset)
      ..lineTo(0, inset)
      ..close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class TasbihPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFFFD700)
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
      ..color = const Color(0xFFFFD700)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;
    canvas.drawLine(Offset(radius, radius * 2 - 3), Offset(radius, radius * 2 + 1), tasselPaint);
    canvas.drawCircle(Offset(radius, radius * 2 + 2), beadRadius, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}


