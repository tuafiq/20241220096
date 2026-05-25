import 'dart:convert';
import 'package:http/http.dart' as http;

void main() async {
  try {
    final response = await http.get(Uri.parse('https://equran.id/api/v2/surat/1'));
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      final surahData = data['data'];
      final List<dynamic> ayats = surahData['ayat'];
      for (int i = 0; i < ayats.length; i++) {
        final ayat = ayats[i];
        print('Ayat ${ayat['nomorAyat']}: audioMap = ${ayat['audio']}');
      }
    } else {
      print('HTTP Error: ${response.statusCode}');
    }
  } catch (e) {
    print('Error: $e');
  }
}
