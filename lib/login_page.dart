import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'settings_provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _obscurePassword = true;
  bool _autoLogin = true;
  bool _isLoading = false;
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  late FocusNode _usernameFocusNode;
  late FocusNode _passwordFocusNode;

  @override
  void initState() {
    super.initState();
    _usernameFocusNode = FocusNode()..addListener(() => setState(() {}));
    _passwordFocusNode = FocusNode()..addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    _usernameFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  void _handleMockLogin() async {
    setState(() {
      _isLoading = true;
    });
    // Simulasi delay jaringan (Mock Login)
    await Future.delayed(const Duration(seconds: 2));
    if (mounted) {
      String input = _usernameController.text.trim();
      if (input.isEmpty) {
        input = 'Pengguna';
      }
      
      String email = '';
      String name = '';
      if (input.contains('@')) {
         email = input;
         name = input.split('@')[0];
      } else {
         name = input;
         email = '${input.toLowerCase().replaceAll(' ', '')}@gmail.com';
      }
      
      final settings = Provider.of<SettingsProvider>(context, listen: false);
      await settings.login(name, email);
      
      setState(() {
        _isLoading = false;
      });
      // Mengembalikan nilai 'true' sebagai tanda berhasil login
      Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        leadingWidth: 72,
        leading: Padding(
          padding: const EdgeInsets.only(left: 20),
          child: Center(
            child: IconButton(
              padding: EdgeInsets.zero,
              icon: Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: const Color(0xFFECEFF1), width: 1.5),
                ),
                child: const Icon(Icons.close, color: Colors.black54, size: 16),
              ),
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ),
        title: Text(
          'accounts.mdonline.id',
          style: GoogleFonts.outfit(
            color: Colors.black,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 30),
            
            // Logo Section
            Center(
              child: Image.asset(
                'assets/images/logo_el_maqam.png',
                height: 160,
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(height: 50),
            
            // Username Field
            TextField(
              controller: _usernameController,
              focusNode: _usernameFocusNode,
              decoration: InputDecoration(
                hintText: 'Nama pengguna, Email atau no. HP',
                hintStyle: GoogleFonts.outfit(color: Colors.grey.shade400, fontSize: 15),
                prefixIcon: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: _usernameFocusNode.hasFocus ? const Color(0xFFE8F6F3) : const Color(0xFFF5F5F5),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.person_outline,
                      color: _usernameFocusNode.hasFocus ? const Color(0xFF0A9B75) : Colors.grey.shade400,
                      size: 20,
                    ),
                  ),
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 18),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: const BorderSide(color: Color(0xFFECEFF1), width: 1.5),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: const BorderSide(color: Color(0xFFECEFF1), width: 1.5),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: const BorderSide(color: Color(0xFF0A9B75), width: 1.5),
                ),
              ),
            ),
            const SizedBox(height: 16),
            
            // Password Field
            TextField(
              controller: _passwordController,
              focusNode: _passwordFocusNode,
              obscureText: _obscurePassword,
              decoration: InputDecoration(
                hintText: 'Kata sandi',
                hintStyle: GoogleFonts.outfit(color: Colors.grey.shade400, fontSize: 15),
                prefixIcon: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: _passwordFocusNode.hasFocus ? const Color(0xFFE8F6F3) : const Color(0xFFF5F5F5),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.lock_outline,
                      color: _passwordFocusNode.hasFocus ? const Color(0xFF0A9B75) : Colors.grey.shade400,
                      size: 20,
                    ),
                  ),
                ),
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscurePassword ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                    color: Colors.grey.shade400,
                    size: 20,
                  ),
                  onPressed: () {
                    setState(() {
                      _obscurePassword = !_obscurePassword;
                    });
                  },
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 18),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: const BorderSide(color: Color(0xFFECEFF1), width: 1.5),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: const BorderSide(color: Color(0xFFECEFF1), width: 1.5),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: const BorderSide(color: Color(0xFF0A9B75), width: 1.5),
                ),
              ),
            ),
            const SizedBox(height: 16),
            
            // Auto Login & Forgot Password
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Theme(
                      data: ThemeData(
                        checkboxTheme: CheckboxThemeData(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                      ),
                      child: Checkbox(
                        value: _autoLogin,
                        activeColor: const Color(0xFF0A9B75),
                        onChanged: (value) {
                          setState(() {
                            _autoLogin = value ?? true;
                          });
                        },
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _autoLogin = !_autoLogin;
                        });
                      },
                      child: Text(
                        'Masuk otomatis',
                        style: GoogleFonts.outfit(
                          fontSize: 14,
                          color: Colors.black87,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
                TextButton(
                  onPressed: () {},
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: Text(
                    'Lupa kata sandi?',
                    style: GoogleFonts.outfit(
                      color: const Color(0xFF0A9B75),
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            
            // Login Button
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _handleMockLogin,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0A9B75),
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: _isLoading
                    ? const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2.5,
                        ),
                      )
                    : Text(
                        'Masuk',
                        style: GoogleFonts.outfit(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),
            ),
            const SizedBox(height: 20),
            
            // Register Link
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Tidak memiliki akun? ',
                  style: GoogleFonts.outfit(
                    color: Colors.black87,
                    fontSize: 14,
                  ),
                ),
                GestureDetector(
                  onTap: () {},
                  child: Text(
                    'Daftar sekarang',
                    style: GoogleFonts.outfit(
                      color: const Color(0xFF0A9B75),
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 40),
            
            // Or Divider
            Row(
              children: [
                Expanded(
                  child: Divider(
                    color: Colors.grey.shade200,
                    thickness: 1.5,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    'atau',
                    style: GoogleFonts.outfit(
                      color: Colors.grey.shade400,
                      fontSize: 14,
                    ),
                  ),
                ),
                Expanded(
                  child: Divider(
                    color: Colors.grey.shade200,
                    thickness: 1.5,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            
            // Google Login Button
            SizedBox(
              width: double.infinity,
              height: 56,
              child: OutlinedButton(
                onPressed: _isLoading ? null : _handleMockLogin,
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Color(0xFFECEFF1), width: 1.5),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  backgroundColor: Colors.white,
                  elevation: 0,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const GoogleSignInLogo(size: 18),
                    const SizedBox(width: 12),
                    Text(
                      'Masuk dengan Google',
                      style: GoogleFonts.outfit(
                        color: Colors.black87,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class GoogleSignInLogo extends StatelessWidget {
  final double size;
  const GoogleSignInLogo({super.key, this.size = 20});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _GoogleLogoPainter(),
      ),
    );
  }
}

class _GoogleLogoPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final double r = size.width / 2;
    final Offset center = Offset(r, r);
    final double strokeWidth = r * 0.45;
    final double pathRadius = r - (strokeWidth / 2);

    final Rect arcRect = Rect.fromCircle(center: center, radius: pathRadius);

    final Paint paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;

    // Red arc (top)
    paint.color = const Color(0xFFEA4335);
    canvas.drawArc(arcRect, -2.35, 1.57, false, paint);

    // Blue arc (right & horizontal bar)
    paint.color = const Color(0xFF4285F4);
    canvas.drawArc(arcRect, -0.78, 0.78, false, paint);
    
    // Draw horizontal bar of the G
    final Paint barPaint = Paint()
      ..color = const Color(0xFF4285F4)
      ..style = PaintingStyle.fill;
    final double barWidth = r;
    final double barHeight = strokeWidth;
    canvas.drawRect(
      Rect.fromLTWH(center.dx, center.dy - (barHeight / 2), barWidth, barHeight),
      barPaint,
    );

    // Green arc (bottom)
    paint.color = const Color(0xFF34A853);
    canvas.drawArc(arcRect, 0.0, 2.35, false, paint);

    // Yellow arc (left)
    paint.color = const Color(0xFFFBBC05);
    canvas.drawArc(arcRect, 2.35, 1.57, false, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
