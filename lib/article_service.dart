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
            'articles': <Article>[],
            'totalPages': 1,
            'success': false,
            'error': 'Gagal memuat artikel: Status Code ${response.statusCode}'
          };
        }
      } catch (e) {
        if (attempt == maxRetries) {
          String errorMsg = e.toString();
          if (errorMsg.contains('TimeoutException')) {
            errorMsg = 'Koneksi lambat / Timeout (25 detik)';
          } else if (errorMsg.contains('SocketException')) {
            errorMsg = 'Tidak ada koneksi internet';
          }
          return {
            'articles': <Article>[],
            'totalPages': 1,
            'success': false,
            'error': 'Gagal memuat artikel: $errorMsg'
          };
        }
      }
      
      // Wait before retrying
      await Future.delayed(Duration(seconds: retryDelaySeconds * attempt));
    }
    
    return {
      'articles': <Article>[],
      'totalPages': 1,
      'success': false,
      'error': 'Gagal memuat artikel setelah beberapa percobaan'
    };
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
          return null;
        }
      }
      await Future.delayed(Duration(seconds: 1 * attempt));
    }
    return null;
  }

  /// Compatibility wrapper for older code using getNews.
  Future<List<Article>> getNews(String portal, {String category = ''}) async {
    String effectivePortal = portal;
    if (portal == 'cnn-news' || portal == 'cnbc-news' || portal == 'antara-news' || portal == 'tempo-news' || portal == 'republika-news') {
      effectivePortal = 'fir'; // Default to Firanda.com
    }
    
    final result = await getArticles(effectivePortal, page: 1);
    return result['articles'] ?? <Article>[];
  }

  /// Compatibility wrapper for older code using searchNews.
  Future<List<Article>> searchNews(String portal, String query) async {
    String effectivePortal = portal;
    if (portal == 'cnn-news' || portal == 'cnbc-news' || portal == 'antara-news' || portal == 'tempo-news' || portal == 'republika-news') {
      effectivePortal = 'fir';
    }
    
    final result = await getArticles(effectivePortal, page: 1, query: query);
    return result['articles'] ?? <Article>[];
  }
}
