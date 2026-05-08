import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';
import 'wirid_doa_page.dart';
import 'prayer_schedule_page.dart';
import 'quran_page.dart';
import 'qibla_page.dart';
import 'calendar_page.dart';
import 'settings_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Al-Qur\'an NU',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF13A884)),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  String _currentLocation = 'Pamekasan, Kabupaten Pamekasan';

  Timer? _timer;
  DateTime _currentTime = DateTime.now();
  String _nextPrayerName = 'Maghrib';
  String _nextPrayerTimeStr = '17:20';
  Duration _timeUntilNextPrayer = Duration.zero;

  @override
  void initState() {
    super.initState();
    _updateTime();
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
    // Dummy jadwal sholat untuk hari ini
    final schedule = {
      'Subuh': DateTime(now.year, now.month, now.day, 4, 25),
      'Dzuhur': DateTime(now.year, now.month, now.day, 11, 45),
      'Ashar': DateTime(now.year, now.month, now.day, 15, 0),
      'Maghrib': DateTime(now.year, now.month, now.day, 17, 45),
      'Isya': DateTime(now.year, now.month, now.day, 18, 55),
    };

    String nextName = 'Subuh';
    DateTime nextTime = schedule['Subuh']!.add(const Duration(days: 1)); // Default ke Subuh besok jika sudah melewati Isya

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

  String _getFormattedDate(DateTime date) {
    const List<String> bulan = [
      '', 'Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni',
      'Juli', 'Agustus', 'September', 'Oktober', 'November', 'Desember'
    ];
    return '${date.day} ${bulan[date.month]} ${date.year}';
  }

  String _getHijriDate(DateTime date) {
    // Estimasi sederhana: 4 Mei 2026 ~ 16 Dzulqa'dah 1447
    int diffDays = date.difference(DateTime(2026, 5, 4)).inDays;
    int baseDay = 16 + diffDays;
    int hDay = ((baseDay - 1) % 30) + 1;
    return '$hDay Dzulqa\'dah 1447';
  }

  final List<String> _indonesianCities = [
    'Kabupaten Aceh Barat', 'Kabupaten Aceh Barat Daya', 'Kabupaten Aceh Besar', 'Kabupaten Aceh Jaya', 'Kabupaten Aceh Selatan', 'Kabupaten Aceh Singkil', 'Kabupaten Aceh Tamiang', 'Kabupaten Aceh Tengah', 'Kabupaten Aceh Tenggara', 'Kabupaten Aceh Timur', 'Kabupaten Aceh Utara', 'Kabupaten Agam', 'Kabupaten Alor', 'Kabupaten Asahan', 'Kabupaten Asmat', 'Kabupaten Badung', 'Kabupaten Balangan', 'Kabupaten Bandung', 'Kabupaten Bandung Barat', 'Kabupaten Banggai', 'Kabupaten Banggai Kepulauan', 'Kabupaten Banggai Laut', 'Kabupaten Bangka', 'Kabupaten Bangka Barat', 'Kabupaten Bangka Selatan', 'Kabupaten Bangka Tengah', 'Kabupaten Bangkalan', 'Kabupaten Bangli', 'Kabupaten Banjar', 'Kabupaten Banjarnegara', 'Kabupaten Bantaeng', 'Kabupaten Bantul', 'Kabupaten Banyu Asin', 'Kabupaten Banyumas', 'Kabupaten Banyuwangi', 'Kabupaten Barito Kuala', 'Kabupaten Barito Selatan', 'Kabupaten Barito Timur', 'Kabupaten Barito Utara', 'Kabupaten Barru', 'Kabupaten Batang', 'Kabupaten Batang Hari', 'Kabupaten Batu Bara', 'Kabupaten Bekasi', 'Kabupaten Belitung', 'Kabupaten Belitung Timur', 'Kabupaten Belu', 'Kabupaten Bener Meriah', 'Kabupaten Bengkalis', 'Kabupaten Bengkayang', 'Kabupaten Bengkulu Selatan', 'Kabupaten Bengkulu Tengah', 'Kabupaten Bengkulu Utara', 'Kabupaten Berau', 'Kabupaten Biak Numfor', 'Kabupaten Bima', 'Kabupaten Bintan', 'Kabupaten Bireuen', 'Kabupaten Blitar', 'Kabupaten Blora', 'Kabupaten Boalemo', 'Kabupaten Bogor', 'Kabupaten Bojonegoro', 'Kabupaten Bolaang Mongondow', 'Kabupaten Bolaang Mongondow Selatan', 'Kabupaten Bolaang Mongondow Timur', 'Kabupaten Bolaang Mongondow Utara', 'Kabupaten Bombana', 'Kabupaten Bondowoso', 'Kabupaten Bone', 'Kabupaten Bone Bolango', 'Kabupaten Boven Digoel', 'Kabupaten Boyolali', 'Kabupaten Brebes', 'Kabupaten Buleleng', 'Kabupaten Bulukumba', 'Kabupaten Bulungan', 'Kabupaten Bungo', 'Kabupaten Buol', 'Kabupaten Buru', 'Kabupaten Buru Selatan', 'Kabupaten Buton', 'Kabupaten Buton Selatan', 'Kabupaten Buton Tengah', 'Kabupaten Buton Utara', 'Kabupaten Ciamis', 'Kabupaten Cianjur', 'Kabupaten Cilacap', 'Kabupaten Cirebon', 'Kabupaten Dairi', 'Kabupaten Deiyai', 'Kabupaten Deli Serdang', 'Kabupaten Demak', 'Kabupaten Dharmasraya', 'Kabupaten Dogiyai', 'Kabupaten Dompu', 'Kabupaten Donggala', 'Kabupaten Empat Lawang', 'Kabupaten Ende', 'Kabupaten Enrekang', 'Kabupaten Fak-Fak', 'Kabupaten Flores Timur', 'Kabupaten Garut', 'Kabupaten Gayo Lues', 'Kabupaten Gianyar', 'Kabupaten Gorontalo', 'Kabupaten Gorontalo Utara', 'Kabupaten Gowa', 'Kabupaten Gresik', 'Kabupaten Grobogan', 'Kabupaten Gunung Kidul', 'Kabupaten Gunung Mas', 'Kabupaten Halmahera Barat', 'Kabupaten Halmahera Selatan', 'Kabupaten Halmahera Tengah', 'Kabupaten Halmahera Timur', 'Kabupaten Halmahera Utara', 'Kabupaten Hulu Sungai Selatan', 'Kabupaten Hulu Sungai Tengah', 'Kabupaten Hulu Sungai Utara', 'Kabupaten Humbang Hasundutan', 'Kabupaten Indragiri Hilir', 'Kabupaten Indragiri Hulu', 'Kabupaten Indramayu', 'Kabupaten Intan Jaya', 'Kabupaten Jayapura', 'Kabupaten Jayawijaya', 'Kabupaten Jember', 'Kabupaten Jembrana', 'Kabupaten Jeneponto', 'Kabupaten Jepara', 'Kabupaten Jombang', 'Kabupaten Kaimana', 'Kabupaten Kampar', 'Kabupaten Kapuas', 'Kabupaten Kapuas Hulu', 'Kabupaten Karang Asem', 'Kabupaten Karanganyar', 'Kabupaten Karawang', 'Kabupaten Karimun', 'Kabupaten Karo', 'Kabupaten Katingan', 'Kabupaten Kaur', 'Kabupaten Kayong Utara', 'Kabupaten Kebumen', 'Kabupaten Kediri', 'Kabupaten Keerom', 'Kabupaten Kendal', 'Kabupaten Kepahiang', 'Kabupaten Kepulauan Anambas', 'Kabupaten Kepulauan Aru', 'Kabupaten Kepulauan Mentawai', 'Kabupaten Kepulauan Meranti', 'Kabupaten Kepulauan Sangihe', 'Kabupaten Kepulauan Selayar', 'Kabupaten Kepulauan Seribu', 'Kabupaten Kepulauan Sula', 'Kabupaten Kepulauan Talaud', 'Kabupaten Kepulauan Yapen', 'Kabupaten Kerinci', 'Kabupaten Ketapang', 'Kabupaten Klaten', 'Kabupaten Klungkung', 'Kabupaten Kolaka', 'Kabupaten Kolaka Timur', 'Kabupaten Kolaka Utara', 'Kabupaten Konawe', 'Kabupaten Konawe Kepulauan', 'Kabupaten Konawe Selatan', 'Kabupaten Konawe Utara', 'Kabupaten Kota Baru', 'Kabupaten Kotawaringin Barat', 'Kabupaten Kotawaringin Timur', 'Kabupaten Kuantan Singingi', 'Kabupaten Kubu Raya', 'Kabupaten Kudus', 'Kabupaten Kulon Progo', 'Kabupaten Kuningan', 'Kabupaten Kupang', 'Kabupaten Kutai Barat', 'Kabupaten Kutai Kartanegara', 'Kabupaten Kutai Timur', 'Kabupaten Labuhan Batu', 'Kabupaten Labuhan Batu Selatan', 'Kabupaten Labuhan Batu Utara', 'Kabupaten Lahat', 'Kabupaten Lamandau', 'Kabupaten Lamongan', 'Kabupaten Lampung Barat', 'Kabupaten Lampung Selatan', 'Kabupaten Lampung Tengah', 'Kabupaten Lampung Timur', 'Kabupaten Lampung Utara', 'Kabupaten Landak', 'Kabupaten Langkat', 'Kabupaten Lanny Jaya', 'Kabupaten Lebak', 'Kabupaten Lebong', 'Kabupaten Lembata', 'Kabupaten Lima Puluh Kota', 'Kabupaten Lingga', 'Kabupaten Lombok Barat', 'Kabupaten Lombok Tengah', 'Kabupaten Lombok Timur', 'Kabupaten Lombok Utara', 'Kabupaten Lumajang', 'Kabupaten Luwu', 'Kabupaten Luwu Timur', 'Kabupaten Luwu Utara', 'Kabupaten Madiun', 'Kabupaten Magelang', 'Kabupaten Magetan', 'Kabupaten Mahakam Hulu', 'Kabupaten Majalengka', 'Kabupaten Majene', 'Kabupaten Malaka', 'Kabupaten Malang', 'Kabupaten Malinau', 'Kabupaten Maluku Barat Daya', 'Kabupaten Maluku Tengah', 'Kabupaten Maluku Tenggara', 'Kabupaten Maluku Tenggara Barat', 'Kabupaten Mamasa', 'Kabupaten Mamberamo Raya', 'Kabupaten Mamberamo Tengah', 'Kabupaten Mamuju', 'Kabupaten Mamuju Tengah', 'Kabupaten Mamuju Utara', 'Kabupaten Mandailing Natal', 'Kabupaten Manggarai', 'Kabupaten Manggarai Barat', 'Kabupaten Manggarai Timur', 'Kabupaten Manokwari', 'Kabupaten Manokwari Selatan', 'Kabupaten Mappi', 'Kabupaten Maros', 'Kabupaten Maybrat', 'Kabupaten Melawi', 'Kabupaten Mempawah', 'Kabupaten Merangin', 'Kabupaten Merauke', 'Kabupaten Mesuji', 'Kabupaten Mimika', 'Kabupaten Minahasa', 'Kabupaten Minahasa Selatan', 'Kabupaten Minahasa Tenggara', 'Kabupaten Minahasa Utara', 'Kabupaten Mojokerto', 'Kabupaten Morowali', 'Kabupaten Morowali Utara', 'Kabupaten Muara Enim', 'Kabupaten Muaro Jambi', 'Kabupaten Mukomuko', 'Kabupaten Muna', 'Kabupaten Muna Barat', 'Kabupaten Murung Raya', 'Kabupaten Musi Banyu Asin', 'Kabupaten Musi Rawas', 'Kabupaten Musi Rawas Utara', 'Kabupaten Nabire', 'Kabupaten Nagan Raya', 'Kabupaten Nagekeo', 'Kabupaten Natuna', 'Kabupaten Nduga', 'Kabupaten Ngada', 'Kabupaten Nganjuk', 'Kabupaten Ngawi', 'Kabupaten Nias', 'Kabupaten Nias Barat', 'Kabupaten Nias Selatan', 'Kabupaten Nias Utara', 'Kabupaten Nunukan', 'Kabupaten Ogan Ilir', 'Kabupaten Ogan Komering Ilir', 'Kabupaten Ogan Komering Ulu', 'Kabupaten Ogan Komering Ulu Selatan', 'Kabupaten Ogan Komering Ulu Timur', 'Kabupaten Pacitan', 'Kabupaten Padang Lawas', 'Kabupaten Padang Lawas Utara', 'Kabupaten Padang Pariaman', 'Kabupaten Pakpak Bharat', 'Kabupaten Pamekasan', 'Kabupaten Pandeglang', 'Kabupaten Pangandaran', 'Kabupaten Pangkajene Dan Kepulauan', 'Kabupaten Paniai', 'Kabupaten Parigi Moutong', 'Kabupaten Pasaman', 'Kabupaten Pasaman Barat', 'Kabupaten Paser', 'Kabupaten Pasuruan', 'Kabupaten Pati', 'Kabupaten Pegunungan Arfak', 'Kabupaten Pegunungan Bintang', 'Kabupaten Pekalongan', 'Kabupaten Pelalawan', 'Kabupaten Pemalang', 'Kabupaten Penajam Paser Utara', 'Kabupaten Penukal Abab Lematang Ilir', 'Kabupaten Pesawaran', 'Kabupaten Pesisir Barat', 'Kabupaten Pesisir Selatan', 'Kabupaten Pidie', 'Kabupaten Pidie Jaya', 'Kabupaten Pinrang', 'Kabupaten Pohuwato', 'Kabupaten Polewali Mandar', 'Kabupaten Ponorogo', 'Kabupaten Poso', 'Kabupaten Pringsewu', 'Kabupaten Probolinggo', 'Kabupaten Pulang Pisau', 'Kabupaten Pulau Morotai', 'Kabupaten Pulau Taliabu', 'Kabupaten Puncak', 'Kabupaten Puncak Jaya', 'Kabupaten Purbalingga', 'Kabupaten Purwakarta', 'Kabupaten Purworejo', 'Kabupaten Raja Ampat', 'Kabupaten Rejang Lebong', 'Kabupaten Rembang', 'Kabupaten Rokan Hilir', 'Kabupaten Rokan Hulu', 'Kabupaten Rote Ndao', 'Kabupaten Sabu Raijua', 'Kabupaten Sambas', 'Kabupaten Samosir', 'Kabupaten Sampang', 'Kabupaten Sanggau', 'Kabupaten Sarmi', 'Kabupaten Sarolangun', 'Kabupaten Sekadau', 'Kabupaten Seluma', 'Kabupaten Semarang', 'Kabupaten Seram Bagian Barat', 'Kabupaten Seram Bagian Timur', 'Kabupaten Serang', 'Kabupaten Serdang Bedagai', 'Kabupaten Seruyan', 'Kabupaten Siak', 'Kabupaten Siau Tagulandang Biaro', 'Kabupaten Sidenreng Rappang', 'Kabupaten Sidoarjo', 'Kabupaten Sigi', 'Kabupaten Sijunjung', 'Kabupaten Sikka', 'Kabupaten Simalungun', 'Kabupaten Simeulue', 'Kabupaten Sinjai', 'Kabupaten Sintang', 'Kabupaten Situbondo', 'Kabupaten Sleman', 'Kabupaten Solok', 'Kabupaten Solok Selatan', 'Kabupaten Soppeng', 'Kabupaten Sorong', 'Kabupaten Sorong Selatan', 'Kabupaten Sragen', 'Kabupaten Subang', 'Kabupaten Sukabumi', 'Kabupaten Sukamara', 'Kabupaten Sukoharjo', 'Kabupaten Sumba Barat', 'Kabupaten Sumba Barat Daya', 'Kabupaten Sumba Tengah', 'Kabupaten Sumba Timur', 'Kabupaten Sumbawa', 'Kabupaten Sumbawa Barat', 'Kabupaten Sumedang', 'Kabupaten Sumenep', 'Kabupaten Supiori', 'Kabupaten Tabalong', 'Kabupaten Tabanan', 'Kabupaten Takalar', 'Kabupaten Tambrauw', 'Kabupaten Tana Tidung', 'Kabupaten Tana Toraja', 'Kabupaten Tanah Bumbu', 'Kabupaten Tanah Datar', 'Kabupaten Tanah Laut', 'Kabupaten Tangerang', 'Kabupaten Tanggamus', 'Kabupaten Tanjung Jabung Barat', 'Kabupaten Tanjung Jabung Timur', 'Kabupaten Tapanuli Selatan', 'Kabupaten Tapanuli Tengah', 'Kabupaten Tapanuli Utara', 'Kabupaten Tapin', 'Kabupaten Tasikmalaya', 'Kabupaten Tebo', 'Kabupaten Tegal', 'Kabupaten Teluk Bintuni', 'Kabupaten Teluk Wondama', 'Kabupaten Temanggung', 'Kabupaten Timor Tengah Selatan', 'Kabupaten Timor Tengah Utara', 'Kabupaten Toba Samosir', 'Kabupaten Tojo Una-Una', 'Kabupaten Toli-Toli', 'Kabupaten Tolikara', 'Kabupaten Toraja Utara', 'Kabupaten Trenggalek', 'Kabupaten Tuban', 'Kabupaten Tulang Bawang Barat', 'Kabupaten Tulangbawang', 'Kabupaten Tulungagung', 'Kabupaten Wajo', 'Kabupaten Wakatobi', 'Kabupaten Waropen', 'Kabupaten Way Kanan', 'Kabupaten Wonogiri', 'Kabupaten Wonosobo', 'Kabupaten Yahukimo', 'Kabupaten Yalimo', 'Kota Ambon', 'Kota Balikpapan', 'Kota Banda Aceh', 'Kota Bandar Lampung', 'Kota Bandung', 'Kota Banjar', 'Kota Banjar Baru', 'Kota Banjarmasin', 'Kota Batam', 'Kota Batu', 'Kota Baubau', 'Kota Bekasi', 'Kota Bengkulu', 'Kota Bima', 'Kota Binjai', 'Kota Bitung', 'Kota Blitar', 'Kota Bogor', 'Kota Bontang', 'Kota Bukittinggi', 'Kota Cilegon', 'Kota Cimahi', 'Kota Cirebon', 'Kota Denpasar', 'Kota Depok', 'Kota Dumai', 'Kota Gorontalo', 'Kota Gunungsitoli', 'Kota Jakarta Barat', 'Kota Jakarta Pusat', 'Kota Jakarta Selatan', 'Kota Jakarta Timur', 'Kota Jakarta Utara', 'Kota Jambi', 'Kota Jayapura', 'Kota Kediri', 'Kota Kendari', 'Kota Kotamobagu', 'Kota Kupang', 'Kota Langsa', 'Kota Lhokseumawe', 'Kota Lubuk Linggau', 'Kota Madiun', 'Kota Magelang', 'Kota Makassar', 'Kota Malang', 'Kota Manado', 'Kota Mataram', 'Kota Medan', 'Kota Metro', 'Kota Mojokerto', 'Kota Padang', 'Kota Padang Panjang', 'Kota Padang Sidempuan', 'Kota Pagar Alam', 'Kota Palangka Raya', 'Kota Palembang', 'Kota Palopo', 'Kota Palu', 'Kota Pangkal Pinang', 'Kota Pare-Pare', 'Kota Pariaman', 'Kota Pasuruan', 'Kota Payakumbuh', 'Kota Pekalongan', 'Kota Pekanbaru', 'Kota Pematang Siantar', 'Kota Pontianak', 'Kota Prabumulih', 'Kota Probolinggo', 'Kota Sabang', 'Kota Salatiga', 'Kota Samarinda', 'Kota Sawah Lunto', 'Kota Semarang', 'Kota Serang', 'Kota Sibolga', 'Kota Singkawang', 'Kota Solok', 'Kota Sorong', 'Kota Subulussalam', 'Kota Sukabumi', 'Kota Sungai Penuh', 'Kota Surabaya', 'Kota Surakarta', 'Kota Tangerang', 'Kota Tangerang Selatan', 'Kota Tanjung Balai', 'Kota Tanjung Pinang', 'Kota Tarakan', 'Kota Tasikmalaya', 'Kota Tebing Tinggi', 'Kota Tegal', 'Kota Ternate', 'Kota Tidore Kepulauan', 'Kota Tomohon', 'Kota Tual', 'Kota Yogyakarta'
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _showLocationPicker() {
    String searchQuery = '';
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            final filteredCities = _indonesianCities
                .where((city) => city.toLowerCase().contains(searchQuery.toLowerCase()))
                .toList();

            return Container(
              height: MediaQuery.of(context).size.height * 0.8,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: Column(
                children: [
                  const SizedBox(height: 12),
                  Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    child: Text(
                      'Pilih Kota/Kabupaten',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF13A884),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: TextField(
                      autofocus: true,
                      decoration: InputDecoration(
                        hintText: 'Cari kota atau kabupaten...',
                        prefixIcon: const Icon(Icons.search, color: Color(0xFF13A884)),
                        filled: true,
                        fillColor: Colors.grey[100],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(vertical: 0),
                      ),
                      onChanged: (value) {
                        setModalState(() {
                          searchQuery = value;
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
                        final isSelected = city == _currentLocation;
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
                            setState(() {
                              _currentLocation = city;
                            });
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

  Widget _buildLocationHeader() {
    return Column(
      children: [
        // Placeholder untuk nuonline logo text
        RichText(
          text: const TextSpan(
            text: 'MD',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Color(0xFF13A884), // Hijau NU
            ),
            children: [
              TextSpan(
                text: 'online',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.location_on, color: Colors.red, size: 16),
            const SizedBox(width: 4),
            Flexible(
              child: Text(
                _currentLocation,
                style: const TextStyle(
                  fontSize: 13,
                  color: Colors.grey,
                  fontWeight: FontWeight.w500,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(width: 4),
            GestureDetector(
              onTap: _showLocationPicker,
              child: const Text(
                '(Ganti)',
                style: TextStyle(
                  fontSize: 13,
                  color: Color(0xFF13A884),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        RichText(
          text: TextSpan(
            text: '$_nextPrayerName ',
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
            children: [
              TextSpan(
                text: '$_nextPrayerTimeStr ',
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const TextSpan(
                text: 'WIB',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 4),
        Text(
          '- ${_timeUntilNextPrayer.inHours.toString().padLeft(2, '0')} : ${(_timeUntilNextPrayer.inMinutes % 60).toString().padLeft(2, '0')} : ${(_timeUntilNextPrayer.inSeconds % 60).toString().padLeft(2, '0')}',
          style: const TextStyle(
            fontSize: 14,
            color: Colors.grey,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          '${_getFormattedDate(_currentTime)} / ${_getHijriDate(_currentTime)}',
          style: const TextStyle(
            fontSize: 12,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 24),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          // Index 0: Beranda (Home)
          Stack(
            children: [
              Positioned.fill(
                child: Container(color: const Color(0xFF13A884)),
              ),
              Positioned.fill(
                child: ClipPath(
                  clipper: DomeClipper(),
                  child: Container(color: Colors.white),
                ),
              ),
              LayoutBuilder(
                builder: (context, constraints) {
                  final double screenHeight = MediaQuery.of(context).size.height;
                  final double topOffset = screenHeight * 0.12;
                  return SafeArea(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          SizedBox(height: topOffset),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Column(
                              children: [
                                _buildLocationHeader(),
                                _buildMenuGrid(),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
          // Index 1: Al-Quran (Bottom Nav - Local Data)
          const QuranPage(useApi: false),
          // Index 2: Artikel
          const Center(child: Text('Halaman Artikel')),
          // Index 3: Kalender
          const CalendarPage(),
          // Index 4: Pengaturan
          const SettingsPage(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: const Color(0xFF13A884),
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_filled),
            label: 'Beranda',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.menu_book),
            label: 'Al-Quran',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.article_outlined),
            label: 'Artikel',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_month_outlined),
            label: 'Kalender',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings_outlined),
            label: 'Pengaturan',
          ),
        ],
      ),
    );
  }

  Widget _buildMenuGrid() {
    return GridView.count(
      crossAxisCount: 4, // 4 kolom sesuai gambar referensi
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 16,
      crossAxisSpacing: 8,
      childAspectRatio: 0.85,
      children: const [
        AlQuranIcon(),
        WiridDoaIcon(),
        JadwalShalatIcon(), // Icon jam yang baru kita buat
        KiblatIcon(),       // Tambahkan placeholder jika ingin melengkapi
        TahlilIcon(),
        MaulidIcon(),
        ZakatIcon(),
        LainnyaIcon(),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────
// ICON 1: AL-QURAN
// Icon by BZZRINCANTATION - Flaticon (https://www.flaticon.com/free-icons/quran)
// ─────────────────────────────────────────────────────────────
class AlQuranIcon extends StatelessWidget {
  const AlQuranIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const QuranPage(useApi: true)),
        );
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: const BoxDecoration(
              color: Color(0xFFE8F5F1),
              shape: BoxShape.circle,
            ),
            padding: const EdgeInsets.all(8),
            child: Image.asset(
              'assets/images/alquran_icon.png',
              fit: BoxFit.contain,
            ),
          ),
          const SizedBox(height: 5),
          const Text(
            'Al-Quran',
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w500,
              color: Color(0xFF333333),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// ICON 2: WIRID & DOA
// ─────────────────────────────────────────────────────────────
class WiridDoaIcon extends StatelessWidget {
  const WiridDoaIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const WiridDoaPage(initialIndex: 0)),
        );
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: const BoxDecoration(
              color: Color(0xFFE8F5F1),
              shape: BoxShape.circle,
            ),
            padding: const EdgeInsets.all(8),
            child: Image.asset(
              'assets/images/wirid_doa_icon.png',
              fit: BoxFit.contain,
            ),
          ),
          const SizedBox(height: 5),
          const Text(
            'Wirid & Doa',
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w500,
              color: Color(0xFF333333),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// ICON 3: JADWAL SHALAT
// Icon by Ghozi Muhtarom - Flaticon (https://www.flaticon.com/free-icons/prayer)
// ─────────────────────────────────────────────────────────────
class JadwalShalatIcon extends StatelessWidget {
  const JadwalShalatIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const PrayerSchedulePage()),
        );
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: const BoxDecoration(
              color: Color(0xFFE8F5F1),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: const Color(0xFF13A884),
                    width: 2.5,
                  ),
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      width: 4,
                      height: 4,
                      decoration: const BoxDecoration(
                        color: Color(0xFF13A884),
                        shape: BoxShape.circle,
                      ),
                    ),
                    Positioned(
                      top: 4,
                      child: Container(
                        width: 2,
                        height: 12,
                        decoration: BoxDecoration(
                          color: const Color(0xFF13A884),
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                    Positioned(
                      right: 6,
                      child: Container(
                        width: 10,
                        height: 2,
                        decoration: BoxDecoration(
                          color: const Color(0xFF13A884),
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 5),
          const Text(
            'Jadwal Shalat',
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w500,
              color: Color(0xFF333333),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// ICON 4: KIBLAT
// Kiblat icons created by Fahrul Oktaviana - Flaticon (https://www.flaticon.com/free-icons/kiblat)
// ─────────────────────────────────────────────────────────────
class KiblatIcon extends StatelessWidget {
  const KiblatIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const QiblaPage()),
        );
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
        Container(
          width: 52,
          height: 52,
          decoration: const BoxDecoration(
            color: Color(0xFFE8F5F1),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: const Color(0xFFF4F4F4),
                shape: BoxShape.circle,
                border: Border.all(
                  color: const Color(0xFF13A884),
                  width: 2.5,
                ),
              ),
              child: CustomPaint(
                painter: KiblatPainter(),
              ),
            ),
          ),
        ),
        const SizedBox(height: 5),
        const Text(
          'Kiblat',
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w500,
            color: Color(0xFF333333),
          ),
          textAlign: TextAlign.center,
        ),
      ],
      ),
    );
  }
}

class KiblatPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()..style = PaintingStyle.fill;

    // Draw Red Compass Marks
    final Paint linePaint = Paint()
      ..color = const Color(0xFFFF4747)
      ..strokeWidth = 2.0
      ..strokeCap = StrokeCap.round;

    final double cx = size.width / 2;
    final double cy = size.height / 2;

    // Draw 7 dashes
    final List<double> angles = [0, 45, 90, 135, 180, 225, 315];
    for (var angle in angles) {
      final double rad = angle * pi / 180;
      final double innerRadius = 12.0;
      final double outerRadius = 14.0;
      canvas.drawLine(
        Offset(cx + innerRadius * cos(rad), cy + innerRadius * sin(rad)),
        Offset(cx + outerRadius * cos(rad), cy + outerRadius * sin(rad)),
        linePaint,
      );
    }

    // Draw Red Triangle at Top (270 degrees)
    final Path trianglePath = Path()
      ..moveTo(cx, 3)
      ..lineTo(cx - 3, 8)
      ..lineTo(cx + 3, 8)
      ..close();
    paint.color = const Color(0xFFFF4747);
    canvas.drawPath(trianglePath, paint);

    // Top face (Dark grey)
    final Path topFace = Path()
      ..moveTo(18, 9)
      ..lineTo(10, 13)
      ..lineTo(18, 17)
      ..lineTo(26, 13)
      ..close();
    paint.color = const Color(0xFF4A4A4A);
    canvas.drawPath(topFace, paint);

    // Left face (Light grey)
    final Path leftFace = Path()
      ..moveTo(10, 13)
      ..lineTo(10, 23)
      ..lineTo(18, 27)
      ..lineTo(18, 17)
      ..close();
    paint.color = const Color(0xFFB4B4B4);
    canvas.drawPath(leftFace, paint);

    // Right face (Black / Very dark grey)
    final Path rightFace = Path()
      ..moveTo(26, 13)
      ..lineTo(26, 23)
      ..lineTo(18, 27)
      ..lineTo(18, 17)
      ..close();
    paint.color = const Color(0xFF333333);
    canvas.drawPath(rightFace, paint);

    // Right Face Yellow Band
    final Path rightBand = Path()
      ..moveTo(26, 16)
      ..lineTo(18, 20)
      ..lineTo(18, 22)
      ..lineTo(26, 18)
      ..close();
    paint.color = const Color(0xFFFFD700);
    canvas.drawPath(rightBand, paint);

    // Left Face Door
    final Path door = Path()
      ..moveTo(17, 26.5)
      ..lineTo(13, 24.5)
      ..lineTo(13, 19)
      ..lineTo(17, 21)
      ..close();
    paint.color = const Color(0xFFFFD700);
    canvas.drawPath(door, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

// ─────────────────────────────────────────────────────────────
// ICON 5: TAHLIL & YASIN
// Worship icons created by ariyantodeni - Flaticon (https://www.flaticon.com/free-icons/worship)
// ─────────────────────────────────────────────────────────────
class TahlilIcon extends StatelessWidget {
  const TahlilIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const WiridDoaPage(initialIndex: 1)),
        );
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: const BoxDecoration(
              color: Color(0xFFE8F5F1),
              shape: BoxShape.circle,
            ),
            padding: const EdgeInsets.all(8),
            child: Image.asset(
              'assets/images/tahlil_icon.png',
              fit: BoxFit.contain,
            ),
          ),
          const SizedBox(height: 5),
          const Text(
            'Tahlil & Yasin',
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w500,
              color: Color(0xFF333333),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// ICON 6: MAULID
// Eid mubarak icons created by mnauliady - Flaticon (https://www.flaticon.com/free-icons/eid-mubarak)
// ─────────────────────────────────────────────────────────────
class MaulidIcon extends StatelessWidget {
  const MaulidIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 52,
          height: 52,
          decoration: const BoxDecoration(
            color: Color(0xFFE8F5F1),
            shape: BoxShape.circle,
          ),
          padding: const EdgeInsets.all(8),
          child: Image.asset(
            'assets/images/maulid_icon.png',
            fit: BoxFit.contain,
          ),
        ),
        const SizedBox(height: 5),
        const Text(
          'Maulid',
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w500,
            color: Color(0xFF333333),
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────
// ICON 7: ZAKAT
// Zakat icons created by Freepik - Flaticon (https://www.flaticon.com/free-icons/zakat)
// ─────────────────────────────────────────────────────────────
class ZakatIcon extends StatelessWidget {
  const ZakatIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 52,
          height: 52,
          decoration: const BoxDecoration(
            color: Color(0xFFE8F5F1),
            shape: BoxShape.circle,
          ),
          padding: const EdgeInsets.all(8),
          child: Image.asset(
            'assets/images/zakat_icon.png',
            fit: BoxFit.contain,
          ),
        ),
        const SizedBox(height: 5),
        const Text(
          'Zakat',
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w500,
            color: Color(0xFF333333),
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────
// ICON 8: LAINNYA
// More icons created by Pixel perfect - Flaticon (https://www.flaticon.com/free-icons/more)
// ─────────────────────────────────────────────────────────────
class LainnyaIcon extends StatelessWidget {
  const LainnyaIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 52,
          height: 52,
          decoration: const BoxDecoration(
            color: Color(0xFFE8F5F1),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: SizedBox(
              width: 36,
              height: 36,
              child: CustomPaint(
                painter: MoreIconPainter(),
              ),
            ),
          ),
        ),
        const SizedBox(height: 5),
        const Text(
          'Lainnya',
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w500,
            color: Color(0xFF333333),
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

class MoreIconPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()..style = PaintingStyle.fill;
    
    // Left half of background
    paint.color = const Color(0xFF50A855);
    canvas.drawArc(
      Rect.fromLTWH(0, 0, size.width, size.height),
      pi / 2,
      pi,
      true,
      paint,
    );

    // Right half of background
    paint.color = const Color(0xFF429147);
    canvas.drawArc(
      Rect.fromLTWH(0, 0, size.width, size.height),
      -pi / 2,
      pi,
      true,
      paint,
    );

    // The three dots
    final double dotRadius = size.width * 0.13;
    final double spacing = size.width * 0.32;
    final double cy = size.height / 2;

    for (int i = -1; i <= 1; i++) {
      final double cx = size.width / 2 + (i * spacing);
      
      // Left half of dot
      paint.color = const Color(0xFFE0E0E0);
      canvas.drawArc(
        Rect.fromCircle(center: Offset(cx, cy), radius: dotRadius),
        pi / 2,
        pi,
        true,
        paint,
      );

      // Right half of dot
      paint.color = Colors.white;
      canvas.drawArc(
        Rect.fromCircle(center: Offset(cx, cy), radius: dotRadius),
        -pi / 2,
        pi,
        true,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

Widget _buildPlaceholder(String title) {
  return Column(
    mainAxisSize: MainAxisSize.min,
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Container(
        width: 52,
        height: 52,
        decoration: const BoxDecoration(
          color: Color(0xFFE8F5F1),
          shape: BoxShape.circle,
        ),
      ),
      const SizedBox(height: 5),
      Text(
        title,
        style: const TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w500,
          color: Color(0xFF333333),
        ),
        textAlign: TextAlign.center,
      ),
    ],
  );
}

class DomeClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    double w = size.width;
    double h = size.height;

    double baseY = h * 0.28;
    double tipY = h * 0.08;
    double hDiff = baseY - tipY;

    double p1x = w * 0.16;
    double p1y = baseY - hDiff * 0.25;

    double p2x = w * 0.33;
    double p2y = baseY - hDiff * 0.65;

    double p3x = w * 0.5;
    double p3y = tipY;
    double p2x_r = w - p2x;
    double p1x_r = w - p1x;
    path.moveTo(0, baseY);
    path.quadraticBezierTo(0, p1y, p1x, p1y);
    path.quadraticBezierTo(p1x, p2y, p2x, p2y);
    path.cubicTo(
        p2x, p3y + hDiff * 0.1, p3x - w * 0.05, p3y + hDiff * 0.1, p3x, p3y);
    path.cubicTo(
        p3x + w * 0.05, p3y + hDiff * 0.1, p2x_r, p3y + hDiff * 0.1, p2x_r, p2y);
    path.quadraticBezierTo(p1x_r, p2y, p1x_r, p1y);
    path.quadraticBezierTo(w, p1y, w, baseY);
    path.lineTo(w, h);
    path.lineTo(0, h);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => true;
}
