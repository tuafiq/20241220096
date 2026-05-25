import 'dart:convert';
import 'package:http/http.dart' as http;

void main() async {
  try {
    final response = await http.get(Uri.parse('https://equran.id/api/v2/surat/1'));
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      final surah = data['data'];
      print('=== SURAH AUDIO FULL ===');
      print(surah['audioFull']);
      print('=== AYAT AUDIO ===');
      final firstAyat = surah['ayat'][0];
      print(firstAyat['audio']);
    } else {
      print('Failed: ${response.statusCode}');
    }
  } catch (e) {
    print('Error: $e');
  }
}
