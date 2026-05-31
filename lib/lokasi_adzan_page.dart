import 'dart:async';
import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'settings_provider.dart';
import 'package:intl/intl.dart';
import 'package:hijri/hijri_calendar.dart';
import 'city_data.dart'; // Ensure city_data is accessible

class LokasiAdzanPage extends StatefulWidget {
  const LokasiAdzanPage({super.key});

  @override
  State<LokasiAdzanPage> createState() => _LokasiAdzanPageState();
}

class _LokasiAdzanPageState extends State<LokasiAdzanPage> {
  Timer? _timer;
  DateTime _currentTime = DateTime.now();
  String _nextPrayerName = 'Subuh';
  String _nextPrayerTimeStr = '00:00';
  Duration _timeUntilNextPrayer = Duration.zero;
  Map<String, String> _todaySchedule = {};
  DateTime? _lastFetchDate;
  
  // Audio Adzan options
  final List<String> _adzanOptions = [
    'Makkah',
    'Madinah',
    'Al-Aqsa',
    'Indonesia (Standar)',
  ];

  @override
  void initState() {
    super.initState();
    final settings = Provider.of<SettingsProvider>(context, listen: false);
    _fetchPrayerTimes(settings.currentLocation);
    
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _updateTime();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _updateTime() {
    final now = DateTime.now();
    final settings = Provider.of<SettingsProvider>(context, listen: false);
    
    if (_lastFetchDate != null && 
        (now.day != _lastFetchDate!.day || now.month != _lastFetchDate!.month || now.year != _lastFetchDate!.year)) {
      _fetchPrayerTimes(settings.currentLocation);
    }
    _lastFetchDate = now;
    
    final schedule = <String, DateTime>{};
    _todaySchedule.forEach((key, value) {
      try {
        final parts = value.split(':');
        schedule[key] = DateTime(
          now.year,
          now.month,
          now.day,
          int.parse(parts[0]),
          int.parse(parts[1]),
        );
      } catch (e) {
        // Fallback
      }
    });

    if (schedule.isEmpty) return;

    String nextName = 'Subuh';
    DateTime nextTime = schedule['Subuh']!.add(const Duration(days: 1)); 

    for (var entry in schedule.entries) {
      if (now.isBefore(entry.value)) {
        nextName = entry.key;
        nextTime = entry.value;
        break;
      }
    }

    if (mounted) {
      setState(() {
        _currentTime = now;
        _nextPrayerName = nextName;
        _nextPrayerTimeStr = '${nextTime.hour.toString().padLeft(2, '0')}:${nextTime.minute.toString().padLeft(2, '0')}';
        _timeUntilNextPrayer = nextTime.difference(now);
      });
    }
  }

  Future<void> _fetchPrayerTimes(String location) async {
    try {
      String cityName = location.contains(',') ? location.split(',').last.trim() : location;
      cityName = cityName.replaceAll('Kabupaten ', '').replaceAll('Kota ', '').trim();
      
      final searchUrl = Uri.parse('https://api.myquran.com/v2/sholat/kota/cari/$cityName');
      final searchResponse = await http.get(searchUrl);
      
      if (searchResponse.statusCode == 200) {
        final searchData = json.decode(searchResponse.body);
        if (searchData['status'] == true && (searchData['data'] as List).isNotEmpty) {
          final cityId = searchData['data'][0]['id'];
          
          final now = DateTime.now();
          final scheduleUrl = Uri.parse('https://api.myquran.com/v2/sholat/jadwal/$cityId/${now.year}/${now.month}/${now.day}');
          final scheduleResponse = await http.get(scheduleUrl);
          
          if (scheduleResponse.statusCode == 200) {
            final scheduleData = json.decode(scheduleResponse.body);
            if (scheduleData['status'] == true) {
              final jadwal = scheduleData['data']['jadwal'];
              if (mounted) {
                setState(() {
                  _todaySchedule = {
                    'Subuh': jadwal['subuh'],
                    'Dzuhur': jadwal['dzuhur'],
                    'Ashar': jadwal['ashar'],
                    'Maghrib': jadwal['maghrib'],
                    'Isya': jadwal['isya'],
                  };
                });
                _updateTime();
              }
            }
          }
        }
      }
    } catch (e) {
      // Ignore
    }
  }

  String _getFormattedDate(DateTime date) {
    List<String> months = ['Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni', 'Juli', 'Agustus', 'September', 'Oktober', 'November', 'Desember'];
    return '${date.day.toString().padLeft(2, '0')} ${months[date.month - 1]} ${date.year}';
  }

  String _getHijriDate(DateTime date) {
    var _hijri = HijriCalendar.fromDate(date);
    return '${_hijri.hDay} ${_hijri.longMonthName} ${_hijri.hYear}';
  }

  void _showLocationPicker() {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final settings = Provider.of<SettingsProvider>(context, listen: false);
    
    String searchQuery = '';
    
    // Use the exact same list as main.dart
    final List<String> allCities = [
      'Kabupaten Aceh Barat', 'Kabupaten Aceh Barat Daya', 'Kabupaten Aceh Besar', 'Kabupaten Aceh Jaya', 'Kabupaten Aceh Selatan', 'Kabupaten Aceh Singkil', 'Kabupaten Aceh Tamiang', 'Kabupaten Aceh Tengah', 'Kabupaten Aceh Tenggara', 'Kabupaten Aceh Timur', 'Kabupaten Aceh Utara', 'Kabupaten Agam', 'Kabupaten Alor', 'Kabupaten Asahan', 'Kabupaten Asmat', 'Kabupaten Badung', 'Kabupaten Balangan', 'Kabupaten Bandung', 'Kabupaten Bandung Barat', 'Kabupaten Banggai', 'Kabupaten Banggai Kepulauan', 'Kabupaten Banggai Laut', 'Kabupaten Bangka', 'Kabupaten Bangka Barat', 'Kabupaten Bangka Selatan', 'Kabupaten Bangka Tengah', 'Kabupaten Bangkalan', 'Kabupaten Bangli', 'Kabupaten Banjar', 'Kabupaten Banjarnegara', 'Kabupaten Bantaeng', 'Kabupaten Bantul', 'Kabupaten Banyu Asin', 'Kabupaten Banyumas', 'Kabupaten Banyuwangi', 'Kabupaten Barito Kuala', 'Kabupaten Barito Selatan', 'Kabupaten Barito Timur', 'Kabupaten Barito Utara', 'Kabupaten Barru', 'Kabupaten Batang', 'Kabupaten Batang Hari', 'Kabupaten Batu Bara', 'Kabupaten Bekasi', 'Kabupaten Belitung', 'Kabupaten Belitung Timur', 'Kabupaten Belu', 'Kabupaten Bener Meriah', 'Kabupaten Bengkalis', 'Kabupaten Bengkayang', 'Kabupaten Bengkulu Selatan', 'Kabupaten Bengkulu Tengah', 'Kabupaten Bengkulu Utara', 'Kabupaten Berau', 'Kabupaten Biak Numfor', 'Kabupaten Bima', 'Kabupaten Bintan', 'Kabupaten Bireuen', 'Kabupaten Blitar', 'Kabupaten Blora', 'Kabupaten Boalemo', 'Kabupaten Bogor', 'Kabupaten Bojonegoro', 'Kabupaten Bolaang Mongondow', 'Kabupaten Bolaang Mongondow Selatan', 'Kabupaten Bolaang Mongondow Timur', 'Kabupaten Bolaang Mongondow Utara', 'Kabupaten Bombana', 'Kabupaten Bondowoso', 'Kabupaten Bone', 'Kabupaten Bone Bolango', 'Kabupaten Boven Digoel', 'Kabupaten Boyolali', 'Kabupaten Brebes', 'Kabupaten Buleleng', 'Kabupaten Bulukumba', 'Kabupaten Bulungan', 'Kabupaten Bungo', 'Kabupaten Buol', 'Kabupaten Buru', 'Kabupaten Buru Selatan', 'Kabupaten Buton', 'Kabupaten Buton Selatan', 'Kabupaten Buton Tengah', 'Kabupaten Buton Utara', 'Kabupaten Ciamis', 'Kabupaten Cianjur', 'Kabupaten Cilacap', 'Kabupaten Cirebon', 'Kabupaten Dairi', 'Kabupaten Deiyai', 'Kabupaten Deli Serdang', 'Kabupaten Demak', 'Kabupaten Dharmasraya', 'Kabupaten Dogiyai', 'Kabupaten Dompu', 'Kabupaten Donggala', 'Kabupaten Empat Lawang', 'Kabupaten Ende', 'Kabupaten Enrekang', 'Kabupaten Fak-Fak', 'Kabupaten Flores Timur', 'Kabupaten Garut', 'Kabupaten Gayo Lues', 'Kabupaten Gianyar', 'Kabupaten Gorontalo', 'Kabupaten Gorontalo Utara', 'Kabupaten Gowa', 'Kabupaten Gresik', 'Kabupaten Grobogan', 'Kabupaten Gunung Kidul', 'Kabupaten Gunung Mas', 'Kabupaten Halmahera Barat', 'Kabupaten Halmahera Selatan', 'Kabupaten Halmahera Tengah', 'Kabupaten Halmahera Timur', 'Kabupaten Halmahera Utara', 'Kabupaten Hulu Sungai Selatan', 'Kabupaten Hulu Sungai Tengah', 'Kabupaten Hulu Sungai Utara', 'Kabupaten Humbang Hasundutan', 'Kabupaten Indragiri Hilir', 'Kabupaten Indragiri Hulu', 'Kabupaten Indramayu', 'Kabupaten Intan Jaya', 'Kabupaten Jayapura', 'Kabupaten Jayawijaya', 'Kabupaten Jember', 'Kabupaten Jembrana', 'Kabupaten Jeneponto', 'Kabupaten Jepara', 'Kabupaten Jombang', 'Kabupaten Kaimana', 'Kabupaten Kampar', 'Kabupaten Kapuas', 'Kabupaten Kapuas Hulu', 'Kabupaten Karang Asem', 'Kabupaten Karanganyar', 'Kabupaten Karawang', 'Kabupaten Karimun', 'Kabupaten Karo', 'Kabupaten Katingan', 'Kabupaten Kaur', 'Kabupaten Kayong Utara', 'Kabupaten Kebumen', 'Kabupaten Kediri', 'Kabupaten Keerom', 'Kabupaten Kendal', 'Kabupaten Kepahiang', 'Kabupaten Kepulauan Anambas', 'Kabupaten Kepulauan Aru', 'Kabupaten Kepulauan Mentawai', 'Kabupaten Kepulauan Meranti', 'Kabupaten Kepulauan Sangihe', 'Kabupaten Kepulauan Selayar', 'Kabupaten Kepulauan Seribu', 'Kabupaten Kepulauan Sula', 'Kabupaten Kepulauan Talaud', 'Kabupaten Kepulauan Yapen', 'Kabupaten Kerinci', 'Kabupaten Ketapang', 'Kabupaten Klaten', 'Kabupaten Klungkung', 'Kabupaten Kolaka', 'Kabupaten Kolaka Timur', 'Kabupaten Kolaka Utara', 'Kabupaten Konawe', 'Kabupaten Konawe Kepulauan', 'Kabupaten Konawe Selatan', 'Kabupaten Konawe Utara', 'Kabupaten Kota Baru', 'Kabupaten Kotawaringin Barat', 'Kabupaten Kotawaringin Timur', 'Kabupaten Kuantan Singingi', 'Kabupaten Kubu Raya', 'Kabupaten Kudus', 'Kabupaten Kulon Progo', 'Kabupaten Kuningan', 'Kabupaten Kupang', 'Kabupaten Kutai Barat', 'Kabupaten Kutai Kartanegara', 'Kabupaten Kutai Timur', 'Kabupaten Labuhan Batu', 'Kabupaten Labuhan Batu Selatan', 'Kabupaten Labuhan Batu Utara', 'Kabupaten Lahat', 'Kabupaten Lamandau', 'Kabupaten Lamongan', 'Kabupaten Lampung Barat', 'Kabupaten Lampung Selatan', 'Kabupaten Lampung Tengah', 'Kabupaten Lampung Timur', 'Kabupaten Lampung Utara', 'Kabupaten Landak', 'Kabupaten Langkat', 'Kabupaten Lanny Jaya', 'Kabupaten Lebak', 'Kabupaten Lebong', 'Kabupaten Lembata', 'Kabupaten Lima Puluh Kota', 'Kabupaten Lingga', 'Kabupaten Lombok Barat', 'Kabupaten Lombok Tengah', 'Kabupaten Lombok Timur', 'Kabupaten Lombok Utara', 'Kabupaten Lumajang', 'Kabupaten Luwu', 'Kabupaten Luwu Timur', 'Kabupaten Luwu Utara', 'Kabupaten Madiun', 'Kabupaten Magelang', 'Kabupaten Magetan', 'Kabupaten Mahakam Hulu', 'Kabupaten Majalengka', 'Kabupaten Majene', 'Kabupaten Malaka', 'Kabupaten Malang', 'Kabupaten Malinau', 'Kabupaten Maluku Barat Daya', 'Kabupaten Maluku Tengah', 'Kabupaten Maluku Tenggara', 'Kabupaten Maluku Tenggara Barat', 'Kabupaten Mamasa', 'Kabupaten Mamberamo Raya', 'Kabupaten Mamberamo Tengah', 'Kabupaten Mamuju', 'Kabupaten Mamuju Tengah', 'Kabupaten Mamuju Utara', 'Kabupaten Mandailing Natal', 'Kabupaten Manggarai', 'Kabupaten Manggarai Barat', 'Kabupaten Manggarai Timur', 'Kabupaten Manokwari', 'Kabupaten Manokwari Selatan', 'Kabupaten Mappi', 'Kabupaten Maros', 'Kabupaten Maybrat', 'Kabupaten Melawi', 'Kabupaten Mempawah', 'Kabupaten Merangin', 'Kabupaten Merauke', 'Kabupaten Mesuji', 'Kabupaten Mimika', 'Kabupaten Minahasa', 'Kabupaten Minahasa Selatan', 'Kabupaten Minahasa Tenggara', 'Kabupaten Minahasa Utara', 'Kabupaten Mojokerto', 'Kabupaten Morowali', 'Kabupaten Morowali Utara', 'Kabupaten Muara Enim', 'Kabupaten Muaro Jambi', 'Kabupaten Mukomuko', 'Kabupaten Muna', 'Kabupaten Muna Barat', 'Kabupaten Murung Raya', 'Kabupaten Musi Banyu Asin', 'Kabupaten Musi Rawas', 'Kabupaten Musi Rawas Utara', 'Kabupaten Nabire', 'Kabupaten Nagan Raya', 'Kabupaten Nagekeo', 'Kabupaten Natuna', 'Kabupaten Nduga', 'Kabupaten Ngada', 'Kabupaten Nganjuk', 'Kabupaten Ngawi', 'Kabupaten Nias', 'Kabupaten Nias Barat', 'Kabupaten Nias Selatan', 'Kabupaten Nias Utara', 'Kabupaten Nunukan', 'Kabupaten Ogan Ilir', 'Kabupaten Ogan Komering Ilir', 'Kabupaten Ogan Komering Ulu', 'Kabupaten Ogan Komering Ulu Selatan', 'Kabupaten Ogan Komering Ulu Timur', 'Kabupaten Pacitan', 'Kabupaten Padang Lawas', 'Kabupaten Padang Lawas Utara', 'Kabupaten Padang Pariaman', 'Kabupaten Pakpak Bharat', 'Kabupaten Pamekasan', 'Kabupaten Pandeglang', 'Kabupaten Pangandaran', 'Kabupaten Pangkajene Dan Kepulauan', 'Kabupaten Paniai', 'Kabupaten Parigi Moutong', 'Kabupaten Pasaman', 'Kabupaten Pasaman Barat', 'Kabupaten Paser', 'Kabupaten Pasuruan', 'Kabupaten Pati', 'Kabupaten Pegunungan Arfak', 'Kabupaten Pegunungan Bintang', 'Kabupaten Pekalongan', 'Kabupaten Pelalawan', 'Kabupaten Pemalang', 'Kabupaten Penajam Paser Utara', 'Kabupaten Penukal Abab Lematang Ilir', 'Kabupaten Pesawaran', 'Kabupaten Pesisir Barat', 'Kabupaten Pesisir Selatan', 'Kabupaten Pidie', 'Kabupaten Pidie Jaya', 'Kabupaten Pinrang', 'Kabupaten Pohuwato', 'Kabupaten Polewali Mandar', 'Kabupaten Ponorogo', 'Kabupaten Poso', 'Kabupaten Pringsewu', 'Kabupaten Probolinggo', 'Kabupaten Pulang Pisau', 'Kabupaten Pulau Morotai', 'Kabupaten Pulau Taliabu', 'Kabupaten Puncak', 'Kabupaten Puncak Jaya', 'Kabupaten Purbalingga', 'Kabupaten Purwakarta', 'Kabupaten Purworejo', 'Kabupaten Raja Ampat', 'Kabupaten Rejang Lebong', 'Kabupaten Rembang', 'Kabupaten Rokan Hilir', 'Kabupaten Rokan Hulu', 'Kabupaten Rote Ndao', 'Kabupaten Sabu Raijua', 'Kabupaten Sambas', 'Kabupaten Samosir', 'Kabupaten Sampang', 'Kabupaten Sanggau', 'Kabupaten Sarmi', 'Kabupaten Sarolangun', 'Kabupaten Sekadau', 'Kabupaten Seluma', 'Kabupaten Semarang', 'Kabupaten Seram Bagian Barat', 'Kabupaten Seram Bagian Timur', 'Kabupaten Serang', 'Kabupaten Serdang Bedagai', 'Kabupaten Seruyan', 'Kabupaten Siak', 'Kabupaten Siau Tagulandang Biaro', 'Kabupaten Sidenreng Rappang', 'Kabupaten Sidoarjo', 'Kabupaten Sigi', 'Kabupaten Sijunjung', 'Kabupaten Sikka', 'Kabupaten Simalungun', 'Kabupaten Simeulue', 'Kabupaten Sinjai', 'Kabupaten Sintang', 'Kabupaten Situbondo', 'Kabupaten Sleman', 'Kabupaten Solok', 'Kabupaten Solok Selatan', 'Kabupaten Soppeng', 'Kabupaten Sorong', 'Kabupaten Sorong Selatan', 'Kabupaten Sragen', 'Kabupaten Subang', 'Kabupaten Sukabumi', 'Kabupaten Sukamara', 'Kabupaten Sukoharjo', 'Kabupaten Sumba Barat', 'Kabupaten Sumba Barat Daya', 'Kabupaten Sumba Tengah', 'Kabupaten Sumba Timur', 'Kabupaten Sumbawa', 'Kabupaten Sumbawa Barat', 'Kabupaten Sumedang', 'Kabupaten Sumenep', 'Kabupaten Supiori', 'Kabupaten Tabalong', 'Kabupaten Tabanan', 'Kabupaten Takalar', 'Kabupaten Tambrauw', 'Kabupaten Tana Tidung', 'Kabupaten Tana Toraja', 'Kabupaten Tanah Bumbu', 'Kabupaten Tanah Datar', 'Kabupaten Tanah Laut', 'Kabupaten Tangerang', 'Kabupaten Tanggamus', 'Kabupaten Tanjung Jabung Barat', 'Kabupaten Tanjung Jabung Timur', 'Kabupaten Tapanuli Selatan', 'Kabupaten Tapanuli Tengah', 'Kabupaten Tapanuli Utara', 'Kabupaten Tapin', 'Kabupaten Tasikmalaya', 'Kabupaten Tebo', 'Kabupaten Tegal', 'Kabupaten Teluk Bintuni', 'Kabupaten Teluk Wondama', 'Kabupaten Temanggung', 'Kabupaten Timor Tengah Selatan', 'Kabupaten Timor Tengah Utara', 'Kabupaten Toba Samosir', 'Kabupaten Tojo Una-Una', 'Kabupaten Toli-Toli', 'Kabupaten Tolikara', 'Kabupaten Toraja Utara', 'Kabupaten Trenggalek', 'Kabupaten Tuban', 'Kabupaten Tulang Bawang Barat', 'Kabupaten Tulangbawang', 'Kabupaten Tulungagung', 'Kabupaten Wajo', 'Kabupaten Wakatobi', 'Kabupaten Waropen', 'Kabupaten Way Kanan', 'Kabupaten Wonogiri', 'Kabupaten Wonosobo', 'Kabupaten Yahukimo', 'Kabupaten Yalimo', 'Kota Ambon', 'Kota Balikpapan', 'Kota Banda Aceh', 'Kota Bandar Lampung', 'Kota Bandung', 'Kota Banjar', 'Kota Banjar Baru', 'Kota Banjarmasin', 'Kota Batam', 'Kota Batu', 'Kota Baubau', 'Kota Bekasi', 'Kota Bengkulu', 'Kota Bima', 'Kota Binjai', 'Kota Bitung', 'Kota Blitar', 'Kota Bogor', 'Kota Bontang', 'Kota Bukittinggi', 'Kota Cilegon', 'Kota Cimahi', 'Kota Cirebon', 'Kota Denpasar', 'Kota Depok', 'Kota Dumai', 'Kota Gorontalo', 'Kota Gunungsitoli', 'Kota Jakarta Barat', 'Kota Jakarta Pusat', 'Kota Jakarta Selatan', 'Kota Jakarta Timur', 'Kota Jakarta Utara', 'Kota Jambi', 'Kota Jayapura', 'Kota Kediri', 'Kota Kendari', 'Kota Kotamobagu', 'Kota Kupang', 'Kota Langsa', 'Kota Lhokseumawe', 'Kota Lubuk Linggau', 'Kota Madiun', 'Kota Magelang', 'Kota Makassar', 'Kota Malang', 'Kota Manado', 'Kota Mataram', 'Kota Medan', 'Kota Metro', 'Kota Mojokerto', 'Kota Padang', 'Kota Padang Panjang', 'Kota Padang Sidempuan', 'Kota Pagar Alam', 'Kota Palangka Raya', 'Kota Palembang', 'Kota Palopo', 'Kota Palu', 'Kota Pangkal Pinang', 'Kota Pare-Pare', 'Kota Pariaman', 'Kota Pasuruan', 'Kota Payakumbuh', 'Kota Pekalongan', 'Kota Pekanbaru', 'Kota Pematang Siantar', 'Kota Pontianak', 'Kota Prabumulih', 'Kota Probolinggo', 'Kota Sabang', 'Kota Salatiga', 'Kota Samarinda', 'Kota Sawah Lunto', 'Kota Semarang', 'Kota Serang', 'Kota Sibolga', 'Kota Singkawang', 'Kota Solok', 'Kota Sorong', 'Kota Subulussalam', 'Kota Sukabumi', 'Kota Sungai Penuh', 'Kota Surabaya', 'Kota Surakarta', 'Kota Tangerang', 'Kota Tangerang Selatan', 'Kota Tanjung Balai', 'Kota Tanjung Pinang', 'Kota Tarakan', 'Kota Tasikmalaya', 'Kota Tebing Tinggi', 'Kota Tegal', 'Kota Ternate', 'Kota Tidore Kepulauan', 'Kota Tomohon', 'Kota Tual', 'Kota Yogyakarta'
    ];
    List<String> filteredCities = List.from(allCities);
    
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Container(
              height: MediaQuery.of(context).size.height * 0.85,
              decoration: BoxDecoration(
                color: isDarkMode ? const Color(0xFF1E1E1E) : Colors.white,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
              ),
              child: Column(
                children: [
                  const SizedBox(height: 12),
                  Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: isDarkMode ? Colors.white24 : Colors.grey[300],
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Pilih Lokasi',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: isDarkMode ? Colors.white : Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: TextField(
                      autofocus: true,
                      style: TextStyle(color: isDarkMode ? Colors.white : Colors.black87),
                      decoration: InputDecoration(
                        hintText: 'Cari kota atau kabupaten...',
                        hintStyle: TextStyle(color: isDarkMode ? Colors.white54 : Colors.grey[400]),
                        prefixIcon: Icon(Icons.search, color: isDarkMode ? Colors.white54 : Colors.grey[400]),
                        filled: true,
                        fillColor: isDarkMode ? const Color(0xFF2D2D2D) : Colors.grey[100],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      onChanged: (value) {
                        setModalState(() {
                          searchQuery = value;
                          filteredCities = allCities
                              .where((city) => city.toLowerCase().contains(searchQuery.toLowerCase()))
                              .toList();
                        });
                      },
                    ),
                  ),
                  const SizedBox(height: 12),
                  Expanded(
                    child: ListView.separated(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      itemCount: filteredCities.length,
                      separatorBuilder: (context, index) => Divider(
                        color: Colors.grey[100],
                        height: 1,
                        indent: 50,
                      ),
                      itemBuilder: (context, index) {
                        final city = filteredCities[index];
                        final isSelected = city == settings.currentLocation;
                        return ListTile(
                          leading: Icon(
                            Icons.location_on_outlined,
                            color: isSelected ? const Color(0xFF13A884) : Colors.grey[400],
                            size: 22,
                          ),
                          title: Text(
                            city,
                            style: TextStyle(
                              fontSize: 15,
                              color: isSelected ? const Color(0xFF13A884) : Colors.black87,
                              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                            ),
                          ),
                          trailing: isSelected
                              ? const Icon(Icons.check_circle, color: Color(0xFF13A884), size: 20)
                              : null,
                          onTap: () {
                            settings.setCurrentLocation(city);
                            _fetchPrayerTimes(city);
                            Navigator.pop(context);
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildPrayerWidget(SettingsProvider settings) {
    const primaryGreen = Color(0xFF13A884);
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    
    return Container(
      width: double.infinity,
      height: 200,
      decoration: BoxDecoration(
        color: isDarkMode ? const Color(0xFF1E1E1E) : Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          // Background Illustration
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Opacity(
              opacity: 0.4,
              child: Image.asset(
                'assets/images/mosque_widget_bg.png',
                fit: BoxFit.cover,
                height: 120, 
              ),
            ),
          ),
          // Content
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Image.asset(
                          'assets/images/logo_el_maqam.png',
                          height: 24,
                          width: 24,
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          'MMU Ulul Maqam',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: primaryGreen,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(width: 8),
                    Flexible(
                      child: GestureDetector(
                        onTap: _showLocationPicker,
                        behavior: HitTestBehavior.opaque,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            const Icon(Icons.location_on, color: primaryGreen, size: 14),
                            const SizedBox(width: 4),
                            Flexible(
                              child: Text(
                                settings.currentLocation.split(',').first.trim(),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: isDarkMode ? Colors.white70 : const Color(0xFF2D3436),
                                ),
                              ),
                            ),
                            const SizedBox(width: 4),
                            Icon(Icons.keyboard_arrow_down_rounded, color: Colors.grey[400], size: 14),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Expanded(child: Divider(color: isDarkMode ? Colors.white10 : Colors.grey[150], thickness: 1)),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Icon(Icons.wb_sunny_rounded, size: 14, color: primaryGreen.withOpacity(0.4)),
                    ),
                    Expanded(child: Divider(color: isDarkMode ? Colors.white10 : Colors.grey[150], thickness: 1)),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _nextPrayerName,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: primaryGreen,
                          ),
                        ),
                        RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: _nextPrayerTimeStr,
                                style: const TextStyle(
                                  fontSize: 34,
                                  fontWeight: FontWeight.w900,
                                  color: primaryGreen,
                                ),
                              ),
                              const TextSpan(
                                text: ' WIB',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: primaryGreen,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: primaryGreen.withOpacity(0.08),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            '- ${_timeUntilNextPrayer.inHours.toString().padLeft(2, '0')} : ${(_timeUntilNextPrayer.inMinutes % 60).toString().padLeft(2, '0')} : ${(_timeUntilNextPrayer.inSeconds % 60).toString().padLeft(2, '0')}',
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: primaryGreen,
                              fontFeatures: [FontFeature.tabularFigures()],
                            ),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${_getFormattedDate(_currentTime)} / ${_getHijriDate(_currentTime)}',
                          style: TextStyle(
                            fontSize: 10,
                            color: isDarkMode ? Colors.white60 : Colors.grey[600],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          Positioned(
            right: -10,
            bottom: -10,
            child: Opacity(
              opacity: 0.05,
              child: Icon(Icons.nightlight_round, size: 60, color: primaryGreen),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSwitchRow(String title, bool value, ValueChanged<bool> onChanged, {bool isDarkMode = false}) {
    return InkWell(
      onTap: () => onChanged(!value),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: isDarkMode ? Colors.white : Colors.black87,
                fontWeight: FontWeight.w500,
              ),
            ),
            Switch(
              value: value,
              onChanged: onChanged,
              activeColor: const Color(0xFF13A884),
              activeTrackColor: const Color(0xFF13A884).withOpacity(0.3),
              inactiveThumbColor: Colors.grey[200],
              inactiveTrackColor: Colors.grey[300],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final settings = Provider.of<SettingsProvider>(context);
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: const Color(0xFFF4F4F4),
      appBar: AppBar(
        title: Text(
          'Lokasi & Pilihan Adzan',
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 18,
          ),
        ),
        backgroundColor: const Color(0xFF13A884),
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildPrayerWidget(settings),
            const SizedBox(height: 24),

            Padding(
              padding: const EdgeInsets.only(left: 4, bottom: 8),
              child: Text(
                'Suara Adzan',
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10, offset: const Offset(0, 4)),
                ],
              ),
              child: ListTile(
                title: Text(
                  'Pilih Suara',
                  style: GoogleFonts.poppins(fontSize: 14, color: Colors.black87, fontWeight: FontWeight.w500),
                ),
                trailing: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: settings.adzanSound,
                    icon: const Icon(Icons.arrow_drop_down, color: Colors.grey),
                    style: GoogleFonts.poppins(fontSize: 13, color: Colors.grey[600]),
                    onChanged: (String? newValue) {
                      if (newValue != null) {
                        settings.setAdzanSound(newValue);
                      }
                    },
                    items: _adzanOptions.map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),

            Padding(
              padding: const EdgeInsets.only(left: 4, bottom: 8),
              child: Text(
                'Aktifkan Adzan Otomatis',
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10, offset: const Offset(0, 4)),
                ],
              ),
              child: Column(
                children: [
                  _buildSwitchRow('Adzan Subuh', settings.adzanSubuh, (val) => settings.setAdzanSubuh(val)),
                  const Divider(height: 1),
                  _buildSwitchRow('Adzan Dzuhur', settings.adzanDzuhur, (val) => settings.setAdzanDzuhur(val)),
                  const Divider(height: 1),
                  _buildSwitchRow('Adzan Ashar', settings.adzanAshar, (val) => settings.setAdzanAshar(val)),
                  const Divider(height: 1),
                  _buildSwitchRow('Adzan Maghrib', settings.adzanMaghrib, (val) => settings.setAdzanMaghrib(val)),
                  const Divider(height: 1),
                  _buildSwitchRow('Adzan Isya', settings.adzanIsya, (val) => settings.setAdzanIsya(val)),
                ],
              ),
            ),
            
            const SizedBox(height: 20),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
