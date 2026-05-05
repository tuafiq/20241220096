import 'dart:convert';
import 'package:http/http.dart' as http;

class PrayerService {
  static const String baseUrl = 'https://equran.id/api/v2/shalat';

  Future<List<String>> getProvinces() async {
    final response = await http.get(Uri.parse('$baseUrl/provinsi'));
    if (response.statusCode == 200) {
      final body = json.decode(response.body);
      return List<String>.from(body['data']);
    } else {
      throw Exception('Failed to load provinces');
    }
  }

  Future<List<String>> getCities(String province) async {
    final response = await http.post(
      Uri.parse('$baseUrl/kabkota'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'provinsi': province}),
    );
    if (response.statusCode == 200) {
      final body = json.decode(response.body);
      return List<String>.from(body['data']);
    } else {
      throw Exception('Failed to load cities');
    }
  }

  Future<Map<String, dynamic>> getMonthlySchedule({
    required String province,
    required String city,
    int? month,
    int? year,
  }) async {
    final now = DateTime.now();
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'provinsi': province,
        'kabkota': city,
        'bulan': month ?? now.month,
        'tahun': year ?? now.year,
      }),
    );
    if (response.statusCode == 200) {
      final body = json.decode(response.body);
      return body['data'];
    } else {
      throw Exception('Failed to load prayer schedule');
    }
  }
}
