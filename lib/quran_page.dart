import 'package:flutter/material.dart';
import 'quran_data.dart';
import 'quran_service.dart';
import 'surah_detail_page.dart';

class QuranPage extends StatefulWidget {
  final bool useApi;
  const QuranPage({super.key, this.useApi = false});

  @override
  State<QuranPage> createState() => _QuranPageState();
}

class _QuranPageState extends State<QuranPage> {
  List<SurahModel> _surahs = [];
  bool _isLoading = false;
  String _errorMessage = '';
  String _searchQuery = '';
  final QuranService _quranService = QuranService();

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    if (!widget.useApi) {
      setState(() {
        _surahs = QuranData.listSurah;
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      final surahs = await _quranService.getSurahList();
      if (mounted) {
        setState(() {
          _surahs = surahs;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = e.toString();
          _isLoading = false;
        });
      }
    }
  }

  void _onSearch(String query) {
    setState(() {
      _searchQuery = query;
      final source = widget.useApi ? _surahs : QuranData.listSurah;
      // We don't want to overwrite _surahs if we are using API because we need the full list to search.
      // But for local data, it's fine.
      // Better approach: filter the list used in ListView.
    });
  }

  List<SurahModel> get _filteredSurahs {
    final list = widget.useApi ? _surahs : QuranData.listSurah;
    if (_searchQuery.isEmpty) return list;
    return list
        .where((surah) =>
            surah.namaLatin.toLowerCase().contains(_searchQuery.toLowerCase()) ||
            surah.nama.contains(_searchQuery))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final filteredSurahs = _filteredSurahs;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          widget.useApi ? 'Al-Quran (API)' : 'Al-Quran',
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color(0xFF13A884),
        elevation: 0,
        centerTitle: true,
      ),
      body: Column(
        children: [
          _buildSearchBox(),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator(color: Color(0xFF13A884)))
                : _errorMessage.isNotEmpty
                    ? _buildErrorState()
                    : filteredSurahs.isEmpty
                        ? _buildEmptyState()
                        : ListView.separated(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            itemCount: filteredSurahs.length,
                            separatorBuilder: (context, index) => Divider(
                              color: Colors.grey[200],
                              height: 1,
                              indent: 75,
                            ),
                            itemBuilder: (context, index) {
                              return _buildSurahItem(filteredSurahs[index]);
                            },
                          ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 80, color: Colors.redAccent),
          const SizedBox(height: 16),
          Text(
            'Gagal mengambil data',
            style: TextStyle(color: Colors.grey[800], fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Text(
              _errorMessage,
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey[600], fontSize: 14),
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: _fetchData,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF13A884),
              foregroundColor: Colors.white,
            ),
            child: const Text('Coba Lagi'),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBox() {
    return Container(
      padding: const EdgeInsets.all(16),
      color: const Color(0xFF13A884),
      child: TextField(
        onChanged: _onSearch,
        style: const TextStyle(color: Colors.black87),
        decoration: InputDecoration(
          hintText: 'Cari Surah...',
          hintStyle: TextStyle(color: Colors.grey[500]),
          prefixIcon: const Icon(Icons.search, color: Color(0xFF13A884)),
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.symmetric(vertical: 0),
        ),
      ),
    );
  }

  Widget _buildSurahItem(SurahModel surah) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
      leading: Container(
        width: 45,
        height: 45,
        decoration: BoxDecoration(
          color: const Color(0xFF13A884).withOpacity(0.1),
          shape: BoxShape.circle,
        ),
        child: Center(
          child: Text(
            '${surah.nomor}',
            style: const TextStyle(
              color: Color(0xFF13A884),
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),
      ),
      title: Text(
        surah.namaLatin,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 17,
          color: Colors.black87,
        ),
      ),
      subtitle: Text(
        '${surah.tempatTurun.toUpperCase()} • ${surah.jumlahAyat} AYAT',
        style: TextStyle(
          color: Colors.grey[600],
          fontSize: 12,
          letterSpacing: 0.5,
        ),
      ),
      trailing: Text(
        surah.nama,
        style: const TextStyle(
          fontSize: 22,
          fontFamily: 'Amiri', // Optional: Use a nice Arabic font if available
          color: Color(0xFF13A884),
          fontWeight: FontWeight.bold,
        ),
      ),
      onTap: () {
        if (widget.useApi) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SurahDetailPage(nomor: surah.nomor),
            ),
          );
        } else {
          _showSurahInfo(surah);
        }
      },
    );
  }

  void _showSurahInfo(SurahModel surah) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(24),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                surah.namaLatin,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF13A884),
                ),
              ),
              Text(
                '(${surah.arti})',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                  fontStyle: FontStyle.italic,
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildInfoBadge(surah.tempatTurun.toUpperCase()),
                  const SizedBox(width: 12),
                  _buildInfoBadge('${surah.jumlahAyat} AYAT'),
                ],
              ),
              const SizedBox(height: 24),
              const Divider(),
              const SizedBox(height: 16),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Deskripsi:',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.black87,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Flexible(
                child: SingleChildScrollView(
                  child: Text(
                    surah.deskripsi.replaceAll(RegExp(r'<[^>]*>'), ''), // Strip HTML tags
                    textAlign: TextAlign.justify,
                    style: const TextStyle(
                      fontSize: 14,
                      height: 1.5,
                      color: Colors.black87,
                    ),
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
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Tutup',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }

  Widget _buildInfoBadge(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFF13A884).withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFF13A884).withOpacity(0.3)),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: Color(0xFF13A884),
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search_off, size: 80, color: Colors.grey[300]),
          const SizedBox(height: 16),
          Text(
            'Surah tidak ditemukan',
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
