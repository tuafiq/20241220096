import 'package:http/http.dart' as http;

void main() async {
  final qoriNames = [
    'Abdullah-Al-Juhany',
    'Abdul-Muhsin-Al-Qasim',
    'Abdurrahman-as-Sudais',
    'Ibrahim-Al-Dossari',
    'Misyari-Rasyid-Al-Afasi',
    'Yasser-Al-Dosari'
  ];

  for (final qori in qoriNames) {
    print('Testing Qori: $qori');
    for (int ayat = 1; ayat <= 7; ayat++) {
      final surahStr = '001';
      final ayatStr = ayat.toString().padLeft(3, '0');
      final url = 'https://cdn.equran.id/audio-partial/$qori/$surahStr$ayatStr.mp3';
      try {
        final res = await http.head(Uri.parse(url));
        print('  Ayat $ayat: ${res.statusCode} (${url})');
      } catch (e) {
        print('  Ayat $ayat: Error: $e');
      }
    }
  }
}
