import 'package:flutter/material.dart';
import 'dart:math';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:just_audio/just_audio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import 'quran_service.dart';
import 'quran_data.dart';
import 'settings_provider.dart';
import 'settings_page.dart';
import 'preferensi_membaca_page.dart';
import 'pilih_surah_page.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

class SurahDetailPage extends StatefulWidget {
  final int nomor;
  final int? initialVerse;
  const SurahDetailPage({super.key, required this.nomor, this.initialVerse});

  @override
  State<SurahDetailPage> createState() => _SurahDetailPageState();
}

class _SurahDetailPageState extends State<SurahDetailPage> {
  late Future<SurahDetailModel> _surahDetail;
  late Future<TafsirDetailModel> _tafsirDetail;
  final AudioPlayer _player = AudioPlayer();
  int? _currentlyPlayingAyat;
  bool _isFullSurahPlaying = false;
  List<String> _favoriteSurahs = [];
  bool _showTranslation = true;
  int _activeTab = 0; // 0: Ayat, 1: Tafsir, 2: Info Surah, 3: Keutamaan
  Duration _position = Duration.zero;
  Duration _duration = Duration.zero;

  late ScrollController _scrollController;
  final Map<int, GlobalKey> _ayatKeys = {};
  bool _hasScrolledToInitialVerse = false;

