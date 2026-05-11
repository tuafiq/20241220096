import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'dart:ui';
import 'dart:math';
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
                  // Audio Player Controller (Premium Glassmorphism Design)
                  Container(
                    margin: const EdgeInsets.all(16),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(24),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.9),
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
                                  // Animated Music Icon
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
                                  const Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Murottal Surah Yasin',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                            color: Color(0xFF2D3436),
                                          ),
                                        ),
                                        Text(
                                          'Mishary Rashid Alafasy',
                                          style: TextStyle(
                                            color: Color(0xFF636E72),
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
                                    color: Colors.grey[400],
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
                                      style: const TextStyle(
                                        fontSize: 11,
                                        color: Color(0xFF636E72),
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      _formatDuration(_duration),
                                      style: const TextStyle(
                                        fontSize: 11,
                                        color: Color(0xFF636E72),
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
