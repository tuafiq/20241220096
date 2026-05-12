import 'dart:convert';
import 'package:http/http.dart' as http;
import 'article_model.dart';

class ArticleService {
  // Update to use /api instead of /v1
  static const String baseUrl = 'https://berita-indo-api-next.vercel.app/api';

  Future<List<Article>> getNews(String portal, {String category = ''}) async {
    try {
      String effectiveCategory = category;
      if (portal == 'antara-news' && effectiveCategory.isEmpty) {
        effectiveCategory = 'terkini';
      }
      if (portal == 'tempo-news' && effectiveCategory.isEmpty) {
        effectiveCategory = 'nasional';
      }
      if (portal == 'republika-news' && effectiveCategory.isEmpty) {
        effectiveCategory = 'news';
      }

      String url = '$baseUrl/$portal/';
      if (effectiveCategory.isNotEmpty) {
        url = '$baseUrl/$portal/$effectiveCategory';
      }
      
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final body = json.decode(response.body);
        // The API response doesn't have 'success: true', it has 'data'
        if (body['data'] != null) {
          final List<dynamic> data = body['data'];
          return data.map((item) => Article.fromJson(item)).toList();
        }
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  Future<List<Article>> searchNews(String portal, String query) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/$portal/?search=$query'));

      if (response.statusCode == 200) {
        final body = json.decode(response.body);
        if (body['data'] != null) {
          final List<dynamic> data = body['data'];
          return data.map((item) => Article.fromJson(item)).toList();
        }
      }
      return [];
    } catch (e) {
      return [];
    }
  }
}
