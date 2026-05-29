import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:share_plus/share_plus.dart';
import 'settings_provider.dart';
import 'settings_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';

class KajianVideoPage extends StatefulWidget {
  const KajianVideoPage({super.key});

  @override
  State<KajianVideoPage> createState() => _KajianVideoPageState();
}

class _KajianVideoPageState extends State<KajianVideoPage> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedCategory = 'Semua';
  bool _isPlayingMiniPlayer = true;
  String _videoTextSize = 'Sedang'; // Kecil, Sedang, Besar

  SharedPreferences? _prefs;
  List<String> _bookmarkedIds = [];
  List<String> _historyIds = [];
  List<String> _downloadedIds = [];

  double get _localTextScale {
    switch (_videoTextSize) {
      case 'Kecil':
        return 0.85;
      case 'Besar':
        return 1.25;
      case 'Sedang':
      default:
        return 1.0;
    }
  }
  
  // Active mini player video (default to first video)
  Map<String, String> _activePlayerVideo = {
    'videoId': 'zPRUFUffZk0',
    'title': 'Mengapa Ada Orang Tidak Beriman Tapi Hidupnya Enak?',
    'duration': '76:08',
    'ustadz': 'Ust. Muhammad Abduh Tuasikal',
    'category': 'Aqidah & Fiqih'
  };

  final List<Map<String, String>> kajianVideos = [
    {
      'videoId': 'eUfw_kZVlcw',
      'title': '7 Amalan Berpahala Haji (Part 1)',
      'duration': '04:45',
      'ustadz': 'Ust. Muhammad Abduh Tuasikal',
      'category': 'Haji & Qurban'
    },
    {
      'videoId': 'a72fRqXimDE',
      'title': 'Takbiran di Awal Dzulhijjah',
      'duration': '01:19',
      'ustadz': 'Ust. Muhammad Abduh Tuasikal',
      'category': 'Haji & Qurban'
    },
    {
      'videoId': 'ApKWyshbLV8',
      'title': 'Cacat Hewan Qurban',
      'duration': '52:00',
      'ustadz': 'Ust. Muhammad Abduh Tuasikal',
      'category': 'Haji & Qurban'
    },
    {
      'videoId': 'hCdTXwY7d30',
      'title': 'Fikih Aqiqah dan Sunnah saat Bayi Lahir',
      'duration': '58:32',
      'ustadz': 'Ust. Muhammad Abduh Tuasikal',
      'category': 'Keluarga & Muamalah'
    },
    {
      'videoId': '9vExf_VatQo',
      'title': 'Hikmah di Balik Qurban',
      'duration': '57:00',
      'ustadz': 'Ust. Muhammad Abduh Tuasikal',
      'category': 'Haji & Qurban'
    },
    {
      'videoId': 'istjr7mA7IE',
      'title': 'Kiat Menjadi Haji Mabrur Dengan Harta',
      'duration': '07:47',
      'ustadz': 'Ust. Muhammad Abduh Tuasikal',
      'category': 'Haji & Qurban'
    },
    {
      'videoId': 'Ep-E-IhOwog',
      'title': 'Pergi Haji Dengan Bekal Apa?',
      'duration': '54:50',
      'ustadz': 'Ust. Muhammad Abduh Tuasikal',
      'category': 'Haji & Qurban'
    },
    {
      'videoId': 'OPOqi2NoN3Q',
      'title': 'Belajar Dari Nabi Ibrahim: Tauhid, Sabar dan Tawakal',
      'duration': '84:30',
      'ustadz': 'Ust. Mujiman',
      'category': 'Aqidah & Fiqih'
    },
    {
      'videoId': 'kfpbZThxiGI',
      'title': 'Dua Nikmat Teragung',
      'duration': '49:50',
      'ustadz': 'Ust. Afifi Abdul Wadud',
      'category': 'Tazkiyatun Nufus'
    },
    {
      'videoId': 'MQftxuJ8S-k',
      'title': 'Taubat, Tauhid, Anxiety, Ujian Hidup & Fikih Qurban',
      'duration': '40:30',
      'ustadz': 'Ust. Muhammad Abduh Tuasikal',
      'category': 'Tazkiyatun Nufus'
    },
    {
      'videoId': '6WaqnpdoWxo',
      'title': 'Seni Mengalah dalam Rumah Tangga',
      'duration': '76:50',
      'ustadz': 'Ust. Ristian Ragil',
      'category': 'Keluarga & Muamalah'
    },
    {
      'videoId': 'zPRUFUffZk0',
      'title': 'Mengapa Ada Orang Tidak Beriman Tapi Hidupnya Enak?',
      'duration': '76:08',
      'ustadz': 'Ust. Muhammad Abduh Tuasikal',
      'category': 'Aqidah & Fiqih'
    },
    {
      'videoId': 'iTZp9Y3MoeI',
      'title': 'Bahaya Orang-Orang Tanpa Ilmu',
      'duration': '69:15',
      'ustadz': 'Ust. Muhammad Abduh Tuasikal',
      'category': 'Aqidah & Fiqih'
    },
    {
      'videoId': 'W3ebQEEecm0',
      'title': 'Vlog Haji Khusus: Dari Haramain Menuju Masjidil Haram',
      'duration': '03:10',
      'ustadz': 'Ust. Muhammad Abduh Tuasikal',
      'category': 'Haji & Qurban'
    },
    {
      'videoId': 'xK09lG3wp5Y',
      'title': 'Vlog Haji Tarwiyah di Mina: Aktivitas Jemaah Haji Plus',
      'duration': '07:07',
      'ustadz': 'Ust. Muhammad Abduh Tuasikal',
      'category': 'Haji & Qurban'
    },
    {
      'videoId': 'y-3sGCiDLS8',
      'title': 'Highlight Langkah Awal Menuju Puncak Haji',
      'duration': '03:10',
      'ustadz': 'Ust. Muhammad Abduh Tuasikal',
      'category': 'Haji & Qurban'
    },
    {
      'videoId': 'RYIWIf40eZo',
      'title': 'Survey Maktab 117 Haji Plus di Mina',
      'duration': '06:25',
      'ustadz': 'Ust. Muhammad Abduh Tuasikal',
      'category': 'Haji & Qurban'
    },
    {
      'videoId': 'aj6yTGyRelo',
      'title': 'Panduan Lengkap Manasik Haji Terbaru',
      'duration': '06:22',
      'ustadz': 'Ust. Muhammad Abduh Tuasikal',
      'category': 'Haji & Qurban'
    },
    {
      'videoId': 'Ndy1wRvajzg',
      'title': 'Sejarah, Fiqih, Akidah & Hikmah Dari Syariat Qurban',
      'duration': '72:11',
      'ustadz': 'Ust. Dr. Firanda Andirja, MA',
      'category': 'Haji & Qurban'
    },
    {
      'videoId': 'vxgQvrr_tvE',
      'title': 'Ayat-Ayat Perekat Cinta Pasangan Suami Istri',
      'duration': '89:39',
      'ustadz': 'Ust. Dr. Firanda Andirja, MA',
      'category': 'Keluarga & Muamalah'
    },
    {
      'videoId': 'yIPXTdY1csE',
      'title': 'Syariat Qurban, Sejarah & Fiqihnya',
      'duration': '61:12',
      'ustadz': 'Ust. Dr. Firanda Andirja, MA',
      'category': 'Haji & Qurban'
    },
    {
      'videoId': 'HGYDlK9gk-k',
      'title': 'Menjaga Keikhlasan Ibadah Di Era Media Sosial',
      'duration': '65:45',
      'ustadz': 'Ust. Dr. Firanda Andirja, MA',
      'category': 'Tazkiyatun Nufus'
    },
    {
      'videoId': 'e-rDxtYjECU',
      'title': 'Bersihkan Hati Dari Noda Hasad',
      'duration': '55:31',
      'ustadz': 'Ust. Dr. Firanda Andirja, MA',
      'category': 'Tazkiyatun Nufus'
    },
    {
      'videoId': 'JCgZ3e3934g',
      'title': 'Indahnya Ukhuwah Di Atas Ilmu',
      'duration': '78:17',
      'ustadz': 'Ust. Dr. Firanda Andirja, MA',
      'category': 'Aqidah & Fiqih'
    },
    {
      'videoId': 'z-ZMpFisXmQ',
      'title': 'Pegangan Para Pedagang',
      'duration': '15:49',
      'ustadz': 'Ust. Dr. Firanda Andirja, MA',
      'category': 'Aqidah & Fiqih'
    },
    {
      'videoId': 'N_4j7TgQBDQ',
      'title': 'Pengorbanan Itu Harus',
      'duration': '18:50',
      'ustadz': 'Ust. Dr. Firanda Andirja, MA',
      'category': 'Tazkiyatun Nufus'
    },
    {
      'videoId': 'b7IcpBPeGYE',
      'title': 'Sombong Tanpa Sadar',
      'duration': '14:06',
      'ustadz': 'Ust. Dr. Firanda Andirja, MA',
      'category': 'Tazkiyatun Nufus'
    },
    {
      'videoId': 'mlKit-HK2Co',
      'title': 'Tawakal',
      'duration': '18:51',
      'ustadz': 'Ust. Dr. Firanda Andirja, MA',
      'category': 'Tazkiyatun Nufus'
    },
    {
      'videoId': 'u5vFIFsKJGs',
      'title': 'Agar Tidak Ngeluh Melulu',
      'duration': '18:46',
      'ustadz': 'Ust. Dr. Firanda Andirja, MA',
      'category': 'Tazkiyatun Nufus'
    },
    {
      'videoId': 'j16CcCGG9Ss',
      'title': 'Orang Pelit Sulit Silaturahmi',
      'duration': '16:56',
      'ustadz': 'Ust. Dr. Firanda Andirja, MA',
      'category': 'Tazkiyatun Nufus'
    },
    {
      'videoId': 'HAVYsCW1FMU',
      'title': 'Sunahnya Berjenggot',
      'duration': '58:33',
      'ustadz': 'Ust. Dr. Firanda Andirja, MA',
      'category': 'Aqidah & Fiqih'
    },
    {
      'videoId': 'JW8j7TUdg-M',
      'title': 'Haramnya Musik',
      'duration': '54:40',
      'ustadz': 'Ust. Dr. Firanda Andirja, MA',
      'category': 'Aqidah & Fiqih'
    },
    {
      'videoId': 'NomrU-A7uF0',
      'title': 'Haruskah Aku Bercadar',
      'duration': '46:31',
      'ustadz': 'Ust. Dr. Firanda Andirja, MA',
      'category': 'Aqidah & Fiqih'
    },
    {
      'videoId': '89TlubX5PaI',
      'title': 'Ku Tinggalkan Rokok Karena-Nya',
      'duration': '56:30',
      'ustadz': 'Ust. Dr. Firanda Andirja, MA',
      'category': 'Aqidah & Fiqih'
    },
    {
      'videoId': '_XqoKX6O1v0',
      'title': 'Tercelanya Fanatik Madzhab',
      'duration': '58:34',
      'ustadz': 'Ust. Dr. Firanda Andirja, MA',
      'category': 'Aqidah & Fiqih'
    },
    {
      'videoId': 'tb6xXFq7h6g',
      'title': 'Larangan Pengagungan Kuburan',
      'duration': '44:22',
      'ustadz': 'Ust. Dr. Firanda Andirja, MA',
      'category': 'Aqidah & Fiqih'
    },
    {
      'videoId': '0o60ZTWBK3Y',
      'title': 'Kegelapan Alam Kubur',
      'duration': '01:55',
      'ustadz': 'Ust. Dr. Firanda Andirja, MA',
      'category': 'Aqidah & Fiqih'
    },
    {
      'videoId': 'LMHFXyx3TFM',
      'title': 'Waspada Penyakit Hati Bernama Sombong',
      'duration': '02:37',
      'ustadz': 'Ust. Dr. Firanda Andirja, MA',
      'category': 'Tazkiyatun Nufus'
    },
    {
      'videoId': '3CXGiyGgYoQ',
      'title': 'Berlomba Dalam Ketaatan Kepada Allah',
      'duration': '01:38',
      'ustadz': 'Ust. Dr. Firanda Andirja, MA',
      'category': 'Tazkiyatun Nufus'
    },
    {
      'videoId': '1ozatmEl_wc',
      'title': 'Ibadah Berpahala Besar Namun Sering Dilalaikan',
      'duration': '02:06',
      'ustadz': 'Ust. Dr. Firanda Andirja, MA',
      'category': 'Tazkiyatun Nufus'
    },
    {
      'videoId': 'm4m5cboQWxw',
      'title': 'Pesan Untuk Generasi Muda Di Zaman Sekarang',
      'duration': '03:11',
      'ustadz': 'Ust. Dr. Firanda Andirja, MA',
      'category': 'Keluarga & Muamalah'
    },
    {
      'videoId': 'KxKJPIZwTYI',
      'title': 'Puasa Tasu\'a dan Asyura Di Bulan Muharram',
      'duration': '02:25',
      'ustadz': 'Ust. Dr. Firanda Andirja, MA',
      'category': 'Aqidah & Fiqih'
    }
  ];

  final List<String> categories = [
    'Semua',
    'Haji & Qurban',
    'Tazkiyatun Nufus',
    'Aqidah & Fiqih',
    'Keluarga & Muamalah'
  ];

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() {});
    });
    _initSharedPrefs();
  }

  Future<void> _initSharedPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _prefs = prefs;
      _bookmarkedIds = prefs.getStringList('bookmarked_kajian_videos') ?? [];
      _historyIds = prefs.getStringList('history_kajian_videos') ?? [];
      _downloadedIds = prefs.getStringList('downloaded_kajian_videos') ?? [];
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _addToHistory(String videoId) async {
    _historyIds.remove(videoId);
    _historyIds.insert(0, videoId);
    if (_historyIds.length > 20) {
      _historyIds = _historyIds.sublist(0, 20);
    }
    await _prefs?.setStringList('history_kajian_videos', _historyIds);
    setState(() {});
  }

  void _toggleBookmark(String videoId) async {
    setState(() {
      if (_bookmarkedIds.contains(videoId)) {
        _bookmarkedIds.remove(videoId);
      } else {
        _bookmarkedIds.add(videoId);
      }
    });
    await _prefs?.setStringList('bookmarked_kajian_videos', _bookmarkedIds);
  }

  void _startDownloadSimulation(Map<String, String> video) {
    if (_downloadedIds.contains(video['videoId'])) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Video "${video['title']}" sudah diunduh offline')),
      );
      return;
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        double progress = 0.0;
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            Future.delayed(const Duration(milliseconds: 100), () {
              if (progress < 1.0) {
                setStateDialog(() {
                  progress += 0.05;
                });
              } else {
                Navigator.pop(context);
                _saveDownload(video['videoId']!);
              }
            });

            return AlertDialog(
              backgroundColor: Theme.of(context).cardColor,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              title: Text(
                'Mengunduh Kajian...',
                style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    video['title']!,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.poppins(fontSize: 12),
                  ),
                  const SizedBox(height: 16),
                  LinearProgressIndicator(
                    value: progress,
                    backgroundColor: Colors.grey[200],
                    valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF13A884)),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${(progress * 100).toInt()}%',
                    style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 13, color: const Color(0xFF13A884)),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _saveDownload(String videoId) async {
    if (!_downloadedIds.contains(videoId)) {
      _downloadedIds.add(videoId);
      await _prefs?.setStringList('downloaded_kajian_videos', _downloadedIds);
      setState(() {});
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Video berhasil diunduh ke penyimpanan offline aplikasi')),
      );
    }
  }

  void _showVideoListBottomSheet({
    required String title,
    required List<String> videoIds,
    required String emptyMessage,
    bool showClearAll = false,
    VoidCallback? onClearAll,
  }) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final cardColor = isDarkMode ? const Color(0xFF1E1E1E) : Colors.white;
    final textColor = isDarkMode ? Colors.white : const Color(0xFF2D3436);
    final Color subtitleColor = isDarkMode ? Colors.white70 : const Color(0xFF757575);

    final List<Map<String, String>> videos = videoIds.map((id) {
      return kajianVideos.firstWhere((v) => v['videoId'] == id, orElse: () => {
        'videoId': id,
        'title': 'Kajian Islam',
        'duration': '--:--',
        'ustadz': 'Ust. Dr. Firanda Andirja, MA',
        'category': 'Umum'
      });
    }).toList();

    showModalBottomSheet(
      context: context,
      backgroundColor: cardColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            return Container(
              padding: const EdgeInsets.all(20),
              height: MediaQuery.of(context).size.height * 0.5,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        title,
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: textColor,
                        ),
                      ),
                      if (showClearAll && videoIds.isNotEmpty)
                        TextButton(
                          onPressed: () {
                            if (onClearAll != null) {
                              onClearAll();
                              setSheetState(() {
                                videos.clear();
                              });
                              Navigator.pop(context);
                            }
                          },
                          child: Text(
                            'Hapus Semua',
                            style: GoogleFonts.poppins(color: Colors.red, fontSize: 12, fontWeight: FontWeight.bold),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  if (videos.isEmpty)
                    Expanded(
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.video_library_outlined, size: 40, color: subtitleColor.withOpacity(0.5)),
                            const SizedBox(height: 12),
                            Text(
                              emptyMessage,
                              style: GoogleFonts.poppins(color: subtitleColor, fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                    )
                  else
                    Expanded(
                      child: ListView.builder(
                        itemCount: videos.length,
                        itemBuilder: (context, index) {
                          final vid = videos[index];
                          final videoId = vid['videoId']!;
                          return ListTile(
                            contentPadding: EdgeInsets.zero,
                            leading: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.network(
                                'https://img.youtube.com/vi/$videoId/mqdefault.jpg',
                                width: 70,
                                height: 45,
                                fit: BoxFit.cover,
                              ),
                            ),
                            title: Text(
                              vid['title']!,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 12, color: textColor),
                            ),
                            subtitle: Text(
                              vid['ustadz']!,
                              style: GoogleFonts.poppins(fontSize: 10, color: subtitleColor),
                            ),
                            trailing: IconButton(
                              icon: Icon(Icons.play_arrow_rounded, color: const Color(0xFF13A884)),
                              onPressed: () {
                                Navigator.pop(context);
                                _launchYouTube(videoId);
                              },
                            ),
                          );
                        },
                      ),
                    ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Future<void> _launchYouTube(String videoId) async {
    _addToHistory(videoId);
    final url = 'https://www.youtube.com/watch?v=$videoId';
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Tidak dapat membuka video: $url')),
      );
    }
  }

  List<Map<String, String>> get _filteredVideos {
    final query = _searchController.text.toLowerCase();
    return kajianVideos.where((vid) {
      final matchesSearch = vid['title']!.toLowerCase().contains(query) ||
          vid['ustadz']!.toLowerCase().contains(query) ||
          vid['category']!.toLowerCase().contains(query);
      final matchesCategory = _selectedCategory == 'Semua' || vid['category'] == _selectedCategory;
      return matchesSearch && matchesCategory;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final themeProvider = Provider.of<SettingsProvider>(context);
    final primaryGreen = const Color(0xFF13A884);
    
    // Background Colors
    final bgColor = isDarkMode ? const Color(0xFF121212) : const Color(0xFFF8F9FA);
    final cardColor = isDarkMode ? const Color(0xFF1E1E1E) : Colors.white;
    final textColor = isDarkMode ? Colors.white : const Color(0xFF2D3436);
    final subtitleColor = isDarkMode ? Colors.white70 : Colors.grey[600];

    return MediaQuery(
      data: MediaQuery.of(context).copyWith(
        textScaler: TextScaler.linear(_localTextScale),
      ),
      child: Scaffold(
        backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: cardColor,
        elevation: 0,
        centerTitle: false,
        leadingWidth: 40,
        leading: Padding(
          padding: const EdgeInsets.only(left: 12),
          child: IconButton(
            icon: Icon(Icons.arrow_back_ios_new, size: 18, color: textColor),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        title: FittedBox(
          fit: BoxFit.scaleDown,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: primaryGreen.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.play_circle_filled, color: primaryGreen, size: 20),
              ),
              const SizedBox(width: 8),
              Text(
                'QURAN PREMIUM',
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  letterSpacing: 0.5,
                  color: primaryGreen,
                ),
              ),
            ],
          ),
        ),
        actions: [
          IconButton(
            constraints: const BoxConstraints(),
            padding: const EdgeInsets.all(6),
            icon: Icon(Icons.bookmark_outline, color: textColor, size: 20),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Daftar bookmark video disimpan di Favorit')),
              );
            },
          ),
          IconButton(
            constraints: const BoxConstraints(),
            padding: const EdgeInsets.all(6),
            icon: Icon(
              themeProvider.themeModeStr == 'Gelap' ? Icons.dark_mode : Icons.light_mode,
              color: textColor,
              size: 20,
            ),
            onPressed: () {
              final current = themeProvider.themeModeStr;
              themeProvider.setThemeModeStr(current == 'Gelap' ? 'Terang' : 'Gelap');
            },
          ),
          IconButton(
            constraints: const BoxConstraints(),
            padding: const EdgeInsets.all(6),
            icon: Icon(Icons.text_fields, color: textColor, size: 20),
            onPressed: () {
              // Adjust text sizes
              showModalBottomSheet(
                context: context,
                builder: (context) => Container(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Ukuran Huruf Teks', style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 16)),
                      const SizedBox(height: 16),
                      ListTile(
                        title: const Text('Kecil'),
                        onTap: () {
                          setState(() {
                            _videoTextSize = 'Kecil';
                          });
                          Navigator.pop(context);
                        },
                      ),
                      ListTile(
                        title: const Text('Sedang'),
                        onTap: () {
                          setState(() {
                            _videoTextSize = 'Sedang';
                          });
                          Navigator.pop(context);
                        },
                      ),
                      ListTile(
                        title: const Text('Besar'),
                        onTap: () {
                          setState(() {
                            _videoTextSize = 'Besar';
                          });
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
          IconButton(
            constraints: const BoxConstraints(),
            padding: const EdgeInsets.all(6),
            icon: Icon(Icons.share_outlined, color: textColor, size: 20),
            onPressed: () {
              Share.share('Ayo tonton video kajian menarik dan bermanfaat di aplikasi Al-Qur\'an NU!');
            },
          ),
          const SizedBox(width: 10),
        ],
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.only(bottom: 120),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // SEARCH BAR
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: cardColor,
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.03),
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: TextField(
                      controller: _searchController,
                      style: GoogleFonts.poppins(color: textColor, fontSize: 14),
                      decoration: InputDecoration(
                        hintText: 'Cari video, ustadz, atau topik...',
                        hintStyle: GoogleFonts.poppins(color: subtitleColor!.withOpacity(0.6), fontSize: 13),
                        prefixIcon: Icon(Icons.search, color: primaryGreen),
                        suffixIcon: _searchController.text.isNotEmpty
                            ? IconButton(
                                icon: Icon(Icons.clear, color: subtitleColor),
                                onPressed: () => _searchController.clear(),
                              )
                            : null,
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                      ),
                    ),
                  ),
                ),

                // FEATURED BANNER
                _buildFeaturedBanner(primaryGreen, cardColor, isDarkMode),

                // QUICK ACTIONS
                _buildQuickActionsRow(cardColor, textColor, isDarkMode, themeProvider),

                // TERAKHIR DITONTON
                _buildTerakhirDitontonSection(cardColor, textColor, subtitleColor, isDarkMode),

                // PLAYLIST POPULER
                _buildPlaylistPopulerSection(textColor, subtitleColor, isDarkMode),

                // KAJIAN TRENDING
                _buildKajianTrendingSection(cardColor, textColor, subtitleColor, isDarkMode),

                // SEMUA VIDEO SECTION
                _buildSemuaVideoHeader(textColor),
                
                // CATEGORIES CHIPS
                _buildCategoriesChips(primaryGreen, cardColor, textColor, isDarkMode),
                
                // VIDEOS GRID / LIST
                _buildVideosListOrGrid(cardColor, textColor, subtitleColor, isDarkMode),
              ],
            ),
          ),

          // BOTTOM MINI PLAYER
          Positioned(
            left: 16,
            right: 16,
            bottom: 16,
            child: _buildBottomMiniPlayer(cardColor, textColor, subtitleColor, primaryGreen, isDarkMode),
          ),
        ],
      ),
      ),
    );
  }

  // --- WIDGET BUILDERS ---

  Widget _buildFeaturedBanner(Color primaryGreen, Color cardColor, bool isDarkMode) {
    // Featured video: W3ebQEEecm0
    final featuredId = 'W3ebQEEecm0';
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: GestureDetector(
        onTap: () => _launchYouTube(featuredId),
        child: Container(
          height: 195,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: primaryGreen.withOpacity(0.15),
                blurRadius: 15,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Stack(
              children: [
                // Background image
                Image.network(
                  'https://img.youtube.com/vi/$featuredId/maxresdefault.jpg',
                  width: double.infinity,
                  height: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: isDarkMode 
                          ? [const Color(0xFF0F5A47), const Color(0xFF1E3A32)]
                          : [const Color(0xFF13A884), const Color(0xFF0C5441)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                  ),
                ),
                // Gradient overlay
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.black.withOpacity(0.75),
                        Colors.black.withOpacity(0.2),
                        Colors.transparent,
                      ],
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                    ),
                  ),
                ),
                // Text and Button Content
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFF13A884),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          'KAJIAN SPESIAL',
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontSize: 9,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.8,
                          ),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Meraih Ketenangan Hati\ndalam Al-Qur\'an & Sunnah',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          height: 1.25,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Ust. Muhammad Abduh Tuasikal, M.Sc.',
                        style: GoogleFonts.poppins(
                          color: Colors.white70,
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                            decoration: BoxDecoration(
                              color: const Color(0xFF13A884),
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.play_arrow_rounded, color: Colors.white, size: 16),
                                const SizedBox(width: 4),
                                Text(
                                  'Tonton Sekarang',
                                  style: GoogleFonts.poppins(
                                    color: Colors.white,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // Carousel Dot Indicators
                          Row(
                            children: List.generate(5, (index) {
                              return Container(
                                margin: const EdgeInsets.only(left: 4),
                                width: index == 0 ? 12 : 5,
                                height: 5,
                                decoration: BoxDecoration(
                                  color: index == 0 ? const Color(0xFF13A884) : Colors.white54,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              );
                            }),
                          )
                        ],
                      )
                    ],
                  ),
                ),
                // Big Play Icon in the Center Right
                Positioned(
                  right: 24,
                  top: 50,
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.85),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.play_arrow_rounded, color: primaryGreen, size: 30),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildQuickActionsRow(Color cardColor, Color textColor, bool isDarkMode, SettingsProvider provider) {
    final actions = [
      {'icon': Icons.download_for_offline_outlined, 'label': 'Download'},
      {'icon': Icons.share_outlined, 'label': 'Bagikan'},
      {'icon': Icons.bookmark_border_outlined, 'label': 'Bookmark'},
      {'icon': Icons.history_outlined, 'label': 'Riwayat'},
      {'icon': Icons.settings_outlined, 'label': 'Pengaturan'},
    ];

    return Container(
      height: 90,
      margin: const EdgeInsets.only(bottom: 12),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: actions.length,
        itemBuilder: (context, index) {
          final act = actions[index];
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: InkWell(
              onTap: () {
                // Action logic
                final isDarkMode = Theme.of(context).brightness == Brightness.dark;
                final cardColor = isDarkMode ? const Color(0xFF1E1E1E) : Colors.white;
                final textColor = isDarkMode ? Colors.white : const Color(0xFF2D3436);
                final subtitleColor = isDarkMode ? Colors.white70 : Colors.grey[600];

                if (index == 0) {
                  // Download Bottom Sheet
                  showModalBottomSheet(
                    context: context,
                    backgroundColor: cardColor,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                    ),
                    builder: (context) {
                      final isDownloaded = _downloadedIds.contains(_activePlayerVideo['videoId']);
                      return Container(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Unduhan Kajian',
                              style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 16, color: textColor),
                            ),
                            const SizedBox(height: 16),
                            ListTile(
                              leading: Icon(isDownloaded ? Icons.download_done : Icons.download, color: const Color(0xFF13A884)),
                              title: Text(
                                isDownloaded ? 'Video Aktif Sudah Diunduh' : 'Unduh Video Aktif Offline',
                                style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w600, color: textColor),
                              ),
                              subtitle: Text(
                                _activePlayerVideo['title']!,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.poppins(fontSize: 11, color: subtitleColor),
                              ),
                              onTap: isDownloaded
                                  ? null
                                  : () {
                                      Navigator.pop(context);
                                      _startDownloadSimulation(_activePlayerVideo);
                                    },
                            ),
                            const Divider(),
                            ListTile(
                              leading: Icon(Icons.folder_zip_outlined, color: const Color(0xFF13A884)),
                              title: Text(
                                'Daftar Unduhan Saya (${_downloadedIds.length})',
                                style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w600, color: textColor),
                              ),
                              onTap: () {
                                Navigator.pop(context);
                                _showVideoListBottomSheet(
                                  title: 'Video Hasil Unduhan',
                                  videoIds: _downloadedIds,
                                  emptyMessage: 'Belum ada video yang diunduh offline',
                                );
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  );
                } else if (index == 1) {
                  // Share active video details
                  Share.share("Yuk tonton kajian '${_activePlayerVideo['title']}' oleh ${_activePlayerVideo['ustadz']} di YouTube: https://www.youtube.com/watch?v=${_activePlayerVideo['videoId']}");
                } else if (index == 2) {
                  // Bookmark Bottom Sheet
                  showModalBottomSheet(
                    context: context,
                    backgroundColor: cardColor,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                    ),
                    builder: (context) {
                      final isBookmarked = _bookmarkedIds.contains(_activePlayerVideo['videoId']);
                      return Container(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Bookmark Kajian',
                              style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 16, color: textColor),
                            ),
                            const SizedBox(height: 16),
                            ListTile(
                              leading: Icon(isBookmarked ? Icons.bookmark : Icons.bookmark_border, color: const Color(0xFF13A884)),
                              title: Text(
                                isBookmarked ? 'Hapus dari Bookmark' : 'Tambah Video Aktif ke Bookmark',
                                style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w600, color: textColor),
                              ),
                              subtitle: Text(
                                _activePlayerVideo['title']!,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.poppins(fontSize: 11, color: subtitleColor),
                              ),
                              onTap: () {
                                Navigator.pop(context);
                                _toggleBookmark(_activePlayerVideo['videoId']!);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      isBookmarked
                                          ? 'Dihapus dari Bookmark'
                                          : 'Berhasil ditambahkan ke Bookmark',
                                    ),
                                  ),
                                );
                              },
                            ),
                            const Divider(),
                            ListTile(
                              leading: Icon(Icons.collections_bookmark_outlined, color: const Color(0xFF13A884)),
                              title: Text(
                                'Daftar Bookmark Saya (${_bookmarkedIds.length})',
                                style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w600, color: textColor),
                              ),
                              onTap: () {
                                Navigator.pop(context);
                                _showVideoListBottomSheet(
                                  title: 'Kajian yang Dibookmark',
                                  videoIds: _bookmarkedIds,
                                  emptyMessage: 'Belum ada kajian yang disimpan di bookmark',
                                );
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  );
                } else if (index == 3) {
                  // Riwayat Bottom Sheet
                  _showVideoListBottomSheet(
                    title: 'Riwayat Tontonan',
                    videoIds: _historyIds,
                    emptyMessage: 'Belum ada riwayat tontonan video',
                    showClearAll: true,
                    onClearAll: () async {
                      _historyIds.clear();
                      await _prefs?.setStringList('history_kajian_videos', []);
                      setState(() {});
                    },
                  );
                } else if (index == 4) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const SettingsPage()),
                  );
                }
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 46,
                    height: 46,
                    decoration: BoxDecoration(
                      color: cardColor,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.02),
                          blurRadius: 5,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Icon(act['icon'] as IconData, color: const Color(0xFF13A884), size: 22),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    act['label'] as String,
                    style: GoogleFonts.poppins(
                      color: textColor,
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
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

  Widget _buildTerakhirDitontonSection(Color cardColor, Color textColor, Color subtitleColor, bool isDarkMode) {
    // Kurasi 4 video untuk "Terakhir Ditonton"
    final recentVideos = [
      {
        'videoId': 'vxgQvrr_tvE',
        'title': 'Jangan Tinggalkan Shalat', // Re-written to match image context
        'ustadz': 'Ust. Adi Hidayat, Lc., M.A.',
        'duration': '18:24',
        'progress': 0.75,
      },
      {
        'videoId': 'Ndy1wRvajzg',
        'title': 'Tafsir Surah Al-Mulk',
        'ustadz': 'Ust. Khalid Basalamah, MA',
        'duration': '24:35',
        'progress': 0.40,
      },
      {
        'videoId': 'mlKit-HK2Co',
        'title': 'Hati yang Tenang',
        'ustadz': 'Ust. Hanan Attaki, Lc.',
        'duration': '21:10',
        'progress': 0.15,
      },
      {
        'videoId': 'b7IcpBPeGYE',
        'title': 'Sabar & Syukur',
        'ustadz': 'Ust. Syafiq Riza Basalamah',
        'duration': '19:45',
        'progress': 0.90,
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Terakhir Ditonton',
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: textColor,
                ),
              ),
              GestureDetector(
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Menampilkan semua riwayat')),
                  );
                },
                child: Row(
                  children: [
                    Text(
                      'Lihat Semua',
                      style: GoogleFonts.poppins(
                        fontSize: 11,
                        color: const Color(0xFF13A884),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const Icon(Icons.chevron_right, size: 14, color: Color(0xFF13A884)),
                  ],
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 155,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: recentVideos.length,
            itemBuilder: (context, index) {
              final vid = recentVideos[index];
              final String videoId = vid['videoId'] as String;
              final String duration = vid['duration'] as String;
              final double progress = vid['progress'] as double;
              
              return GestureDetector(
                onTap: () => _launchYouTube(videoId),
                child: Container(
                  width: 150,
                  margin: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                  decoration: BoxDecoration(
                    color: cardColor,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.02),
                        blurRadius: 6,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Video Thumbnail with Duration
                      Stack(
                        children: [
                          ClipRRect(
                            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                            child: Image.network(
                              'https://img.youtube.com/vi/$videoId/mqdefault.jpg',
                              height: 80,
                              width: 150,
                              fit: BoxFit.cover,
                            ),
                          ),
                          // Play overlay in center
                          Positioned.fill(
                            child: Center(
                              child: Container(
                                padding: const EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                  color: Colors.black.withOpacity(0.5),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(Icons.play_arrow_rounded, color: Colors.white, size: 18),
                              ),
                            ),
                          ),
                          // Duration label
                          Positioned(
                            right: 6,
                            bottom: 6,
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.7),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                duration,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 8,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      // Progress Bar
                      LinearProgressIndicator(
                        value: progress,
                        minHeight: 3,
                        backgroundColor: isDarkMode ? Colors.white10 : Colors.grey[200],
                        valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF13A884)),
                      ),
                      // Video Title & Ustadz
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              vid['title'] as String,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.bold,
                                fontSize: 10,
                                color: textColor,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              vid['ustadz'] as String,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.poppins(
                                fontSize: 8,
                                color: subtitleColor,
                                fontWeight: FontWeight.w500,
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
        ),
      ],
    );
  }

  Widget _buildPlaylistPopulerSection(Color textColor, Color subtitleColor, bool isDarkMode) {
    final playlists = [
      {
        'title': 'Seputar Shalat',
        'count': '32 Video',
        'color': const Color(0xFFE6F4F1),
        'darkColor': const Color(0xFF0F3A30),
        'icon': Icons.menu_book,
      },
      {
        'title': 'Seputar Zakat',
        'count': '28 Video',
        'color': const Color(0xFFFBF1EB),
        'darkColor': const Color(0xFF402E23),
        'icon': Icons.volunteer_activism,
      },
      {
        'title': 'Kisah Nabi & Rasul',
        'count': '45 Video',
        'color': const Color(0xFFE8F5E9),
        'darkColor': const Color(0xFF1B3D20),
        'icon': Icons.history_edu,
      },
      {
        'title': 'Keluarga Islami',
        'count': '36 Video',
        'color': const Color(0xFFEDE7F6),
        'darkColor': const Color(0xFF261F3D),
        'icon': Icons.people_outline,
      },
      {
        'title': 'Doa & Dzikir',
        'count': '52 Video',
        'color': const Color(0xFFE1F5FE),
        'darkColor': const Color(0xFF0F314D),
        'icon': Icons.spa_outlined,
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Playlist Populer',
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: textColor,
                ),
              ),
              GestureDetector(
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Menampilkan semua playlist')),
                  );
                },
                child: Row(
                  children: [
                    Text(
                      'Lihat Semua',
                      style: GoogleFonts.poppins(
                        fontSize: 11,
                        color: const Color(0xFF13A884),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const Icon(Icons.chevron_right, size: 14, color: Color(0xFF13A884)),
                  ],
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 120,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: playlists.length,
            itemBuilder: (context, index) {
              final pl = playlists[index];
              final tileBg = isDarkMode ? pl['darkColor'] as Color : pl['color'] as Color;
              
              return GestureDetector(
                onTap: () {
                  // Filter by corresponding category
                  String filterCat = 'Semua';
                  if (index == 0) filterCat = 'Aqidah & Fiqih';
                  else if (index == 1) filterCat = 'Haji & Qurban';
                  else if (index == 2) filterCat = 'Haji & Qurban';
                  else if (index == 3) filterCat = 'Keluarga & Muamalah';
                  else if (index == 4) filterCat = 'Tazkiyatun Nufus';
                  
                  setState(() {
                    _selectedCategory = filterCat;
                  });

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Menyaring video kategori: $filterCat')),
                  );
                },
                child: Container(
                  width: 110,
                  margin: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: tileBg,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Silhouette icon / representation
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(isDarkMode ? 0.08 : 0.6),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(pl['icon'] as IconData, color: const Color(0xFF13A884), size: 18),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            pl['title'] as String,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.bold,
                              fontSize: 10,
                              color: isDarkMode ? Colors.white : const Color(0xFF1B4D3E),
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            pl['count'] as String,
                            style: GoogleFonts.poppins(
                              fontSize: 8,
                              color: isDarkMode ? Colors.white70 : Colors.grey[600],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildKajianTrendingSection(Color cardColor, Color textColor, Color subtitleColor, bool isDarkMode) {
    // Trending curation mapping
    final trendingList = [
      {
        'rank': 'TRENDING #1',
        'videoId': 'vxgQvrr_tvE',
        'title': 'Tanda-Tanda Hati yang Mati',
        'ustadz': 'Ust. Khalid Basalamah, MA',
        'views': '125 rb',
        'duration': '21:05',
      },
      {
        'rank': 'TRENDING #2',
        'videoId': 'u5vFIFsKJGs',
        'title': 'Amalan Ringan Pahala Berat',
        'ustadz': 'Ust. Syafiq Riza Basalamah',
        'views': '98 rb',
        'duration': '17:44',
      },
      {
        'rank': 'TRENDING #3',
        'videoId': 'zPRUFUffZk0',
        'title': 'Cara Mengatasi Kegelisahan',
        'ustadz': 'Ust. Adi Hidayat, Lc., M.A.',
        'views': '87 rb',
        'duration': '24:10',
      },
      {
        'rank': 'TRENDING #4',
        'videoId': 'b7IcpBPeGYE',
        'title': 'Dahsyatnya Sedekah',
        'ustadz': 'Ust. Khalid Basalamah, MA',
        'views': '76 rb',
        'duration': '18:33',
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Kajian Trending',
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: textColor,
                ),
              ),
              GestureDetector(
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Menampilkan video trending')),
                  );
                },
                child: Row(
                  children: [
                    Text(
                      'Lihat Semua',
                      style: GoogleFonts.poppins(
                        fontSize: 11,
                        color: const Color(0xFF13A884),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const Icon(Icons.chevron_right, size: 14, color: Color(0xFF13A884)),
                  ],
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 145,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: trendingList.length,
            itemBuilder: (context, index) {
              final item = trendingList[index];
              final String videoId = item['videoId'] as String;
              
              return GestureDetector(
                onTap: () => _launchYouTube(videoId),
                child: Container(
                  width: 180,
                  margin: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                  decoration: BoxDecoration(
                    color: cardColor,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.02),
                        blurRadius: 6,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Video thumbnail & Rank Badge & Duration
                      Stack(
                        children: [
                          ClipRRect(
                            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                            child: Image.network(
                              'https://img.youtube.com/vi/$videoId/mqdefault.jpg',
                              height: 85,
                              width: 180,
                              fit: BoxFit.cover,
                            ),
                          ),
                          // Play button overlay in center
                          Positioned.fill(
                            child: Center(
                              child: Container(
                                padding: const EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  color: Colors.black.withOpacity(0.4),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(Icons.play_arrow_rounded, color: Colors.white, size: 16),
                              ),
                            ),
                          ),
                          // Rank Badge
                          Positioned(
                            left: 8,
                            top: 8,
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                              decoration: BoxDecoration(
                                color: const Color(0xFF13A884),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                item['rank'] as String,
                                style: GoogleFonts.poppins(
                                  color: Colors.white,
                                  fontSize: 7,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          // Duration badge
                          Positioned(
                            right: 6,
                            bottom: 6,
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.7),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                item['duration'] as String,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 8,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      // Text metadata
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item['title'] as String,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.bold,
                                fontSize: 10,
                                color: textColor,
                              ),
                            ),
                            const SizedBox(height: 1),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    item['ustadz'] as String,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: GoogleFonts.poppins(
                                      fontSize: 8,
                                      color: subtitleColor,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                                Row(
                                  children: [
                                    Icon(Icons.remove_red_eye_outlined, size: 9, color: subtitleColor),
                                    const SizedBox(width: 2),
                                    Text(
                                      item['views'] as String,
                                      style: GoogleFonts.poppins(fontSize: 8, color: subtitleColor, fontWeight: FontWeight.w500),
                                    ),
                                  ],
                                )
                              ],
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
        ),
      ],
    );
  }

  Widget _buildSemuaVideoHeader(Color textColor) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
      child: Text(
        'Semua Kajian Video',
        style: GoogleFonts.poppins(
          fontWeight: FontWeight.bold,
          fontSize: 14,
          color: textColor,
        ),
      ),
    );
  }

  Widget _buildCategoriesChips(Color primaryGreen, Color cardColor, Color textColor, bool isDarkMode) {
    return SizedBox(
      height: 38,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final cat = categories[index];
          final isSelected = cat == _selectedCategory;
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: FilterChip(
              label: Text(
                cat,
                style: GoogleFonts.poppins(
                  fontSize: 11,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                  color: isSelected ? Colors.white : textColor,
                ),
              ),
              selected: isSelected,
              onSelected: (selected) {
                setState(() {
                  _selectedCategory = cat;
                });
              },
              selectedColor: primaryGreen,
              checkmarkColor: Colors.white,
              backgroundColor: cardColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: BorderSide(
                  color: isSelected ? primaryGreen : (isDarkMode ? Colors.white10 : Colors.grey[300]!),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildVideosListOrGrid(Color cardColor, Color textColor, Color subtitleColor, bool isDarkMode) {
    final filtered = _filteredVideos;
    if (filtered.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 40),
          child: Column(
            children: [
              Icon(Icons.video_library_outlined, size: 48, color: subtitleColor.withOpacity(0.5)),
              const SizedBox(height: 12),
              Text(
                'Tidak ada video yang cocok',
                style: GoogleFonts.poppins(color: subtitleColor, fontSize: 13, fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      itemCount: filtered.length,
      itemBuilder: (context, index) {
        final vid = filtered[index];
        final String videoId = vid['videoId']!;
        
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            color: cardColor,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.015),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: InkWell(
              onTap: () {
                // Set as active player video
                setState(() {
                  _activePlayerVideo = vid;
                  _isPlayingMiniPlayer = true;
                });
                _launchYouTube(videoId);
              },
              child: Row(
                children: [
                  // Thumbnail (Left)
                  Stack(
                    children: [
                      Image.network(
                        'https://img.youtube.com/vi/$videoId/mqdefault.jpg',
                        height: 80,
                        width: 120,
                        fit: BoxFit.cover,
                      ),
                      Positioned.fill(
                        child: Center(
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.4),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.play_arrow_rounded, color: Colors.white, size: 16),
                          ),
                        ),
                      ),
                      Positioned(
                        right: 4,
                        bottom: 4,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1.5),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.75),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            vid['duration']!,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 7.5,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 12),
                  // Details (Right)
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: const Color(0xFF13A884).withOpacity(0.1),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              vid['category']!,
                              style: GoogleFonts.poppins(
                                color: const Color(0xFF13A884),
                                fontSize: 7.5,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            vid['title']!,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.bold,
                              fontSize: 11,
                              color: textColor,
                              height: 1.3,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            vid['ustadz']!,
                            style: GoogleFonts.poppins(
                              fontSize: 9,
                              color: subtitleColor,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Icon(Icons.chevron_right, color: subtitleColor.withOpacity(0.4)),
                  const SizedBox(width: 12),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildBottomMiniPlayer(Color cardColor, Color textColor, Color subtitleColor, Color primaryGreen, bool isDarkMode) {
    return Container(
      height: 60,
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDarkMode ? 0.4 : 0.1),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Row(
          children: [
            // Thumbnail / Icon
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.network(
                'https://img.youtube.com/vi/${_activePlayerVideo['videoId']}/mqdefault.jpg',
                width: 44,
                height: 44,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  width: 44,
                  height: 44,
                  color: primaryGreen,
                  child: const Icon(Icons.music_note, color: Colors.white),
                ),
              ),
            ),
            const SizedBox(width: 12),
            // Title & Ustadz
            Expanded(
              child: GestureDetector(
                onTap: () => _launchYouTube(_activePlayerVideo['videoId']!),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _activePlayerVideo['title']!,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.bold,
                        fontSize: 11,
                        color: textColor,
                      ),
                    ),
                    Text(
                      _activePlayerVideo['ustadz']!,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.poppins(
                        fontSize: 9,
                        color: subtitleColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Controls
            IconButton(
              icon: Icon(Icons.skip_previous_rounded, color: textColor, size: 20),
              onPressed: () {
                // Play previous video
                final currentIdx = kajianVideos.indexWhere((vid) => vid['videoId'] == _activePlayerVideo['videoId']);
                if (currentIdx > 0) {
                  setState(() {
                    _activePlayerVideo = kajianVideos[currentIdx - 1];
                  });
                }
              },
            ),
            IconButton(
              icon: Icon(
                _isPlayingMiniPlayer ? Icons.pause_circle_filled : Icons.play_circle_filled,
                color: primaryGreen,
                size: 28,
              ),
              onPressed: () {
                setState(() {
                  _isPlayingMiniPlayer = !_isPlayingMiniPlayer;
                });
                _launchYouTube(_activePlayerVideo['videoId']!);
              },
            ),
            IconButton(
              icon: Icon(Icons.skip_next_rounded, color: textColor, size: 20),
              onPressed: () {
                // Play next video
                final currentIdx = kajianVideos.indexWhere((vid) => vid['videoId'] == _activePlayerVideo['videoId']);
                if (currentIdx >= 0 && currentIdx < kajianVideos.length - 1) {
                  setState(() {
                    _activePlayerVideo = kajianVideos[currentIdx + 1];
                  });
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
