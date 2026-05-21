import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:just_audio/just_audio.dart';
import 'quran_service.dart';
import 'quran_data.dart';

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

  @override
  void initState() {
    super.initState();
    _surahDetail = QuranService().getSurahDetail(widget.nomor);
    
    _player.playerStateStream.listen((state) {
      if (state.processingState == ProcessingState.completed) {
        setState(() {
          _currentlyPlayingAyat = null;
          _isFullSurahPlaying = false;
        });
      }
    });
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  Future<void> _playAudio(String url, {int? ayatNomor}) async {
    try {
      if (_currentlyPlayingAyat == ayatNomor && ayatNomor != null && _player.playing) {
        await _player.pause();
        setState(() {
          _currentlyPlayingAyat = null;
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
                child: _buildSurahHeader(surah),
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
    return SliverAppBar(
      expandedHeight: 200.0,
      floating: false,
      pinned: true,
      backgroundColor: const Color(0xFF13A884),
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
        onPressed: () => Navigator.pop(context),
      ),
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: true,
        title: Text(
          surah.namaLatin,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        background: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFF13A884), Color(0xFF0D7A60)],
            ),
          ),
          child: Center(
            child: Opacity(
              opacity: 0.2,
              child: Text(
                surah.nama,
                style: GoogleFonts.scheherazadeNew(
                  fontSize: 80,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSurahHeader(SurahDetailModel surah) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 15,
            offset: const Offset(0, 6),
          ),
        ],
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Quran Rehal Image on the left
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.asset(
              'assets/images/quran_rehal.png',
              width: 80,
              height: 80,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) => Container(
                width: 80,
                height: 80,
                color: Colors.teal.shade50,
                child: const Icon(Icons.menu_book, color: Color(0xFF13A884), size: 36),
              ),
            ),
          ),
          const SizedBox(width: 16),
          // Info on the right
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  surah.namaLatin,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0C5441),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  surah.arti,
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey.shade600,
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    _buildBadge(surah.tempatTurun),
                    const SizedBox(width: 8),
                    _buildBadge('${surah.jumlahAyat} Ayat'),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    StreamBuilder<PlayerState>(
                      stream: _player.playerStateStream,
                      builder: (context, snapshot) {
                        final playerState = snapshot.data;
                        final playing = playerState?.playing ?? false;
                        
                        bool isThisPlaying = playing && _isFullSurahPlaying;
                        
                        return TextButton.icon(
                          onPressed: () => _playAudio(surah.audio),
                          icon: Icon(
                            isThisPlaying ? Icons.stop_circle : Icons.play_circle_fill,
                            color: const Color(0xFF13A884),
                            size: 16,
                          ),
                          label: Text(
                            isThisPlaying ? 'Stop Full' : 'Play Full',
                            style: const TextStyle(
                              color: Color(0xFF13A884),
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          style: TextButton.styleFrom(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                            backgroundColor: const Color(0xFFE8F5F1),
                            minimumSize: Size.zero,
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        );
                      },
                    ),
                    const SizedBox(width: 8),
                    TextButton.icon(
                      onPressed: () => _showInfo(surah),
                      icon: const Icon(
                        Icons.info_outline,
                        color: Colors.blueAccent,
                        size: 16,
                      ),
                      label: const Text(
                        'Info',
                        style: TextStyle(
                          color: Colors.blueAccent,
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                        backgroundColor: Colors.blue.shade50,
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
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

  Widget _buildBadge(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFF13A884).withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label.toUpperCase(),
        style: const TextStyle(
          color: Color(0xFF13A884),
          fontSize: 11,
          fontWeight: FontWeight.bold,
        ),
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
