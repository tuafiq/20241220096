import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
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
          SnackBar(content: Text('Gagal memutar audio. Pastikan koneksi internet aktif.')),
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

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF13A884);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7F8),
      appBar: AppBar(
        title: const Text(
          'Tahlil & Yasin',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: primaryColor,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          indicatorWeight: 3,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          tabs: const [
            Tab(text: 'Tahlil'),
            Tab(text: 'Yasin'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // Tab Tahlil
          ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            itemCount: DoaData.listTahlil.length,
            itemBuilder: (context, index) {
              return _buildTahlilItem(DoaData.listTahlil[index], index);
            },
          ),
          // Tab Yasin
          Column(
            children: [
              // Audio Player Controller
              Container(
                margin: const EdgeInsets.all(16),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: primaryColor.withOpacity(0.1),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.music_note, color: primaryColor, size: 20),
                        ),
                        const SizedBox(width: 12),
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Murottal Surah Yasin',
                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                              ),
                              Text(
                                'Mishary Rashid Alafasy',
                                style: TextStyle(color: Colors.grey, fontSize: 12),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: Icon(_isPlaying ? Icons.pause_circle_filled : Icons.play_circle_filled),
                          iconSize: 40,
                          color: primaryColor,
                          onPressed: _toggleAudio,
                        ),
                        IconButton(
                          icon: const Icon(Icons.replay),
                          color: Colors.grey,
                          onPressed: _replayAudio,
                        ),
                      ],
                    ),
                    SliderTheme(
                      data: SliderTheme.of(context).copyWith(
                        trackHeight: 2,
                        thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
                        overlayShape: const RoundSliderOverlayShape(overlayRadius: 14),
                      ),
                      child: Slider(
                        value: _position.inSeconds.toDouble(),
                        max: _duration.inSeconds.toDouble() > 0 ? _duration.inSeconds.toDouble() : 1.0,
                        activeColor: primaryColor,
                        inactiveColor: primaryColor.withOpacity(0.2),
                        onChanged: (value) {
                          _audioPlayer.seek(Duration(seconds: value.toInt()));
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(_formatDuration(_position), style: const TextStyle(fontSize: 10, color: Colors.grey)),
                          Text(_formatDuration(_duration), style: const TextStyle(fontSize: 10, color: Colors.grey)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              // Yasin List
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: YasinData.verses.length,
                  itemBuilder: (context, index) {
                    return _buildYasinVerseItem(YasinData.verses[index]);
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildYasinVerseItem(YasinVerse verse) {
    const primaryColor = Color(0xFF13A884);
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFE8F5F1), width: 2),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  verse.arabic,
                  textAlign: TextAlign.right,
                  style: const TextStyle(
                    fontSize: 24,
                    height: 2.0,
                    color: Color(0xFF13A884),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  verse.transliteration,
                  style: const TextStyle(
                    fontSize: 14,
                    fontStyle: FontStyle.italic,
                    color: Color(0xFF636E72),
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'Artinya:',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  verse.translation,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF2D3436),
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTahlilItem(TahlilModel tahlil, int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Index Number
          Container(
            width: 32,
            height: 32,
            decoration: const BoxDecoration(
              color: Color(0xFF13A884),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                '${index + 1}',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          // Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  tahlil.title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2D3436),
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0xFFE8F5F1), width: 2),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        tahlil.arabic,
                        textAlign: TextAlign.right,
                        style: const TextStyle(
                          fontSize: 22,
                          height: 1.8,
                          color: Color(0xFF13A884),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        tahlil.transliteration,
                        style: const TextStyle(
                          fontSize: 13,
                          fontStyle: FontStyle.italic,
                          color: Color(0xFF636E72),
                        ),
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        'Artinya:',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        tahlil.translation,
                        style: const TextStyle(
                          fontSize: 13,
                          color: Color(0xFF2D3436),
                          height: 1.5,
                        ),
                      ),
                      if (tahlil.note != null) ...[
                        const SizedBox(height: 12),
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFF9DB),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            tahlil.note!,
                            style: const TextStyle(
                              fontSize: 12,
                              fontStyle: FontStyle.italic,
                              color: Color(0xFFF08C00),
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
