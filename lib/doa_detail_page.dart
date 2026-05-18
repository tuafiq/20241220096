import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'doa_data.dart';

class DoaDetailPage extends StatefulWidget {
  final DoaModel doa;
  final List<DoaModel> doaList;
  final int currentIndex;

  const DoaDetailPage({
    super.key,
    required this.doa,
    required this.doaList,
    required this.currentIndex,
  });

  @override
  State<DoaDetailPage> createState() => _DoaDetailPageState();
}

class _DoaDetailPageState extends State<DoaDetailPage> {
  late int _currentIndex;
  bool _isBookmarked = false;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.currentIndex;
  }

  DoaModel get _currentDoa => widget.doaList[_currentIndex];

  IconData _getIconForDoa(String title) {
    final t = title.toLowerCase();
    if (t.contains('kamar mandi') || t.contains('toilet') || t.contains('wc')) {
      return Icons.shower;
    } else if (t.contains('tidur')) {
      return Icons.nights_stay;
    } else if (t.contains('wudhu')) {
      return Icons.water_drop;
    } else if (t.contains('pakaian') || t.contains('baju')) {
      return Icons.checkroom;
    } else if (t.contains('masjid')) {
      return Icons.mosque;
    } else if (t.contains('makan') || t.contains('minum')) {
      return Icons.restaurant;
    } else if (t.contains('kendaraan') || t.contains('perjalanan') || t.contains('musafir')) {
      return Icons.directions_car;
    } else if (t.contains('ampun') || t.contains('tobat')) {
      return Icons.volunteer_activism;
    } else if (t.contains('lindung')) {
      return Icons.security;
    }
    return FontAwesomeIcons.handsPraying;
  }

  String _getSourceForDoa(String title) {
    final t = title.toLowerCase();
    if (t.contains('kamar mandi')) {
      return 'HR. Bukhari no. 142 dan Muslim no. 375';
    } else if (t.contains('keluar kamar mandi')) {
      return 'HR. Abu Dawud no. 30, Tirmidzi no. 7 dan Ibnu Majah no. 300';
    } else if (t.contains('sebelum tidur 1')) {
      return 'HR. Bukhari no. 6320 dan Muslim no. 2714';
    } else if (t.contains('sebelum tidur 2')) {
      return 'HR. Bukhari no. 6312 dan Muslim no. 2711';
    } else if (t.contains('bangun tidur 1')) {
      return 'HR. Bukhari no. 6312';
    } else if (t.contains('sebelum wudhu')) {
      return 'HR. Abu Dawud no. 101, Ibnu Majah no. 397';
    } else if (t.contains('setelah wudhu')) {
      return 'HR. Muslim no. 234';
    } else if (t.contains('mengenakan pakaian')) {
      return 'HR. Abu Dawud no. 4023 dan Tirmidzi no. 1767';
    } else if (t.contains('naik kendaraan')) {
      return 'HR. Abu Dawud no. 2599 dan Tirmidzi no. 3446';
    }
    return 'HR. Bukhari, Muslim, & Kitab Hisnul Muslim';
  }

  void _navigateTo(int index) {
    if (index >= 0 && index < widget.doaList.length) {
      setState(() {
        _currentIndex = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF13A884);
    final currentDoa = _currentDoa;
    final hasPrev = _currentIndex > 0;
    final hasNext = _currentIndex < widget.doaList.length - 1;

    final prevDoa = hasPrev ? widget.doaList[_currentIndex - 1] : null;
    final nextDoa = hasNext ? widget.doaList[_currentIndex + 1] : null;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7F8),
      appBar: AppBar(
        title: Text(
          currentDoa.title,
          style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 18),
        ),
        backgroundColor: primaryColor,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: Icon(
              _isBookmarked ? Icons.bookmark : Icons.bookmark_border_outlined,
              color: Colors.white,
            ),
            onPressed: () {
              setState(() {
                _isBookmarked = !_isBookmarked;
              });
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    _isBookmarked ? 'Doa disimpan ke favorit' : 'Doa dihapus dari favorit',
                  ),
                  duration: const Duration(seconds: 1),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () {},
          )
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // Header Card
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            color: const Color(0xFFE8F5F1),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Icon(
                            _getIconForDoa(currentDoa.title),
                            color: primaryColor,
                            size: 32,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                currentDoa.title,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF2D3436),
                                ),
                              ),
                              const SizedBox(height: 4),
                              const Text(
                                'Bacaan doa',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Content Card
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          currentDoa.arabic,
                          textAlign: TextAlign.right,
                          style: const TextStyle(
                            fontSize: 26,
                            height: 2.0,
                            color: Color(0xFF13A884),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          currentDoa.transliteration,
                          style: const TextStyle(
                            fontSize: 14,
                            fontStyle: FontStyle.italic,
                            color: Color(0xFF636E72),
                            height: 1.5,
                          ),
                        ),
                        const SizedBox(height: 16),
                        const Divider(),
                        const SizedBox(height: 16),
                        const Text(
                          'Artinya:',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF2D3436),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          currentDoa.translation,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Color(0xFF2D3436),
                            height: 1.5,
                          ),
                        ),
                        const SizedBox(height: 24),

                        // Sumber Box
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF0F9F6),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: const [
                                  Icon(Icons.menu_book, color: primaryColor, size: 20),
                                  SizedBox(width: 8),
                                  Text(
                                    'Sumber',
                                    style: TextStyle(
                                      color: primaryColor,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Padding(
                                padding: const EdgeInsets.only(left: 28),
                                child: Text(
                                  _getSourceForDoa(currentDoa.title),
                                  style: const TextStyle(
                                    color: Colors.grey,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),

                        // Actions Row
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            _buildActionButton(
                              icon: Icons.share_outlined,
                              label: 'Bagikan',
                              onTap: () {
                                Share.share('${currentDoa.title}\n\n${currentDoa.arabic}\n\n${currentDoa.transliteration}\n\nArtinya:\n${currentDoa.translation}');
                              },
                            ),

                            _buildActionButton(
                              icon: Icons.copy_outlined,
                              label: 'Salin',
                              onTap: () {
                                Clipboard.setData(ClipboardData(
                                  text: '${currentDoa.title}\n\n${currentDoa.arabic}\n\n${currentDoa.transliteration}\n\nArtinya:\n${currentDoa.translation}',
                                ));
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Teks disalin ke clipboard')),
                                );
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Bottom Navigation Card
          Container(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            decoration: const BoxDecoration(
              color: Colors.white,
              border: Border(
                top: BorderSide(color: Color(0xFFE8F5F1), width: 1),
              ),
            ),
            child: SafeArea(
              child: Row(
                children: [
                  // Prev Button
                  Expanded(
                    child: InkWell(
                      onTap: hasPrev ? () => _navigateTo(_currentIndex - 1) : null,
                      child: Opacity(
                        opacity: hasPrev ? 1.0 : 0.3,
                        child: Row(
                          children: [
                            const Icon(Icons.chevron_left, color: primaryColor, size: 28),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Text(
                                    'Doa Sebelumnya',
                                    style: TextStyle(
                                      color: primaryColor,
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    prevDoa?.title ?? '-',
                                    style: const TextStyle(
                                      color: Colors.grey,
                                      fontSize: 11,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  // Divider
                  Container(
                    height: 30,
                    width: 1,
                    color: const Color(0xFFE8F5F1),
                  ),
                  const SizedBox(width: 12),

                  // Next Button
                  Expanded(
                    child: InkWell(
                      onTap: hasNext ? () => _navigateTo(_currentIndex + 1) : null,
                      child: Opacity(
                        opacity: hasNext ? 1.0 : 0.3,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Text(
                                    'Doa Selanjutnya',
                                    style: TextStyle(
                                      color: primaryColor,
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    nextDoa?.title ?? '-',
                                    style: const TextStyle(
                                      color: Colors.grey,
                                      fontSize: 11,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 4),
                            const Icon(Icons.chevron_right, color: primaryColor, size: 28),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({required IconData icon, required String label, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Icon(icon, color: const Color(0xFF13A884), size: 24),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(
              color: Color(0xFF13A884),
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }


}
