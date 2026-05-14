import 'package:flutter/material.dart';
import 'hadith_list_page.dart';

class HadithSearchResultsPage extends StatelessWidget {
  final String query;

  const HadithSearchResultsPage({super.key, required this.query});

  @override
  Widget build(BuildContext context) {
    const primaryGreen = Color(0xFF13A884);

    // Mock search results matching the screenshot
    final List<Map<String, dynamic>> results = [
      {
        'id': 'tirmidzi',
        'name': 'Jami\' At-Tirmidzi',
        'detail': 'Kitab Shalat - No. 3',
        'snippet': 'Kunci shalat adalah bersuci, membukanya...',
        'number': 3,
        'arab': 'مِفْتَاحُ الصَّلَاةِ الطُّهُورُ وَتَحْرِيمُهَا التَّكْبِيرُ وَتَحْلِيلُهَا التَّسْلِيمُ',
      },
      {
        'id': 'nasai',
        'name': 'Sunan An-Nasa\'i',
        'detail': 'Kitab Shalat - No. 15',
        'snippet': 'Tidak sah shalat seseorang tanpa bersuci.',
        'number': 15,
        'arab': 'لَا تُقْبَلُ صَلَاةٌ بِغَيْرِ طُهُورٍ',
      },
      {
        'id': 'ibnumajah',
        'name': 'Sunan Ibnu Majah',
        'detail': 'Kitab Zakat - No. 7',
        'snippet': 'Bersuci adalah kunci dari shalat.',
        'number': 7,
        'arab': 'الظُّهُورُ شَطْرُ الْإِيمَانِ وَالصَّلَاةُ نُورٌ',
      },
      {
        'id': 'darimi',
        'name': 'Sunan Ad-Darimi',
        'detail': 'Kitab Shalat - No. 9',
        'snippet': 'Takbir adalah pembuka shalat.',
        'number': 9,
        'arab': 'تَحْرِيمُهَا التَّكْبِيرُ وَتَحْلِيلُهَا التَّسْلِيمُ',
      },
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0C5441),
        elevation: 0,
        title: const Text('Hasil Pencarian', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(icon: const Icon(Icons.search, color: Colors.white), onPressed: () {}),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: TextField(
              controller: TextEditingController(text: query),
              decoration: InputDecoration(
                suffixIcon: const Icon(Icons.search, color: Colors.grey),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey[200]!),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey[200]!),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              'Ditemukan ${results.length} hasil',
              style: TextStyle(color: Colors.grey[600], fontSize: 14),
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: results.length,
              itemBuilder: (context, index) {
                final item = results[index];
                return _buildResultCard(context, item, index + 1);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResultCard(BuildContext context, Map<String, dynamic> item, int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ListTile(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => HadithDetailPage(
                hadith: {
                  'number': item['number'],
                  'arab': item['arab'],
                  'id': item['snippet'],
                  'name': item['name'],
                },
                narratorId: item['id'],
                narratorName: item['name'],
              ),
            ),
          );
        },
        contentPadding: const EdgeInsets.all(16),
        leading: Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: const Color(0xFF0C5441),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Center(
            child: Text(
              '$index',
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
            ),
          ),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              item['name'],
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
            ),
            const SizedBox(height: 2),
            Text(
              item['detail'],
              style: TextStyle(color: Colors.grey[600], fontSize: 13),
            ),
          ],
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 8),
          child: Text(
            item['snippet'],
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(color: Colors.grey[600], fontSize: 13),
          ),
        ),
      ),
    );
  }
}
