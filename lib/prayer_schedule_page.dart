import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'prayer_service.dart';

class PrayerSchedulePage extends StatefulWidget {
  const PrayerSchedulePage({super.key});

  @override
  State<PrayerSchedulePage> createState() => _PrayerSchedulePageState();
}

class _PrayerSchedulePageState extends State<PrayerSchedulePage> {
  final PrayerService _prayerService = PrayerService();

  String _selectedProvince = 'Jawa Timur';
  String _selectedCity = 'Kab. Bangkalan';
  int _selectedMonth = DateTime.now().month;
  int _selectedYear = DateTime.now().year;

  List<String> _provinces = [];
  List<String> _cities = [];
  Map<String, dynamic>? _scheduleData;
  bool _isLoading = true;

  static const primaryColor = Color(0xFF13A884);

  final List<String> _monthNames = [
    'Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni',
    'Juli', 'Agustus', 'September', 'Oktober', 'November', 'Desember'
  ];

  @override
  void initState() {
    super.initState();
    _loadInitialData();
  }

  Future<void> _loadInitialData() async {
    setState(() => _isLoading = true);
    try {
      final provinces = await _prayerService.getProvinces();
      setState(() => _provinces = provinces);
      await _loadCities(_selectedProvince);
      await _loadSchedule();
    } catch (e) {
      _showError(e.toString());
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _loadCities(String province) async {
    try {
      final cities = await _prayerService.getCities(province);
      setState(() {
        _cities = cities;
        // Keep Bangkalan if possible, else first
        if (!_cities.contains(_selectedCity)) {
          _selectedCity = _cities.isNotEmpty ? _cities.first : '';
        }
      });
    } catch (e) {
      _showError(e.toString());
    }
  }

  Future<void> _loadSchedule() async {
    setState(() => _isLoading = true);
    try {
      final data = await _prayerService.getMonthlySchedule(
        province: _selectedProvince,
        city: _selectedCity,
        month: _selectedMonth,
        year: _selectedYear,
      );
      setState(() => _scheduleData = data);
    } catch (e) {
      _showError(e.toString());
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Error: $message'), backgroundColor: Colors.red),
    );
  }

  void _showSearchPicker({
    required String title,
    required List<String> items,
    required String currentValue,
    required Function(String) onSelected,
  }) {
    String searchQuery = "";
    final TextEditingController searchController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            final filteredItems = items.where((item) => 
              item.toLowerCase().contains(searchQuery.toLowerCase())
            ).toList();

            final isDarkMode = Theme.of(context).brightness == Brightness.dark;
            return Container(
              height: MediaQuery.of(context).size.height * 0.75,
              decoration: BoxDecoration(
                color: isDarkMode ? const Color(0xFF1E1E1E) : Colors.white,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(25)),
              ),
              child: Column(
                children: [
                  const SizedBox(height: 12),
                  Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: isDarkMode ? Colors.white24 : Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    title,
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: primaryColor),
                  ),
                  const SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: TextField(
                      controller: searchController,
                      onChanged: (value) {
                        setModalState(() {
                          searchQuery = value;
                        });
                      },
                      decoration: InputDecoration(
                        hintText: "Cari...",
                        prefixIcon: const Icon(Icons.search, color: primaryColor),
                        filled: true,
                        fillColor: isDarkMode ? const Color(0xFF2C2C2C) : Colors.grey.shade100,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(vertical: 0),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Expanded(
                    child: ListView.builder(
                      itemCount: filteredItems.length,
                      itemBuilder: (context, index) {
                        final item = filteredItems[index];
                        final isSelected = item == currentValue;
                        return ListTile(
                          title: Text(
                            item,
                            style: TextStyle(
                              color: isSelected ? primaryColor : (isDarkMode ? Colors.white70 : Colors.black87),
                              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                            ),
                          ),
                          trailing: isSelected ? const Icon(Icons.check_circle, color: primaryColor) : null,
                          onTap: () {
                            onSelected(item);
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

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      backgroundColor: isDarkMode ? const Color(0xFF121212) : const Color(0xFFF9FBFB),
      body: CustomScrollView(
        slivers: [
          _buildSliverHeader(),
          if (_isLoading)
            const SliverFillRemaining(
              child: Center(child: CircularProgressIndicator(color: primaryColor)),
            )
          else if (_scheduleData == null)
            const SliverFillRemaining(
              child: Center(child: Text('Data tidak tersedia')),
            )
          else ...[
            const SliverToBoxAdapter(child: SizedBox(height: 20)),
            _buildScheduleSliver(),
            SliverToBoxAdapter(child: _buildQuoteCard()),
          ],
          const SliverToBoxAdapter(child: SizedBox(height: 40)),
        ],
      ),
    );
  }

  Widget _buildSliverHeader() {
    return SliverToBoxAdapter(
      child: Container(
        decoration: const BoxDecoration(
          color: primaryColor,
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(30),
            bottomRight: Radius.circular(30),
          ),
        ),
        child: SafeArea(
          bottom: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top bar
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back_ios, color: Colors.white, size: 20),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const Text(
                      'Jadwal Shalat',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                // Banner row
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.white24),
                      ),
                      child: const Icon(Icons.mosque_outlined, color: Colors.white, size: 40),
                    ),
                    const SizedBox(width: 16),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Jadwalkan shalatmu,',
                            style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            'kuatkan iman dan raih\nkeberkahan setiap hari.',
                            style: TextStyle(color: Colors.white70, fontSize: 13),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                // Selectors
                Row(
                  children: [
                    Expanded(
                      child: _buildClickableSelector(
                        icon: Icons.location_on,
                        label: 'Provinsi',
                        value: _selectedProvince,
                        onTap: () => _showSearchPicker(
                          title: 'Pilih Provinsi',
                          items: _provinces,
                          currentValue: _selectedProvince,
                          onSelected: (val) {
                            setState(() => _selectedProvince = val);
                            _loadCities(val).then((_) => _loadSchedule());
                          },
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildClickableSelector(
                        icon: Icons.map,
                        label: 'Kota/Kab',
                        value: _selectedCity,
                        onTap: () => _showSearchPicker(
                          title: 'Pilih Kota/Kabupaten',
                          items: _cities,
                          currentValue: _selectedCity,
                          onSelected: (val) {
                            setState(() => _selectedCity = val);
                            _loadSchedule();
                          },
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _buildDropdownSelector(
                        icon: Icons.calendar_today,
                        label: 'Bulan',
                        value: _selectedMonth.toString(),
                        items: List.generate(12, (i) => (i + 1).toString()),
                        itemLabels: _monthNames,
                        onChanged: (val) {
                          if (val != null) {
                            setState(() => _selectedMonth = int.parse(val));
                            _loadSchedule();
                          }
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildDropdownSelector(
                        icon: Icons.event,
                        label: 'Tahun',
                        value: _selectedYear.toString(),
                        items: ['2026', '2027'],
                        onChanged: (val) {
                          if (val != null) {
                            setState(() => _selectedYear = int.parse(val));
                            _loadSchedule();
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildClickableSelector({
    required IconData icon,
    required String label,
    required String value,
    required VoidCallback onTap,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Colors.white, fontSize: 12)),
        const SizedBox(height: 6),
        GestureDetector(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Row(
              children: [
                Icon(icon, color: Colors.white, size: 16),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    value,
                    style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w500),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const Icon(Icons.keyboard_arrow_down, color: Colors.white, size: 18),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDropdownSelector({
    required IconData icon,
    required String label,
    required String value,
    required List<String> items,
    List<String>? itemLabels,
    required ValueChanged<String?> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Colors.white, fontSize: 12)),
        const SizedBox(height: 6),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            borderRadius: BorderRadius.circular(15),
          ),
          child: Row(
            children: [
              Icon(icon, color: Colors.white, size: 16),
              const SizedBox(width: 8),
              Expanded(
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: items.contains(value) ? value : (items.isNotEmpty ? items.first : null),
                    isExpanded: true,
                    dropdownColor: primaryColor,
                    icon: const Icon(Icons.keyboard_arrow_down, color: Colors.white),
                    style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w500),
                    items: items.asMap().entries.map((entry) {
                      return DropdownMenuItem(
                        value: entry.value,
                        child: Text(
                          itemLabels != null ? itemLabels[entry.key] : entry.value,
                          overflow: TextOverflow.ellipsis,
                        ),
                      );
                    }).toList(),
                    onChanged: onChanged,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  SliverList _buildScheduleSliver() {
    final List<dynamic> schedules = _scheduleData?['jadwal'] ?? [];
    
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          final day = schedules[index];

          final isDarkMode = Theme.of(context).brightness == Brightness.dark;
          return Container(
            margin: const EdgeInsets.fromLTRB(16, 0, 16, 20),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isDarkMode ? const Color(0xFF1E1E1E) : Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.03),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    const Icon(Icons.calendar_month, color: primaryColor, size: 20),
                    const SizedBox(width: 8),
                    Text(
                      '${day['hari']}, ${day['tanggal']}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: isDarkMode ? Colors.white : const Color(0xFF2D3436),
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      icon: const Icon(Icons.calendar_today_outlined, size: 18, color: Colors.grey),
                      onPressed: () {
                        final text = "Jadwal Shalat $_selectedCity, $_selectedProvince\n"
                            "${day['hari']}, ${day['tanggal']}\n\n"
                            "Imsak: ${day['imsak']}\n"
                            "Subuh: ${day['subuh']}\n"
                            "Terbit: ${day['terbit']}\n"
                            "Dhuha: ${day['dhuha']}\n"
                            "Dzuhur: ${day['dzuhur']}\n"
                            "Ashar: ${day['ashar']}\n"
                            "Maghrib: ${day['maghrib']}\n"
                            "Isya: ${day['isya']}";
                        Clipboard.setData(ClipboardData(text: text));
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Jadwal berhasil disalin!'),
                            duration: Duration(seconds: 2),
                            backgroundColor: primaryColor,
                          ),
                        );
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildTimeBox('Imsak', Icons.nightlight_round, day['imsak']),
                      _buildTimeBox('Subuh', Icons.wb_twilight, day['subuh']),
                      _buildTimeBox('Terbit', Icons.wb_sunny_outlined, day['terbit']),
                      _buildTimeBox('Dhuha', Icons.wb_sunny_outlined, day['dhuha']),
                      _buildTimeBox('Dzuhur', Icons.wb_sunny, day['dzuhur']),
                      _buildTimeBox('Ashar', Icons.wb_cloudy_outlined, day['ashar']),
                      _buildTimeBox('Maghrib', Icons.wb_twilight_outlined, day['maghrib']),
                      _buildTimeBox('Isya', Icons.nightlight_round, day['isya']),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
        childCount: schedules.length,
      ),
    );
  }

  Widget _buildTimeBox(String label, IconData icon, String time) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      width: 70,
      decoration: BoxDecoration(
        color: isDarkMode ? const Color(0xFF2D2D2D) : const Color(0xFFF9FBFB),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: isDarkMode ? Colors.white10 : Colors.grey.withOpacity(0.1)),
      ),
      child: Column(
        children: [
          Text(label, style: TextStyle(fontSize: 10, color: isDarkMode ? Colors.grey[400] : Colors.grey, fontWeight: FontWeight.w500)),
          const SizedBox(height: 8),
          Icon(icon, size: 18, color: Colors.grey.shade600),
          const SizedBox(height: 8),
          Text(
            time,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: primaryColor),
          ),
        ],
      ),
    );
  }

  Widget _buildQuoteCard() {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 8, 16, 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDarkMode ? const Color(0xFF1E1E1E) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.format_quote, color: primaryColor, size: 30),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Sesungguhnya shalat itu adalah tiang agama.',
                  style: TextStyle(
                    color: isDarkMode ? Colors.white : const Color(0xFF2D3436),
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Padding(
            padding: EdgeInsets.only(left: 38),
            child: Text(
              '(HR. Bukhari & Muslim)',
              style: TextStyle(color: primaryColor, fontSize: 12, fontWeight: FontWeight.w500),
            ),
          ),
          const SizedBox(height: 20),
          Align(
            alignment: Alignment.bottomRight,
            child: Icon(Icons.menu_book, color: primaryColor.withOpacity(0.1), size: 60),
          ),
        ],
      ),
    );
  }
}
