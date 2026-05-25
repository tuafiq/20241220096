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

  TajwidRule({
    required this.title,
    required this.titleColor,
    required this.description,
    this.caraBaca,
    this.catatan,
    this.bulletPoints,
    required this.examples,
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
      title: 'Mad Thabi\'i / Mad Asli',
      titleColor: const Color(0xFF009688),
      description: 'Terjadi jika alif sukun setelah fathah, ya sukun setelah kasrah, atau wau sukun setelah dhammad. Panjangnya 2 harakat.',
      examples: [
        TajwidRuleExample(
          spans: [
            TextSpanSpec('قَ', false),
            TextSpanSpec('ا', true),
            TextSpanSpec('لَ يَ', false),
            TextSpanSpec('قُ', false),
            TextSpanSpec('و', true),
            TextSpanSpec('لُ ', false),
            TextSpanSpec('قِ', false),
            TextSpanSpec('ي', true),
            TextSpanSpec('لَ', false),
          ],
          audioUrl: 'https://cdn.equran.id/audio-partial/Misyari-Rasyid-Al-Afasi/002008.mp3',
        ),
      ],
    ),
    TajwidRule(
      title: 'Mad Wajib Muttasil',
      titleColor: const Color(0xFF9C27B0),
      description: 'Terjadi jika huruf Mad Thabi\'i bertemu hamzah dalam satu kata. Dibaca panjang 4-5 harakat (2 setengah alif).',
      examples: [
        TajwidRuleExample(
          spans: [
            TextSpanSpec('إِذَا ', false),
            TextSpanSpec('جَاءَ', true),
            TextSpanSpec(' نَصْرُ اللّٰهِ وَالْفَتْحُ', false),
          ],
          audioUrl: 'https://cdn.equran.id/audio-partial/Misyari-Rasyid-Al-Afasi/110001.mp3',
        ),
      ],
    ),
    TajwidRule(
      title: 'Mad Jaiz Munfasil',
      titleColor: const Color(0xFF9C27B0),
      description: 'Terjadi jika huruf Mad Thabi\'i bertemu hamzah di kata yang lain. Dibaca panjang 2, 4, atau 5 harakat.',
      examples: [
        TajwidRuleExample(
          spans: [
            TextSpanSpec('إِ', false),
            TextSpanSpec('نَّا أَنْ', true),
            TextSpanSpec('زَلْنَاهُ فِي لَيْلَةِ الْقَدْرِ', false),
          ],
          audioUrl: 'https://cdn.equran.id/audio-partial/Misyari-Rasyid-Al-Afasi/097001.mp3',
        ),
      ],
    ),
    TajwidRule(
      title: 'Mad Aridh Lissukun',
      titleColor: const Color(0xFFFF9800),
      description: 'Terjadi jika huruf mad berada sebelum huruf hidup di akhir ayat yang di-waqaf-kan (berhenti). Dibaca panjang 2, 4, atau 6 harakat.',
      examples: [
        TajwidRuleExample(
          spans: [
            TextSpanSpec('الْحَمْدُ لِلّٰهِ رَبِّ الْ', false),
            TextSpanSpec('عَالَمِينَ', true),
          ],
          audioUrl: 'https://cdn.equran.id/audio-partial/Misyari-Rasyid-Al-Afasi/001002.mp3',
        ),
      ],
    ),
    TajwidRule(
      title: 'Mad Lazim Kilmi Muthaqqal',
      titleColor: const Color(0xFFE53935),
      description: 'Terjadi jika huruf mad bertemu dengan huruf bertasydid dalam satu kata. Dibaca panjang wajib 6 harakat.',
      examples: [
        TajwidRuleExample(
          spans: [
            TextSpanSpec('صِرَاطَ الَّذِينَ أَنْعَمْتَ عَلَيْهِمْ غَيْرِ الْمَغْضُوبِ عَلَيْهِمْ وَ', false),
            TextSpanSpec('لَا الضَّالِّينَ', true),
          ],
          audioUrl: 'https://cdn.equran.id/audio-partial/Misyari-Rasyid-Al-Afasi/001007.mp3',
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
        backgroundColor: isDarkMode ? const Color(0xFF1E1E1E) : Colors.white,
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
            preferredSize: const Size.fromHeight(40),
            child: Container(
              decoration: BoxDecoration(
                color: isDarkMode ? const Color(0xFF1E1E1E) : Colors.white,
                border: Border(
                  bottom: BorderSide(
                    color: isDarkMode ? Colors.grey.shade800 : Colors.grey.shade300,
                    width: 1,
                  ),
                ),
              ),
              child: TabBar(
                indicatorColor: const Color(0xFF13A884),
                indicatorWeight: 2.5,
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
        body: TabBarView(
          children: [
            _buildRuleList(_dasarRules, isDarkMode),
            _buildRuleList(_madRules, isDarkMode),
          ],
        ),
      ),
    );
  }

  Widget _buildRuleList(List<TajwidRule> rules, bool isDarkMode) {
    return ListView.builder(
      padding: EdgeInsets.zero,
      itemCount: rules.length,
      itemBuilder: (context, index) {
        final rule = rules[index];
        return _buildRuleItem(rule, isDarkMode);
      },
    );
  }

  Widget _buildRuleItem(TajwidRule rule, bool isDarkMode) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Full width colored Title Bar
          Container(
            color: rule.titleColor,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 7),
            child: Text(
              rule.title,
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ),
          // Description Area
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  rule.description,
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    color: isDarkMode ? Colors.white70 : Colors.black87,
                    height: 1.45,
                  ),
                ),
                if (rule.caraBaca != null) ...[
                  const SizedBox(height: 8),
                  Text(
                    rule.caraBaca!,
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      color: isDarkMode ? Colors.white70 : Colors.black87,
                      height: 1.45,
                    ),
                  ),
                ],
                if (rule.bulletPoints != null) ...[
                  const SizedBox(height: 6),
                  ...rule.bulletPoints!.map((point) => Padding(
                        padding: const EdgeInsets.only(left: 8, bottom: 3),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('• ', style: GoogleFonts.poppins(fontSize: 13, color: isDarkMode ? Colors.white70 : Colors.black87)),
                            Expanded(
                              child: Text(
                                point,
                                style: GoogleFonts.poppins(
                                  fontSize: 13,
                                  color: isDarkMode ? Colors.white70 : Colors.black87,
                                  height: 1.45,
                                ),
                              ),
                            ),
                          ],
                        ),
                      )),
                ],
                if (rule.catatan != null) ...[
                  const SizedBox(height: 10),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('📝 ', style: TextStyle(fontSize: 13)),
                      Expanded(
                        child: RichText(
                          text: TextSpan(
                            style: GoogleFonts.poppins(
                              fontSize: 13,
                              color: isDarkMode ? Colors.white70 : Colors.black87,
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
                if (rule.examples.isNotEmpty) ...[
                  const SizedBox(height: 10),
                  ...rule.examples.asMap().entries.map((entry) {
                    final idx = entry.key;
                    final example = entry.value;
                    final exampleId = '${rule.title}_$idx';
                    final isPlaying = _currentlyPlayingExampleId == exampleId && _audioPlayer.playing;

                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Directionality(
                              textDirection: TextDirection.rtl,
                              child: RichText(
                                textAlign: TextAlign.right,
                                text: TextSpan(
                                  style: GoogleFonts.scheherazadeNew(
                                    fontSize: 22,
                                    height: 1.1,
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
                          const SizedBox(width: 12),
                          IconButton(
                            icon: Icon(
                              isPlaying ? Icons.pause_circle_filled : Icons.volume_up,
                              color: const Color(0xFF13A884),
                              size: 24,
                            ),
                            onPressed: () => _playExampleAudio(example.audioUrl, exampleId),
                            constraints: const BoxConstraints(),
                            padding: EdgeInsets.zero,
                          ),
                        ],
                      ),
                    );
                  }),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