  void _showFontSizeDialog(BuildContext context, SettingsProvider settings) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const PreferensiMembacaPage()),
    );
  }

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _surahDetail = QuranService().getSurahDetail(widget.nomor);
    _tafsirDetail = QuranService().getTafsirDetail(widget.nomor);
    _loadFavorites();
    
    _player.playerStateStream.listen((state) {
      if (state.processingState == ProcessingState.completed) {
        setState(() {
          _currentlyPlayingAyat = null;
          _isFullSurahPlaying = false;
        });
      }
    });

    _player.positionStream.listen((p) {
      if (mounted) {
        setState(() {
          _position = p;
        });
      }
    });

    _player.durationStream.listen((d) {
      if (mounted) {
        setState(() {
          _duration = d ?? Duration.zero;
        });
      }
    });

    // Pre-load the full surah audio URL to get the duration metadata
    _surahDetail.then((surah) {
      final settings = Provider.of<SettingsProvider>(context, listen: false);
      
      // Auto-bookmark first verse if penandaOtomatis is enabled
      if (settings.penandaOtomatis) {
        SharedPreferences.getInstance().then((prefs) async {
          await prefs.setString('lastReadSurah', surah.namaLatin);
          await prefs.setInt('lastReadVerse', 1);
          await prefs.setInt('lastReadSurahNumber', surah.nomor);
        });
      }

      final qoriId = settings.selectedQoriId;
      final audioUrl = surah.audioFull[qoriId] ?? surah.audio;
      _player.setUrl(audioUrl).then((_) {
        if (mounted) {
          setState(() {
            _duration = _player.duration ?? Duration.zero;
          });
        }
      }).catchError((e) {
        // ignore or handle failure (e.g. offline mode)
      });
    });
  }

  bool _isCompleted = false;
  List<String> _completedSurahs = [];
  List<String> _memorizedAyats = [];

  Future<void> _loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _favoriteSurahs = prefs.getStringList('favoriteSurahs') ?? [];
      _completedSurahs = prefs.getStringList('completedSurahs') ?? [];
      _isCompleted = _completedSurahs.contains(widget.nomor.toString());
      _memorizedAyats = prefs.getStringList('memorizedAyats') ?? [];
    });
  }

  Future<void> _toggleCompletedSurah() async {
    final prefs = await SharedPreferences.getInstance();
    final list = List<String>.from(_completedSurahs);
    final String surahStr = widget.nomor.toString();
    
    if (list.contains(surahStr)) {
      list.remove(surahStr);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Batal menandai Surah selesai'),
            duration: Duration(seconds: 1),
          ),
        );
      }
    } else {
      list.add(surahStr);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Surah ditandai selesai!'),
            duration: Duration(seconds: 1),
          ),
        );
      }
    }
    await prefs.setStringList('completedSurahs', list);
    if (mounted) {
      setState(() {
        _completedSurahs = list;
        _isCompleted = list.contains(surahStr);
      });
    }
  }

  Future<void> _toggleMemorizedAyat(int ayatNomor) async {
    final prefs = await SharedPreferences.getInstance();
    final list = List<String>.from(_memorizedAyats);
    final String key = "${widget.nomor}_$ayatNomor";
    
    if (list.contains(key)) {
      list.remove(key);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Batal menandai hafalan ayat'),
            duration: Duration(seconds: 1),
          ),
        );
      }
    } else {
      list.add(key);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Ayat berhasil ditandai sebagai dihafal!'),
            duration: Duration(seconds: 1),
          ),
        );
      }
    }
    await prefs.setStringList('memorizedAyats', list);
    if (mounted) {
      setState(() {
        _memorizedAyats = list;
      });
    }
  }

  Future<void> _toggleFavoriteSurah() async {
    final prefs = await SharedPreferences.getInstance();
    final list = List<String>.from(_favoriteSurahs);
    final String surahStr = widget.nomor.toString();
    
    if (list.contains(surahStr)) {
      list.remove(surahStr);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Dihapus dari bookmark'),
            duration: Duration(seconds: 1),
          ),
        );
      }
    } else {
      list.add(surahStr);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Ditambahkan ke bookmark'),
            duration: Duration(seconds: 1),
          ),
        );
      }
    }
    await prefs.setStringList('favoriteSurahs', list);
    if (mounted) {
      setState(() {
        _favoriteSurahs = list;
      });
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _player.dispose();
    WakelockPlus.disable();
    super.dispose();
  }

  Future<void> _playAudio(String url, {int? ayatNomor}) async {
    try {
      final bool isCurrentFullSurah = (ayatNomor == null && _isFullSurahPlaying);
      final bool isCurrentAyat = (ayatNomor != null && _currentlyPlayingAyat == ayatNomor);

      if (isCurrentFullSurah || isCurrentAyat) {
        // If the current track is active (either playing, loading or buffering), we pause/stop it.
        if (_player.playing || 
            _player.processingState == ProcessingState.loading || 
            _player.processingState == ProcessingState.buffering) {
          await _player.pause();
        } else {
          // If it's paused, we resume it.
          await _player.play();
        }
        // Trigger UI update
        setState(() {});
        return;
      }

      // Stop previous audio and load new one
      await _player.stop();
      
      setState(() {
        _currentlyPlayingAyat = ayatNomor;
        _isFullSurahPlaying = (ayatNomor == null);
      });

      if (ayatNomor != null) {
        final settings = Provider.of<SettingsProvider>(context, listen: false);
        if (settings.penandaOtomatis) {
          SharedPreferences.getInstance().then((prefs) async {
            final surah = await _surahDetail;
            await prefs.setString('lastReadSurah', surah.namaLatin);
            await prefs.setInt('lastReadVerse', ayatNomor);
            await prefs.setInt('lastReadSurahNumber', surah.nomor);
          });
        }
      }

      await _player.setUrl(url);
      await _player.play();
    } catch (e) {
      print('DEBUG AUDIO ERROR: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal memutar audio: $e'),
            backgroundColor: Colors.redAccent,
            duration: const Duration(seconds: 5),
            action: SnackBarAction(
              label: 'OK',
              textColor: Colors.white,
              onPressed: () {},
            ),
          ),
        );
      }
    }
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }

  Widget _buildAyatNumberOrnament(int number) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Transform.rotate(
          angle: pi / 4,
          child: Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              border: Border.all(
                color: const Color(0xFFC5A880),
                width: 1.2,
              ),
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        ),
        Container(
          width: 24,
          height: 24,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              '$number',
              style: GoogleFonts.outfit(
                fontSize: 9,
                fontWeight: FontWeight.bold,
                color: const Color(0xFFC5A880),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTabsRow() {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final activeColor = const Color(0xFF13A884);
    final inactiveColor = isDarkMode ? Colors.grey[400] : Colors.grey[600];

    Widget tabItem(int index, IconData icon, String label) {
      final isActive = _activeTab == index;
      return GestureDetector(
        onTap: () {
          setState(() {
            _activeTab = index;
          });
        },
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      icon,
                      size: 16,
                      color: isActive ? activeColor : inactiveColor,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      label,
                      style: GoogleFonts.outfit(
                        fontSize: 12,
                        fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
                        color: isActive ? activeColor : inactiveColor,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              height: 3,
              width: 28,
              decoration: BoxDecoration(
                color: isActive ? activeColor : Colors.transparent,
                borderRadius: BorderRadius.circular(1.5),
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isDarkMode ? Theme.of(context).colorScheme.surface : Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(
          color: isDarkMode ? Colors.transparent : Colors.grey.shade100,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(child: tabItem(0, Icons.menu_book, 'Ayat')),
            Expanded(child: tabItem(1, Icons.book, 'Tafsir')),
            Expanded(child: tabItem(2, Icons.info_outline, 'Info Surah')),
            Expanded(child: tabItem(3, Icons.star_border, 'Keutamaan')),
          ],
        ),
      ),
    );
  }

  Widget _buildPlaceholderTabContent(String text, IconData icon) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Container(
      margin: const EdgeInsets.all(24),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: isDarkMode ? Theme.of(context).colorScheme.surface : Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 48, color: const Color(0xFF13A884).withOpacity(0.5)),
          const SizedBox(height: 16),
          Text(
            text,
            textAlign: TextAlign.center,
            style: GoogleFonts.outfit(
              fontSize: 15,
              color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoTabContent(SurahDetailModel surah) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDarkMode ? Theme.of(context).colorScheme.surface : Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: isDarkMode ? Colors.transparent : Colors.grey.shade100),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Tentang Surah ${surah.namaLatin}',
            style: GoogleFonts.outfit(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF13A884),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            surah.deskripsi.replaceAll(RegExp(r'<[^>]*>'), ''),
            style: GoogleFonts.outfit(
              fontSize: 14,
              height: 1.6,
              color: isDarkMode ? Colors.white70 : Colors.grey.shade800,
            ),
            textAlign: TextAlign.justify,
          ),
        ],
      ),
    );
  }

  Widget _buildFloatingBottomPlayer(SurahDetailModel surah) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return StreamBuilder<PlayerState>(
      stream: _player.playerStateStream,
      builder: (context, snapshot) {
        final playerState = snapshot.data;
        final playing = playerState?.playing ?? false;
        
        if (_currentlyPlayingAyat == null && !_isFullSurahPlaying && !playing) {
          return const SizedBox.shrink();
        }

        return Container(
          height: 72,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: isDarkMode ? Theme.of(context).colorScheme.surface : Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 16,
                offset: const Offset(0, 4),
              ),
            ],
            border: Border.all(
              color: isDarkMode ? Colors.transparent : Colors.grey.shade100,
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: const Color(0xFF386B5F),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: Text(
                    surah.nama,
                    style: GoogleFonts.scheherazadeNew(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      surah.namaLatin,
                      style: GoogleFonts.outfit(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF0C5441),
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      _currentlyPlayingAyat != null 
                          ? 'Ayat $_currentlyPlayingAyat / ${surah.jumlahAyat}'
                          : 'Surah ke-${surah.nomor} • ${surah.jumlahAyat} Ayat',
                      style: GoogleFonts.outfit(
                        fontSize: 12,
                        color: isDarkMode ? Colors.white70 : Colors.grey[600],
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.skip_previous, color: Color(0xFF0C5441), size: 24),
                    onPressed: () {
                      if (_currentlyPlayingAyat != null) {
                        final prevAyat = _currentlyPlayingAyat! - 1;
                        if (prevAyat >= 1) {
                          final prevAyatModel = surah.ayat[prevAyat - 1];
                          final settings = Provider.of<SettingsProvider>(context, listen: false);
                          final qoriId = settings.selectedQoriId;
                          _playAudio(prevAyatModel.audio[qoriId] ?? prevAyatModel.audio.values.first, ayatNomor: prevAyat);
                        }
                      } else {
                        final newPos = _player.position - const Duration(seconds: 10);
                        _player.seek(newPos < Duration.zero ? Duration.zero : newPos);
                      }
                    },
                  ),
                  GestureDetector(
                    onTap: () {
                      if (playing) {
                        _player.pause();
                      } else {
                        _player.play();
                      }
                    },
                    child: Container(
                      width: 38,
                      height: 38,
                      decoration: const BoxDecoration(
                        color: Color(0xFF0C5441),
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Icon(
                          playing ? Icons.pause : Icons.play_arrow,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.skip_next, color: Color(0xFF0C5441), size: 24),
                    onPressed: () {
                      if (_currentlyPlayingAyat != null) {
                        final nextAyat = _currentlyPlayingAyat! + 1;
                        if (nextAyat <= surah.ayat.length) {
                          final nextAyatModel = surah.ayat[nextAyat - 1];
                          final settings = Provider.of<SettingsProvider>(context, listen: false);
                          final qoriId = settings.selectedQoriId;
                          _playAudio(nextAyatModel.audio[qoriId] ?? nextAyatModel.audio.values.first, ayatNomor: nextAyat);
                        }
                      } else {
                        final newPos = _player.position + const Duration(seconds: 10);
                        _player.seek(newPos > _duration ? _duration : newPos);
                      }
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.list, color: Color(0xFF0C5441), size: 24),
                    onPressed: () => _showMenuBottomSheet(context, surah),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final settings = Provider.of<SettingsProvider>(context);
    if (settings.layarTetapAktif) {
      WakelockPlus.enable();
    } else {
      WakelockPlus.disable();
    }

    return FutureBuilder<SurahDetailModel>(
      future: _surahDetail,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator(color: Color(0xFF13A884))),
          );
        }

        if (snapshot.hasError) {
          return Scaffold(
            appBar: AppBar(backgroundColor: const Color(0xFF13A884)),
            body: Center(child: Text('Error: ${snapshot.error}')),
          );
        }

        final surah = snapshot.data!;
        if (!_hasScrolledToInitialVerse && widget.initialVerse != null) {
          _hasScrolledToInitialVerse = true;
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _scrollToVerse(widget.initialVerse!);
          });
        }
        return Scaffold(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          body: Stack(
            children: [
              CustomScrollView(
                controller: _scrollController,
                slivers: [
                  _buildSliverAppBar(surah),
                  SliverToBoxAdapter(
                    child: _buildAudioControlCard(surah),
                  ),
                  SliverToBoxAdapter(
                    child: _buildTabsRow(),
                  ),
                  if (_activeTab == 0)
                    SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          return _buildAyatItem(surah, surah.ayat[index]);
                        },
                        childCount: surah.ayat.length,
                      ),
                    )
                  else if (_activeTab == 1)
                    FutureBuilder<TafsirDetailModel>(
                      future: _tafsirDetail,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const SliverToBoxAdapter(
                            child: Padding(
                              padding: EdgeInsets.symmetric(vertical: 40.0),
                              child: Center(
                                child: CircularProgressIndicator(
                                  color: Color(0xFF13A884),
                                ),
                              ),
                            ),
                          );
                        }
                        if (snapshot.hasError) {
                          return SliverToBoxAdapter(
                            child: _buildPlaceholderTabContent(
                              'Gagal memuat Tafsir. Pastikan Anda terhubung ke internet.',
                              Icons.cloud_off_rounded,
                            ),
                          );
                        }
                        if (!snapshot.hasData || snapshot.data!.tafsir.isEmpty) {
                          return SliverToBoxAdapter(
                            child: _buildPlaceholderTabContent(
                              'Tafsir tidak ditemukan.',
                              Icons.book_outlined,
                            ),
                          );
                        }

                        final tafsirData = snapshot.data!;
                        return SliverList(
                          delegate: SliverChildBuilderDelegate(
                            (context, index) {
                              final item = tafsirData.tafsir[index];
                              return _buildTafsirItem(item);
                            },
                            childCount: tafsirData.tafsir.length,
                          ),
                        );
                      },
                    )
                  else if (_activeTab == 2)
                    SliverToBoxAdapter(
                      child: _buildInfoTabContent(surah),
                    )
                  else if (_activeTab == 3)
                    SliverToBoxAdapter(
                      child: _buildKeutamaanTabContent(surah),
                    ),
                  const SliverToBoxAdapter(child: SizedBox(height: 100)),
                ],
              ),
              Positioned(
                bottom: 16,
                left: 16,
                right: 16,
                child: _buildFloatingBottomPlayer(surah),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildBottomSheetItem({
    required BuildContext context,
    required Widget icon,
    required String title,
    required VoidCallback onTap,
  }) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        child: Row(
          children: [
            SizedBox(
              width: 32,
              child: icon,
            ),
            const SizedBox(width: 16),
            Text(
              title,
              style: GoogleFonts.outfit(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: isDarkMode ? Colors.white : Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _scrollToVerse(int ayatNomor) {
    final index = ayatNomor - 1;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final key = _ayatKeys[index];
      if (key != null && key.currentContext != null) {
        Scrollable.ensureVisible(
          key.currentContext!,
          duration: const Duration(milliseconds: 600),
          curve: Curves.easeInOut,
          alignment: 0.3,
        );
      } else {
        double estimatedOffset = 320.0 + (index * 190.0);
        _scrollController.animateTo(
          estimatedOffset,
          duration: const Duration(milliseconds: 600),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  void _showGoToDialog(BuildContext context, SurahDetailModel currentSurah) {
    final settings = Provider.of<SettingsProvider>(context, listen: false);
    final isDarkMode = settings.themeModeStr == 'Gelap';
    final surahList = QuranData.listSurah;
    
    SurahModel selectedSurah = surahList.firstWhere(
      (s) => s.nomor == currentSurah.nomor,
      orElse: () => surahList.first,
    );
    
    final TextEditingController verseController = TextEditingController();
    
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            final maxVerses = selectedSurah.jumlahAyat;
            
            return AlertDialog(
              backgroundColor: isDarkMode ? const Color(0xFF1E1E1E) : Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              contentPadding: const EdgeInsets.all(24),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'Pergi ke',
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: isDarkMode ? Colors.white : Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 20),
                    
                    Text(
                      'Pilih Surah',
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 8),
                    
                    InkWell(
                      onTap: () async {
                        final result = await Navigator.push<SurahModel>(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PilihSurahPage(currentSurah: selectedSurah),
                          ),
                        );
                        if (result != null) {
                          setState(() {
                            selectedSurah = result;
                            verseController.clear();
                          });
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: isDarkMode ? Colors.grey[700]! : Colors.grey[350]!,
                          ),
                          borderRadius: BorderRadius.circular(10),
                          color: isDarkMode ? const Color(0xFF2D2D2D) : Colors.white,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '${selectedSurah.nomor}. ${selectedSurah.namaLatin}',
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                color: isDarkMode ? Colors.white : Colors.black87,
                              ),
                            ),
                            Icon(
                              Icons.keyboard_arrow_down,
                              color: isDarkMode ? Colors.white70 : Colors.black54,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    
                    Text(
                      'Masukkan nomor ayat antara 1 - $maxVerses',
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 8),
                    
                    TextField(
                      controller: verseController,
                      keyboardType: TextInputType.number,
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        color: isDarkMode ? Colors.white : Colors.black87,
                      ),
                      decoration: InputDecoration(
                        hintText: '1 - $maxVerses',
                        hintStyle: GoogleFonts.poppins(
                          fontSize: 14,
                          color: isDarkMode ? Colors.grey[600] : Colors.grey[400],
                        ),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                            color: isDarkMode ? Colors.grey[700]! : Colors.grey[350]!,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                            color: isDarkMode ? Colors.grey[700]! : Colors.grey[350]!,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(
                            color: Color(0xFF13A884),
                            width: 1.5,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () => Navigator.pop(context),
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              side: BorderSide(
                                color: isDarkMode ? Colors.grey[700]! : Colors.grey[350]!,
                              ),
                            ),
                            child: Text(
                              'Batal',
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: isDarkMode ? Colors.white70 : Colors.black87,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              final input = verseController.text.trim();
                              final verseNum = int.tryParse(input);
                              if (verseNum == null || verseNum < 1 || verseNum > maxVerses) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      'Nomor ayat tidak valid. Masukkan antara 1 - $maxVerses',
                                      style: GoogleFonts.poppins(),
                                    ),
                                    backgroundColor: Colors.redAccent,
                                    duration: const Duration(seconds: 2),
                                  ),
                                );
                                return;
                              }
                              
                              Navigator.pop(context);
                              
                              if (selectedSurah.nomor == currentSurah.nomor) {
                                _scrollToVerse(verseNum);
                              } else {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => SurahDetailPage(
                                      nomor: selectedSurah.nomor,
                                      initialVerse: verseNum,
                                    ),
                                  ),
                                );
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF13A884),
                              elevation: 0,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: Text(
                              'Oke',
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _showMenuBottomSheet(BuildContext context, SurahDetailModel surah) {
    final settings = Provider.of<SettingsProvider>(context, listen: false);
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    showModalBottomSheet(
      context: context,
      backgroundColor: isDarkMode ? Theme.of(context).colorScheme.surface : Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            final localIsDarkMode = Theme.of(context).brightness == Brightness.dark;
            final localIsFavorite = _favoriteSurahs.contains(widget.nomor.toString());
            final localIsCompleted = _isCompleted;

            return SafeArea(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 10, bottom: 10),
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  _buildBottomSheetItem(
                    context: context,
                    icon: Center(
                      child: Text(
                        'aA',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: localIsDarkMode ? Colors.white : Colors.black87,
                        ),
                      ),
                    ),
                    title: 'Ubah ukuran teks',
                    onTap: () {
                      Navigator.pop(context);
                      _showFontSizeDialog(context, settings);
                    },
                  ),
                  _buildBottomSheetItem(
                    context: context,
                    icon: Icon(Icons.info_outline, color: localIsDarkMode ? Colors.white : Colors.black87),
                    title: 'Informasi',
                    onTap: () {
                      Navigator.pop(context);
                      _showInfo(surah);
                    },
                  ),
                  _buildBottomSheetItem(
                    context: context,
                    icon: Icon(
                      localIsFavorite ? Icons.bookmark : Icons.bookmark_border,
                      color: localIsFavorite ? Colors.amber[800] : (localIsDarkMode ? Colors.white : localIsContrastColor(localIsDarkMode)),
                    ),
                    title: 'Bookmark',
                    onTap: () async {
                      await _toggleFavoriteSurah();
                      setModalState(() {});
                    },
                  ),
                  _buildBottomSheetItem(
                    context: context,
                    icon: Icon(
                      localIsCompleted ? Icons.check_circle : Icons.check_circle_outline,
                      color: localIsCompleted ? const Color(0xFF13A884) : (localIsDarkMode ? Colors.white : Colors.black87),
                    ),
                    title: 'Tandai Selesai',
                    onTap: () async {
                      await _toggleCompletedSurah();
                      setModalState(() {});
                    },
                  ),
                  _buildBottomSheetItem(
                    context: context,
                    icon: Icon(
                      _showTranslation ? Icons.book : Icons.book_outlined,
                      color: localIsDarkMode ? Colors.white : Colors.black87,
                    ),
                    title: 'Teks Terjemahan',
                    onTap: () {
                      setState(() {
                        _showTranslation = !_showTranslation;
                      });
                      setModalState(() {});
                    },
                  ),
                  _buildBottomSheetItem(
                    context: context,
                    icon: Icon(
                      localIsDarkMode ? Icons.light_mode : Icons.dark_mode_outlined,
                      color: localIsDarkMode ? Colors.white : Colors.black87,
                    ),
                    title: localIsDarkMode ? 'Mode siang' : 'Mode malam',
                    onTap: () async {
                      await settings.setThemeModeStr(localIsDarkMode ? 'Hijau' : 'Gelap');
                      setModalState(() {});
                    },
                  ),
                  _buildBottomSheetItem(
                    context: context,
                    icon: Icon(Icons.settings, color: localIsDarkMode ? Colors.white : Colors.black87),
                    title: 'Pengaturan',
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const SettingsPage()),
                      );
                    },
                  ),
                  const SizedBox(height: 12),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Color localIsContrastColor(bool isDark) {
    return isDark ? Colors.white : Colors.black87;
  }

  Widget _buildSliverAppBar(SurahDetailModel surah) {
    final settings = Provider.of<SettingsProvider>(context);
    final isDarkMode = settings.themeModeStr == 'Gelap';

    return SliverAppBar(
      expandedHeight: 220.0,
      floating: false,
      pinned: true,
      backgroundColor: const Color(0xFF0C5441),
      elevation: 0,
      automaticallyImplyLeading: false,
      leading: Padding(
        padding: const EdgeInsets.only(left: 16, top: 8, bottom: 8),
        child: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: const Center(
              child: Icon(
                Icons.chevron_left,
                color: Colors.black87,
                size: 28,
              ),
            ),
          ),
        ),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 16, top: 8, bottom: 8),
          child: GestureDetector(
            onTap: () => _showMenuBottomSheet(context, surah),
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: const Center(
                child: Icon(
                  Icons.more_vert,
                  color: Color(0xFF0C5441),
                  size: 24,
                ),
              ),
            ),
          ),
        ),
      ],
      flexibleSpace: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          final double top = constraints.biggest.height;
          final bool isCollapsed = top <= (MediaQuery.of(context).padding.top + kToolbarHeight + 10);
          
          return FlexibleSpaceBar(
            titlePadding: const EdgeInsets.only(bottom: 12),
            centerTitle: true,
            title: isCollapsed
                ? GestureDetector(
                    onTap: () => _showGoToDialog(context, surah),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.white.withOpacity(0.8), width: 1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            surah.namaLatin,
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(width: 4),
                          const Icon(Icons.keyboard_arrow_down, color: Colors.white, size: 16),
                        ],
                      ),
                    ),
                  )
                : null,
            background: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: isDarkMode 
                      ? [const Color(0xFF0A2B21), const Color(0xFF071F18)]
                      : [const Color(0xFFF9FBFB), const Color(0xFFE8F5F1)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: Stack(
                children: [
                  // Outer Islamic arch contour
                  Positioned(
                    right: 16,
                    bottom: 0,
                    top: 26,
                    width: 138,
                    child: ClipPath(
                      clipper: IslamicArchClipper(),
                      child: Container(
                        color: Colors.white,
                      ),
                    ),
                  ),
                  // Inner Islamic arch with Rehal image clipped inside it
                  Positioned(
                    right: 20,
                    bottom: 0,
                    top: 30,
                    width: 130,
                    child: ClipPath(
                      clipper: IslamicArchClipper(),
                      child: Container(
                        color: Colors.white,
                        child: Image.asset(
                          'assets/images/quran_rehal.png',
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => const Center(
                            child: Icon(
                              Icons.menu_book,
                              color: Color(0xFF13A884),
                              size: 40,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  // Left side info
                  Positioned(
                    left: 20,
                    bottom: 16,
                    right: 160,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          surah.nama,
                          style: GoogleFonts.scheherazadeNew(
                            fontSize: 36,
                            fontWeight: FontWeight.bold,
                            color: isDarkMode ? Colors.white : const Color(0xFF0C5441),
                            height: 1.0,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          surah.namaLatin,
                          style: GoogleFonts.outfit(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: isDarkMode ? Colors.white : const Color(0xFF0C5441),
                            height: 1.0,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'Surah ke-${surah.nomor} • ${surah.jumlahAyat} Ayat • ${surah.tempatTurun == 'mekah' ? 'Makkiyah' : 'Madaniyah'}',
                          style: GoogleFonts.outfit(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: isDarkMode ? Colors.white70 : Colors.grey[600],
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: isDarkMode ? const Color(0xFF0C5441).withOpacity(0.3) : const Color(0xFFE8F5F1),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: const Color(0xFF13A884).withOpacity(0.3),
                              width: 1.2,
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.menu_book, 
                                size: 14, 
                                color: isDarkMode ? const Color(0xFF13A884) : const Color(0xFF0C5441)
                              ),
                              const SizedBox(width: 6),
                              Text(
                                surah.arti,
                                style: GoogleFonts.outfit(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: isDarkMode ? const Color(0xFF13A884) : const Color(0xFF0C5441),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildAudioControlCard(SurahDetailModel surah) {
    final settings = Provider.of<SettingsProvider>(context);
    final isDownloaded = settings.downloadedSurahs.contains(surah.nomor.toString());
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return StreamBuilder<PlayerState>(
      stream: _player.playerStateStream,
      builder: (context, snapshot) {
        final playerState = snapshot.data;
        final playing = playerState?.playing ?? false;
        final processingState = playerState?.processingState ?? ProcessingState.idle;
        final bool isThisPlaying = _isFullSurahPlaying &&
            (playing || processingState == ProcessingState.loading || processingState == ProcessingState.buffering);

        final double maxVal = _duration.inMilliseconds.toDouble() > 0 
            ? _duration.inMilliseconds.toDouble() 
            : 1.0;
        final double currentVal = _position.inMilliseconds.toDouble().clamp(0.0, maxVal);

        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          decoration: BoxDecoration(
            color: isDarkMode ? Theme.of(context).colorScheme.surface : Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
            border: Border.all(color: isDarkMode ? Colors.transparent : Colors.grey.shade100),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: const BoxDecoration(
                      color: Color(0xFF13A884),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.headphones, color: Colors.white, size: 20),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Audio Surah Lengkap',
                          style: GoogleFonts.outfit(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: isDarkMode ? Colors.white : Colors.grey.shade800,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          isThisPlaying ? 'Sedang memutar audio surah' : 'Dengarkan per ayat atau lengkap',
                          style: GoogleFonts.outfit(
                            fontSize: 11,
                            color: isDarkMode ? Colors.white70 : Colors.grey.shade500,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: isDarkMode ? Colors.grey[800] : const Color(0xFFF4F8F6),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: const Color(0xFF13A884).withOpacity(0.15)),
                    ),
                    child: Center(
                      child: IconButton(
                        icon: Icon(
                          isDownloaded ? Icons.cloud_done : Icons.file_download_outlined,
                          color: isDownloaded ? Colors.green : const Color(0xFF13A884),
                          size: isDownloaded ? 20 : 18,
                        ),
                        tooltip: isDownloaded ? 'Audio Surah Terunduh' : 'Unduh Audio',
                        onPressed: () {
                          if (isDownloaded) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Row(
                                  children: [
                                    const Icon(Icons.cloud_done, color: Colors.white),
                                    const SizedBox(width: 10),
                                    Text(
                                      'Audio surah ini sudah diunduh offline.',
                                      style: GoogleFonts.poppins(color: Colors.white, fontSize: 12),
                                    ),
                                  ],
                                ),
                                backgroundColor: const Color(0xFF13A884),
                                behavior: SnackBarBehavior.floating,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                duration: const Duration(seconds: 2),
                              ),
                            );
                          } else {
                            _simulateDownloadAudio(context, settings, surah);
                          }
                        },
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: () {
                      final settings = Provider.of<SettingsProvider>(context, listen: false);
                      final qoriId = settings.selectedQoriId;
                      final audioUrl = surah.audioFull[qoriId] ?? surah.audio;
                      _playAudio(audioUrl);
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: const Color(0xFF13A884),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            isThisPlaying ? Icons.stop : Icons.play_arrow,
                            color: Colors.white,
                            size: 16,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            isThisPlaying ? 'Stop' : 'Putar',
                            style: GoogleFonts.outfit(
                              color: Colors.white,
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              SliderTheme(
                data: SliderThemeData(
                  trackHeight: 2,
                  activeTrackColor: const Color(0xFF13A884),
                  inactiveTrackColor: isDarkMode ? Colors.grey[800] : Colors.grey[200],
                  thumbColor: const Color(0xFF13A884),
                  thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
                  overlayShape: const RoundSliderOverlayShape(overlayRadius: 14),
                ),
                child: Slider(
                  min: 0,
                  max: maxVal,
                  value: currentVal,
                  onChanged: (value) {
                    _player.seek(Duration(milliseconds: value.toInt()));
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      _formatDuration(_position),
                      style: TextStyle(fontSize: 11, color: isDarkMode ? Colors.grey[400] : Colors.grey[500]),
                    ),
                    Text(
                      _formatDuration(_duration),
                      style: TextStyle(fontSize: 11, color: isDarkMode ? Colors.grey[400] : Colors.grey[500]),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _simulateDownloadAudio(BuildContext context, SettingsProvider settings, SurahDetailModel surah) {
    // 150 KB per verse
    final double sizeInBytes = surah.jumlahAyat * 150.0 * 1024.0;
    
    // Show a premium progress/loading indicator SnackBar
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const SizedBox(
              width: 18,
              height: 18,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                'Mengunduh audio Surah ${surah.namaLatin}...',
                style: GoogleFonts.poppins(color: Colors.white, fontSize: 12),
              ),
            ),
          ],
        ),
        backgroundColor: const Color(0xFF13A884),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        duration: const Duration(milliseconds: 1500),
      ),
    );

    // Simulate network delay
    Future.delayed(const Duration(milliseconds: 1500), () {
      if (!mounted) return;
      settings.addDownloadedSurah(surah.nomor, sizeInBytes);
      
      // Show premium success SnackBar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.cloud_done, color: Colors.white),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Audio Surah ${surah.namaLatin} berhasil diunduh (${(sizeInBytes / (1024 * 1024)).toStringAsFixed(1)} MB)!',
                  style: GoogleFonts.poppins(color: Colors.white, fontSize: 12),
                ),
              ),
            ],
          ),
          backgroundColor: const Color(0xFF13A884),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          duration: const Duration(seconds: 2),
        ),
      );
    });
  }


  int _getJuzNumber(int surahNum, int ayatNum) {
    if (surahNum == 1) return 1;
    if (surahNum == 2) {
      if (ayatNum <= 141) return 1;
      if (ayatNum <= 252) return 2;
      return 3;
    }
    if (surahNum == 3) {
      if (ayatNum <= 92) return 3;
      return 4;
    }
    if (surahNum >= 78) return 30;
    if (surahNum >= 67) return 29;
    if (surahNum >= 58) return 28;
    return 30;
  }

  void _showVerseOptionsBottomSheet(BuildContext context, SurahDetailModel surah, AyatModel ayat) {
    final settings = Provider.of<SettingsProvider>(context, listen: false);
    final isDarkMode = settings.themeModeStr == 'Gelap';
    final juzNum = _getJuzNumber(surah.nomor, ayat.nomorAyat);
    final isMemorized = _memorizedAyats.contains("${widget.nomor}_${ayat.nomorAyat}");

    showModalBottomSheet(
      context: context,
      backgroundColor: isDarkMode ? Theme.of(context).colorScheme.surface : Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                margin: const EdgeInsets.only(top: 10, bottom: 10),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'QS. ${surah.namaLatin}: Ayat ${ayat.nomorAyat} (Juz $juzNum)',
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: isDarkMode ? Colors.white70 : Colors.black87,
                    ),
                  ),
                ),
              ),
              const Divider(height: 1),
              _buildBottomSheetItem(
                context: context,
                icon: const Icon(Icons.play_arrow, color: Color(0xFF13A884)),
                title: 'Putar Ayat',
                onTap: () {
                  Navigator.pop(context);
                  final qoriId = settings.selectedQoriId;
                  _playAudio(ayat.audio[qoriId] ?? ayat.audio.values.first, ayatNomor: ayat.nomorAyat);
                },
              ),
              _buildBottomSheetItem(
                context: context,
                icon: const Icon(Icons.share, color: Color(0xFF13A884)),
                title: 'Bagikan',
                onTap: () {
                  Navigator.pop(context);
                  Clipboard.setData(ClipboardData(text: "${ayat.teksArab}\n\n${ayat.teksIndonesia} (QS. ${surah.namaLatin}: ${ayat.nomorAyat})"));
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Menyalin Ayat ${ayat.nomorAyat} ke Clipboard...'),
                      backgroundColor: const Color(0xFF13A884),
                    ),
                  );
                },
              ),
              _buildBottomSheetItem(
                context: context,
                icon: const Icon(Icons.book, color: Color(0xFF13A884)),
                title: 'Lihat Terjemah & Tafsir',
                onTap: () {
                  Navigator.pop(context);
                  setState(() {
                    _activeTab = 1;
                  });
                },
              ),
              _buildBottomSheetItem(
                context: context,
                icon: const Icon(Icons.bookmark_outline, color: Color(0xFF13A884)),
                title: 'Tandai Terakhir Dibaca',
                onTap: () async {
                  final messenger = ScaffoldMessenger.of(context);
                  Navigator.pop(context);
                  final prefs = await SharedPreferences.getInstance();
                  await prefs.setString('lastReadSurah', surah.namaLatin);
                  await prefs.setInt('lastReadVerse', ayat.nomorAyat);
                  await prefs.setInt('lastReadSurahNumber', surah.nomor);
                  messenger.showSnackBar(
                    SnackBar(
                      content: Text('Tandai sebagai ayat terakhir dibaca: QS. ${surah.namaLatin} ayat ${ayat.nomorAyat}'),
                      backgroundColor: const Color(0xFF13A884),
                    ),
                  );
                },
              ),
              _buildBottomSheetItem(
                context: context,
                icon: Icon(
                  isMemorized ? Icons.star : Icons.star_border,
                  color: const Color(0xFF13A884),
                ),
                title: 'Simpan ke Bookmark',
                onTap: () {
                  Navigator.pop(context);
                  _toggleMemorizedAyat(ayat.nomorAyat);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildAyatItem(SurahDetailModel surah, AyatModel ayat) {
    final settings = Provider.of<SettingsProvider>(context);
    final isDarkMode = settings.themeModeStr == 'Gelap';

    final int index = ayat.nomorAyat - 1;
    _ayatKeys.putIfAbsent(index, () => GlobalKey());
    final itemKey = _ayatKeys[index];

    return StreamBuilder<PlayerState>(
      stream: _player.playerStateStream,
      builder: (context, snapshot) {
        final playerState = snapshot.data;
        final playing = playerState?.playing ?? false;
        final processingState = playerState?.processingState ?? ProcessingState.idle;
        bool isPlaying = _currentlyPlayingAyat == ayat.nomorAyat &&
            (playing || processingState == ProcessingState.loading || processingState == ProcessingState.buffering);

        return Container(
          key: itemKey,
          decoration: BoxDecoration(
            color: isPlaying
                ? (isDarkMode ? const Color(0xFF0F362C) : const Color(0xFFE8F5F1))
                : Colors.transparent,
            border: Border(
              bottom: BorderSide(
                color: isDarkMode ? Colors.grey[850]! : Colors.grey[200]!,
                width: 1,
              ),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Left option menu trigger (three vertical dots)
                IconButton(
                  icon: Icon(
                    Icons.more_vert,
                    color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                  ),
                  onPressed: () => _showVerseOptionsBottomSheet(context, surah, ayat),
                ),
                const SizedBox(width: 8),
                // Verse content: Arabic, Transliteration, and translation
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Arabic verse text with inline end-of-verse ornament
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: _buildTajwidRichText(
                              ayat.teksArab,
                              settings.showWarnaTajwid,
                              isDarkMode,
                              settings.arabFontSize,
                              ayat.nomorAyat,
                            ),
                          ),
                        ],
                      ),
                      if (_showTranslation) ...[
                        if (settings.showTransliterasi) ...[
                          const SizedBox(height: 12),
                          // Latin Transliteration (Teal)
                          Text(
                            ayat.teksLatin,
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              fontSize: settings.latinFontSize,
                              fontStyle: FontStyle.italic,
                              color: const Color(0xFF13A884),
                              height: 1.4,
                            ),
                          ),
                        ],
                        if (settings.showTerjemah) ...[
                          const SizedBox(height: 8),
                          // Indonesian translation
                          Text(
                            ayat.teksIndonesia,
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              fontSize: settings.latinFontSize + 1,
                              color: isDarkMode ? Colors.white70 : Colors.grey[600],
                              height: 1.4,
                            ),
                          ),
                        ],
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showInfo(SurahDetailModel surah) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    showModalBottomSheet(
      context: context,
      backgroundColor: isDarkMode ? Theme.of(context).colorScheme.surface : Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Tentang Surah',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF13A884)),
              ),
              const SizedBox(height: 16),
              Flexible(
                child: SingleChildScrollView(
                  child: Text(
                    surah.deskripsi.replaceAll(RegExp(r'<[^>]*>'), ''),
                    style: const TextStyle(fontSize: 14, height: 1.6),
                    textAlign: TextAlign.justify,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF13A884),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text('Tutup'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTafsirItem(TafsirAyatModel item) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    
    // Split text by newlines to render clean paragraphs
    final paragraphs = item.teks.split('\n').where((p) => p.trim().isNotEmpty).toList();

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDarkMode ? Theme.of(context).colorScheme.surface : Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(
          color: isDarkMode ? Colors.transparent : Colors.grey.shade100,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header: Ayat Number Badge
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFF0C5441).withOpacity(0.08),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.book_rounded,
                      size: 14,
                      color: Color(0xFF13A884),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'Tafsir Ayat ${item.ayat}',
                      style: GoogleFonts.outfit(
                        color: const Color(0xFF0C5441),
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              // Copy Button
              IconButton(
                icon: Icon(
                  Icons.copy_rounded,
                  size: 18,
                  color: isDarkMode ? Colors.grey[400] : Colors.grey[500],
                ),
                onPressed: () {
                  Clipboard.setData(ClipboardData(text: item.teks));
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Tafsir Ayat ${item.ayat} disalin ke papan klip!'),
                      behavior: SnackBarBehavior.floating,
                      backgroundColor: const Color(0xFF0C5441),
                    ),
                  );
                },
                tooltip: 'Salin Tafsir',
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Paragraphs
          ...paragraphs.map((paragraph) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 12.0),
              child: Text(
                paragraph.trim(),
                style: TextStyle(
                  fontSize: 14,
                  height: 1.6,
                  color: isDarkMode ? Colors.white70 : Colors.black87,
                ),
                textAlign: TextAlign.justify,
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildKeutamaanTabContent(SurahDetailModel surah) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    const primaryGreen = Color(0xFF13A884);
    const darkGreen = Color(0xFF0C5441);
    
    final virtue = SurahVirtue.getVirtue(surah.nomor, surah.namaLatin);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. Top Card: Title, Alternative Name, & Description
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: isDarkMode
                    ? [const Color(0xFF0A2B21), const Color(0xFF071F18)]
                    : [const Color(0xFFF9FBFB), const Color(0xFFE8F5F1)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: primaryGreen.withOpacity(0.15),
                width: 1.2,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: primaryGreen.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.stars_rounded,
                        color: Color(0xFFE1B12C), // Gold star
                        size: 28,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Keutamaan Surah',
                            style: GoogleFonts.outfit(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: primaryGreen,
                              letterSpacing: 1.0,
                            ),
                          ),
                          Text(
                            surah.namaLatin,
                            style: GoogleFonts.outfit(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: isDarkMode ? Colors.white : darkGreen,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                if (virtue.namaLain.isNotEmpty) ...[
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      Icon(
                        Icons.local_offer_rounded,
                        size: 14,
                        color: primaryGreen.withOpacity(0.7),
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          'Nama Lain: ${virtue.namaLain}',
                          style: GoogleFonts.outfit(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: isDarkMode ? Colors.white70 : darkGreen.withOpacity(0.8),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
                const SizedBox(height: 12),
                Divider(color: primaryGreen.withOpacity(0.15), thickness: 1),
                const SizedBox(height: 12),
                Text(
                  virtue.deskripsi,
                  style: TextStyle(
                    fontSize: 14,
                    height: 1.6,
                    color: isDarkMode ? Colors.white70 : Colors.black87,
                  ),
                  textAlign: TextAlign.justify,
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // 2. Hadith Card (Quote)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: isDarkMode ? Theme.of(context).colorScheme.surface : Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isDarkMode ? Colors.transparent : Colors.grey.shade100,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.03),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.format_quote_rounded,
                      color: Color(0xFF13A884),
                      size: 24,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Dalil / Hadits Rujukan',
                      style: GoogleFonts.outfit(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: isDarkMode ? Colors.white : darkGreen,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                // Arabic Hadith
                if (virtue.haditsArab.isNotEmpty) ...[
                  Text(
                    virtue.haditsArab,
                    textAlign: TextAlign.right,
                    style: GoogleFonts.scheherazadeNew(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: primaryGreen,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 14),
                ],
                // Translation
                Text(
                  virtue.haditsTerjemahan,
                  style: TextStyle(
                    fontSize: 14,
                    fontStyle: FontStyle.italic,
                    height: 1.5,
                    color: isDarkMode ? Colors.white70 : Colors.grey[800],
                  ),
                  textAlign: TextAlign.justify,
                ),
                const SizedBox(height: 12),
                Text(
                  virtue.riwayat,
                  textAlign: TextAlign.right,
                  style: GoogleFonts.outfit(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: primaryGreen,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // 3. Fadhilah / Keutamaan Utama List
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: isDarkMode ? Theme.of(context).colorScheme.surface : Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isDarkMode ? Colors.transparent : Colors.grey.shade100,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.03),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Fadhilah Utama',
                  style: GoogleFonts.outfit(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: isDarkMode ? Colors.white : darkGreen,
                  ),
                ),
                const SizedBox(height: 16),
                ...virtue.fadhilah.map((fadhilahItem) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          margin: const EdgeInsets.only(top: 2),
                          child: const Icon(
                            Icons.check_circle_rounded,
                            color: Color(0xFF13A884),
                            size: 16,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            fadhilahItem,
                            style: TextStyle(
                              fontSize: 13,
                              height: 1.5,
                              color: isDarkMode ? Colors.white70 : Colors.black87,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTajwidRichText(String text, bool showColor, bool isDarkMode, double fontSize, int ayatNomor) {
    final baseColor = isDarkMode ? Colors.white : const Color(0xFF0C5441);
    final style = GoogleFonts.scheherazadeNew(
      fontSize: fontSize,
      fontWeight: FontWeight.bold,
      color: baseColor,
      height: 1.6,
    );

    final ornamentSpan = WidgetSpan(
      alignment: PlaceholderAlignment.middle,
      child: Padding(
        padding: const EdgeInsets.only(right: 8.0, left: 4.0),
        child: _buildAyatNumberOrnament(ayatNomor),
      ),
    );

    if (!showColor) {
      return Directionality(
        textDirection: TextDirection.rtl,
        child: RichText(
          textAlign: TextAlign.right,
          text: TextSpan(
            children: [
              TextSpan(text: text, style: style),
              ornamentSpan,
            ],
          ),
        ),
      );
    }

    final ghunnahColor = const Color(0xFF27AE60); 
    final qalqalahColor = const Color(0xFFE67E22); 
    final madColor = const Color(0xFFC0392B); 
    final idghamColor = const Color(0xFF2980B9); 

    List<InlineSpan> spans = [];
    int i = 0;
    while (i < text.length) {
      String char = text[i];
      
      if ((char == 'ن' || char == 'م') && i + 1 < text.length && text[i + 1] == 'ّ') {
        spans.add(TextSpan(text: char + 'ّ', style: style.copyWith(color: ghunnahColor)));
        i += 2;
        continue;
      }
      
      if (('بجدطق'.contains(char)) && i + 1 < text.length && text[i + 1] == 'ْ') {
        spans.add(TextSpan(text: char + 'ْ', style: style.copyWith(color: qalqalahColor)));
        i += 2;
        continue;
      }
      
      if (char == '\u0670' || char == '\u0653' || char == 'آ') {
        spans.add(TextSpan(text: char, style: style.copyWith(color: madColor)));
        i++;
        continue;
      }
      
      if ((char == '\u064b' || char == '\u064c' || char == '\u064d') && i + 1 < text.length && 'يرملون'.contains(text[i + 1])) {
        spans.add(TextSpan(text: char, style: style.copyWith(color: idghamColor)));
        i++;
        continue;
      }

      spans.add(TextSpan(text: char, style: style));
      i++;
    }

    spans.add(ornamentSpan);

    return Directionality(
      textDirection: TextDirection.rtl,
      child: RichText(
        textAlign: TextAlign.right,
        text: TextSpan(children: spans),
      ),
    );
  }
}

class IslamicArchClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    final w = size.width;
    final h = size.height;
    
    path.moveTo(0, h);
    path.lineTo(0, h * 0.35);
    
    // Islamic arch curve
    // Left side shoulder curves
    path.quadraticBezierTo(0, h * 0.15, w * 0.25, h * 0.12);
    // Left curve to peak
    path.quadraticBezierTo(w * 0.45, h * 0.08, w * 0.5, 0);
    // Right curve from peak
    path.quadraticBezierTo(w * 0.55, h * 0.08, w * 0.75, h * 0.12);
    // Right shoulder curves
    path.quadraticBezierTo(w, h * 0.15, w, h * 0.35);
    
    path.lineTo(w, h);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}

class SurahVirtue {
  final String namaLain;
  final String deskripsi;
  final String haditsArab;
  final String haditsTerjemahan;
  final String riwayat;
  final List<String> fadhilah;

  SurahVirtue({
    required this.namaLain,
    required this.deskripsi,
    required this.haditsArab,
    required this.haditsTerjemahan,
    required this.riwayat,
    required this.fadhilah,
  });

  static SurahVirtue getVirtue(int nomorSurah, String namaLatin) {
    switch (nomorSurah) {
      case 1:
        return SurahVirtue(
          namaLain: 'Ummul Qur\'an, As-Sab\'ul Matsani, Asy-Syifa',
          deskripsi: 'Surah Al-Fatihah adalah surah paling agung dalam Al-Qur\'an. Ia merupakan rukun shalat yang wajib dibaca pada setiap rakaat dan berfungsi sebagai obat (ruqyah) penyembuh dari berbagai penyakit hati maupun fisik.',
          haditsArab: 'أَعْظَمُ سُورَةٍ فِي الْقُرْآنِ',
          haditsTerjemahan: '"Maukah aku ajarkan kepadamu surah yang paling agung di dalam Al-Qur\'an sebelum engkau keluar dari masjid?" Beliau bersabda: "Al-Hamdulillahi Rabbil \'Alamin (Al-Fatihah), ia adalah As-Sab\'ul Matsani (tujuh ayat yang berulang-ulang) dan Al-Qur\'an Al-Azhim yang diberikan kepadaku."',
          riwayat: 'HR. Bukhari no. 4474',
          fadhilah: [
            'Rukun shalat yang wajib dibaca pada setiap rakaat.',
            'Asy-Syifa: Penawar dan penyembuh atas izin Allah.',
            'Membuka pintu-pintu kebaikan dan keberkahan doa.',
          ],
        );
      case 2:
        return SurahVirtue(
          namaLain: 'Fusthathul Qur\'an (Tenda Al-Qur\'an)',
          deskripsi: 'Surah Al-Baqarah adalah surah terpanjang yang memiliki kekuatan perlindungan yang sangat besar bagi rumah tangga dari gangguan setan dan sihir. Di dalamnya terdapat Ayat Kursi, ayat paling agung dalam Al-Qur\'an.',
          haditsArab: 'إِنَّ الشَّيْطَانَ يَنْفِرُ مِنَ الْبَيْتِ الَّذِي تُقْرَأُ فِيهِ سُورَةُ الْبَقَرَةِ',
          haditsTerjemahan: '"Janganlah jadikan rumah-rumah kalian seperti kuburan, sesungguhnya setan lari dari rumah yang dibacakan di dalamnya surah Al-Baqarah."',
          riwayat: 'HR. Muslim no. 780',
          fadhilah: [
            'Mengusir setan dan pengaruh sihir dari dalam rumah.',
            'Mengandung Ayat Kursi sebagai pelindung utama sebelum tidur.',
            'Dua ayat terakhirnya mencukupi perlindungan sepanjang malam.',
          ],
        );
      case 18:
        return SurahVirtue(
          namaLain: 'Al-Ishmah (Perlindungan)',
          deskripsi: 'Surah Al-Kahfi memberikan pancaran cahaya iman bagi pembacanya di antara dua Jumat, serta menjadi perisai kokoh yang melindungi umat Islam dari dahsyatnya fitnah Dajjal di akhir zaman.',
          haditsArab: 'مَنْ حَفِظَ عَشْرَ آيَاتٍ مِنْ أَوَّلِ سُورَةِ الْكَهْفِ عُصِمَ مِنَ الدَّجَّالِ',
          haditsTerjemahan: '"Barangsiapa menghafal sepuluh ayat pertama dari surah Al-Kahfi, maka ia akan terlindungi dari fitnah Dajjal."',
          riwayat: 'HR. Muslim no. 809',
          fadhilah: [
            'Menjadi cahaya penerang di antara dua Jumat bagi pembacanya.',
            'Perlindungan mutlak dari fitnah Dajjal dengan menghafal 10 ayat pertamanya.',
            'Mendatangkan ketenangan jiwa (sakinah) saat dibaca.',
          ],
        );
      case 36:
        return SurahVirtue(
          namaLain: 'Qalbul Qur\'an (Jantung Al-Qur\'an)',
          deskripsi: 'Surah Yasin merupakan jantung dari kitab suci Al-Qur\'an. Membaca Yasin dengan ikhlas karena Allah mendatangkan ampunan dosa-dosa yang lalu dan memberikan kemudahan dalam setiap urusan hidup.',
          haditsArab: 'إِنَّ لِكُلِّ شَيْءٍ قَلْبًا وَقَلْبُ الْقُرْآنِ يس',
          haditsTerjemahan: '"Sesungguhnya segala sesuatu memiliki jantung (hati), dan jantung Al-Qur\'an adalah surah Yasin. Barangsiapa membacanya, Allah mencatat baginya pahala membaca Al-Qur\'an sepuluh kali."',
          riwayat: 'HR. Tirmidzi no. 2887 (Hadits Fadhilah)',
          fadhilah: [
            'Mendapatkan ampunan dosa di malam hari jika dibaca dengan ikhlas.',
            'Memberikan ketenangan dan meringankan sakaratul maut bagi yang membacanya.',
            'Mempermudah hajat hidup dan melapangkan kesusahan.',
          ],
        );
      case 55:
        return SurahVirtue(
          namaLain: '\'Arusul Qur\'an (Pengantin Al-Qur\'an)',
          deskripsi: 'Surah Ar-Rahman adalah surat yang sangat indah yang menggambarkan keluasan sifat kasih sayang Allah (Ar-Rahman). Membacanya menumbuhkan rasa syukur mendalam atas nikmat lahir dan batin.',
          haditsArab: 'لِكُلِّ شَيْءٍ عَرُوسٌ، وَعَرُوسُ الْقُرْآنِ سُورَةُ الرَّحْمَنِ',
          haditsTerjemahan: '"Setiap sesuatu memiliki pengantin (hiasan), dan pengantin Al-Qur\'an adalah surah Ar-Rahman."',
          riwayat: 'HR. Baihaqi dalam Syu\'abul Iman',
          fadhilah: [
            'Mengingatkan hamba secara mendalam akan nikmat-nikmat Allah yang tak terhitung.',
            'Menanamkan kecintaan yang kuat kepada Sang Pencipta Yang Maha Pengasih.',
            'Melunakkan hati yang keras dengan untaian ayatnya yang berirama indah.',
          ],
        );
      case 56:
        return SurahVirtue(
          namaLain: 'Surah Kekayaan',
          deskripsi: 'Surah Al-Waqi\'ah menceritakan gambaran hari kiamat dan pembagian golongan manusia. Membaca Al-Waqi\'ah secara istiqamah di malam hari berkhasiat menghindarkan seseorang dari kesusahan ekonomi.',
          haditsArab: 'مَنْ قَرَأَ سُورَةَ الْوَاقِعَةِ كُلَّ لَيْلَةٍ لَمْ تُصِبْهُ فَاقَةٌ أَبَدًا',
          haditsTerjemahan: '"Barangsiapa membaca surah Al-Waqi\'ah setiap malam, maka dia tidak akan tertimpa kefakiran (kemiskinan) selamanya."',
          riwayat: 'HR. Al-Harits bin Abu Usamah (Hadits Fadhilah)',
          fadhilah: [
            'Diberikan kecukupan rezeki dan dijauhkan dari kemiskinan.',
            'Menjadi alarm pengingat tentang kepastian hari kiamat.',
            'Mendidik jiwa untuk bersikap zuhud terhadap kemewahan dunia.',
          ],
        );
      case 67:
        return SurahVirtue(
          namaLain: 'Al-Mani\'ah (Pencegah), Al-Munjiyah (Penyelamat)',
          deskripsi: 'Surah Al-Mulk memiliki keutamaan luar biasa sebagai pembela pembacanya di hari penghakiman. Rutin membacanya sebelum tidur akan menjadi pelindung dan penyelamat dari siksa kubur.',
          haditsArab: 'سُورَةٌ مِنَ الْقُرْآنِ ثَلَاثُونَ آيَةً تَشْفَعُ لِصَاحِبِهَا حَتَّى يُغْفَرَ لَهُ',
          haditsTerjemahan: '"Ada satu surah di dalam Al-Qur\'an yang terdiri dari tiga puluh ayat, ia dapat memberikan syafaat bagi pembacanya hingga ia diampuni, yaitu surah Tabarakalladzi bi yadihil mulk (Al-Mulk)."',
          riwayat: 'HR. Abu Dawud no. 1400 & Tirmidzi no. 2891',
          fadhilah: [
            'Pencegah utama dari siksa kubur jika dibaca istiqamah sebelum tidur.',
            'Memberikan syafaat pembelaan di hari kiamat hingga dosa diampuni.',
            'Menegaskan keagungan dan kekuasaan mutlak Allah atas alam semesta.',
          ],
        );
      case 112:
        return SurahVirtue(
          namaLain: 'Al-Ikhlas (Kemurnian Tauhid)',
          deskripsi: 'Surah Al-Ikhlas mengandung penjelasan murni tentang sifat keesaan Allah yang mutlak. Membacanya setara dengan membaca sepertiga isi Al-Qur\'an dan mencintai surah ini mendatangkan cinta Allah.',
          haditsArab: 'قُلْ هُوَ اللَّهُ أَحَدٌ تَعْدِلُ ثُلُثَ الْقُرْآنِ',
          haditsTerjemahan: '"Demi Zat yang jiwaku berada di tangan-Nya, sesungguhnya surah Qul Huwallahu Ahad sebanding dengan sepertiga Al-Qur\'an."',
          riwayat: 'HR. Bukhari no. 5013',
          fadhilah: [
            'Setara sepertiga Al-Qur\'an dalam hal pahala dan isi kandungan tauhid.',
            'Mendapatkan istana di surga bagi yang membacanya sepuluh kali sehari.',
            'Menjadi wasilah masuk surga karena rasa cinta kepada kandungan maknanya.',
          ],
        );
      case 113:
      case 114:
        return SurahVirtue(
          namaLain: 'Al-Mu\'awwidzatain (Dua Pelindung)',
          deskripsi: 'Surah Al-Falaq dan An-Nas diturunkan bersamaan sebagai obat perlindungan mutlak bagi umat Islam dari kejahatan malam, bisikan setan, sihir, hasad, serta kejahatan mahluk lainnya.',
          haditsArab: 'قُلْ أَعُوذُ بِرَبِّ الْفَلَقِ وَ قُلْ أَعُوذُ بِرَبِّ النَّاسِ',
          haditsTerjemahan: '"Tidakkah engkau tahu bahwa malam ini telah diturunkan ayat-ayat yang tidak ada bandingannya sama sekali, yaitu Qul A\'udzu Birabbil Falaq dan Qul A\'udzu Birabbin Nas."',
          riwayat: 'HR. Muslim no. 814',
          fadhilah: [
            'Sarana perlindungan (ruqyah mandiri) terbaik dari sihir dan penyakit non-fisik (\'ain).',
            'Menjaga diri dari bisikan-bisikan jahat setan dari golongan jin dan manusia.',
            'Sunnah dibaca rutin setelah shalat wajib dan sebelum tidur.',
          ],
        );
      default:
        return SurahVirtue(
          namaLain: 'Kalamullah (Wahyu Suci)',
          deskripsi: 'Membaca Surah $namaLatin merupakan ibadah yang mulia. Setiap ayat yang dilafalkan mengandung keberkahan dan pahala yang dilipatgandakan oleh Allah SWT.',
          haditsArab: 'مَنْ قَرَأَ حَرْفًا مِنْ كِتَابِ اللَّهِ فَلَهُ بِهِ حَسَنَةٌ',
          haditsTerjemahan: '"Barangsiapa membaca satu huruf dari kitab Allah (Al-Qur\'an), maka baginya satu kebaikan, dan satu kebaikan dilipatgandakan menjadi sepuluh kali lipat. Aku tidak mengatakan Alif Lam Mim itu satu huruf..."',
          riwayat: 'HR. Tirmidzi no. 2910',
          fadhilah: [
            'Setiap huruf yang dibaca bernilai 10 kebaikan di sisi Allah.',
            'Al-Qur\'an akan datang sebagai saksi penolong (syafaat) di hari kiamat.',
            'Mendatangkan rahmat, ketenangan, serta naungan para malaikat bagi pembacanya.',
          ],
        );
    }
  }
}
