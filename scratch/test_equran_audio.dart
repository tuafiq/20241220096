import 'dart:convert';
import 'package:http/http.dart' as http;

void main() async {
  try {
    final response = await http.get(Uri.parse('https://equran.id/api/v2/surat/1'));
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      final surahData = data['data'];
      print('Surah: ${surahData['namaLatin']}');
      print('audioFull: ${surahData['audioFull']}');
      final firstAyat = surahData['ayat'][0];
      print('First Ayat Audio Map: ${firstAyat['audio']}');
    } else {
      print('HTTP Error: ${response.statusCode}');
    }
  } catch (e) {
    print('Error: $e');
  }
}
