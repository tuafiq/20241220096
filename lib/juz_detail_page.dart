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
import 'quran_settings_page.dart';
import 'preferensi_membaca_page.dart';
import 'pilih_surah_page.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

class JuzRange {
  final int surahNumber;
  final int startVerse;
  final int endVerse;
  
  const JuzRange({
    required this.surahNumber,
    required this.startVerse,
    required this.endVerse,
  });
}

const Map<int, List<JuzRange>> juzBoundaries = {
  1: [
    JuzRange(surahNumber: 1, startVerse: 1, endVerse: 7),
    JuzRange(surahNumber: 2, startVerse: 1, endVerse: 141),
  ],
  2: [
    JuzRange(surahNumber: 2, startVerse: 142, endVerse: 252),
  ],
  3: [
    JuzRange(surahNumber: 2, startVerse: 253, endVerse: 286),
    JuzRange(surahNumber: 3, startVerse: 1, endVerse: 92),
  ],
  4: [
    JuzRange(surahNumber: 3, startVerse: 93, endVerse: 200),
    JuzRange(surahNumber: 4, startVerse: 1, endVerse: 23),
  ],
  5: [
    JuzRange(surahNumber: 4, startVerse: 24, endVerse: 147),
  ],
  6: [
    JuzRange(surahNumber: 4, startVerse: 148, endVerse: 176),
    JuzRange(surahNumber: 5, startVerse: 1, endVerse: 81),
  ],
  7: [
    JuzRange(surahNumber: 5, startVerse: 82, endVerse: 120),
    JuzRange(surahNumber: 6, startVerse: 1, endVerse: 110),
  ],
  8: [
    JuzRange(surahNumber: 6, startVerse: 111, endVerse: 165),
    JuzRange(surahNumber: 7, startVerse: 1, endVerse: 87),
  ],
  9: [
    JuzRange(surahNumber: 7, startVerse: 88, endVerse: 206),
    JuzRange(surahNumber: 8, startVerse: 1, endVerse: 40),
  ],
  10: [
    JuzRange(surahNumber: 8, startVerse: 41, endVerse: 75),
    JuzRange(surahNumber: 9, startVerse: 1, endVerse: 92),
  ],
  11: [
    JuzRange(surahNumber: 9, startVerse: 93, endVerse: 129),
    JuzRange(surahNumber: 10, startVerse: 1, endVerse: 109),
    JuzRange(surahNumber: 11, startVerse: 1, endVerse: 5),
  ],
  12: [
    JuzRange(surahNumber: 11, startVerse: 6, endVerse: 123),
    JuzRange(surahNumber: 12, startVerse: 1, endVerse: 52),
  ],
  13: [
    JuzRange(surahNumber: 12, startVerse: 53, endVerse: 111),
    JuzRange(surahNumber: 13, startVerse: 1, endVerse: 43),
    JuzRange(surahNumber: 14, startVerse: 1, endVerse: 52),
  ],
  14: [
    JuzRange(surahNumber: 15, startVerse: 1, endVerse: 99),
    JuzRange(surahNumber: 16, startVerse: 1, endVerse: 128),
  ],
  15: [
    JuzRange(surahNumber: 17, startVerse: 1, endVerse: 111),
    JuzRange(surahNumber: 18, startVerse: 1, endVerse: 74),
  ],
  16: [
    JuzRange(surahNumber: 18, startVerse: 75, endVerse: 110),
    JuzRange(surahNumber: 19, startVerse: 1, endVerse: 98),
    JuzRange(surahNumber: 20, startVerse: 1, endVerse: 135),
  ],
  17: [
    JuzRange(surahNumber: 21, startVerse: 1, endVerse: 112),
    JuzRange(surahNumber: 22, startVerse: 1, endVerse: 78),
  ],
  18: [
    JuzRange(surahNumber: 23, startVerse: 1, endVerse: 118),
    JuzRange(surahNumber: 24, startVerse: 1, endVerse: 64),
    JuzRange(surahNumber: 25, startVerse: 1, endVerse: 20),
  ],
  19: [
    JuzRange(surahNumber: 25, startVerse: 21, endVerse: 77),
    JuzRange(surahNumber: 26, startVerse: 1, endVerse: 227),
    JuzRange(surahNumber: 27, startVerse: 1, endVerse: 55),
  ],
  20: [
    JuzRange(surahNumber: 27, startVerse: 56, endVerse: 93),
    JuzRange(surahNumber: 28, startVerse: 1, endVerse: 88),
    JuzRange(surahNumber: 29, startVerse: 1, endVerse: 45),
  ],
  21: [
    JuzRange(surahNumber: 29, startVerse: 46, endVerse: 69),
    JuzRange(surahNumber: 30, startVerse: 1, endVerse: 60),
    JuzRange(surahNumber: 31, startVerse: 1, endVerse: 34),
    JuzRange(surahNumber: 32, startVerse: 1, endVerse: 30),
    JuzRange(surahNumber: 33, startVerse: 1, endVerse: 30),
  ],
  22: [
    JuzRange(surahNumber: 33, startVerse: 31, endVerse: 73),
    JuzRange(surahNumber: 34, startVerse: 1, endVerse: 54),
    JuzRange(surahNumber: 35, startVerse: 1, endVerse: 45),
    JuzRange(surahNumber: 36, startVerse: 1, endVerse: 27),
  ],
  23: [
    JuzRange(surahNumber: 36, startVerse: 28, endVerse: 83),
    JuzRange(surahNumber: 37, startVerse: 1, endVerse: 182),
    JuzRange(surahNumber: 38, startVerse: 1, endVerse: 88),
    JuzRange(surahNumber: 39, startVerse: 1, endVerse: 31),
  ],
  24: [
    JuzRange(surahNumber: 39, startVerse: 32, endVerse: 75),
    JuzRange(surahNumber: 40, startVerse: 1, endVerse: 85),
    JuzRange(surahNumber: 41, startVerse: 1, endVerse: 46),
  ],
  25: [
    JuzRange(surahNumber: 41, startVerse: 47, endVerse: 54),
    JuzRange(surahNumber: 42, startVerse: 1, endVerse: 53),
    JuzRange(surahNumber: 43, startVerse: 1, endVerse: 89),
    JuzRange(surahNumber: 44, startVerse: 1, endVerse: 59),
    JuzRange(surahNumber: 45, startVerse: 1, endVerse: 37),
  ],
  26: [
    JuzRange(surahNumber: 46, startVerse: 1, endVerse: 35),
    JuzRange(surahNumber: 47, startVerse: 1, endVerse: 38),
    JuzRange(surahNumber: 48, startVerse: 1, endVerse: 29),
    JuzRange(surahNumber: 49, startVerse: 1, endVerse: 18),
    JuzRange(surahNumber: 50, startVerse: 1, endVerse: 45),
    JuzRange(surahNumber: 51, startVerse: 1, endVerse: 30),
  ],
  27: [
    JuzRange(surahNumber: 51, startVerse: 31, endVerse: 60),
    JuzRange(surahNumber: 52, startVerse: 1, endVerse: 49),
    JuzRange(surahNumber: 53, startVerse: 1, endVerse: 62),
    JuzRange(surahNumber: 54, startVerse: 1, endVerse: 55),
    JuzRange(surahNumber: 55, startVerse: 1, endVerse: 78),
    JuzRange(surahNumber: 56, startVerse: 1, endVerse: 96),
    JuzRange(surahNumber: 57, startVerse: 1, endVerse: 29),
  ],
  28: [
    JuzRange(surahNumber: 58, startVerse: 1, endVerse: 22),
    JuzRange(surahNumber: 59, startVerse: 1, endVerse: 24),
    JuzRange(surahNumber: 60, startVerse: 1, endVerse: 13),
    JuzRange(surahNumber: 61, startVerse: 1, endVerse: 14),
    JuzRange(surahNumber: 62, startVerse: 1, endVerse: 11),
    JuzRange(surahNumber: 63, startVerse: 1, endVerse: 11),
    JuzRange(surahNumber: 64, startVerse: 1, endVerse: 18),
    JuzRange(surahNumber: 65, startVerse: 1, endVerse: 12),
    JuzRange(surahNumber: 66, startVerse: 1, endVerse: 12),
  ],
  29: [
    JuzRange(surahNumber: 67, startVerse: 1, endVerse: 30),
    JuzRange(surahNumber: 68, startVerse: 1, endVerse: 52),
    JuzRange(surahNumber: 69, startVerse: 1, endVerse: 52),
    JuzRange(surahNumber: 70, startVerse: 1, endVerse: 44),
    JuzRange(surahNumber: 71, startVerse: 1, endVerse: 28),
    JuzRange(surahNumber: 72, startVerse: 1, endVerse: 28),
    JuzRange(surahNumber: 73, startVerse: 1, endVerse: 20),
    JuzRange(surahNumber: 74, startVerse: 1, endVerse: 56),
    JuzRange(surahNumber: 75, startVerse: 1, endVerse: 40),
    JuzRange(surahNumber: 76, startVerse: 1, endVerse: 31),
    JuzRange(surahNumber: 77, startVerse: 1, endVerse: 50),
  ],
  30: [
    JuzRange(surahNumber: 78, startVerse: 1, endVerse: 40),
    JuzRange(surahNumber: 79, startVerse: 1, endVerse: 46),
    JuzRange(surahNumber: 80, startVerse: 1, endVerse: 42),
    JuzRange(surahNumber: 81, startVerse: 1, endVerse: 29),
    JuzRange(surahNumber: 82, startVerse: 1, endVerse: 19),
    JuzRange(surahNumber: 83, startVerse: 1, endVerse: 36),
    JuzRange(surahNumber: 84, startVerse: 1, endVerse: 25),
    JuzRange(surahNumber: 85, startVerse: 1, endVerse: 22),
    JuzRange(surahNumber: 86, startVerse: 1, endVerse: 17),
    JuzRange(surahNumber: 87, startVerse: 1, endVerse: 19),
    JuzRange(surahNumber: 88, startVerse: 1, endVerse: 26),
    JuzRange(surahNumber: 89, startVerse: 1, endVerse: 30),
    JuzRange(surahNumber: 90, startVerse: 1, endVerse: 20),
    JuzRange(surahNumber: 91, startVerse: 1, endVerse: 15),
    JuzRange(surahNumber: 92, startVerse: 1, endVerse: 21),
    JuzRange(surahNumber: 93, startVerse: 1, endVerse: 11),
    JuzRange(surahNumber: 94, startVerse: 1, endVerse: 8),
    JuzRange(surahNumber: 95, startVerse: 1, endVerse: 8),
    JuzRange(surahNumber: 96, startVerse: 1, endVerse: 19),
    JuzRange(surahNumber: 97, startVerse: 1, endVerse: 5),
    JuzRange(surahNumber: 98, startVerse: 1, endVerse: 8),
    JuzRange(surahNumber: 99, startVerse: 1, endVerse: 8),
    JuzRange(surahNumber: 100, startVerse: 1, endVerse: 11),
    JuzRange(surahNumber: 101, startVerse: 1, endVerse: 11),
    JuzRange(surahNumber: 102, startVerse: 1, endVerse: 8),
    JuzRange(surahNumber: 103, startVerse: 1, endVerse: 3),
    JuzRange(surahNumber: 104, startVerse: 1, endVerse: 9),
    JuzRange(surahNumber: 105, startVerse: 1, endVerse: 5),
    JuzRange(surahNumber: 106, startVerse: 1, endVerse: 4),
    JuzRange(surahNumber: 107, startVerse: 1, endVerse: 7),
    JuzRange(surahNumber: 108, startVerse: 1, endVerse: 3),
    JuzRange(surahNumber: 109, startVerse: 1, endVerse: 6),
    JuzRange(surahNumber: 110, startVerse: 1, endVerse: 3),
    JuzRange(surahNumber: 111, startVerse: 1, endVerse: 5),
    JuzRange(surahNumber: 112, startVerse: 1, endVerse: 4),
    JuzRange(surahNumber: 113, startVerse: 1, endVerse: 5),
    JuzRange(surahNumber: 114, startVerse: 1, endVerse: 6),
  ],
};

