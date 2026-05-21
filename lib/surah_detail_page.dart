import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:just_audio/just_audio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'quran_service.dart';

class SurahDetailPage extends StatefulWidget {
  final int nomor;
  const SurahDetailPage({super.key, required this.nomor});

  @override
  State<SurahDetailPage> createState() => _SurahDetailPageState();
}

class _SurahDetailPageState extends State<SurahDetailPage> {
  late Future<SurahDetailModel> _surahDetail;
  final AudioPlayer _player = AudioPlayer();
  int? _currentlyPlayingAyat;
  bool _isFullSurahPlaying = false;
  List<String> _favoriteSurahs = [];

  @override
  void initState() {
    super.initState();
    _surahDetail = QuranService().getSurahDetail(widget.nomor);
    _loadFavorites();
    
    _player.playerStateStream.listen((state) {
      if (state.processingState == ProcessingState.completed) {
        setState(() {
          _currentlyPlayingAyat = null;
          _isFullSurahPlaying = false;
        });
      }
    });
  }

  Future<void> _loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _favoriteSurahs = prefs.getStringList('favoriteSurahs') ?? [];
    });
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

      if ((isCurrentFullSurah || isCurrentAyat) && _player.playing) {
        await _player.pause();
        setState(() {
          _currentlyPlayingAyat = null;
          _isFullSurahPlaying = false;
        });
        return;
      }

      await _player.stop();
      await _player.setUrl(url);
      await _player.play();
      
      setState(() {
        _currentlyPlayingAyat = ayatNomor;
        _isFullSurahPlaying = ayatNomor == null;
      });
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
          backgroundColor: Colors.white,
          body: CustomScrollView(
            slivers: [
              _buildSliverAppBar(surah),
              SliverToBoxAdapter(
                child: _buildAudioControlCard(surah),
              ),
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    return _buildAyatItem(surah.ayat[index]);
                  },
                  childCount: surah.ayat.length,
                ),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 32)),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSliverAppBar(SurahDetailModel surah) {
    final bool isFavorite = _favoriteSurahs.contains(widget.nomor.toString());
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
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: const Center(
              child: Icon(
                Icons.chevron_left,
                color: Color(0xFF0C5441),
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
            onTap: _toggleFavoriteSurah,
            child: Container(
              width: 40,
              height: 40,
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Icon(
                  isFavorite ? Icons.bookmark : Icons.bookmark_border,
                  color: const Color(0xFF0C5441),
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
              color: const Color(0xFFE8F5F1), // Soft mint green background matching Gambar 1
              child: Stack(
                children: [
                  // Mosque silhouette in the background
                  Positioned(
                    right: -20,
                    bottom: 0,
                    child: Opacity(
                      opacity: 0.15,
                      child: Icon(
                        Icons.mosque,
                        size: 170,
                        color: const Color(0xFF13A884).withOpacity(0.3),
                      ),
                    ),
                  ),
                  // Quran Rehal image in the foreground
                  Positioned(
                    right: 8,
                    bottom: 12,
                    top: 60,
                    width: 150,
                    child: Image.asset(
                      'assets/images/quran_rehal.png',
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) => const SizedBox(),
                    ),
                  ),
                  // Left side info
                  Positioned(
                    left: 20,
                    bottom: 24,
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
                            color: const Color(0xFF0C5441),
                            height: 1.0,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          surah.namaLatin,
                          style: GoogleFonts.outfit(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF0C5441),
                            height: 1.0,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Surah ke-${surah.nomor} • ${surah.jumlahAyat} Ayat • ${surah.tempatTurun == 'mekah' ? 'Makkiyah' : 'Madaniyah'}',
                          style: GoogleFonts.outfit(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: const Color(0xFF0C5441).withOpacity(0.7),
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
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              const Icon(Icons.audiotrack, color: Color(0xFF13A884), size: 20),
              const SizedBox(width: 8),
              Text(
                'Audio Surah Lengkap',
                style: GoogleFonts.outfit(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey.shade800,
                ),
              ),
            ],
          ),
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.info_outline, color: Color(0xFF13A884), size: 20),
                tooltip: 'Info Surah',
                onPressed: () => _showInfo(surah),
              ),
              const SizedBox(width: 8),
              StreamBuilder<PlayerState>(
                stream: _player.playerStateStream,
                builder: (context, snapshot) {
                  final playerState = snapshot.data;
                  final playing = playerState?.playing ?? false;
                  bool isThisPlaying = playing && _isFullSurahPlaying;
                  
                  return ElevatedButton.icon(
                    onPressed: () => _playAudio(surah.audio),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF13A884),
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    ),
                    icon: Icon(
                      isThisPlaying ? Icons.stop : Icons.play_arrow,
                      size: 16,
                    ),
                    label: Text(
                      isThisPlaying ? 'Stop' : 'Putar',
                      style: GoogleFonts.outfit(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }


  Widget _buildAyatItem(AyatModel ayat) {
    return StreamBuilder<PlayerState>(
      stream: _player.playerStateStream,
      builder: (context, snapshot) {
        final playerState = snapshot.data;
        final playing = playerState?.playing ?? false;
        bool isPlaying = playing && _currentlyPlayingAyat == ayat.nomorAyat;

        return Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            border: Border(bottom: BorderSide(color: Colors.grey[100]!)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    decoration: const BoxDecoration(
                      color: Color(0xFF13A884),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        '${ayat.nomorAyat}',
                        style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: Icon(
                      isPlaying ? Icons.pause_circle_outline : Icons.play_circle_outline,
                      color: const Color(0xFF13A884),
                    ),
                    onPressed: () => _playAudio(ayat.audio['05'] ?? ayat.audio.values.first, ayatNomor: ayat.nomorAyat),
                  ),
                  IconButton(
                    icon: const Icon(Icons.share_outlined, color: Colors.grey),
                    onPressed: () {},
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Text(
                ayat.teksArab,
                textAlign: TextAlign.right,
                style: GoogleFonts.scheherazadeNew(
                  fontSize: 32,
                  height: 1.8,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF2D2D2D),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                ayat.teksLatin,
                style: const TextStyle(
                  fontSize: 14,
                  fontStyle: FontStyle.italic,
                  color: Color(0xFF13A884),
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                ayat.teksIndonesia,
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.grey[800],
                  height: 1.5,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showInfo(SurahDetailModel surah) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
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
}
