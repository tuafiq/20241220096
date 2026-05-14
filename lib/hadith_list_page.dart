import 'package:flutter/material.dart';
import 'hadith_service.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:share_plus/share_plus.dart';

class HadithListPage extends StatefulWidget {
  final String narratorId;
  final String narratorName;

  const HadithListPage({
    super.key,
    required this.narratorId,
    required this.narratorName,
  });

  @override
  State<HadithListPage> createState() => _HadithListPageState();
}

class _HadithListPageState extends State<HadithListPage> {
  final HadithService _hadithService = HadithService();
  List<dynamic> _hadiths = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchHadiths();
  }

  int _selectedIndex = -1;

  Future<void> _fetchHadiths() async {
    setState(() => _isLoading = true);
    try {
      final fetched = await _hadithService.getHadithsByNarrator(
        widget.narratorId,
        start: 1,
        end: 20,
      );
      if (mounted) {
        setState(() {
          _hadiths = fetched;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    const primaryGreen = Color(0xFF13A884);

    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0C5441),
        title: Text(widget.narratorName, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        iconTheme: const IconThemeData(color: Colors.white),
        actions: const [],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: primaryGreen))
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Navigation Link
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Row(
                      children: [
                        Icon(Icons.chevron_left, color: primaryGreen, size: 20),
                        Text(
                          'Kembali ke daftar bab',
                          style: TextStyle(color: primaryGreen, fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  ),
                ),
                
                // Chapter Title & Count
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.narratorName,
                        style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        '${_hadiths.length} Hadis',
                        style: TextStyle(color: Colors.grey[600], fontSize: 16),
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 16),
                
                // Hadith List
                Expanded(
                  child: ListView.separated(
                    padding: const EdgeInsets.all(16),
                    itemCount: _hadiths.length,
                    separatorBuilder: (context, index) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final hadith = _hadiths[index];
                      return _buildHadithCard(hadith, index);
                    },
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildHadithCard(Map<String, dynamic> hadith, int index) {
    const primaryGreen = Color(0xFF13A884);
    final isSelected = _selectedIndex == index;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedIndex = index;
        });
        // Tetap navigasi ke detail setelah memilih
        Future.delayed(const Duration(milliseconds: 200), () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => HadithDetailPage(
                hadith: hadith,
                narratorId: widget.narratorId,
                narratorName: widget.narratorName,
              ),
            ),
          );
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFF0F9F6) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? primaryGreen : Colors.black.withOpacity(0.05),
            width: isSelected ? 1.5 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.02),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: const BoxDecoration(
                  color: primaryGreen,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    '${hadith['number'] ?? (index + 1)}',
                    style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  hadith['id'] ?? '',
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 14, height: 1.5),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class HadithDetailPage extends StatefulWidget {
  final Map<String, dynamic> hadith;
  final String? narratorId;
  final String? narratorName;

  const HadithDetailPage({
    super.key, 
    required this.hadith,
    this.narratorId,
    this.narratorName,
  });

  @override
  State<HadithDetailPage> createState() => _HadithDetailPageState();
}

class _HadithDetailPageState extends State<HadithDetailPage> {
  late Map<String, dynamic> currentHadith;
  String? _currentNarratorId;
  String? _currentNarratorName;
  bool _isLoading = false;
  bool _isBookmarked = false;
  final HadithService _hadithService = HadithService();

  @override
  void initState() {
    super.initState();
    _currentNarratorId = widget.narratorId;
    _currentNarratorName = widget.narratorName;
    _normalizeData(widget.hadith);
    
    // Check if bookmarked in global manager
    _isBookmarked = BookmarkManager().isHadithBookmarked(
      _currentNarratorId ?? 'bukhari', 
      currentHadith['number'] as int
    );
  }

  void _normalizeData(Map<String, dynamic> data) {
    // If data has 'contents', it's from detail API
    if (data.containsKey('contents')) {
      final contents = data['contents'];
      currentHadith = {
        'number': contents['number'],
        'arab': contents['arab'],
        'id': contents['id'], // Translation
        'name': data['name'],
        'slug': data['id'],
      };
      if (_currentNarratorId == null) _currentNarratorId = data['id'];
      if (_currentNarratorName == null) _currentNarratorName = data['name'];
    } else {
      // It's already the content map (from list or search)
      currentHadith = data;
    }
  }

  void _toggleBookmark() {
    final manager = BookmarkManager();
    final nId = _currentNarratorId ?? 'bukhari';
    final nName = _currentNarratorName ?? 'Hadis';
    final hNumber = currentHadith['number'] as int;

    setState(() {
      if (_isBookmarked) {
        manager.removeBookmark(nId, number: hNumber);
      } else {
        manager.addHadithBookmark(currentHadith, nId, nName);
      }
      _isBookmarked = !_isBookmarked;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(_isBookmarked ? 'Hadis disimpan ke bookmark' : 'Hadis dihapus dari bookmark'),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  Future<void> _navigateHadith(int offset) async {
    final currentNumber = currentHadith['number'] as int;
    final newNumber = currentNumber + offset;

    if (newNumber <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Ini adalah hadis pertama')),
      );
      return;
    }

    setState(() => _isLoading = true);

    final nId = _currentNarratorId ?? 'bukhari';
    final result = await _hadithService.getHadithDetail(nId, newNumber);

    if (mounted) {
      if (result != null) {
        setState(() {
          _normalizeData(result);
          _isLoading = false;
        });
      } else {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Gagal memuat hadis')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    const primaryGreen = Color(0xFF13A884);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF0C5441),
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Detail Hasil Cari',
          style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: _isLoading 
        ? const Center(child: CircularProgressIndicator(color: primaryGreen))
        : SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Info
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _currentNarratorName ?? currentHadith['name'] ?? 'Hadis',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'No. ${currentHadith['number']}',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[700],
                    ),
                  ),
                ],
              ),
            ),

            // Arabic Text
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              child: Center(
                child: Text(
                  currentHadith['arab'] ?? '',
                  style: const TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Amiri',
                    height: 2.2,
                    color: Color(0xFF2D2D2D),
                  ),
                  textAlign: TextAlign.center,
                  textDirection: TextDirection.rtl,
                ),
              ),
            ),

            // Translation Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Artinya:',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    currentHadith['id'] ?? '',
                    style: TextStyle(
                      fontSize: 14,
                      height: 1.6,
                      color: Colors.grey[800],
                    ),
                  ),
                ],
              ),
            ),

            // Status Badge
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Row(
                children: [
                  const Text(
                    'Status:  ',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF0F9F6),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text(
                      'Hasan',
                      style: TextStyle(
                        color: primaryGreen,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Bookmark and Share Buttons
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 16),
                decoration: BoxDecoration(
                  border: Border(
                    top: BorderSide(color: Colors.grey[100]!),
                    bottom: BorderSide(color: Colors.grey[100]!),
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: _toggleBookmark,
                        child: Column(
                          children: [
                            Icon(
                              _isBookmarked ? Icons.bookmark : Icons.bookmark_border, 
                              color: _isBookmarked ? primaryGreen : Colors.black54
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Bookmark', 
                              style: TextStyle(
                                fontSize: 12, 
                                color: _isBookmarked ? primaryGreen : Colors.black54
                              )
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(width: 1, height: 24, color: Colors.grey[200]),
                    Expanded(
                      child: InkWell(
                        onTap: () => _showShareBottomSheet(context),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.share_outlined, color: Colors.grey[600], size: 20),
                            const SizedBox(width: 8),
                            Text('Bagikan', style: TextStyle(color: Colors.grey[700], fontWeight: FontWeight.w500)),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Informasi Hadis (Screen 5)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Informasi Hadis',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.black87),
                  ),
                  const SizedBox(height: 16),
                  _buildInfoRow('Perawi', _currentNarratorName ?? 'Anonim'),
                  _buildInfoRow('Sumber', 'Aplikasi Hadis Digital'),
                  _buildInfoRow('Nomor', 'No. ${currentHadith['number']}'),
                  _buildInfoRow('ID Buku', _currentNarratorId?.toUpperCase() ?? '-'),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // Navigation Buttons (Screen 5)
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 40),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        side: const BorderSide(color: Color(0xFFE0E0E0)),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      onPressed: () => _navigateHadith(-1),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.chevron_left, color: primaryGreen, size: 20),
                          SizedBox(width: 4),
                          Text(
                            'Sebelumnya',
                            style: TextStyle(color: primaryGreen, fontSize: 13, fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        backgroundColor: const Color(0xFFF0F9F6),
                        side: const BorderSide(color: Color(0xFF13A884), width: 0.5),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      onPressed: () => _navigateHadith(1),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Selanjutnya',
                            style: TextStyle(color: primaryGreen, fontSize: 13, fontWeight: FontWeight.w600),
                          ),
                          SizedBox(width: 4),
                          Icon(Icons.chevron_right, color: primaryGreen, size: 20),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: TextStyle(color: Colors.grey[600], fontSize: 13),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(color: Colors.black87, fontSize: 13, fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }

  void _showShareBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.3),
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 8),
            Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.white.withOpacity(0.3), borderRadius: BorderRadius.circular(2))),
            const SizedBox(height: 16),
            const Text(
              'Bagikan Hadis',
              style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 24),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: const Color(0xFF0C5441),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Icons.mosque, color: Colors.white, size: 20),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Jami\' At-Tirmidzi',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                        ),
                        Text(
                          'Kitab Shalat - No. 3',
                          style: TextStyle(color: Colors.grey[600], fontSize: 13),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          currentHadith['id'] ?? '',
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(color: Colors.grey[800], fontSize: 13, height: 1.4),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 24),
              padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildShareApp('WhatsApp', FontAwesomeIcons.whatsapp, const Color(0xFF25D366), () => _launchSocial('whatsapp')),
                      _buildShareApp('Telegram', FontAwesomeIcons.telegram, const Color(0xFF0088CC), () => _launchSocial('telegram')),
                      _buildShareApp('Instagram', FontAwesomeIcons.instagram, const Color(0xFFE4405F), () => _launchSocial('instagram')),
                      _buildShareApp('Facebook', FontAwesomeIcons.facebook, const Color(0xFF1877F2), () => _launchSocial('facebook')),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildActionItem('Salin Teks', FontAwesomeIcons.copy, onTap: () {
                        final fullText = '${currentHadith['arab']}\n\n${currentHadith['id']}';
                        Clipboard.setData(ClipboardData(text: fullText));
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Teks berhasil disalin')),
                        );
                      }),
                      _buildActionItem('Salin Link', FontAwesomeIcons.link, onTap: () {
                        Clipboard.setData(ClipboardData(text: 'https://hadiths.in/${currentHadith['number']}'));
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Link berhasil disalin')),
                        );
                      }),
                      _buildActionItem('Gmail', FontAwesomeIcons.google, isGmail: true, onTap: () => _launchSocial('gmail')),
                      _buildActionItem('Lainnya', Icons.more_horiz, onTap: () {
                        final fullText = '${currentHadith['arab']}\n\n${currentHadith['id']}\n\nSumber: Aplikasi Hadis Digital';
                        Share.share(fullText);
                      }),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: const Color(0xFF13A884),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    elevation: 0,
                  ),
                  child: const Text('Batal', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildShareApp(String label, IconData icon, Color color, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          Icon(icon, color: color, size: 45),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(fontSize: 11, color: Colors.black87),
          ),
        ],
      ),
    );
  }

  void _launchSocial(String platform) async {
    final arabText = currentHadith['arab'] ?? '';
    final indoText = currentHadith['id'] ?? '';
    final fullContent = '$arabText\n\n$indoText\n\nSumber: Aplikasi Hadis Digital';
    final encodedText = Uri.encodeComponent(fullContent);
    
    String url = '';
    if (platform == 'whatsapp') url = 'whatsapp://send?text=$encodedText';
    else if (platform == 'telegram') url = 'tg://msg?text=$encodedText';
    else if (platform == 'instagram') url = 'instagram://sharesheet?text=$encodedText'; // Mock deep link
    else if (platform == 'facebook') url = 'fb://facewebmodal/f?href=https://www.facebook.com/sharer/sharer.php?u=&quote=$encodedText';
    else if (platform == 'gmail') {
      final subject = Uri.encodeComponent('Hadis Hari Ini');
      url = 'mailto:?subject=$subject&body=$encodedText';
    }
    
    if (url.isNotEmpty) {
      final uri = Uri.parse(url);
      if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Tidak dapat membuka $platform')),
        );
      }
    }
  }

  Widget _buildActionItem(String label, IconData icon, {bool isGmail = false, VoidCallback? onTap}) {
    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 45,
            height: 45,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.grey[200]!),
            ),
            child: Icon(
              icon, 
              color: isGmail ? Colors.red : Colors.black54, 
              size: 20,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(fontSize: 11, color: Colors.black87),
          ),
        ],
      ),
    );
  }
}
