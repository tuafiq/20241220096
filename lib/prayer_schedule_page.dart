import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'prayer_service.dart';
import 'settings_provider.dart';

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

  // Prayer display config
  final List<Map<String, dynamic>> _prayerMeta = [
    {'key': 'imsak',   'label': 'Imsak',   'icon': Icons.nightlight_round},
    {'key': 'subuh',   'label': 'Subuh',   'icon': Icons.wb_twilight},
    {'key': 'terbit',  'label': 'Terbit',  'icon': Icons.wb_sunny_outlined},
    {'key': 'dhuha',   'label': 'Dhuha',   'icon': Icons.wb_sunny_outlined},
    {'key': 'dzuhur',  'label': 'Dzuhur',  'icon': Icons.wb_sunny},
    {'key': 'ashar',   'label': 'Ashar',   'icon': Icons.wb_cloudy_outlined},
    {'key': 'maghrib', 'label': 'Maghrib', 'icon': Icons.wb_twilight_outlined},
    {'key': 'isya',    'label': 'Isya',    'icon': Icons.nights_stay},
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
            final filteredItems = items
                .where((item) =>
                    item.toLowerCase().contains(searchQuery.toLowerCase()))
                .toList();
            final isDark = Theme.of(context).brightness == Brightness.dark;
            return Container(
              height: MediaQuery.of(context).size.height * 0.75,
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF1C1C1C) : Colors.white,
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(24)),
              ),
              child: Column(
                children: [
                  const SizedBox(height: 12),
                  Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: isDark ? Colors.white24 : Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(title,
                      style: GoogleFonts.outfit(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: primaryColor)),
                  const SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: TextField(
                      controller: searchController,
                      onChanged: (v) => setModalState(() => searchQuery = v),
                      style: TextStyle(
                          color: isDark ? Colors.white : Colors.black87),
                      decoration: InputDecoration(
                        hintText: 'Cari...',
                        hintStyle: TextStyle(
                            color: isDark ? Colors.white38 : Colors.grey),
                        prefixIcon:
                            const Icon(Icons.search, color: primaryColor),
                        filled: true,
                        fillColor: isDark
                            ? const Color(0xFF2A2A2A)
                            : Colors.grey.shade100,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Expanded(
                    child: ListView.builder(
                      itemCount: filteredItems.length,
                      itemBuilder: (context, index) {
                        final item = filteredItems[index];
                        final isSelected = item == currentValue;
                        return ListTile(
                          title: Text(item,
                              style: GoogleFonts.outfit(
                                color: isSelected
                                    ? primaryColor
                                    : (isDark
                                        ? Colors.white70
                                        : Colors.black87),
                                fontWeight: isSelected
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                              )),
                          trailing: isSelected
                              ? const Icon(Icons.check_circle,
                                  color: primaryColor)
                              : null,
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
    final settings = context.watch<SettingsProvider>();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Colors based on theme
    final bgColor = isDark ? const Color(0xFF0D0D0D) : const Color(0xFFF2F2F2);
    final headerBg = isDark ? const Color(0xFF0D0D0D) : Colors.white;
    final selectorBg = isDark ? const Color(0xFF1A3A2E) : const Color(0xFFE8F5F0);
    final selectorBorder = isDark ? const Color(0xFF244D3A) : const Color(0xFFB2DFDB);
    final textColor = isDark ? Colors.white : Colors.black87;
    final subtleText = isDark ? Colors.white60 : Colors.grey.shade600;

    return Scaffold(
      backgroundColor: bgColor,
      body: Column(
        children: [
          // ── Fixed Header ──
          Container(
            color: headerBg,
            child: SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Top bar
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: Icon(Icons.arrow_back_ios,
                              color: textColor, size: 20),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Jadwal Shalat',
                            style: GoogleFonts.outfit(
                              color: textColor,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        // Dark/Light toggle button (moon/sun icon in rounded box)
                        GestureDetector(
                          onTap: () {
                            final newMode = isDark ? 'Hijau' : 'Gelap';
                            settings.setThemeModeStr(newMode);
                          },
                          child: Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: isDark
                                  ? const Color(0xFF1E1E1E)
                                  : const Color(0xFFEEEEEE),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Center(
                              child: Icon(
                                isDark
                                    ? Icons.nightlight_round
                                    : Icons.wb_sunny_rounded,
                                color: isDark ? Colors.white : Colors.black54,
                                size: 20,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // ── Hero banner ──
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 56,
                          height: 56,
                          decoration: BoxDecoration(
                            color: primaryColor,
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: const Center(
                            child: Icon(Icons.mosque_outlined,
                                color: Colors.white, size: 28),
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Jadwalkan shalatmu,',
                                style: GoogleFonts.outfit(
                                  color: textColor,
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                'kuatkan iman dan raih\nkeberkahan setiap hari.',
                                style: GoogleFonts.outfit(
                                  color: subtleText,
                                  fontSize: 13,
                                  height: 1.4,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // ── Selectors Row 1 ──
                    Row(
                      children: [
                        Expanded(
                          child: _buildSelector(
                            label: 'Provinsi',
                            icon: Icons.location_on,
                            value: _selectedProvince,
                            selectorBg: selectorBg,
                            selectorBorder: selectorBorder,
                            textColor: textColor,
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
                          child: _buildSelector(
                            label: 'Kota/Kab',
                            icon: Icons.apartment_rounded,
                            value: _selectedCity,
                            selectorBg: selectorBg,
                            selectorBorder: selectorBorder,
                            textColor: textColor,
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
                    const SizedBox(height: 10),

                    // ── Selectors Row 2 ──
                    Row(
                      children: [
                        Expanded(
                          child: _buildDropdown(
                            label: 'Bulan',
                            icon: Icons.calendar_month_rounded,
                            value: _selectedMonth.toString(),
                            items: List.generate(12, (i) => (i + 1).toString()),
                            itemLabels: _monthNames,
                            selectorBg: selectorBg,
                            selectorBorder: selectorBorder,
                            textColor: textColor,
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
                          child: _buildDropdown(
                            label: 'Tahun',
                            icon: Icons.calendar_month_rounded,
                            value: _selectedYear.toString(),
                            items: ['2025', '2026', '2027'],
                            selectorBg: selectorBg,
                            selectorBorder: selectorBorder,
                            textColor: textColor,
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

          // ── Scrollable Content ──
          Expanded(
            child: _isLoading
                ? const Center(
                    child: CircularProgressIndicator(color: primaryColor))
                : _scheduleData == null
                    ? Center(
                        child: Text('Data tidak tersedia',
                            style: TextStyle(color: subtleText)))
                    : ListView.builder(
                        padding: const EdgeInsets.only(top: 16, bottom: 40),
                        itemCount:
                            (_scheduleData!['jadwal'] as List? ?? []).length +
                                1,
                        itemBuilder: (context, index) {
                          final schedules =
                              _scheduleData!['jadwal'] as List? ?? [];
                          if (index == schedules.length) {
                            return _buildQuoteCard(isDark, textColor, subtleText);
                          }
                          final day = schedules[index];
                          return _buildDayCard(day, isDark, textColor, subtleText);
                        },
                      ),
          ),
        ],
      ),
    );
  }

  // ── Selector (clickable) ──
  Widget _buildSelector({
    required String label,
    required IconData icon,
    required String value,
    required Color selectorBg,
    required Color selectorBorder,
    required Color textColor,
    required VoidCallback onTap,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: GoogleFonts.outfit(
                fontSize: 12,
                color: textColor,
                fontWeight: FontWeight.w500)),
        const SizedBox(height: 6),
        GestureDetector(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 13),
            decoration: BoxDecoration(
              color: selectorBg,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: selectorBorder, width: 1),
            ),
            child: Row(
              children: [
                Icon(icon, color: primaryColor, size: 16),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    value,
                    style: GoogleFonts.outfit(
                        color: textColor,
                        fontSize: 13,
                        fontWeight: FontWeight.w500),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const Icon(Icons.keyboard_arrow_down_rounded,
                    color: primaryColor, size: 18),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // ── Dropdown Selector ──
  Widget _buildDropdown({
    required String label,
    required IconData icon,
    required String value,
    required List<String> items,
    List<String>? itemLabels,
    required Color selectorBg,
    required Color selectorBorder,
    required Color textColor,
    required ValueChanged<String?> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: GoogleFonts.outfit(
                fontSize: 12,
                color: textColor,
                fontWeight: FontWeight.w500)),
        const SizedBox(height: 6),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: selectorBg,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: selectorBorder, width: 1),
          ),
          child: Row(
            children: [
              Icon(icon, color: primaryColor, size: 16),
              const SizedBox(width: 8),
              Expanded(
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: items.contains(value)
                        ? value
                        : (items.isNotEmpty ? items.first : null),
                    isExpanded: true,
                    dropdownColor: selectorBg,
                    icon: const Icon(Icons.keyboard_arrow_down_rounded,
                        color: primaryColor, size: 18),
                    style: GoogleFonts.outfit(
                        color: textColor,
                        fontSize: 13,
                        fontWeight: FontWeight.w500),
                    items: items.asMap().entries.map((entry) {
                      return DropdownMenuItem(
                        value: entry.value,
                        child: Text(
                          itemLabels != null
                              ? itemLabels[entry.key]
                              : entry.value,
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

  // ── Day Card ──
  Widget _buildDayCard(
      Map<String, dynamic> day, bool isDark, Color textColor, Color subtleText) {
    final cardBg = isDark ? const Color(0xFF1A1A1A) : Colors.white;
    final cardBorder =
        isDark ? const Color(0xFF2A2A2A) : Colors.grey.shade200;

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 14),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: cardBorder, width: 1),
      ),
      child: Column(
        children: [
          // Header row
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 12, 12),
            child: Row(
              children: [
                Icon(Icons.calendar_month_rounded,
                    color: primaryColor, size: 20),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    _formatDayTitle(day),
                    style: GoogleFonts.outfit(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: textColor,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () => _copySchedule(day),
                  child: Icon(
                    Icons.calendar_today_outlined,
                    size: 18,
                    color: isDark ? Colors.white30 : Colors.grey.shade400,
                  ),
                ),
              ],
            ),
          ),

          // Prayer time boxes (horizontal scroll)
          SizedBox(
            height: 90,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.only(left: 12, right: 12, bottom: 14),
              itemCount: _prayerMeta.length,
              itemBuilder: (context, index) {
                final meta = _prayerMeta[index];
                return _buildTimeBox(
                  label: meta['label'] as String,
                  icon: meta['icon'] as IconData,
                  time: day[meta['key']] ?? '--:--',
                  isDark: isDark,
                  subtleText: subtleText,
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  String _formatDayTitle(Map<String, dynamic> day) {
    final hari = day['hari']?.toString() ?? '';
    final tanggal = day['tanggal']?.toString() ?? '';
    // Extract day number from full date string
    final dayNum = tanggal.split(' ').first.trim();
    return '$hari, $dayNum';
  }

  void _copySchedule(Map<String, dynamic> day) {
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
      SnackBar(
        content: Text('Jadwal berhasil disalin!',
            style: GoogleFonts.outfit(color: Colors.white)),
        duration: const Duration(seconds: 2),
        backgroundColor: primaryColor,
        behavior: SnackBarBehavior.floating,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  // ── Single Time Box ──
  Widget _buildTimeBox({
    required String label,
    required IconData icon,
    required String time,
    required bool isDark,
    required Color subtleText,
  }) {
    final boxBg = isDark ? const Color(0xFF272727) : const Color(0xFFF5F5F5);
    final boxBorder =
        isDark ? const Color(0xFF333333) : Colors.grey.shade200;
    final iconColor = isDark ? Colors.white60 : Colors.grey.shade600;

    return Container(
      width: 72,
      margin: const EdgeInsets.only(right: 8),
      decoration: BoxDecoration(
        color: boxBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: boxBorder, width: 1),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            label,
            style: GoogleFonts.outfit(
              fontSize: 10,
              color: subtleText,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 6),
          Icon(icon, size: 18, color: iconColor),
          const SizedBox(height: 6),
          Text(
            time,
            style: GoogleFonts.outfit(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: primaryColor,
            ),
          ),
        ],
      ),
    );
  }

  // ── Quote Card ──
  Widget _buildQuoteCard(bool isDark, Color textColor, Color subtleText) {
    final cardBg = isDark ? const Color(0xFF1A1A1A) : Colors.white;
    final cardBorder =
        isDark ? const Color(0xFF2A2A2A) : Colors.grey.shade200;
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: cardBorder, width: 1),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.format_quote_rounded, color: primaryColor, size: 28),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Sesungguhnya shalat itu adalah tiang agama.',
                  style: GoogleFonts.outfit(
                    color: textColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'HR. Bukhari & Muslim',
                  style: GoogleFonts.outfit(
                    color: primaryColor,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
