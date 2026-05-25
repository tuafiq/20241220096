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

  Future<TafsirDetailModel> getTafsirDetail(int nomor) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/tafsir/$nomor'));
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        return TafsirDetailModel.fromJson(data['data']);
      } else {
        throw Exception('Failed to load tafsir detail');
      }
    } catch (e) {
      throw Exception('Error fetching tafsir detail: $e');
    }
  }
}

class SurahDetailModel extends SurahModel {
  final List<AyatModel> ayat;
  final Map<String, String> audioFull;

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
    required this.audioFull,
  });

  factory SurahDetailModel.fromJson(Map<String, dynamic> json) {
    // API v2 return audioFull as a map, we take one (e.g., Al-Afasy) as default for the base model
    String audioUrl = '';
    Map<String, String> audioFullMap = {};
    if (json['audioFull'] != null && json['audioFull'] is Map) {
      audioFullMap = Map<String, String>.from(
          json['audioFull'].map((key, val) => MapEntry(key.toString(), val.toString())));
      audioUrl = audioFullMap['05'] ?? audioFullMap.values.first;
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
      audioFull: audioFullMap,
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

class TafsirDetailModel {
  final int nomor;
  final String nama;
  final String namaLatin;
  final int jumlahAyat;
  final String tempatTurun;
  final String arti;
  final String deskripsi;
  final List<TafsirAyatModel> tafsir;

  TafsirDetailModel({
    required this.nomor,
    required this.nama,
    required this.namaLatin,
    required this.jumlahAyat,
    required this.tempatTurun,
    required this.arti,
    required this.deskripsi,
    required this.tafsir,
  });

  factory TafsirDetailModel.fromJson(Map<String, dynamic> json) {
    return TafsirDetailModel(
      nomor: json['nomor'],
      nama: json['nama'],
      namaLatin: json['namaLatin'],
      jumlahAyat: json['jumlahAyat'],
      tempatTurun: json['tempatTurun'],
      arti: json['arti'],
      deskripsi: json['deskripsi'],
      tafsir: (json['tafsir'] as List)
          .map((t) => TafsirAyatModel.fromJson(t))
          .toList(),
    );
  }
}

class TafsirAyatModel {
  final int ayat;
  final String teks;

  TafsirAyatModel({
    required this.ayat,
    required this.teks,
  });

  factory TafsirAyatModel.fromJson(Map<String, dynamic> json) {
    return TafsirAyatModel(
      ayat: json['ayat'],
      teks: json['teks'],
    );
  }
}