class JuzAyatModel {
  final SurahDetailModel surah;
  final AyatModel ayat;
  
  JuzAyatModel({required this.surah, required this.ayat});
}

class JuzDetailPage extends StatefulWidget {
  final int juzNumber;
  const JuzDetailPage({super.key, required this.juzNumber});

  @override
  State<JuzDetailPage> createState() => _JuzDetailPageState();
}

class _JuzDetailPageState extends State<JuzDetailPage> {
  bool _isLoading = true;
  String _errorMessage = '';
  List<JuzAyatModel> _juzAyats = [];
  final AudioPlayer _player = AudioPlayer();
  int? _currentlyPlayingIndex;
  List<String> _memorizedAyats = [];
  bool _showTranslation = true;

  // New state variables for detailed UI/UX
  late int _currentJuzNumber;
  int? _currentSurahNomor;
  late ScrollController _scrollController;
  late ScrollController _juzTabScrollController;
  final Map<int, GlobalKey> _surahKeys = {};
  final Map<int, GlobalKey> _ayatKeys = {};
  int _playlistStartIndex = 0;
  int? _pendingScrollToSurah;
  int? _pendingScrollToVerse;

  void _scrollToCurrentlyPlaying() {
    if (_currentlyPlayingIndex == null) return;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final key = _ayatKeys[_currentlyPlayingIndex];
      if (key != null && key.currentContext != null) {
        Scrollable.ensureVisible(
          key.currentContext!,
          duration: const Duration(milliseconds: 600),
          curve: Curves.easeInOut,
          alignment: 0.3, // Centers the playing verse in the view
        );
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _currentJuzNumber = widget.juzNumber;
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);
    _juzTabScrollController = ScrollController();
    _loadJuzData();
    _loadFavorites();
    
    _player.playerStateStream.listen((state) {
      if (state.processingState == ProcessingState.completed) {
        if (mounted) {
          setState(() {
            _currentlyPlayingIndex = null;
          });
        }
      }
    });

    _player.currentIndexStream.listen((index) {
      if (index != null && mounted) {
        final actualIndex = _playlistStartIndex + index;
        if (_currentlyPlayingIndex != actualIndex && actualIndex < _juzAyats.length) {
          setState(() {
            _currentlyPlayingIndex = actualIndex;
          });
          _scrollToCurrentlyPlaying();

          final settings = Provider.of<SettingsProvider>(context, listen: false);
          if (settings.penandaOtomatis) {
            final item = _juzAyats[actualIndex];
            SharedPreferences.getInstance().then((prefs) async {
              await prefs.setString('lastReadSurah', item.surah.namaLatin);
              await prefs.setInt('lastReadVerse', item.ayat.nomorAyat);
              await prefs.setInt('lastReadSurahNumber', item.surah.nomor);
            });
          }
        }
      }
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToCurrentJuzTab();
    });
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    _juzTabScrollController.dispose();
    _player.dispose();
    WakelockPlus.disable();
    super.dispose();
  }

