import 'package:flutter/material.dart';
import 'dart:math';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:just_audio/just_audio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import 'quran_service.dart';
import 'settings_provider.dart';
import 'settings_page.dart';

class SurahDetailPage extends StatefulWidget {
  final int nomor;
  const SurahDetailPage({super.key, required this.nomor});

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

  void _showFontSizeDialog(BuildContext context, SettingsProvider settings) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Pilih Ukuran Font', style: TextStyle(fontWeight: FontWeight.bold)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: ['Kecil', 'Sedang', 'Besar'].map((option) {
              return RadioListTile<String>(
                title: Text(option),
                value: option,
                groupValue: settings.fontSize,
                activeColor: const Color(0xFF13A884),
                onChanged: (String? value) {
                  if (value != null) {
                    settings.setFontSize(value);
                    Navigator.pop(context);
                  }
                },
              );
            }).toList(),
          ),
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
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
      _player.setUrl(surah.audio).then((_) {
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
    _player.dispose();
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

      await _player.setUrl(url);
      await _player.play();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal memutar audio. Ini mungkin karena pembatasan browser (CORS). Coba akses di perangkat seluler atau browser lain.'),
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
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              border: Border.all(color: const Color(0xFF13A884).withOpacity(0.5), width: 1.5),
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        ),
        Container(
          width: 34,
          height: 34,
          decoration: BoxDecoration(
            border: Border.all(color: const Color(0xFF13A884).withOpacity(0.5), width: 1.5),
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        Text(
          '$number',
          style: GoogleFonts.outfit(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF13A884),
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
                          _playAudio(prevAyatModel.audio['05'] ?? prevAyatModel.audio.values.first, ayatNomor: prevAyat);
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
                          _playAudio(nextAyatModel.audio['05'] ?? nextAyatModel.audio.values.first, ayatNomor: nextAyat);
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
        return Scaffold(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          body: Stack(
            children: [
              CustomScrollView(
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
                          return _buildAyatItem(surah.ayat[index]);
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
                      child: _buildPlaceholderTabContent('Keutamaan Surah ini sedang disiapkan.', Icons.star),
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
            titlePadding: EdgeInsets.zero,
            centerTitle: true,
            title: isCollapsed
                ? Text(
                    surah.namaLatin,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
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
                        icon: const Icon(Icons.file_download_outlined, color: Color(0xFF13A884), size: 18),
                        tooltip: 'Unduh Audio',
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Mengunduh audio surah...'),
                              duration: Duration(seconds: 1),
                            ),
                          );
                        },
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: () => _playAudio(surah.audio),
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


  Widget _buildAyatItem(AyatModel ayat) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return StreamBuilder<PlayerState>(
      stream: _player.playerStateStream,
      builder: (context, snapshot) {
        final playerState = snapshot.data;
        final playing = playerState?.playing ?? false;
        final processingState = playerState?.processingState ?? ProcessingState.idle;
        bool isPlaying = _currentlyPlayingAyat == ayat.nomorAyat &&
            (playing || processingState == ProcessingState.loading || processingState == ProcessingState.buffering);

        final bool isMemorized = _memorizedAyats.contains("${widget.nomor}_${ayat.nomorAyat}");

        return Container(
          margin: const EdgeInsets.only(bottom: 12, left: 16, right: 16),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isDarkMode ? Theme.of(context).colorScheme.surface : Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.02),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
            border: Border.all(
              color: isDarkMode ? Colors.transparent : Colors.grey.shade100,
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                children: [
                  const SizedBox(height: 4),
                  _buildAyatNumberOrnament(ayat.nomorAyat),
                ],
              ),
              const SizedBox(width: 12),
              Container(
                width: 1,
                height: 48,
                color: isDarkMode ? Colors.grey[800] : Colors.grey[200],
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      ayat.teksArab,
                      textAlign: TextAlign.right,
                      style: GoogleFonts.scheherazadeNew(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: isDarkMode ? Colors.white : const Color(0xFF0C5441),
                        height: 1.6,
                      ),
                    ),
                    if (_showTranslation) ...[
                      const SizedBox(height: 8),
                      Text(
                        ayat.teksLatin,
                        textAlign: TextAlign.left,
                        style: const TextStyle(
                          fontSize: 12,
                          fontStyle: FontStyle.italic,
                          color: Color(0xFF13A884),
                          height: 1.4,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        ayat.teksIndonesia,
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontSize: 13,
                          color: isDarkMode ? Colors.white70 : Colors.grey[600],
                          height: 1.4,
                        ),
                      ),
                    ],
                    const SizedBox(height: 12),
                    // Action Buttons Row under the text
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () => _playAudio(ayat.audio['05'] ?? ayat.audio.values.first, ayatNomor: ayat.nomorAyat),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                isPlaying ? Icons.pause_circle_outline : Icons.play_circle_outline,
                                color: isPlaying ? const Color(0xFF13A884) : Colors.grey[600],
                                size: 18,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                isPlaying ? 'Pause' : 'Putar',
                                style: GoogleFonts.outfit(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color: isPlaying ? const Color(0xFF13A884) : Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 24),
                        GestureDetector(
                          onTap: () => _toggleMemorizedAyat(ayat.nomorAyat),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                isMemorized ? Icons.favorite : Icons.favorite_border,
                                color: isMemorized ? Colors.amber : Colors.grey[600],
                                size: 18,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                'Simpan',
                                style: GoogleFonts.outfit(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color: isMemorized ? Colors.amber : Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 24),
                        GestureDetector(
                          onTap: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Menyalin Ayat ${ayat.nomorAyat}...'),
                                duration: const Duration(seconds: 1),
                              ),
                            );
                          },
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.share_outlined,
                                color: Colors.grey[600],
                                size: 18,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                'Bagikan',
                                style: GoogleFonts.outfit(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
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
