import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:audioplayers/audioplayers.dart';
import 'dart:ui';
import 'dart:math';
import 'package:provider/provider.dart';
import 'settings_provider.dart';
import 'doa_data.dart';
import 'yasin_data.dart';

class TahlilYasinPage extends StatefulWidget {
  final int initialIndex;
  const TahlilYasinPage({super.key, this.initialIndex = 0});

  @override
  State<TahlilYasinPage> createState() => _TahlilYasinPageState();
}

class _TahlilYasinPageState extends State<TahlilYasinPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _isPlaying = false;
  Duration _duration = Duration.zero;
  Duration _position = Duration.zero;
  final String _audioUrl = 'https://server8.mp3quran.net/afs/036.mp3';

  final ScrollController _tahlilScrollController = ScrollController();
  final ScrollController _yasinScrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this, initialIndex: widget.initialIndex);

    // Audio Player Listeners
    _audioPlayer.onPlayerStateChanged.listen((state) {
      if (mounted) {
        setState(() {
          _isPlaying = state == PlayerState.playing;
        });
      }
    });

    _audioPlayer.onDurationChanged.listen((newDuration) {
      if (mounted) {
        setState(() {
          _duration = newDuration;
        });
      }
    });

    _audioPlayer.onPositionChanged.listen((newPosition) {
      if (mounted) {
        setState(() {
          _position = newPosition;
        });
      }
    });

    _audioPlayer.onPlayerComplete.listen((event) {
      if (mounted) {
        setState(() {
          _position = Duration.zero;
          _isPlaying = false;
        });
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _audioPlayer.dispose();
    _tahlilScrollController.dispose();
    _yasinScrollController.dispose();
    super.dispose();
  }

  Future<void> _toggleAudio() async {
    try {
      if (_isPlaying) {
        await _audioPlayer.pause();
      } else {
        await _audioPlayer.play(UrlSource(_audioUrl));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Gagal memutar audio. Pastikan koneksi internet aktif.')),
        );
      }
    }
  }

  Future<void> _replayAudio() async {
    try {
      await _audioPlayer.stop();
      await _audioPlayer.play(UrlSource(_audioUrl));
    } catch (e) {
      // Handle error
    }
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return "$minutes:$seconds";
  }

  void _navigateToBookmark(String title) {
    if (title.startsWith('Yasin Ayat ')) {
      // Switch to Yasin Tab
      _tabController.animateTo(1);
      final numStr = title.replaceAll('Yasin Ayat ', '');
      final idx = YasinData.verses.indexWhere((v) => v.number.toString() == numStr);
      if (idx >= 0) {
        Future.delayed(const Duration(milliseconds: 300), () {
          if (_yasinScrollController.hasClients) {
            _yasinScrollController.animateTo(
              idx * 220.0,
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeInOut,
            );
          }
        });
      }
    } else {
      // Switch to Tahlil Tab
      _tabController.animateTo(0);
      final idx = DoaData.listTahlil.indexWhere((item) => item.title == title);
      if (idx >= 0) {
        Future.delayed(const Duration(milliseconds: 300), () {
          if (_tahlilScrollController.hasClients) {
            _tahlilScrollController.animateTo(
              idx * 300.0,
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeInOut,
            );
          }
        });
      }
    }
  }

  void _showSettingsPopover(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    const primaryColor = Color(0xFF13A884);
    
    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.3),
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          backgroundColor: isDarkMode ? const Color(0xFF1E1E1E) : Colors.white,
          child: Container(
            width: double.infinity,
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.75,
            ),
            padding: const EdgeInsets.all(20.0),
            child: StatefulBuilder(
              builder: (context, setPopupState) {
                final settings = Provider.of<SettingsProvider>(context);
                final isDark = Theme.of(context).brightness == Brightness.dark;
                final textColor = isDark ? Colors.white : Colors.black87;
                final subtitleColor = isDark ? Colors.white70 : Colors.black54;
                final boxBgColor = isDark ? const Color(0xFF2C2C2C) : Colors.grey[100];
                
                // Get bookmarks
                final bookmarks = settings.bookmarkedDoas.where((title) {
                  final isTahlil = DoaData.listTahlil.any((item) => item.title == title);
                  final isYasin = title.startsWith('Yasin Ayat ');
                  return isTahlil || isYasin;
                }).toList();

                final isOnlyArab = !settings.showTransliterasi && !settings.showTerjemah;

                return SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Header Row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Pengaturan Tampilan',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: textColor,
                            ),
                          ),
                          IconButton(
                            icon: Icon(Icons.close, size: 20, color: isDark ? Colors.white54 : Colors.grey),
                            onPressed: () => Navigator.pop(context),
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      // 1. Theme Selection
                      Text(
                        'Mode Layar',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                          color: primaryColor,
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            child: _buildThemeSelectionCard(
                              context,
                              'Mode Terang',
                              Icons.light_mode_outlined,
                              !isDark,
                              () {
                                settings.setThemeModeStr('Terang');
                                setPopupState(() {});
                              },
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _buildThemeSelectionCard(
                              context,
                              'Mode Gelap',
                              Icons.nights_stay_outlined,
                              isDark,
                              () {
                                settings.setThemeModeStr('Gelap');
                                setPopupState(() {});
                              },
                            ),
                          ),
                        ],
                      ),
                      const Divider(height: 24),
                      // 2. Font Size Selection
                      Text(
                        'Ukuran Font',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                          color: primaryColor,
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildFontSizeButton(context, 'A-', 20.0, 12.0, settings, setPopupState),
                          _buildFontSizeButton(context, 'A', 24.0, 14.0, settings, setPopupState),
                          _buildFontSizeButton(context, 'A+', 28.0, 16.0, settings, setPopupState),
                          _buildFontSizeButton(context, 'A++', 32.0, 18.0, settings, setPopupState),
                        ],
                      ),
                      const SizedBox(height: 12),
                      // Contoh Teks
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                        decoration: BoxDecoration(
                          color: boxBgColor,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'الْحَمْدُ لِلَّهِ',
                              style: GoogleFonts.scheherazadeNew(
                                fontSize: settings.arabFontSize * 0.8,
                                color: primaryColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            if (!isOnlyArab) ...[
                              const SizedBox(height: 4),
                              Text(
                                'Alhamdulillahi',
                                style: TextStyle(
                                  fontSize: settings.latinFontSize,
                                  fontStyle: FontStyle.italic,
                                  color: isDark ? Colors.white70 : Colors.grey[600],
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                      const Divider(height: 24),
                      // 3. Option Toggle (Hanya Arab)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Hanya Lafal Arab',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                    color: textColor,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  'Sembunyikan teks latin & terjemah',
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: subtitleColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Switch(
                            value: isOnlyArab,
                            activeColor: primaryColor,
                            onChanged: (val) {
                              settings.setShowTransliterasi(!val);
                              settings.setShowTerjemah(!val);
                              setPopupState(() {});
                            },
                          ),
                        ],
                      ),
                      const Divider(height: 24),
                      // 4. Bookmarks list
                      Text(
                        'Bookmark Tahlil & Yasin (${bookmarks.length})',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                          color: primaryColor,
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(height: 8),
                      bookmarks.isEmpty
                          ? Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              child: Text(
                                'Belum ada bookmark yang disimpan',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontStyle: FontStyle.italic,
                                  color: subtitleColor,
                                ),
                              ),
                            )
                          : Container(
                              constraints: const BoxConstraints(maxHeight: 120),
                              child: ListView.builder(
                                shrinkWrap: true,
                                physics: const ClampingScrollPhysics(),
                                itemCount: bookmarks.length,
                                itemBuilder: (context, idx) {
                                  final title = bookmarks[idx];
                                  return InkWell(
                                    onTap: () {
                                      Navigator.pop(context);
                                      _navigateToBookmark(title);
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(vertical: 6),
                                      child: Row(
                                        children: [
                                          const Icon(Icons.bookmark, size: 14, color: primaryColor),
                                          const SizedBox(width: 8),
                                          Expanded(
                                            child: Text(
                                              title,
                                              style: TextStyle(
                                                fontSize: 13,
                                                color: textColor,
                                                fontWeight: FontWeight.w500,
                                              ),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                          Icon(
                                            Icons.chevron_right,
                                            size: 14,
                                            color: isDark ? Colors.white30 : Colors.grey[400],
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                    ],
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }

  Widget _buildThemeSelectionCard(
    BuildContext context,
    String label,
    IconData icon,
    bool isSelected,
    VoidCallback onTap,
  ) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    const primaryColor = Color(0xFF13A884);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
        decoration: BoxDecoration(
          color: isSelected 
              ? primaryColor.withOpacity(0.1) 
              : (isDark ? const Color(0xFF2C2C2C) : Colors.grey[100]),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSelected ? primaryColor : Colors.transparent,
            width: 1.5,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 16,
              color: isSelected ? primaryColor : (isDark ? Colors.white60 : Colors.black54),
            ),
            const SizedBox(width: 6),
            Expanded(
              child: Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  color: isSelected ? primaryColor : (isDark ? Colors.white70 : Colors.black87),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFontSizeButton(
    BuildContext context,
    String label,
    double arabSize,
    double latinSize,
    SettingsProvider settings,
    StateSetter setPopupState,
  ) {
    final isSelected = settings.arabFontSize == arabSize;
    const primaryColor = Color(0xFF13A884);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return GestureDetector(
      onTap: () {
        settings.setArabFontSize(arabSize);
        settings.setLatinFontSize(latinSize);
        setPopupState(() {});
      },
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: isSelected ? primaryColor : (isDark ? const Color(0xFF2C2C2C) : Colors.grey[100]),
          shape: BoxShape.circle,
          border: Border.all(
            color: isSelected ? primaryColor : (isDark ? Colors.white10 : Colors.grey[300]!),
          ),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : (isDark ? Colors.white70 : Colors.black87),
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            fontSize: 12,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF13A884);
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final settings = context.watch<SettingsProvider>();

    return Scaffold(
      backgroundColor: isDarkMode ? const Color(0xFF121212) : const Color(0xFFF5F7F8),
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.15),
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white, size: 20),
              onPressed: () => Navigator.pop(context),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
          ),
        ),
        title: Row(
          children: [
            const Text(
              'Tahlil & Yasin',
              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 18),
            ),
            const SizedBox(width: 4),
            Icon(Icons.star, color: Colors.yellow[300], size: 12),
          ],
        ),
        backgroundColor: primaryColor,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          // Sun/Moon quick theme toggle
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.15),
                shape: BoxShape.circle,
              ),
              child: IconButton(
                icon: Icon(
                  isDarkMode ? Icons.light_mode : Icons.nights_stay,
                  color: Colors.white,
                  size: 20,
                ),
                onPressed: () {
                  settings.setThemeModeStr(isDarkMode ? 'Terang' : 'Gelap');
                },
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ),
          ),
          const SizedBox(width: 8),
          // Three Dot dropdown (now contains Font Sizes, Bookmarks, and Only Arab toggle)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.15),
                shape: BoxShape.circle,
              ),
              child: IconButton(
                icon: const Icon(Icons.more_vert, color: Colors.white, size: 20),
                onPressed: () => _showSettingsPopover(context),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ),
          ),
          const SizedBox(width: 12),
        ],
      ),
      body: Column(
        children: [
          // Header Background overlap banner
          Stack(
            children: [
              Container(
                height: 24,
                color: primaryColor,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Container(
                  height: 50,
                  decoration: BoxDecoration(
                    color: isDarkMode ? const Color(0xFF1E1E1E) : Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.all(4),
                  child: TabBar(
                    controller: _tabController,
                    indicator: const UnderlineTabIndicator(
                      borderSide: BorderSide(color: primaryColor, width: 3),
                      insets: EdgeInsets.symmetric(horizontal: 40),
                    ),
                    labelColor: primaryColor,
                    unselectedLabelColor: isDarkMode ? Colors.white60 : Colors.grey[600],
                    labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                    tabs: [
                      Tab(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(Icons.menu_book, size: 16),
                            SizedBox(width: 8),
                            Text('Tahlil'),
                          ],
                        ),
                      ),
                      Tab(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(Icons.book_outlined, size: 16),
                            SizedBox(width: 8),
                            Text('Yasin'),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Tab views
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                // Tab Tahlil List
                ListView.builder(
                  controller: _tahlilScrollController,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: DoaData.listTahlil.length,
                  itemBuilder: (context, index) {
                    return _buildTahlilItem(DoaData.listTahlil[index], index, isDarkMode, settings);
                  },
                ),
                // Tab Yasin Content
                Column(
                  children: [
                    // Glassmorphic Audio Player Card
                    Container(
                      margin: const EdgeInsets.all(16),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(24),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: isDarkMode ? const Color(0xFF1E1E1E).withOpacity(0.9) : Colors.white.withOpacity(0.9),
                              borderRadius: BorderRadius.circular(24),
                              border: Border.all(color: primaryColor.withOpacity(0.1)),
                              boxShadow: [
                                BoxShadow(
                                  color: primaryColor.withOpacity(0.1),
                                  blurRadius: 20,
                                  offset: const Offset(0, 10),
                                ),
                              ],
                            ),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    // Animated Music icon rotation
                                    TweenAnimationBuilder<double>(
                                      tween: Tween<double>(begin: 0.0, end: _isPlaying ? 2 * pi : 0.0),
                                      duration: const Duration(seconds: 3),
                                      onEnd: () {
                                        if (_isPlaying) setState(() {});
                                      },
                                      builder: (context, value, child) {
                                        return Transform.rotate(
                                          angle: value,
                                          child: Container(
                                            padding: const EdgeInsets.all(10),
                                            decoration: BoxDecoration(
                                              gradient: LinearGradient(
                                                colors: [primaryColor, primaryColor.withOpacity(0.7)],
                                              ),
                                              shape: BoxShape.circle,
                                              boxShadow: [
                                                BoxShadow(
                                                  color: primaryColor.withOpacity(0.3),
                                                  blurRadius: 8,
                                                  offset: const Offset(0, 4),
                                                ),
                                              ],
                                            ),
                                            child: const Icon(Icons.music_note, color: Colors.white, size: 22),
                                          ),
                                        );
                                      },
                                    ),
                                    const SizedBox(width: 16),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Murottal Surah Yasin',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                              color: isDarkMode ? Colors.white : const Color(0xFF2D3436),
                                            ),
                                          ),
                                          Text(
                                            'Mishary Rashid Alafasy',
                                            style: TextStyle(
                                              color: isDarkMode ? Colors.white60 : const Color(0xFF636E72),
                                              fontSize: 12,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    IconButton(
                                      icon: Icon(_isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded),
                                      iconSize: 42,
                                      color: primaryColor,
                                      onPressed: _toggleAudio,
                                      style: IconButton.styleFrom(
                                        backgroundColor: primaryColor.withOpacity(0.1),
                                        padding: EdgeInsets.zero,
                                      ),
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.replay_rounded),
                                      color: isDarkMode ? Colors.white30 : Colors.grey[400],
                                      onPressed: _replayAudio,
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                SliderTheme(
                                  data: SliderTheme.of(context).copyWith(
                                    trackHeight: 4,
                                    thumbColor: primaryColor,
                                    activeTrackColor: primaryColor,
                                    inactiveTrackColor: primaryColor.withOpacity(0.1),
                                    thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 7),
                                    overlayColor: primaryColor.withOpacity(0.1),
                                    trackShape: const RoundedRectSliderTrackShape(),
                                  ),
                                  child: Slider(
                                    value: _position.inSeconds.toDouble(),
                                    max: _duration.inSeconds.toDouble() > 0 ? _duration.inSeconds.toDouble() : 1.0,
                                    onChanged: (value) {
                                      _audioPlayer.seek(Duration(seconds: value.toInt()));
                                    },
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 16),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        _formatDuration(_position),
                                        style: TextStyle(
                                          fontSize: 11,
                                          color: isDarkMode ? Colors.white70 : const Color(0xFF636E72),
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        _formatDuration(_duration),
                                        style: TextStyle(
                                          fontSize: 11,
                                          color: isDarkMode ? Colors.white70 : const Color(0xFF636E72),
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    // Yasin Verses List
                    Expanded(
                      child: ListView.builder(
                        controller: _yasinScrollController,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: YasinData.verses.length,
                        itemBuilder: (context, index) {
                          return _buildYasinVerseItem(YasinData.verses[index], isDarkMode, settings);
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTahlilItem(TahlilModel tahlil, int index, bool isDarkMode, SettingsProvider settings) {
    const primaryColor = Color(0xFF13A884);
    const deepGreen = Color(0xFF0F5A47);
    final isBookmarked = settings.isDoaBookmarked(tahlil.title);
    final isOnlyArab = !settings.showTransliterasi && !settings.showTerjemah;

    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: isDarkMode ? const Color(0xFF1E1E1E) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(
          color: isDarkMode ? Colors.white.withOpacity(0.05) : const Color(0xFFE8F5F1),
          width: 1.5,
        ),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Index, Title, Bookmark Row
          Row(
            children: [
              Container(
                width: 28,
                height: 28,
                decoration: const BoxDecoration(
                  color: deepGreen,
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: Text(
                  '${index + 1}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  tahlil.title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: isDarkMode ? Colors.white : const Color(0xFF1E1E1E),
                  ),
                ),
              ),
              IconButton(
                icon: Icon(
                  isBookmarked ? Icons.bookmark : Icons.bookmark_border,
                  color: isBookmarked ? primaryColor : Colors.grey,
                  size: 22,
                ),
                onPressed: () {
                  settings.toggleDoaBookmark(tahlil.title);
                },
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Quote Ornament + Arabic Section
          Stack(
            children: [
              Positioned(
                left: 0,
                top: 0,
                child: Text(
                  '“',
                  style: TextStyle(
                    fontFamily: 'serif',
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                    color: primaryColor.withOpacity(0.12),
                    height: 0.8,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  tahlil.arabic,
                  textAlign: TextAlign.right,
                  style: GoogleFonts.scheherazadeNew(
                    fontSize: settings.arabFontSize,
                    height: 1.8,
                    color: deepGreen,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          if (!isOnlyArab) ...[
            const SizedBox(height: 16),
            // Divider with Star Ornament
            Row(
              children: [
                Expanded(child: Divider(color: isDarkMode ? Colors.white10 : Colors.grey[200])),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Icon(
                    Icons.emergency_outlined,
                    size: 10,
                    color: primaryColor.withOpacity(0.4),
                  ),
                ),
                Expanded(child: Divider(color: isDarkMode ? Colors.white10 : Colors.grey[200])),
              ],
            ),
            const SizedBox(height: 16),
            // Audio Speaker Button & Latin text row
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: primaryColor.withOpacity(0.12),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.volume_up,
                    color: Color(0xFF13A884),
                    size: 18,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    tahlil.transliteration,
                    style: TextStyle(
                      fontSize: settings.latinFontSize,
                      fontStyle: FontStyle.italic,
                      color: isDarkMode ? Colors.white70 : const Color(0xFF636E72),
                      height: 1.4,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Translation Box (Artinya)
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isDarkMode ? const Color(0xFF142421) : const Color(0xFFE8F5F1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.menu_book_outlined, size: 14, color: primaryColor),
                      const SizedBox(width: 6),
                      Text(
                        'Artinya:',
                        style: TextStyle(
                          fontSize: settings.latinFontSize - 2.0,
                          fontWeight: FontWeight.bold,
                          color: primaryColor,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    tahlil.translation,
                    style: TextStyle(
                      fontSize: settings.latinFontSize - 1.0,
                      color: isDarkMode ? Colors.white70 : const Color(0xFF2D3436),
                      height: 1.4,
                    ),
                  ),
                  if (tahlil.note != null) ...[
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: isDarkMode ? const Color(0xFF332D15) : const Color(0xFFFFF9DB),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        tahlil.note!,
                        style: TextStyle(
                          fontSize: settings.latinFontSize - 2.0,
                          fontStyle: FontStyle.italic,
                          color: isDarkMode ? const Color(0xFFFFD43B) : const Color(0xFFF08C00),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildYasinVerseItem(YasinVerse verse, bool isDarkMode, SettingsProvider settings) {
    const primaryColor = Color(0xFF13A884);
    const deepGreen = Color(0xFF0F5A47);
    final itemKey = 'Yasin Ayat ${verse.number}';
    final isBookmarked = settings.isDoaBookmarked(itemKey);
    final isOnlyArab = !settings.showTransliterasi && !settings.showTerjemah;

    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: isDarkMode ? const Color(0xFF1E1E1E) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(
          color: isDarkMode ? Colors.white.withOpacity(0.05) : const Color(0xFFE8F5F1),
          width: 1.5,
        ),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Ayat Tag & Bookmark Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: deepGreen,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  'Ayat ${verse.number}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
              IconButton(
                icon: Icon(
                  isBookmarked ? Icons.bookmark : Icons.bookmark_border,
                  color: isBookmarked ? primaryColor : Colors.grey,
                  size: 22,
                ),
                onPressed: () {
                  settings.toggleDoaBookmark(itemKey);
                },
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Arabic Text
          Text(
            verse.arabic,
            textAlign: TextAlign.right,
            style: GoogleFonts.scheherazadeNew(
              fontSize: settings.arabFontSize,
              height: 1.8,
              color: deepGreen,
              fontWeight: FontWeight.bold,
            ),
          ),
          if (!isOnlyArab) ...[
            const SizedBox(height: 16),
            // Divider with Star Ornament
            Row(
              children: [
                Expanded(child: Divider(color: isDarkMode ? Colors.white10 : Colors.grey[200])),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Icon(
                    Icons.emergency_outlined,
                    size: 10,
                    color: primaryColor.withOpacity(0.4),
                  ),
                ),
                Expanded(child: Divider(color: isDarkMode ? Colors.white10 : Colors.grey[200])),
              ],
            ),
            const SizedBox(height: 16),
            // Latin transliteration
            Text(
              verse.transliteration,
              style: TextStyle(
                fontSize: settings.latinFontSize,
                fontStyle: FontStyle.italic,
                color: isDarkMode ? Colors.white70 : const Color(0xFF636E72),
                height: 1.4,
              ),
            ),
            const SizedBox(height: 16),
            // Translation Box (Artinya)
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isDarkMode ? const Color(0xFF142421) : const Color(0xFFE8F5F1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.menu_book_outlined, size: 14, color: primaryColor),
                      const SizedBox(width: 6),
                      Text(
                        'Artinya:',
                        style: TextStyle(
                          fontSize: settings.latinFontSize - 2.0,
                          fontWeight: FontWeight.bold,
                          color: primaryColor,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    verse.translation,
                    style: TextStyle(
                      fontSize: settings.latinFontSize - 1.0,
                      color: isDarkMode ? Colors.white70 : const Color(0xFF2D3436),
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
