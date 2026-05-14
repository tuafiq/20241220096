import 'package:flutter/material.dart';
import 'hadith_service.dart';
import 'hadith_list_page.dart';
import 'dart:math';

class NotificationHadithPage extends StatefulWidget {
  const NotificationHadithPage({super.key});

  @override
  State<NotificationHadithPage> createState() => _NotificationHadithPageState();
}

class _NotificationHadithPageState extends State<NotificationHadithPage> {
  final HadithService _hadithService = HadithService();
  Map<String, dynamic>? _dailyHadith;
  bool _isLoading = true;
  String _narratorName = '';
  String _narratorId = '';

  @override
  void initState() {
    super.initState();
    _fetchRandomHadith();
  }

  Future<void> _fetchRandomHadith() async {
    setState(() => _isLoading = true);
    
    final List<Map<String, String>> narrators = [
      {'id': 'bukhari', 'name': 'Shahih Bukhari'},
      {'id': 'muslim', 'name': 'Shahih Muslim'},
      {'id': 'abu-daud', 'name': 'Sunan Abu Daud'},
      {'id': 'tirmidzi', 'name': 'Jami\' At-Tirmidzi'},
      {'id': 'nasai', 'name': 'Sunan An-Nasa\'i'},
      {'id': 'ibnu-majah', 'name': 'Sunan Ibnu Majah'},
    ];

    final randomNarrator = narrators[Random().nextInt(narrators.length)];
    _narratorId = randomNarrator['id']!;
    _narratorName = randomNarrator['name']!;
    
    final randomNum = Random().nextInt(50) + 1;
    final result = await _hadithService.getHadithDetail(_narratorId, randomNum);

    if (mounted) {
      setState(() {
        _dailyHadith = result;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    const primaryGreen = Color(0xFF0C5441);

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF0C5441),
              Color(0xFF083A2D),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Custom App Bar
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const Expanded(
                      child: Center(
                        child: Text(
                          'Notifikasi Hadis Hari Ini',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.refresh, color: Colors.white),
                      onPressed: _fetchRandomHadith,
                    ),
                  ],
                ),
              ),

              const Spacer(),

              // Notification Card
              _isLoading 
              ? const Center(child: CircularProgressIndicator(color: Colors.white))
              : Center(
                child: Container(
                  constraints: BoxConstraints(
                    maxHeight: MediaQuery.of(context).size.height * 0.75,
                  ),
                  margin: const EdgeInsets.symmetric(horizontal: 24),
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: SingleChildScrollView(
                    child: InkWell(
                      onTap: _navigateToDetail,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // App info row
                          Row(
                            children: [
                              Container(
                                width: 32,
                                height: 32,
                                decoration: BoxDecoration(
                                  color: const Color(0xFF13A884),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Icon(Icons.menu_book, color: Colors.white, size: 18),
                              ),
                              const SizedBox(width: 12),
                              const Text(
                                'Aplikasi Hadis Digital',
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const Spacer(),
                              const Text(
                                '08.00',
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 24),
                          
                          const Text(
                            'Hadis Hari Ini',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(height: 24),
                          
                          // Arabic text
                          Text(
                            _dailyHadith?['contents']?['arab'] ?? '...',
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              height: 1.8,
                              fontFamily: 'Amiri',
                              color: Colors.black,
                            ),
                            textDirection: TextDirection.rtl,
                          ),
                          const SizedBox(height: 24),
                          
                          // Translation
                          Text(
                            _dailyHadith?['contents']?['id'] ?? 'Memuat...',
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.black87,
                              height: 1.5,
                            ),
                          ),
                          const SizedBox(height: 16),
                          
                          // Source
                          Text(
                            '- $_narratorName (No. ${_dailyHadith?['contents']?['number'] ?? '?'})',
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 13,
                              color: Colors.grey,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                          const SizedBox(height: 32),
                          
                          // Button
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF0C5441),
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                elevation: 0,
                              ),
                              onPressed: _navigateToDetail,
                              child: const Text(
                                'Baca Sekarang',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              const Spacer(flex: 2),
            ],
          ),
        ),
      ),
    );
  }

  void _navigateToDetail() {
    if (_dailyHadith != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => HadithDetailPage(
            hadith: _dailyHadith!['contents'],
            narratorId: _narratorId,
            narratorName: _narratorName,
          ),
        ),
      );
    }
  }
}
