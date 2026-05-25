import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:just_audio/just_audio.dart';
import 'package:provider/provider.dart';
import 'settings_provider.dart';

class TextSpanSpec {
  final String text;
  final bool isColored;
  final Color? colorOverride;

  TextSpanSpec(this.text, this.isColored, {this.colorOverride});
}

class TajwidRuleExample {
  final List<TextSpanSpec> spans;
  final String audioUrl;

  TajwidRuleExample({required this.spans, required this.audioUrl});
}

class TajwidRule {
  final String title;
  final Color titleColor;
  final String description;
  final String? caraBaca;
  final String? catatan;
  final List<String>? bulletPoints;
  final List<TajwidRuleExample> examples;
  final String? harakat;

  TajwidRule({
    required this.title,
    required this.titleColor,
    required this.description,
    this.caraBaca,
    this.catatan,
    this.bulletPoints,
    required this.examples,
    this.harakat,
  });
}

class PanduanTajwidPage extends StatefulWidget {
  const PanduanTajwidPage({super.key});

  @override
  State<PanduanTajwidPage> createState() => _PanduanTajwidPageState();
}

class _PanduanTajwidPageState extends State<PanduanTajwidPage> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  String? _currentlyPlayingExampleId;

  final List<TajwidRule> _dasarRules = [
    TajwidRule(
      title: 'Ghunnah',
      titleColor: const Color(0xFFD222B5),
      harakat: '2',
      description: 'Terjadi saat membaca nun tasydid (نّ) atau mim tasydid (مّ).\nLama dengungnya sekitar 2 harakat.',
      examples: [
        TajwidRuleExample(
          spans: [
            TextSpanSpec('ثُ\u200D', false),
            TextSpanSpec('\u200Dمَّ', true),
            TextSpanSpec(' اِ\u200D', false),
            TextSpanSpec('\u200Dنَّ', true),
            TextSpanSpec(' عَلَيْنَا حِسَابَهُمْ', false),
          ],
          audioUrl: 'https://cdn.equran.id/audio-partial/Misyari-Rasyid-Al-Afasi/088026.mp3',
        ),
      ],
    ),
    TajwidRule(
      title: 'Idgham Bighunnah',
      titleColor: const Color(0xFFD222B5),
      harakat: '2',
      description: 'Terjadi saat nun sukun (نْ) atau tanwin (ــًــٍــٌ) bertemu dengan salah satu dari ن (nun), م (mim), و (wau), atau ي (ya).',
      caraBaca: 'Cara baca: meleburkan bunyi nun sukun atau tanwin ke huruf berikutnya dengan dengung selama 2 harakat.',
      catatan: 'bila nun sukun bertemu dengan و atau ي dalam satu kata maka status bacaan menjadi idzhar muthlaq (wajib) alias dibaca jelas. Kasus ini hanya terjadi pada empat kata di berbagai surat: الدُّنْيَا، قِنْوَانٌ، صِنْوَانٌ، بُنْيَانٌ',
      examples: [
        TajwidRuleExample(
          spans: [
            TextSpanSpec('فَمَ\u200D', false),
            TextSpanSpec('\u200Dن يَّ\u200D', true),
            TextSpanSpec('\u200Dعْمَلْ مِثْقَالَ ذَرَّةٍ خَيْ\u200D', false),
            TextSpanSpec('\u200Dرًا يَّ\u200D', true),
            TextSpanSpec('\u200Dرَهٗ', false),
          ],
          audioUrl: 'https://cdn.equran.id/audio-partial/Misyari-Rasyid-Al-Afasi/099007.mp3',
        ),
      ],
    ),
    TajwidRule(
      title: 'Idgham Mimi',
      titleColor: const Color(0xFFD222B5),
      harakat: '2',
      description: 'Terjadi saat mim sukun (مْ) bertemu dengan mim (م).',
      caraBaca: 'Cara baca: meleburkan mim sukun ke huruf mim berikutnya dengan dengung.',
      examples: [
        TajwidRuleExample(
          spans: [
            TextSpanSpec('وَالَّذِينَ هُ\u200D', false),
            TextSpanSpec('\u200Dم مِّ\u200D', true),
            TextSpanSpec('\u200Dنْ عَذَابِ رَبِّهِ\u200D', false),
            TextSpanSpec('\u200Dم مُّ\u200D', true),
            TextSpanSpec('\u200Dشْفِقُونَۚ', false),
          ],
          audioUrl: 'https://cdn.equran.id/audio-partial/Misyari-Rasyid-Al-Afasi/070027.mp3',
        ),
      ],
    ),
    TajwidRule(
      title: 'Idgham Bilaghunnah',
      titleColor: const Color(0xFFD32F2F),
      description: 'Terjadi ketika nun sukun (نْ) atau tanwin (ــًــٍــٌ) dengan lam (ل) atau ra (ر). Cara baca: meleburkan suara nun sukun atau tanwin sepenuhnya ke huruf lam atau ra\' tanpa disertai dengung.',
      examples: [
        TajwidRuleExample(
          spans: [
            TextSpanSpec('وَيْ\u200D', false),
            TextSpanSpec('\u200Dلٌ لِّ\u200D', true),
            TextSpanSpec('\u200Dكُلِّ هُمَزَ', false),
            TextSpanSpec('ةٍۙ لُّ\u200D', true),
            TextSpanSpec('\u200Dمَزَةٍۙ', false),
          ],
          audioUrl: 'https://cdn.equran.id/audio-partial/Misyari-Rasyid-Al-Afasi/104001.mp3',
        ),
        TajwidRuleExample(
          spans: [
            TextSpanSpec('أَ', false),
            TextSpanSpec('ن رَّ', true),
            TextSpanSpec('اهُ ٱسْتَغْنَىٰ', false),
          ],
          audioUrl: 'https://cdn.equran.id/audio-partial/Misyari-Rasyid-Al-Afasi/096007.mp3',
        ),
      ],
    ),
    TajwidRule(
      title: 'Idgham Mutamatsilain',
      titleColor: const Color(0xFFD32F2F),
      description: 'Terjadi ketika dua huruf yang sama bertemu, seperti ba\' sukun (بْ) bertemu dengan ب, kaf sukun (كْ) bertemu dengan ك, dst.',
      caraBaca: 'Cara baca: meleburkan huruf pertama ke huruf kedua dengan tasydid.',
      catatan: 'jika و mad bertemu و dan ي mad bertemu ي, tetap dibaca panjang.',
      examples: [
        TajwidRuleExample(
          spans: [
            TextSpanSpec('كَلَّا بَ\u200D', false),
            TextSpanSpec('\u200Dلْ لَا', true),
            TextSpanSpec(' تُكْرِمُونَ الْيَتِيمَ', false),
          ],
          audioUrl: 'https://cdn.equran.id/audio-partial/Misyari-Rasyid-Al-Afasi/089017.mp3',
        ),
      ],
    ),
    TajwidRule(
      title: 'Idgham Mutajanisain',
      titleColor: const Color(0xFFD32F2F),
      description: 'Terjadi saat dua huruf dengan makhraj yang sama tetapi sifatnya berbeda bertemu. Meliputi:',
      bulletPoints: [
        'huruf ط sukun bertemu ت',
        'huruf ت sukun bertemu ط',
        'huruf د sukun bertemu ت',
        'huruf ت sukun bertemu د',
        'huruf ث sukun bertemu ذ',
        'huruf ذ sukun bertemu ظ',
        'huruf ب sukun bertemu م (wajib dengung).'
      ],
      caraBaca: 'Cara baca: meleburkan huruf pertama ke huruf kedua dengan tasydid.',
      catatan: 'Seluruhnya dibaca melebur penuh (idgham kamil), kecuali saat ط (tha\' sukun) bertemu ت (ta\') yang hanya melebur sebagian (idgham naqish).',
      examples: [
        TajwidRuleExample(
          spans: [
            TextSpanSpec('قَالَ قَ\u200D', false),
            TextSpanSpec('\u200Dدْ', false, colorOverride: const Color(0xFF3F51B5)),
            TextSpanSpec(' أُجِيبَ\u200D', false),
            TextSpanSpec('\u200Dتْ دَّ\u200D', true),
            TextSpanSpec('\u200Dعْوَتُكُمَا فَاسْتَقِيمَا وَلَا تَتَّبِعَاۤ\u200D', false),
            TextSpanSpec('\u200Dنِّ', false, colorOverride: const Color(0xFFD222B5)),
            TextSpanSpec(' سَبِيلَ الَّذِينَ لَا يَعْلَمُونَ', false),
          ],
          audioUrl: 'https://cdn.equran.id/audio-partial/Misyari-Rasyid-Al-Afasi/010089.mp3',
        ),
      ],
    ),
    TajwidRule(
      title: 'Idgham Mutaqaribain',
      titleColor: const Color(0xFFD32F2F),
      description: 'Terjadi saat dua huruf yang hampir sama makhraj dan sifatnya bertemu. Meliputi:',
      bulletPoints: [
        'huruf ل sukun bertemu ر',
        'huruf ق sukun bertemu ك'
      ],
      caraBaca: 'Cara baca: meleburkan huruf pertama ke huruf kedua dengan tasydid.',
      examples: [
        TajwidRuleExample(
          spans: [
            TextSpanSpec('بَ\u200D', false),
            TextSpanSpec('\u200Dل رَّ\u200D', true),
            TextSpanSpec('\u200Dفَعَهُ اللَّهُ وَكَانَ اللَّهُ عَزِيزًا حَكِيمًا', false),
          ],
          audioUrl: 'https://cdn.equran.id/audio-partial/Misyari-Rasyid-Al-Afasi/004158.mp3',
        ),
      ],
    ),
    TajwidRule(
      title: 'Ikhfa\' Haqiqi',
      titleColor: const Color(0xFF4CAF50),
      harakat: '2',
      description: 'Terjadi ketika nun sukun (نْ) atau tanwin (ــًــٍــٌ) bertemu dengan 15 huruf ikhfa\':\nت - ث - ج - د - ذ - ز - س - ش - ص - ض - ط - ظ - ف - ق - ك',
      caraBaca: 'Cara baca: menyamarkan bunyi nun sukun atau tanwin, berada di antara jelas dan dengung, selama 2 harakat.',
      examples: [
        TajwidRuleExample(
          spans: [
            TextSpanSpec('وَقَالَ الْاِ\u200D', false),
            TextSpanSpec('\u200Dنسَ\u200D', true),
            TextSpanSpec('\u200Dانُ مَا لَهَاۚ', false),
          ],
          audioUrl: 'https://cdn.equran.id/audio-partial/Misyari-Rasyid-Al-Afasi/099003.mp3',
        ),
        TajwidRuleExample(
          spans: [
            TextSpanSpec('يَوْمَئِ\u200D', false),
            TextSpanSpec('\u200Dذٍ تُ\u200D', true),
            TextSpanSpec('\u200Dحَدِّثُ أَخْبَارَهَاۙ', false),
          ],
          audioUrl: 'https://cdn.equran.id/audio-partial/Misyari-Rasyid-Al-Afasi/099004.mp3',
        ),
      ],
    ),
    TajwidRule(
      title: 'Ikhfa\' Syafawi',
      titleColor: const Color(0xFF4CAF50),
      harakat: '2',
      description: 'Terjadi ketika mim sukun (مْ) bertemu dengan ب (ba\'). Cara baca: menyamarkan huruf mim mati (مْ) di bibir sambil didengungkan.',
      examples: [
        TajwidRuleExample(
          spans: [
            TextSpanSpec('سَلَامٌ عَلَيْكُ\u200D', false),
            TextSpanSpec('\u200Dم بِ\u200D', true),
            TextSpanSpec('\u200Dمَا صَبَرْتُم فَنِعْمَ عُ\u200D', false),
            TextSpanSpec('\u200Dقْ\u200D', false, colorOverride: const Color(0xFF3F51B5)),
            TextSpanSpec('\u200Dبَى ٱلدَّارِۗ', false),
          ],
          audioUrl: 'https://cdn.equran.id/audio-partial/Misyari-Rasyid-Al-Afasi/013024.mp3',
        ),
      ],
    ),
    TajwidRule(
      title: 'Iqlab',
      titleColor: const Color(0xFF00BCD4),
      harakat: '2',
      description: 'Terjadi ketika nun sukun (نْ) atau tanwin (ــًــٍــٌ) bertemu dengan ب (ba\'). Cara baca: mengganti bunyi nun sukun atau tanwin menjadi mim mati dengan dengung.',
      examples: [
        TajwidRuleExample(
          spans: [
            TextSpanSpec('إِذِ ٱ', false),
            TextSpanSpec('نۢبَ\u200D', true),
            TextSpanSpec('\u200Dعَثَ أَشْقَىٰهَا', false),
          ],
          audioUrl: 'https://cdn.equran.id/audio-partial/Misyari-Rasyid-Al-Afasi/091012.mp3',
        ),
      ],
    ),
    TajwidRule(
      title: 'Qalqalah',
      titleColor: const Color(0xFF3F51B5),
      description: 'Bacaan memantul saat menjumpai huruf ق, ط, ب, ج, dan د yang bersukun atau berada di akhir kalimat (waqaf).',
      bulletPoints: [
        'Qalqalah Kubra (pantulan kuat) terjadi di akhir kalimat.',
        'Qalqalah Shughra (pantulan ringan) terjadi di tengah kata atau bacaan.'
      ],
      examples: [
        TajwidRuleExample(
          spans: [
            TextSpanSpec('كَلَّا لَا تُطِعْهُ وَٱسْجُ\u200D', false),
            TextSpanSpec('\u200Dدْ', true),
            TextSpanSpec(' وَٱ\u200D', false),
            TextSpanSpec('قْ\u200D', true),
            TextSpanSpec('\u200Dتَرِ', false),
            TextSpanSpec('بْ', true),
            TextSpanSpec(' ۩', false),
          ],
          audioUrl: 'https://cdn.equran.id/audio-partial/Misyari-Rasyid-Al-Afasi/096019.mp3',
        ),
      ],
    ),
  ];

  final List<TajwidRule> _madRules = [
    TajwidRule(
      title: 'Mad Wajib Muttashil',
      titleColor: const Color(0xFF00BCD4),
      harakat: '5',
      description: 'Terjadi saat mad thabi\'i bertemu dengan hamzah (ء) dalam satu kata.',
      bulletPoints: ['Panjang bacaan adalah 5 harakat.'],
      examples: [
        TajwidRuleExample(
          spans: [
            TextSpanSpec('إِذَا ', false),
            TextSpanSpec('جَا\u200D', true),
            TextSpanSpec('\u200Dءَ نَصْرُ اللهِ وَالْفَتْحُ', false),
          ],
          audioUrl: 'https://cdn.equran.id/audio-partial/Misyari-Rasyid-Al-Afasi/110001.mp3',
        ),
      ],
    ),
    TajwidRule(
      title: 'Mad Jaiz Munfashil',
      titleColor: const Color(0xFF4CAF50),
      harakat: '2-4-5',
      description: 'Terjadi saat mad thabi\'i bertemu dengan hamzah (ء) dalam dua kata terpisah.',
      bulletPoints: ['Boleh dibaca 2, 4, atau 5 harakat.'],
      examples: [
        TajwidRuleExample(
          spans: [
            TextSpanSpec('قُلْ ', false),
            TextSpanSpec('يٰۤ\u200D', true),
            TextSpanSpec('\u200Dأَيُّهَا الْكٰفِرُونَۙ', false),
          ],
          audioUrl: 'https://cdn.equran.id/audio-partial/Misyari-Rasyid-Al-Afasi/109001.mp3',
        ),
        TajwidRuleExample(
          spans: [
            TextSpanSpec('لَاۤ ', true),
            TextSpanSpec('أَعْبُدُ مَا تَعْبُدُونَۙ', false),
          ],
          audioUrl: 'https://cdn.equran.id/audio-partial/Misyari-Rasyid-Al-Afasi/109002.mp3',
        ),
      ],
    ),
    TajwidRule(
      title: 'Mad Shilah Thawilah',
      titleColor: const Color(0xFF4CAF50),
      harakat: '2-4-5',
      description: 'Terjadi ketika ha\' dhamir (ه) yang didahului harakat hidup bertemu hamzah.',
      bulletPoints: ['Boleh dibaca 2, 4, atau 5 harakat.'],
      examples: [
        TajwidRuleExample(
          spans: [
            TextSpanSpec('وَمَا يُكَذِّبُ بِ\u200D', false),
            TextSpanSpec('\u200Dهِۦۤ', true),
            TextSpanSpec(' إِلَّا مُعْتَدٍ أَثِيمٍ', false),
          ],
          audioUrl: 'https://cdn.equran.id/audio-partial/Misyari-Rasyid-Al-Afasi/083012.mp3',
        ),
      ],
    ),
    TajwidRule(
      title: 'Mad Farqi',
      titleColor: const Color(0xFFD222B5),
      harakat: '6',
      description: 'Mad (bacaan panjang) yang berfungsi untuk membedakan pertanyaan atau bukan.',
      bulletPoints: ['Harus dibaca panjang 6 harakat.'],
      examples: [
        TajwidRuleExample(
          spans: [
            TextSpanSpec('قُلِ الْحَمْدُ لِلَّهِ وَسَلَامٌ عَلَىٰ عِبَادِهِ الَّذِينَ اصْطَفَىٰۗ ', false),
            TextSpanSpec('ءٰۤا', true),
            TextSpanSpec('للَّهُ خَيْرٌ أَ\u200D', false),
            TextSpanSpec('\u200Dمَّا', false, colorOverride: const Color(0xFFD222B5)),
            TextSpanSpec(' يُشْرِكُونَ', false),
          ],
          audioUrl: 'https://cdn.equran.id/audio-partial/Misyari-Rasyid-Al-Afasi/027059.mp3',
        ),
      ],
    ),
    TajwidRule(
      title: 'Mad Lazim Mukhaffaf Kilmi',
      titleColor: const Color(0xFFD222B5),
      harakat: '6',
      description: 'Terjadi saat mad thabi\'i bertemu dengan huruf sukun dalam satu kata.',
      bulletPoints: ['Harus dibaca panjang 6 harakat.'],
      examples: [
        TajwidRuleExample(
          spans: [
            TextSpanSpec('آ', true),
            TextSpanSpec('لْآنَ وَقَ\u200D', false),
            TextSpanSpec('\u200Dدْ', false, colorOverride: const Color(0xFF3F51B5)),
            TextSpanSpec(' عَصَيْتَ قَ\u200D', false),
            TextSpanSpec('\u200Dبْ\u200D', false, colorOverride: const Color(0xFF3F51B5)),
            TextSpanSpec('\u200Dلُ وَكُ\u200D', false),
            TextSpanSpec('\u200Dنْتَ', false, colorOverride: const Color(0xFF4CAF50)),
            TextSpanSpec(' مِنَ الْمُفْسِدِينَ', false),
          ],
          audioUrl: 'https://cdn.equran.id/audio-partial/Misyari-Rasyid-Al-Afasi/010091.mp3',
        ),
      ],
    ),
    TajwidRule(
      title: 'Mad Lazim Mutsaqqal Kilmi',
      titleColor: const Color(0xFFD222B5),
      harakat: '6',
      description: 'Terjadi saat mad thabi\'i bertemu dengan huruf bertasydid dalam satu kata.',
      bulletPoints: ['Harus dibaca panjang 6 harakat.'],
      examples: [
        TajwidRuleExample(
          spans: [
            TextSpanSpec('وَلَا تَحَ\u200D', false),
            TextSpanSpec('\u200Dاضُّ\u200D', true),
            TextSpanSpec('\u200Dونَ عَلَىٰ طَعَامِ الْمِسْكِينِ', false),
          ],
          audioUrl: 'https://cdn.equran.id/audio-partial/Misyari-Rasyid-Al-Afasi/089018.mp3',
        ),
      ],
    ),
    TajwidRule(
      title: 'Mad Lazim Harfi Musyabba',
      titleColor: const Color(0xFFD222B5),
      harakat: '6',
      description: 'Bacaan panjang 6 harakat pada huruf-huruf di permulaan surat yang terdiri dari huruf:\nن - ق - ص - ع - س - ل - ك - م\nHuruf-huruf ini terkumpul dalam satu kalimat (نَقَصَ عَسَلُكُمْ).',
      examples: [
        TajwidRuleExample(
          spans: [
            TextSpanSpec('ا', false),
            TextSpanSpec('لٓمٓ', true),
          ],
          audioUrl: 'https://cdn.equran.id/audio-partial/Misyari-Rasyid-Al-Afasi/002001.mp3',
        ),
        TajwidRuleExample(
          spans: [
            TextSpanSpec('ا', false),
            TextSpanSpec('لٓمٓصٓ', true),
          ],
          audioUrl: 'https://cdn.equran.id/audio-partial/Misyari-Rasyid-Al-Afasi/007001.mp3',
        ),
        TajwidRuleExample(
          spans: [
            TextSpanSpec('كٰ\u200D', true),
            TextSpanSpec('\u200Dهيٰ\u200D', false),
            TextSpanSpec('\u200Dعٓصٓ', true),
          ],
          audioUrl: 'https://cdn.equran.id/audio-partial/Misyari-Rasyid-Al-Afasi/019001.mp3',
        ),
        TajwidRuleExample(
          spans: [
            TextSpanSpec('طٰ\u200D', false),
            TextSpanSpec('\u200Dسٓمٓ', true),
          ],
          audioUrl: 'https://cdn.equran.id/audio-partial/Misyari-Rasyid-Al-Afasi/026001.mp3',
        ),
        TajwidRuleExample(
          spans: [
            TextSpanSpec('نٓۚ ', true),
            TextSpanSpec('وَالْقَلَمِ وَمَا يَسْطُرُونَ', false),
          ],
          audioUrl: 'https://cdn.equran.id/audio-partial/Misyari-Rasyid-Al-Afasi/068001.mp3',
        ),
      ],
    ),
  ];

  @override
  void initState() {
    super.initState();
    _audioPlayer.playerStateStream.listen((state) {
      if (state.processingState == ProcessingState.completed) {
        if (mounted) {
          setState(() {
            _currentlyPlayingExampleId = null;
          });
        }
      }
    });
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  Future<void> _playExampleAudio(String url, String id) async {
    try {
      if (_currentlyPlayingExampleId == id) {
        if (_audioPlayer.playing) {
          await _audioPlayer.pause();
        } else {
          await _audioPlayer.play();
        }
        setState(() {});
        return;
      }

      await _audioPlayer.stop();
      setState(() {
        _currentlyPlayingExampleId = id;
      });

      await _audioPlayer.setUrl(url);
      await _audioPlayer.play();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal memutar audio contoh: $e'),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final settings = Provider.of<SettingsProvider>(context);
    final isDarkMode = settings.themeModeStr == 'Gelap';

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: isDarkMode ? const Color(0xFF121212) : const Color(0xFF13A884),
        appBar: AppBar(
          title: Text(
            'Panduan Tajwid Berwarna',
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: 16,
            ),
          ),
          backgroundColor: const Color(0xFF13A884),
          iconTheme: const IconThemeData(color: Colors.white),
          elevation: 0,
          centerTitle: false,
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(48),
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: isDarkMode ? const Color(0xFF1E1E1E) : Colors.white,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(24),
                  topRight: Radius.circular(24),
                ),
              ),
              child: TabBar(
                indicatorColor: const Color(0xFF13A884),
                indicatorWeight: 3,
                indicatorSize: TabBarIndicatorSize.label,
                labelColor: isDarkMode ? Colors.white : Colors.black,
                unselectedLabelColor: isDarkMode ? Colors.white70 : Colors.grey,
                labelStyle: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 13),
                unselectedLabelStyle: GoogleFonts.poppins(fontWeight: FontWeight.normal, fontSize: 13),
                tabs: const [
                  Tab(text: 'Dasar'),
                  Tab(text: 'Mad'),
                ],
              ),
            ),
          ),
        ),
        body: Container(
          color: isDarkMode ? const Color(0xFF121212) : const Color(0xFFF5F7F8),
          child: TabBarView(
            children: [
              _buildRuleList(_dasarRules, isDarkMode),
              _buildRuleList(_madRules, isDarkMode),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRuleList(List<TajwidRule> rules, bool isDarkMode) {
    return ListView.builder(
      padding: const EdgeInsets.only(top: 8, bottom: 24),
      itemCount: rules.length + 1,
      itemBuilder: (context, index) {
        if (index == rules.length) {
          return _buildCatatanPenting(isDarkMode);
        }
        final rule = rules[index];
        return _buildRuleItem(rule, isDarkMode);
      },
    );
  }

  Widget _buildRuleItem(TajwidRule rule, bool isDarkMode) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isDarkMode ? const Color(0xFF1E1E1E) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Left Accent Ribbon
              Container(
                width: 50,
                color: rule.titleColor,
                child: Center(
                  child: Container(
                    width: 30,
                    height: 30,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Icon(
                        Icons.menu_book,
                        color: rule.titleColor,
                        size: 16,
                      ),
                    ),
                  ),
                ),
              ),
              // Center Content Column
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title
                      Text(
                        rule.title,
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: rule.titleColor,
                        ),
                      ),
                      const SizedBox(height: 6),
                      // Description
                      Text(
                        rule.description,
                        style: GoogleFonts.poppins(
                          fontSize: 11,
                          color: isDarkMode ? Colors.white70 : const Color(0xFF4A5568),
                          height: 1.45,
                        ),
                      ),
                      if (rule.caraBaca != null) ...[
                        const SizedBox(height: 4),
                        Text(
                          rule.caraBaca!,
                          style: GoogleFonts.poppins(
                            fontSize: 11,
                            color: isDarkMode ? Colors.white70 : const Color(0xFF4A5568),
                            height: 1.45,
                          ),
                        ),
                      ],
                      if (rule.bulletPoints != null) ...[
                        const SizedBox(height: 6),
                        ...rule.bulletPoints!.map((point) => Padding(
                              padding: const EdgeInsets.only(bottom: 3),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    margin: const EdgeInsets.only(top: 5, right: 6),
                                    width: 5,
                                    height: 5,
                                    decoration: BoxDecoration(
                                      color: rule.titleColor,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                  Expanded(
                                    child: Text(
                                      point,
                                      style: GoogleFonts.poppins(
                                        fontSize: 11,
                                        color: isDarkMode ? Colors.white70 : const Color(0xFF4A5568),
                                        height: 1.4,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            )),
                      ],
                      if (rule.catatan != null) ...[
                        const SizedBox(height: 8),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('📝 ', style: TextStyle(fontSize: 11)),
                            Expanded(
                              child: RichText(
                                text: TextSpan(
                                  style: GoogleFonts.poppins(
                                    fontSize: 11,
                                    color: isDarkMode ? Colors.white70 : const Color(0xFF4A5568),
                                    height: 1.45,
                                  ),
                                  children: [
                                    const TextSpan(
                                      text: 'Catatan: ',
                                      style: TextStyle(fontWeight: FontWeight.bold),
                                    ),
                                    TextSpan(text: rule.catatan!),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                      // Examples
                      if (rule.examples.isNotEmpty) ...[
                        ...rule.examples.asMap().entries.map((entry) {
                          final idx = entry.key;
                          final example = entry.value;
                          final exampleId = '${rule.title}_$idx';
                          final isPlaying = _currentlyPlayingExampleId == exampleId && _audioPlayer.playing;

                          return Container(
                            margin: const EdgeInsets.only(top: 8),
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                            decoration: BoxDecoration(
                              color: isDarkMode ? const Color(0xFF262626) : Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: isDarkMode ? Colors.grey.shade800 : Colors.grey.shade200,
                              ),
                            ),
                            child: Row(
                              children: [
                                // Arabic Text (RTL)
                                Expanded(
                                  child: Directionality(
                                    textDirection: TextDirection.rtl,
                                    child: RichText(
                                      textAlign: TextAlign.right,
                                      text: TextSpan(
                                        style: GoogleFonts.scheherazadeNew(
                                          fontSize: 20,
                                          height: 1.2,
                                          color: isDarkMode ? Colors.white : const Color(0xFF0C5441),
                                        ),
                                        children: example.spans.map((spanSpec) {
                                          return TextSpan(
                                            text: spanSpec.text,
                                            style: spanSpec.isColored
                                                ? TextStyle(
                                                    color: rule.titleColor,
                                                    fontWeight: FontWeight.bold,
                                                  )
                                                : spanSpec.colorOverride != null
                                                    ? TextStyle(
                                                        color: spanSpec.colorOverride,
                                                        fontWeight: FontWeight.bold,
                                                      )
                                                    : null,
                                          );
                                        }).toList(),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                // Speaker/Volume icon container
                                Container(
                                  width: 32,
                                  height: 32,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: isDarkMode ? Colors.grey.shade700 : Colors.grey.shade300,
                                    ),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: IconButton(
                                    icon: Icon(
                                      isPlaying ? Icons.pause_circle_filled : Icons.volume_up,
                                      color: const Color(0xFF13A884),
                                      size: 16,
                                    ),
                                    onPressed: () => _playExampleAudio(example.audioUrl, exampleId),
                                    constraints: const BoxConstraints(),
                                    padding: EdgeInsets.zero,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }),
                      ],
                    ],
                  ),
                ),
              ),
              // Right Harakat Badge
              if (rule.harakat != null)
                Container(
                  padding: const EdgeInsets.only(right: 12),
                  child: Center(
                    child: _buildHarakatBadge(rule.harakat!, rule.titleColor),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHarakatBadge(String harakat, Color color) {
    return SizedBox(
      width: 60,
      height: 60,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CustomPaint(
            size: const Size(60, 60),
            painter: RubElHizbPainter(color: color),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                harakat,
                style: GoogleFonts.poppins(
                  fontSize: harakat.length > 2 ? 10 : 15,
                  fontWeight: FontWeight.bold,
                  color: color,
                  height: 1.0,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                'HARAKAT',
                style: GoogleFonts.poppins(
                  fontSize: 7,
                  fontWeight: FontWeight.bold,
                  color: color,
                  height: 1.0,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCatatanPenting(bool isDarkMode) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isDarkMode ? const Color(0xFF1A2E26) : const Color(0xFFE8F5F1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDarkMode
              ? const Color(0xFF13A884).withOpacity(0.2)
              : const Color(0xFF13A884).withOpacity(0.15),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: const Center(
              child: Icon(
                Icons.lightbulb_outline,
                color: Color(0xFF13A884),
                size: 20,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Catatan Penting',
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF0C5441),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Pahami setiap hukum bacaan dengan benar agar tilawah Al-Qur\'an menjadi lebih fasih dan sesuai dengan kaidah tajwid.',
                  style: GoogleFonts.poppins(
                    fontSize: 10,
                    color: isDarkMode ? Colors.white70 : const Color(0xFF4A5568),
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          const Icon(
            Icons.chevron_right,
            color: Color(0xFF13A884),
            size: 20,
          ),
        ],
      ),
    );
  }
}

class RubElHizbPainter extends CustomPainter {
  final Color color;

  RubElHizbPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.8
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final path = Path();
    final double cx = size.width / 2;
    final double cy = size.height / 2;
    final double outerRadius = size.width / 2;
    final double innerRadius = outerRadius * 0.82;

    for (int i = 0; i < 16; i++) {
      final double angle = i * 3.14159265358979323846 / 8;
      final double r = (i % 2 == 0) ? outerRadius : innerRadius;
      final double x = cx + r * math.cos(angle);
      final double y = cy + r * math.sin(angle);
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
