import 'dart:convert';
import 'package:http/http.dart' as http;
import 'quran_data.dart';

class QuranService {
  static const String baseUrl = 'https://equran.id/api/v2';

  Future<List<SurahModel>> getSurahList() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/surat'));
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final List<dynamic> surahsJson = data['data'];
        return surahsJson.map((json) => SurahModel.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load surah list');
      }
    } catch (e) {
      throw Exception('Error fetching surah list: $e');
    }
  }

  Future<SurahDetailModel> getSurahDetail(int nomor) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/surat/$nomor'));
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        return SurahDetailModel.fromJson(data['data']);
      } else {
        throw Exception('Failed to load surah detail');
      }
    } catch (e) {
      throw Exception('Error fetching surah detail: $e');
    }
  }
}

class SurahDetailModel extends SurahModel {
  final List<AyatModel> ayat;

  SurahDetailModel({
    required super.nomor,
    required super.nama,
    required super.namaLatin,
    required super.jumlahAyat,
    required super.tempatTurun,
    required super.arti,
    required super.deskripsi,
    required super.audio,
    required this.ayat,
  });

  factory SurahDetailModel.fromJson(Map<String, dynamic> json) {
    // API v2 return audioFull as a map, we take one (e.g., Al-Afasy) as default for the base model
    String audioUrl = '';
    if (json['audioFull'] != null && json['audioFull'] is Map) {
      audioUrl = json['audioFull']['05'] ?? json['audioFull'].values.first;
    }

    return SurahDetailModel(
      nomor: json['nomor'],
      nama: json['nama'],
      namaLatin: json['namaLatin'],
      jumlahAyat: json['jumlahAyat'],
      tempatTurun: json['tempatTurun'],
      arti: json['arti'],
      deskripsi: json['deskripsi'],
      audio: audioUrl,
      ayat: (json['ayat'] as List).map((a) => AyatModel.fromJson(a)).toList(),
    );
  }
}

class AyatModel {
  final int nomorAyat;
  final String teksArab;
  final String teksLatin;
  final String teksIndonesia;
  final Map<String, String> audio;

  AyatModel({
    required this.nomorAyat,
    required this.teksArab,
    required this.teksLatin,
    required this.teksIndonesia,
    required this.audio,
  });

  factory AyatModel.fromJson(Map<String, dynamic> json) {
    return AyatModel(
      nomorAyat: json['nomorAyat'],
      teksArab: json['teksArab'],
      teksLatin: json['teksLatin'],
      teksIndonesia: json['teksIndonesia'],
      audio: Map<String, String>.from(json['audio']),
    );
  }
}
