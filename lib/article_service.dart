import 'dart:convert';
import 'package:http/http.dart' as http;
import 'article_model.dart';

class ArticleService {
  static const String baseUrl = 'https://artikel-islam.netlify.app/.netlify/functions/api';

  /// Fetch articles for a specific portal, with optional pagination and search query.
  Future<Map<String, dynamic>> getArticles(String portal, {int page = 1, String query = ''}) async {
    const int maxRetries = 2;
    const int retryDelaySeconds = 1;
    
    for (int attempt = 1; attempt <= maxRetries; attempt++) {
      try {
        final queryParams = <String, String>{
          'page': page.toString(),
        };
        if (query.trim().isNotEmpty) {
          queryParams['s'] = query.trim();
        }
        
        final uri = Uri.parse('$baseUrl/$portal').replace(queryParameters: queryParams);
        final response = await http.get(uri).timeout(const Duration(seconds: 25));

        if (response.statusCode == 200) {
          final body = json.decode(response.body);
          if (body['success'] == true && body['data'] != null) {
            final dataObj = body['data'];
            final List<dynamic> listData = dataObj['data'] ?? [];
            final List<Article> articles = listData.map((item) => Article.fromJson(item)).toList();
            
            // Get pagination total page
            int totalPages = 1;
            if (dataObj['pagination'] != null && dataObj['pagination']['total_page'] != null) {
              totalPages = int.tryParse(dataObj['pagination']['total_page'].toString()) ?? 1;
            }
            
            return {
              'articles': articles,
              'totalPages': totalPages,
              'success': true,
            };
          }
        }
        
        if (attempt == maxRetries) {
          return {
            'articles': _getDummyArticles(portal),
            'totalPages': 1,
            'success': true,
          };
        }
      } catch (e) {
        if (attempt == maxRetries) {
          return {
            'articles': _getDummyArticles(portal),
            'totalPages': 1,
            'success': true,
          };
        }
      }
      
      // Wait before retrying
      await Future.delayed(Duration(seconds: retryDelaySeconds * attempt));
    }
    
    return {
      'articles': _getDummyArticles(portal),
      'totalPages': 1,
      'success': true,
    };
  }

  List<Article> _getDummyArticles(String portal) {
    return [
      Article(
        id: 'dummy1',
        title: 'Keutamaan Menuntut Ilmu Agama',
        url: 'https://firanda.com',
        date: '2024-05-10',
        dateTime: '2024-05-10T08:00:00Z',
        author: 'Tim Redaksi',
        authorLink: '',
        type: portal,
        thumbnail: 'https://images.unsplash.com/photo-1609599006353-e629aaab315d?q=80&w=400&auto=format&fit=crop',
        categories: ['Kajian', 'Ilmu'],
      ),
      Article(
        id: 'dummy2',
        title: 'Adab Berdoa Agar Cepat Dikabulkan',
        url: 'https://konsultasisyariah.com',
        date: '2024-05-09',
        dateTime: '2024-05-09T08:00:00Z',
        author: 'Tim Redaksi',
        authorLink: '',
        type: portal,
        thumbnail: 'https://images.unsplash.com/photo-1596728045617-646cc55047b4?q=80&w=400&auto=format&fit=crop',
        categories: ['Doa', 'Adab'],
      ),
      Article(
        id: 'dummy3',
        title: 'Menjaga Hati dari Penyakit Hasad',
        url: 'https://firanda.com',
        date: '2024-05-08',
        dateTime: '2024-05-08T08:00:00Z',
        author: 'Tim Redaksi',
        authorLink: '',
        type: portal,
        thumbnail: 'https://images.unsplash.com/photo-1585036156171-384164a8c675?q=80&w=400&auto=format&fit=crop',
        categories: ['Akhlak', 'Hati'],
      ),
    ];
  }

  // Detail cache map to store loaded article details (HTML content, thumbnails, etc.)
  static final Map<String, Map<String, dynamic>> detailCache = {};

  /// Fetch details of a single article (including body html content).
  Future<Map<String, dynamic>?> getArticleDetail(String portal, String articleId) async {
    // Return cached value if exists
    if (detailCache.containsKey(articleId)) {
      return detailCache[articleId];
    }

    const int maxRetries = 2;
    for (int attempt = 1; attempt <= maxRetries; attempt++) {
      try {
        final url = '$baseUrl/$portal/detail/$articleId';
        final response = await http.get(Uri.parse(url)).timeout(const Duration(seconds: 25));

        if (response.statusCode == 200) {
          final body = json.decode(response.body);
          if (body['success'] == true && body['data'] != null) {
            final data = body['data'] as Map<String, dynamic>;
            detailCache[articleId] = data; // Save to cache
            return data;
          }
        }
      } catch (e) {
        if (attempt == maxRetries) {
          return {
            'title': 'Mode Offline (Server Gangguan)',
            'content': '<p>Mohon maaf, saat ini server penyedia artikel sedang mengalami gangguan (Status 500). Ini adalah artikel cadangan agar Anda tetap bisa melihat tampilan aplikasi.</p><br/><p>Semoga sistem API segera pulih kembali.</p>',
            'date': 'Hari ini',
            'author': 'Admin'
          };
        }
      }
      await Future.delayed(Duration(seconds: 1 * attempt));
    }
    return {
      'title': 'Mode Offline (Server Gangguan)',
      'content': '<p>Mohon maaf, saat ini server penyedia artikel sedang mengalami gangguan. Ini adalah artikel cadangan agar Anda tetap bisa melihat tampilan aplikasi.</p>',
      'date': 'Hari ini',
      'author': 'Admin'
    };
  }

  /// Compatibility wrapper for older code using getNews.
  Future<List<Article>> getNews(String portal, {String category = ''}) async {
    String effectivePortal = portal;
    if (portal == 'cnn-news' || portal == 'cnbc-news' || portal == 'antara-news' || portal == 'tempo-news' || portal == 'republika-news') {
      effectivePortal = 'ks';
    }
    
    final result = await getArticles(effectivePortal, page: 1);
    return result['articles'] ?? <Article>[];
  }

  /// Compatibility wrapper for older code using searchNews.
  Future<List<Article>> searchNews(String portal, String query) async {
    String effectivePortal = portal;
    if (portal == 'cnn-news' || portal == 'cnbc-news' || portal == 'antara-news' || portal == 'tempo-news' || portal == 'republika-news') {
      effectivePortal = 'ks';
    }
    
    final result = await getArticles(effectivePortal, page: 1, query: query);
    return result['articles'] ?? <Article>[];
  }
}