  void _scrollToCurrentJuzTab() {
    if (_currentJuzNumber > 1) {
      // Estimated width of each Juz tab is 80 pixels
      double targetOffset = (_currentJuzNumber - 1) * 80.0;
      if (_juzTabScrollController.hasClients) {
        _juzTabScrollController.animateTo(
          targetOffset,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    }
  }

  void _onScroll() {
    if (_juzAyats.isEmpty) return;
    double offset = _scrollController.offset;
    // Estimate current index in list
    int approxIndex = (offset / 180.0).round();
    if (approxIndex < 0) approxIndex = 0;
    if (approxIndex >= _juzAyats.length) approxIndex = _juzAyats.length - 1;
    
    final currentSurah = _juzAyats[approxIndex].surah;
    if (_currentSurahNomor != currentSurah.nomor) {
      setState(() {
        _currentSurahNomor = currentSurah.nomor;
      });
    }
  }

  Future<void> _loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _memorizedAyats = prefs.getStringList('memorizedAyats') ?? [];
    });
  }

  Future<void> _loadJuzData() async {
    _player.stop();
    setState(() {
      _isLoading = true;
      _errorMessage = '';
      _currentlyPlayingIndex = null;
      _ayatKeys.clear();
    });
    try {
      final boundaries = juzBoundaries[_currentJuzNumber];
      if (boundaries == null) {
        throw Exception('Juz boundary not found');
      }
      
      List<JuzAyatModel> tempAyats = [];
      
      // Fetch details of all surahs in this Juz concurrently to avoid lagging on long lists (like Juz 30)
      final uniqueSurahNums = boundaries.map((b) => b.surahNumber).toSet().toList();
      final surahFutures = uniqueSurahNums.map((sNum) => QuranService().getSurahDetail(sNum));
      final surahDetails = await Future.wait(surahFutures);
      
      Map<int, SurahDetailModel> fetchedSurahs = {};
      for (int i = 0; i < uniqueSurahNums.length; i++) {
        fetchedSurahs[uniqueSurahNums[i]] = surahDetails[i];
      }
      
      // Filter and slice verses according to Juz boundary rules
      for (final range in boundaries) {
        final surah = fetchedSurahs[range.surahNumber];
        if (surah == null) continue;
        
        for (final ayat in surah.ayat) {
          if (ayat.nomorAyat >= range.startVerse && ayat.nomorAyat <= range.endVerse) {
            tempAyats.add(JuzAyatModel(surah: surah, ayat: ayat));
          }
        }
      }
      
      if (mounted) {
        setState(() {
          _juzAyats = tempAyats;
          if (tempAyats.isNotEmpty) {
            _currentSurahNomor = tempAyats.first.surah.nomor;
          }
          _isLoading = false;
        });
        
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _scrollToCurrentJuzTab();
          
          if (_pendingScrollToSurah != null && _pendingScrollToVerse != null) {
            final targetSurah = _pendingScrollToSurah!;
            final targetVerse = _pendingScrollToVerse!;
            _pendingScrollToSurah = null;
            _pendingScrollToVerse = null;
            
            setState(() {
              _currentSurahNomor = targetSurah;
            });
            _scrollToSurahVerse(targetSurah, targetVerse);
          }
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = 'Gagal memuat Juz $_currentJuzNumber. Pastikan Anda memiliki koneksi internet.';
          _isLoading = false;
        });
      }
    }
  }

  AudioSource _buildPlaylist(int startIndex) {
    final settings = Provider.of<SettingsProvider>(context, listen: false);
    final qoriId = settings.selectedQoriId;
    
    List<AudioSource> sources = [];
    for (int i = startIndex; i < _juzAyats.length; i++) {
      final item = _juzAyats[i];
      final url = item.ayat.audio[qoriId] ?? item.ayat.audio.values.first;
      sources.add(AudioSource.uri(Uri.parse(url)));
    }
    return ConcatenatingAudioSource(children: sources);
  }

  Future<void> _playAudioAtIndex(int index) async {
    try {
      if (_currentlyPlayingIndex == index) {
        if (_player.playing) {
          await _player.pause();
        } else {
          await _player.play();
        }
        setState(() {});
        return;
      }

      await _player.stop();
      _playlistStartIndex = index;
      setState(() {
        _currentlyPlayingIndex = index;
      });
      _scrollToCurrentlyPlaying();
      
      final playlist = _buildPlaylist(index);
      await _player.setAudioSource(playlist);
      await _player.play();
    } catch (e) {
      print('DEBUG AUDIO ERROR: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal memutar audio: $e'),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    }
  }

  Future<void> _toggleMemorizedAyat(int surahNomor, int ayatNomor) async {
    final prefs = await SharedPreferences.getInstance();
    final list = List<String>.from(_memorizedAyats);
    final String key = "${surahNomor}_$ayatNomor";
    
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

  double _getArabicFontSize(String fontSize) {
    switch (fontSize) {
      case 'Kecil':
        return 18.0;
      case 'Besar':
        return 26.0;
      case 'Sedang':
      default:
        return 22.0;
    }
  }

  double _getLatinFontSize(String fontSize) {
    switch (fontSize) {
      case 'Kecil':
        return 10.0;
      case 'Besar':
        return 14.0;
      case 'Sedang':
      default:
        return 12.0;
    }
  }

  Widget _buildAyatNumberOrnament(int number) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Transform.rotate(
          angle: pi / 4,
          child: Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              border: Border.all(color: const Color(0xFFC5A880), width: 1),
              borderRadius: BorderRadius.circular(3),
            ),
          ),
        ),
        Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: const Color(0xFFC5A880), width: 1),
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

  List<InlineSpan> _buildTajwidSpans(String text, bool showColor, bool isDarkMode, double fontSize) {
    final baseColor = isDarkMode ? Colors.white : const Color(0xFF0C5441);
    final style = GoogleFonts.scheherazadeNew(
      fontSize: fontSize,
      fontWeight: FontWeight.bold,
      color: baseColor,
      height: 1.6,
    );

    if (!showColor) {
      return [TextSpan(text: text, style: style)];
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
    return spans;
  }

  void _showTafsirDialog(BuildContext context, JuzAyatModel item) async {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return const Center(child: CircularProgressIndicator(color: Color(0xFF13A884)));
      },
    );
    try {
      final tafsirData = await QuranService().getTafsirDetail(item.surah.nomor);
      if (context.mounted) Navigator.pop(context); // Dismiss loading
      
      final tafsirAyat = tafsirData.tafsir.firstWhere(
        (t) => t.ayat == item.ayat.nomorAyat,
        orElse: () => TafsirAyatModel(ayat: item.ayat.nomorAyat, teks: 'Tafsir tidak ditemukan untuk ayat ini.'),
      );

      if (context.mounted) {
        final isDarkMode = Theme.of(context).brightness == Brightness.dark;
        showModalBottomSheet(
          context: context,
          backgroundColor: isDarkMode ? Theme.of(context).colorScheme.surface : Colors.white,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          builder: (context) {
            return Container(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Tafsir QS. ${item.surah.namaLatin} Ayat ${item.ayat.nomorAyat}',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF0C5441),
                    ),
                  ),
                  const Divider(height: 20),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Text(
                        tafsirAyat.teks,
                        style: GoogleFonts.poppins(
                          fontSize: 13,
                          height: 1.6,
                          color: isDarkMode ? Colors.white70 : Colors.black87,
                        ),
                        textAlign: TextAlign.justify,
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      }
    } catch (e) {
      if (context.mounted) {
        Navigator.pop(context); // Dismiss loading
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Gagal memuat tafsir.')),
        );
      }
    }
  }

  void _showVerseOptionsBottomSheet(BuildContext context, JuzAyatModel item) {
    final settings = Provider.of<SettingsProvider>(context, listen: false);
    final isDarkMode = settings.themeModeStr == 'Gelap';
    final isMemorized = _memorizedAyats.contains("${item.surah.nomor}_${item.ayat.nomorAyat}");

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
                    'QS. ${item.surah.namaLatin}: Ayat ${item.ayat.nomorAyat} (Juz $_currentJuzNumber)',
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
                  final idx = _juzAyats.indexOf(item);
                  if (idx != -1) {
                    _playAudioAtIndex(idx);
                  }
                },
              ),
              _buildBottomSheetItem(
                context: context,
                icon: const Icon(Icons.share, color: Color(0xFF13A884)),
                title: 'Bagikan',
                onTap: () {
                  Navigator.pop(context);
                  Clipboard.setData(ClipboardData(text: "${item.ayat.teksArab}\n\n${item.ayat.teksIndonesia} (QS. ${item.surah.namaLatin}: ${item.ayat.nomorAyat})"));
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Menyalin Ayat ${item.ayat.nomorAyat} ke Clipboard...'),
                      backgroundColor: const Color(0xFF13A884),
                    ),
                  );
                },
              ),
              _buildBottomSheetItem(
                context: context,
                icon: const Icon(Icons.book, color: Color(0xFF13A884)),
                title: 'Lihat Tafsir',
                onTap: () {
                  Navigator.pop(context);
                  _showTafsirDialog(context, item);
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
                  await prefs.setString('lastReadSurah', item.surah.namaLatin);
                  await prefs.setInt('lastReadVerse', item.ayat.nomorAyat);
                  await prefs.setInt('lastReadSurahNumber', item.surah.nomor);
                  messenger.showSnackBar(
                    SnackBar(
                      content: Text('Tandai sebagai ayat terakhir dibaca: QS. ${item.surah.namaLatin} ayat ${item.ayat.nomorAyat}'),
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
                  _toggleMemorizedAyat(item.surah.nomor, item.ayat.nomorAyat);
                },
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
            SizedBox(width: 32, child: icon),
            const SizedBox(width: 16),
            Text(
              title,
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: isDarkMode ? Colors.white : Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOrnateSurahNameFrame(String surahNama, bool isDarkMode) {
    String displayName = surahNama;
    if (!displayName.contains('سورة') && !displayName.contains('سُوْرَة')) {
      displayName = 'سُورَةُ $displayName';
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: isDarkMode ? const Color(0xFF0A261F) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0xFF13A884).withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Text(
        displayName,
        style: GoogleFonts.scheherazadeNew(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: isDarkMode ? Colors.white : const Color(0xFF0C5441),
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildSurahBanner(SurahDetailModel surah, bool isDarkMode) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: isDarkMode ? const Color(0xFF0F362C) : const Color(0xFFE8F5F1),
        border: Border.all(
          color: const Color(0xFF13A884).withOpacity(isDarkMode ? 0.3 : 0.5),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            surah.tempatTurun == 'mekah' ? 'Makkiyah' : 'Madaniyah',
            style: GoogleFonts.outfit(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF13A884),
            ),
          ),
          _buildOrnateSurahNameFrame(surah.nama, isDarkMode),
          Text(
            '${surah.jumlahAyat} Ayat',
            style: GoogleFonts.outfit(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF13A884),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAyatItem(JuzAyatModel item, int index) {
    final settings = Provider.of<SettingsProvider>(context);
    final isDarkMode = settings.themeModeStr == 'Gelap';
    final isMemorized = _memorizedAyats.contains("${item.surah.nomor}_${item.ayat.nomorAyat}");
    final isPlaying = _currentlyPlayingIndex == index;

    _ayatKeys.putIfAbsent(index, () => GlobalKey());
    final itemKey = _ayatKeys[index];

    return Container(
      key: itemKey,
      decoration: BoxDecoration(
        color: isPlaying
            ? (isDarkMode ? const Color(0xFF0F362C) : const Color(0xFFE8F5F1))
            : Colors.transparent,
        border: Border(
          left: BorderSide(
            color: isPlaying ? const Color(0xFF13A884) : Colors.transparent,
            width: 4,
          ),
          bottom: BorderSide(
            color: isDarkMode ? Colors.grey[850]! : Colors.grey[200]!,
            width: 1,
          ),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Left option menu trigger (three vertical dots)
            IconButton(
              icon: Icon(
                Icons.more_vert,
                color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
              ),
              onPressed: () => _showVerseOptionsBottomSheet(context, item),
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
                        child: Directionality(
                          textDirection: TextDirection.rtl,
                          child: RichText(
                            textAlign: TextAlign.right,
                            text: TextSpan(
                              children: [
                                ..._buildTajwidSpans(
                                  item.ayat.teksArab,
                                  settings.showWarnaTajwid,
                                  isDarkMode,
                                  settings.arabFontSize,
                                ),
                                WidgetSpan(
                                  alignment: PlaceholderAlignment.middle,
                                  child: Padding(
                                    padding: const EdgeInsets.only(right: 8.0, left: 4.0),
                                    child: _buildAyatNumberOrnament(item.ayat.nomorAyat),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  if (_showTranslation) ...[
                    if (settings.showTransliterasi) ...[
                      const SizedBox(height: 12),
                      // Latin Transliteration (Teal)
                      Text(
                        item.ayat.teksLatin,
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
                        item.ayat.teksIndonesia,
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
  }

  Widget _buildFloatingBottomPlayer() {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    if (_currentlyPlayingIndex == null) return const SizedBox.shrink();

    final item = _juzAyats[_currentlyPlayingIndex!];
    final isPlaying = _player.playing;

    return Container(
      height: 72,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: isDarkMode ? const Color(0xFF1E1E1E) : Colors.white,
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
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Putar surah',
                  style: GoogleFonts.poppins(
                    fontSize: 11,
                    color: isDarkMode ? Colors.white70 : Colors.grey[500],
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '${item.surah.namaLatin} ${item.ayat.nomorAyat}/${item.surah.jumlahAyat}',
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: isDarkMode ? Colors.white : Colors.black87,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          // Play button capsule style
          GestureDetector(
            onTap: () {
              if (isPlaying) {
                _player.pause();
              } else {
                _player.play();
              }
              setState(() {});
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: isDarkMode ? const Color(0xFF0F362C) : const Color(0xFFE8F5F1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    isPlaying ? Icons.pause : Icons.play_arrow,
                    color: const Color(0xFF13A884),
                    size: 18,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    isPlaying ? 'Pause' : 'Putar',
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: isDarkMode ? Colors.white : const Color(0xFF0C5441),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 8),
          // Mic circle button
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: isDarkMode ? Colors.grey[850] : Colors.grey[100],
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: const Icon(Icons.mic, size: 18),
              color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
              padding: EdgeInsets.zero,
              onPressed: () {},
            ),
          ),
          const SizedBox(width: 8),
          // Close circle button
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: isDarkMode ? Colors.grey[850] : Colors.grey[100],
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: const Icon(Icons.close, size: 18),
              color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
              padding: EdgeInsets.zero,
              onPressed: () {
                setState(() {
                  _currentlyPlayingIndex = null;
                });
                _player.stop();
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showFontSizeDialog(BuildContext context, SettingsProvider settings) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const PreferensiMembacaPage()),
    );
  }

  List<SurahDetailModel> get uniqueSurahsInJuz {
    final Set<int> seen = {};
    final List<SurahDetailModel> list = [];
    for (final item in _juzAyats) {
      if (!seen.contains(item.surah.nomor)) {
        seen.add(item.surah.nomor);
        list.add(item.surah);
      }
    }
    return list;
  }

  void _scrollToSurahVerse(int surahNomor, int ayatNomor) {
    int targetIndex = _juzAyats.indexWhere(
      (item) => item.surah.nomor == surahNomor && item.ayat.nomorAyat == ayatNomor
    );
    if (targetIndex != -1) {
      final key = _ayatKeys[targetIndex];
      if (key != null && key.currentContext != null) {
        Scrollable.ensureVisible(
          key.currentContext!,
          duration: const Duration(milliseconds: 600),
          curve: Curves.easeInOut,
          alignment: 0.3,
        );
      } else {
        double estimatedOffset = 0.0;
        for (int i = 0; i < targetIndex; i++) {
          final bool isFirstOfSurah = i == 0 || _juzAyats[i - 1].surah.nomor != _juzAyats[i].surah.nomor;
          if (isFirstOfSurah) {
            estimatedOffset += 100.0;
          }
          estimatedOffset += 180.0;
        }
        _scrollController.animateTo(
          estimatedOffset,
          duration: const Duration(milliseconds: 600),
          curve: Curves.easeInOut,
        );
      }
    }
  }

  void _showGoToDialog(BuildContext context) {
    final settings = Provider.of<SettingsProvider>(context, listen: false);
    final isDarkMode = settings.themeModeStr == 'Gelap';
    final surahList = QuranData.listSurah;
    
    SurahModel selectedSurah = surahList.firstWhere(
      (s) => s.nomor == _currentSurahNomor,
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
                              
                              int targetIndex = _juzAyats.indexWhere(
                                (item) => item.surah.nomor == selectedSurah.nomor && item.ayat.nomorAyat == verseNum
                              );
                              
                              if (targetIndex != -1) {
                                setState(() {
                                  _currentSurahNomor = selectedSurah.nomor;
                                });
                                _scrollToSurahVerse(selectedSurah.nomor, verseNum);
                              } else {
                                int? targetJuz;
                                for (final entry in juzBoundaries.entries) {
                                  for (final range in entry.value) {
                                    if (range.surahNumber == selectedSurah.nomor &&
                                        verseNum >= range.startVerse &&
                                        verseNum <= range.endVerse) {
                                      targetJuz = entry.key;
                                      break;
                                    }
                                  }
                                  if (targetJuz != null) break;
                                }
                                
                                if (targetJuz != null) {
                                  setState(() {
                                    _pendingScrollToSurah = selectedSurah.nomor;
                                    _pendingScrollToVerse = verseNum;
                                    _currentJuzNumber = targetJuz!;
                                  });
                                  _loadJuzData();
                                }
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


  AppBar _buildAppBar(BuildContext context, bool isDarkMode, SettingsProvider settings) {
    final activeSurahName = _juzAyats.isNotEmpty
        ? (_juzAyats.firstWhere(
            (item) => item.surah.nomor == _currentSurahNomor,
            orElse: () => _juzAyats.first,
          )).surah.namaLatin
        : 'Memuat...';

    return AppBar(
      backgroundColor: const Color(0xFF13A884),
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.chevron_left, color: Colors.white, size: 28),
        onPressed: () => Navigator.pop(context),
      ),
      titleSpacing: 0,
      title: GestureDetector(
        onTap: () => _showGoToDialog(context),
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
                activeSurahName,
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
      ),
      actions: [
        Center(
          child: GestureDetector(
            onTap: () => _showFontSizeDialog(context, settings),
            child: Text(
              'aA',
              style: GoogleFonts.outfit(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        const SizedBox(width: 16),
        IconButton(
          icon: Icon(
            _showTranslation ? Icons.menu_book : Icons.menu_book_outlined,
            color: Colors.white,
            size: 22,
          ),
          onPressed: () {
            setState(() {
              _showTranslation = !_showTranslation;
            });
          },
        ),
        IconButton(
          icon: Icon(
            isDarkMode ? Icons.light_mode : Icons.dark_mode_outlined,
            color: Colors.white,
            size: 22,
          ),
          onPressed: () {
            settings.setThemeModeStr(isDarkMode ? 'Hijau' : 'Gelap');
          },
        ),
        IconButton(
          icon: const Icon(Icons.settings, color: Colors.white, size: 22),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const QuranSettingsPage()),
            );
          },
        ),
        const SizedBox(width: 8),
      ],
    );
  }

  Widget _buildJuzTabsBar(bool isDarkMode) {
    return Container(
      height: 48,
      decoration: BoxDecoration(
        color: isDarkMode ? const Color(0xFF1E1E1E) : Colors.white,
        border: Border(
          bottom: BorderSide(
            color: isDarkMode ? Colors.grey[850]! : Colors.grey[200]!,
            width: 1,
          ),
        ),
      ),
      child: ListView.builder(
        controller: _juzTabScrollController,
        scrollDirection: Axis.horizontal,
        reverse: true, // This puts Juz 1 on the right side and scrolls left
        itemCount: 30,
        itemBuilder: (context, index) {
          final juzNum = index + 1;
          final isSelected = _currentJuzNumber == juzNum;
          return GestureDetector(
            onTap: () {
              if (_currentJuzNumber != juzNum) {
                setState(() {
                  _currentJuzNumber = juzNum;
                });
                _loadJuzData();
              }
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: isSelected ? const Color(0xFF13A884) : Colors.transparent,
                    width: 3,
                  ),
                ),
              ),
              child: Text(
                'Juz $juzNum',
                style: GoogleFonts.poppins(
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  color: isSelected 
                      ? const Color(0xFF13A884) 
                      : (isDarkMode ? Colors.grey[400] : Colors.grey[600]),
                  fontSize: 14,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final settings = Provider.of<SettingsProvider>(context);
    final isDarkMode = settings.themeModeStr == 'Gelap';

    if (settings.layarTetapAktif) {
      WakelockPlus.enable();
    } else {
      WakelockPlus.disable();
    }

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: _buildAppBar(context, isDarkMode, settings),
      body: Column(
        children: [
          _buildJuzTabsBar(isDarkMode),
          Expanded(
            child: Stack(
              children: [
                if (_isLoading)
                  const Center(
                    child: CircularProgressIndicator(color: Color(0xFF13A884)),
                  )
                else if (_errorMessage.isNotEmpty)
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Text(
                        _errorMessage,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(color: Colors.redAccent),
                      ),
                    ),
                  )
                else
                  CustomScrollView(
                    controller: _scrollController,
                    slivers: [
                      SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            final item = _juzAyats[index];
                            final bool isFirstVerseOfSurahInJuz = index == 0 ||
                                _juzAyats[index - 1].surah.nomor != item.surah.nomor;

                            if (isFirstVerseOfSurahInJuz) {
                              _surahKeys.putIfAbsent(item.surah.nomor, () => GlobalKey());
                              
                              return Column(
                                key: _surahKeys[item.surah.nomor],
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  _buildSurahBanner(item.surah, isDarkMode),
                                  if (item.ayat.nomorAyat == 1 && item.surah.nomor != 1 && item.surah.nomor != 9)
                                    Padding(
                                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                                      child: Text(
                                        'بِسْمِ اللّٰهِ الرَّحْمٰنِ الرَّحِيْمِ',
                                        style: GoogleFonts.scheherazadeNew(
                                          fontSize: 22,
                                          fontWeight: FontWeight.bold,
                                          color: isDarkMode ? Colors.white : const Color(0xFF0C5441),
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  _buildAyatItem(item, index),
                                ],
                              );
                            }
                            return _buildAyatItem(item, index);
                          },
                          childCount: _juzAyats.length,
                        ),
                      ),
                      const SliverToBoxAdapter(child: SizedBox(height: 100)),
                    ],
                  ),
                Positioned(
                  bottom: 16,
                  left: 16,
                  right: 16,
                  child: _buildFloatingBottomPlayer(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
