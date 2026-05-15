import 'dart:convert';
import 'package:http/http.dart' as http;
import 'tutorial_model.dart';

class TutorialService {
  static const String niatUrl = 'https://raw.githubusercontent.com/AzharRivaldi/Bacaan-Sholat-Flutter/main/assets/data/niatshalat.json';
  static const String bacaanUrl = 'https://raw.githubusercontent.com/AzharRivaldi/Bacaan-Sholat-Flutter/main/assets/data/bacaanshalat.json';

  Future<List<TutorialModel>> getNiatSholat() async {
    try {
      final response = await http.get(Uri.parse(niatUrl));
      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        return data.map((json) => TutorialModel.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load niat sholat');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<List<TutorialModel>> getBacaanSholat() async {
    try {
      final response = await http.get(Uri.parse(bacaanUrl));
      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        return data.map((json) => TutorialModel.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load bacaan sholat');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<List<TutorialModel>> getAyatKursi() async {
    // Data Ayat Kursi diambil dari source code AzharRivaldi
    return [
      TutorialModel(
        id: 1,
        name: "Ayat Kursi",
        arabic: "اَللّٰهُ لَآ اِلٰهَ اِلَّا هُوَۚ اَلْحَيُّ الْقَيُّوْمُ ەۚ لَا تَأْخُذُهٗ سِنَةٌ وَّلَا نَوْمٌۗ لَهٗ مَا فِى السَّمٰوٰتِ وَمَا فِى الْاَرْضِۗ مَنْ ذَا الَّذِيْ يَشْفَعُ عِنْدَهٗٓ اِلَّا بِاِذْنِهٖۗ يَعْلَمُ مَا بَيْنَ اَيْدِيْهِمْ وَمَا خَلْفَهُمْۚ وَلَا يُحِيْطُوْنَ بِشَيْءٍ مِّنْ عِلْمِهٖٓ اِلَّا بِمَا شَاۤءَۚ وَسِعَ كُرْسِيُّهُ السَّمٰوٰتِ وَالْاَرْضَۚ وَلَا يَـُٔوْدُهٗ حِفْظُهُمَاۚ وَهُوَ الْعَلِيُّ الْعَظِيْمُ",
        latin: "Allaahu laa ilaaha illaa huwal hayyul qoyyuum, laa ta’khudzuhuu sinatuw walaa naum. Lahuu maa fissamaawaati wa maa fil ardli man dzal ladzii yasyfa’u ‘indahuu illaa biidznih, ya’lamu maa baina aidiihim wamaa kholfahum wa laa yuhiithuuna bisyai’im min ‘ilmihii illaa bimaa syaa’ wasi’a kursiyyuhus samaawaati wal ardlo walaa ya’uuduhuu hifdhuhumaa wahuwal ‘aliyyul ‘adhiim.",
        terjemahan: "Allah, tidak ada tuhan selain Dia. Yang Mahahidup, Yang terus menerus mengurus (makhluk-Nya), tidak mengantuk dan tidak tidur. Milik-Nya apa yang ada di langit dan apa yang ada di bumi. Tidak ada yang dapat memberi syafaat di sisi-Nya tanpa izin-Nya. Dia mengetahui apa yang di hadapan mereka dan apa yang di belakang mereka, dan mereka tidak mengetahui sesuatu apa pun tentang ilmu-Nya melainkan apa yang Dia kehendaki. Kursi-Nya meliputi langit dan bumi. Dan Dia tidak merasa berat memelihara keduanya, dan Dia Mahatinggi, Mahabesar."
      )
    ];
  }
}
