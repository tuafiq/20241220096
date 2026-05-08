import 'dart:convert';
import 'package:http/http.dart' as http;
import 'holiday_model.dart';

class HolidayService {
  static const String baseUrl = 'https://api-hari-libur.vercel.app/api';

  Future<List<Holiday>> getHolidays(int year) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl?year=$year'));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        
        if (data['status'] == 'success' && data['data'] != null) {
          final List<dynamic> holidaysJson = data['data'];
          return holidaysJson.map((json) => Holiday.fromJson(json)).toList();
        }
      }
      return [];
    } catch (e) {
      // In a production app, we would log this error or show a message.
      print('Error fetching holidays: $e');
      return [];
    }
  }
}
