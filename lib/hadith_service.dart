import 'dart:convert';
import 'package:http/http.dart' as http;

class HadithService {
  final String baseUrl = 'https://api.hadith.gading.dev';

  Future<List<dynamic>> getHadithsByNarrator(String perawi, {int start = 1, int end = 20}) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/books/$perawi?range=$start-$end'));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['data']['hadiths'] ?? [];
      }
      return [];
    } catch (e) {
      print('Error fetching hadiths: $e');
      return [];
    }
  }

  Future<Map<String, dynamic>?> getHadithDetail(String perawi, int nomor) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/books/$perawi/$nomor'));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['data'];
      }
      return null;
    } catch (e) {
      print('Error fetching specific hadith: $e');
      return null;
    }
  }
}

class BookmarkManager {
  static final BookmarkManager _instance = BookmarkManager._internal();
  factory BookmarkManager() => _instance;
  BookmarkManager._internal();

  final List<Map<String, dynamic>> _bookmarks = [];
  
  List<Map<String, dynamic>> get bookmarks => List.unmodifiable(_bookmarks);

  void addHadithBookmark(Map<String, dynamic> hadith, String narratorId, String narratorName) {
    final exists = _bookmarks.any((b) => 
      b['type'] == 'Hadis' &&
      b['narratorId'] == narratorId && 
      b['hadith']['number'] == hadith['number']
    );
    
    if (!exists) {
      _bookmarks.add({
        'id': DateTime.now().millisecondsSinceEpoch,
        'narrator': narratorName,
        'narratorId': narratorId,
        'detail': 'No. ${hadith['number']}',
        'type': 'Hadis',
        'hadith': hadith,
        'isStarred': true,
      });
    }
  }

  void addBabBookmark(Map<String, dynamic> narrator) {
    final exists = _bookmarks.any((b) => 
      b['type'] == 'Bab' &&
      b['narratorId'] == narrator['id']
    );
    
    if (!exists) {
      _bookmarks.add({
        'id': DateTime.now().millisecondsSinceEpoch,
        'narrator': narrator['name'],
        'narratorId': narrator['id'],
        'detail': narrator['count'],
        'type': 'Bab',
        'narratorData': narrator,
        'isStarred': true,
      });
    }
  }

  void removeBookmark(String narratorId, {int? number}) {
    if (number != null) {
      _bookmarks.removeWhere((b) => 
        b['type'] == 'Hadis' &&
        b['narratorId'] == narratorId && 
        b['hadith']['number'] == number
      );
    } else {
      _bookmarks.removeWhere((b) => 
        b['type'] == 'Bab' &&
        b['narratorId'] == narratorId
      );
    }
  }

  void clearBookmarks() {
    _bookmarks.clear();
  }

  bool isHadithBookmarked(String narratorId, int number) {
    return _bookmarks.any((b) => 
      b['type'] == 'Hadis' &&
      b['narratorId'] == narratorId && 
      b['hadith']['number'] == number
    );
  }

  bool isBabBookmarked(String narratorId) {
    return _bookmarks.any((b) => 
      b['type'] == 'Bab' &&
      b['narratorId'] == narratorId
    );
  }
}
