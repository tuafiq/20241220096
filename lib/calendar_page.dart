import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:hijri/hijri_calendar.dart';
import 'package:provider/provider.dart';
import 'settings_provider.dart';
import 'holiday_model.dart';
import 'holiday_service.dart';
import 'all_holidays_page.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  bool _isSearching = false;
  bool _isExpanded = true;
  final TextEditingController _searchController = TextEditingController();

  final HolidayService _holidayService = HolidayService();
  Map<DateTime, List<Holiday>> _holidays = {};
  List<Holiday> _allHolidaysList = [];
  bool _isLoading = true;

  static const indonesianMonths = [
    'Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni',
    'Juli', 'Agustus', 'September', 'Oktober', 'November', 'Desember'
  ];

  static const hijriMonths = [
    '', 'Muharram', 'Shafar', 'Rabiul Awal', 'Rabiul Akhir', 'Jumadil Awal', 'Jumadil Akhir',
    'Rajab', 'Sya\'ban', 'Ramadhan', 'Syawal', 'Dzulqa\'dah', 'Dzulhijjah'
  ];

  final Color primaryGreen = const Color(0xFF0C5441);
  final Color accentGreen = const Color(0xFF13A884);

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
    _fetchAllHolidays();
  }

  Future<void> _fetchAllHolidays() async {
    if (!mounted) return;
    setState(() => _isLoading = true);

    try {
      final currentYear = DateTime.now().year;
      final yearsToFetch = [currentYear - 1, currentYear, currentYear + 1];
      
      final List<Holiday> fetchedHolidays = [];
      for (var year in yearsToFetch) {
        final list = await _holidayService.getHolidays(year);
        fetchedHolidays.addAll(list);
      }

      final newHolidaysMap = <DateTime, List<Holiday>>{};
      for (var holiday in fetchedHolidays) {
        final normalizedDate = DateTime.utc(holiday.date.year, holiday.date.month, holiday.date.day);
        if (newHolidaysMap[normalizedDate] == null) {
          newHolidaysMap[normalizedDate] = [];
        }
        bool exists = newHolidaysMap[normalizedDate]!.any((h) => h.description == holiday.description);
        if (!exists) {
          newHolidaysMap[normalizedDate]!.add(holiday);
        }
      }

      if (mounted) {
        setState(() {
          _allHolidaysList = fetchedHolidays;
          _holidays = newHolidaysMap;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  List<Holiday> _getEventsForDay(DateTime day) {
    final normalizedDate = DateTime.utc(day.year, day.month, day.day);
    return _holidays[normalizedDate] ?? [];
  }

  String _getPasaran(DateTime date) {
    const pasaran = ['Legi', 'Pahing', 'Pon', 'Wage', 'Kliwon'];
    final baseDate = DateTime(2026, 5, 14);
    final diff = DateTime(date.year, date.month, date.day).difference(baseDate).inDays;
    int index = (0 + diff) % 5;
    if (index < 0) index += 5;
    return pasaran[index];
  }

  String _getHijriRange() {
    final firstDay = DateTime(_focusedDay.year, _focusedDay.month, 1);
    final lastDay = DateTime(_focusedDay.year, _focusedDay.month + 1, 0);
    final hFirst = HijriCalendar.fromDate(firstDay);
    final hLast = HijriCalendar.fromDate(lastDay);
    
    return '${hijriMonths[hFirst.hMonth]} - ${hijriMonths[hLast.hMonth]} ${hFirst.hYear}';
  }

  Widget _buildDayCell(DateTime day, bool isDarkMode, {bool isSelected = false, bool isOutside = false, bool isToday = false}) {
    final hDate = HijriCalendar.fromDate(day);
    final pasaran = _getPasaran(day);
    final isSunday = day.weekday == DateTime.sunday;
    final isHoliday = _getEventsForDay(day).isNotEmpty;
    final isRed = isSunday || isHoliday;
    
    Color textColor = isSelected 
        ? Colors.white 
        : (isOutside 
            ? (isDarkMode ? Colors.grey[800]! : Colors.grey[300]!) 
            : (isRed 
                ? Colors.red 
                : (isDarkMode ? Colors.white : Colors.black87)));
    Color pasaranColor = isSelected 
        ? Colors.white.withOpacity(0.9) 
        : (isOutside 
            ? (isDarkMode ? Colors.grey[800]! : Colors.grey[300]!) 
            : (isDarkMode ? Colors.white30 : Colors.grey[500]!));
    Color hijriColor = isSelected 
        ? Colors.white.withOpacity(0.8) 
        : (isOutside 
            ? (isDarkMode ? Colors.grey[800]! : Colors.grey[300]!) 
            : (isDarkMode ? Colors.white38 : Colors.black54));

    return Container(
      margin: const EdgeInsets.all(2),
      decoration: isSelected 
        ? BoxDecoration(
            color: accentGreen,
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: accentGreen.withOpacity(0.3),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ) 
        : null,
      child: Stack(
        children: [
          Positioned(
            top: 2,
            right: 4,
            child: Text(
              '${hDate.hDay}',
              style: TextStyle(fontSize: 9, color: hijriColor),
            ),
          ),
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '${day.day}',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                ),
                const SizedBox(height: 1),
                Text(
                  pasaran,
                  style: TextStyle(fontSize: 8, color: pasaranColor),
                ),
              ],
            ),
          ),
          if (isHoliday && !isOutside)
            Positioned(
              bottom: 4,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 4,
                    height: 4,
                    decoration: BoxDecoration(
                      color: isSelected ? Colors.white : Colors.red,
                      shape: BoxShape.circle,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final settings = Provider.of<SettingsProvider>(context);
    final isDarkMode = settings.themeModeStr == 'Gelap';

    return Scaffold(
      backgroundColor: isDarkMode ? const Color(0xFF121212) : Colors.grey[100],
      appBar: AppBar(
        title: _isSearching
            ? TextField(
                controller: _searchController,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  hintText: 'Cari tanggal atau hari besar...',
                  hintStyle: TextStyle(color: Colors.white70),
                  border: InputBorder.none,
                ),
                onSubmitted: (value) => _navigateToHoliday(value),
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Kalender', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
                  Text('Hijriah & Masehi', style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 12, fontWeight: FontWeight.normal)),
                ],
              ),
        backgroundColor: primaryGreen,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(_isSearching ? Icons.close : Icons.search, color: Colors.white),
            onPressed: () {
              setState(() {
                _isSearching = !_isSearching;
                if (!_isSearching) _searchController.clear();
              });
            },
          ),
          IconButton(
            icon: const Icon(Icons.calendar_month, color: Colors.white),
            tooltip: 'Hari Ini',
            onPressed: () {
              setState(() {
                _focusedDay = DateTime.now();
                _selectedDay = DateTime.now();
              });
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 40,
              decoration: BoxDecoration(
                color: primaryGreen,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
            ),
            Transform.translate(
              offset: const Offset(0, -30),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: isDarkMode ? const Color(0xFF1E1E1E) : Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4)),
                        ],
                      ),
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                _buildCircleArrow(Icons.arrow_back_ios_new, isDarkMode, () {
                                  setState(() {
                                    _focusedDay = DateTime(_focusedDay.year, _focusedDay.month - 1, 1);
                                  });
                                }),
                                Column(
                                  children: [
                                    Text(
                                      '${indonesianMonths[_focusedDay.month - 1]} ${_focusedDay.year}',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20,
                                        color: isDarkMode ? Colors.white : Colors.black87,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      _getHijriRange(),
                                      style: TextStyle(color: accentGreen, fontSize: 13, fontWeight: FontWeight.w500),
                                    ),
                                  ],
                                ),
                                _buildCircleArrow(Icons.arrow_forward_ios, isDarkMode, () {
                                  setState(() {
                                    _focusedDay = DateTime(_focusedDay.year, _focusedDay.month + 1, 1);
                                  });
                                }),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),
                          TableCalendar<Holiday>(
                            firstDay: DateTime.utc(2020, 1, 1),
                            lastDay: DateTime.utc(2030, 12, 31),
                            focusedDay: _focusedDay,
                            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                            startingDayOfWeek: StartingDayOfWeek.sunday,
                            headerVisible: false,
                            rowHeight: 62, 
                            daysOfWeekHeight: 30,
                            calendarBuilders: CalendarBuilders(
                              dowBuilder: (context, day) {
                                final text = ['Senin', 'Selasa', 'Rabu', 'Kamis', 'Jumat', 'Sabtu', 'Ahad'][day.weekday - 1];
                                final isSunday = day.weekday == DateTime.sunday;
                                return Center(
                                  child: Text(
                                    text,
                                    style: TextStyle(
                                      color: isSunday ? Colors.red : (isDarkMode ? Colors.white70 : Colors.grey[700]),
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                );
                              },
                              defaultBuilder: (context, day, focusedDay) => _buildDayCell(day, isDarkMode),
                              todayBuilder: (context, day, focusedDay) => _buildDayCell(day, isDarkMode, isToday: true, isSelected: isSameDay(_selectedDay, day)),
                              selectedBuilder: (context, day, focusedDay) => _buildDayCell(day, isDarkMode, isSelected: true),
                              outsideBuilder: (context, day, focusedDay) => _buildDayCell(day, isDarkMode, isOutside: true),
                            ),
                            onDaySelected: (selectedDay, focusedDay) {
                              setState(() {
                                _selectedDay = selectedDay;
                                _focusedDay = focusedDay;
                              });
                            },
                            onPageChanged: (focusedDay) {
                              setState(() {
                                _focusedDay = focusedDay;
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                    if (_selectedDay != null && _getEventsForDay(_selectedDay!).isNotEmpty)
                      _buildSelectedDayDetail(isDarkMode),
                    const SizedBox(height: 20),
                    Container(
                      decoration: BoxDecoration(
                        color: isDarkMode ? const Color(0xFF1E1E1E) : Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4)),
                        ],
                      ),
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          InkWell(
                            onTap: () => setState(() => _isExpanded = !_isExpanded),
                            child: Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(6),
                                  decoration: BoxDecoration(color: accentGreen.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
                                  child: Icon(Icons.calendar_today, color: accentGreen, size: 20),
                                ),
                                const SizedBox(width: 12),
                                Text(
                                  'Hari Besar & Libur Nasional',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                    color: isDarkMode ? Colors.white : Colors.black87,
                                  ),
                                ),
                                const Spacer(),
                                Icon(_isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down, color: Colors.grey),
                              ],
                            ),
                          ),
                          if (_isExpanded) ...[
                            const SizedBox(height: 16),
                            _buildHolidayList(isDarkMode),
                            const SizedBox(height: 16),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: () {
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => AllHolidaysPage(holidays: _allHolidaysList)));
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: accentGreen,
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                  padding: const EdgeInsets.symmetric(vertical: 12),
                                  elevation: 0,
                                ),
                                child: const Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text('Lihat Semua Hari Besar', style: TextStyle(fontWeight: FontWeight.bold)),
                                    SizedBox(width: 8),
                                    Icon(Icons.arrow_forward, size: 18),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSelectedDayDetail(bool isDarkMode) {
    final events = _getEventsForDay(_selectedDay!);
    return Container(
      margin: const EdgeInsets.only(top: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: accentGreen.withOpacity(0.05),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: accentGreen.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.info_outline, size: 18, color: Color(0xFF13A884)),
              const SizedBox(width: 8),
              Text(
                'Detail ${indonesianMonths[_selectedDay!.month - 1]} ${_selectedDay!.day}',
                style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF13A884)),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ...events.map((e) => Padding(
            padding: const EdgeInsets.only(bottom: 4.0),
            child: Text('• ${e.description}', style: TextStyle(fontWeight: FontWeight.w500, color: isDarkMode ? Colors.white70 : Colors.black87)),
          )),
        ],
      ),
    );
  }

  void _navigateToHoliday(String query) {
    final match = _allHolidaysList.where((h) => h.description.toLowerCase().contains(query.toLowerCase())).toList();
    if (match.isNotEmpty) {
      setState(() {
        _focusedDay = match.first.date;
        _selectedDay = match.first.date;
        _isSearching = false;
        _searchController.clear();
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Tidak ditemukan hari besar tersebut.')));
    }
  }

  Widget _buildCircleArrow(IconData icon, bool isDarkMode, VoidCallback onPressed) {
    return Container(
      decoration: BoxDecoration(
        color: isDarkMode ? const Color(0xFF2D2D2D) : Colors.grey[100],
        shape: BoxShape.circle,
      ),
      child: IconButton(
        icon: Icon(icon, color: accentGreen, size: 16),
        onPressed: onPressed,
        constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
        padding: EdgeInsets.zero,
      ),
    );
  }

  Widget _buildHolidayList(bool isDarkMode) {
    List<Holiday> currentMonthHolidays = [];
    _holidays.forEach((date, list) {
      if (date.month == _focusedDay.month && date.year == _focusedDay.year) {
        currentMonthHolidays.addAll(list);
      }
    });

    currentMonthHolidays.sort((a, b) => a.date.compareTo(b.date));

    if (_isLoading) {
      return const Center(child: Padding(padding: EdgeInsets.all(20.0), child: CircularProgressIndicator()));
    }

    if (currentMonthHolidays.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(20.0),
        child: Text(
          'Tidak ada hari libur di bulan ini.',
          style: TextStyle(color: isDarkMode ? Colors.white38 : Colors.grey[500], fontSize: 13),
        ),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: currentMonthHolidays.length,
      itemBuilder: (context, index) {
        final holiday = currentMonthHolidays[index];
        final hDate = HijriCalendar.fromDate(holiday.date);
        final dayName = ['Senin', 'Selasa', 'Rabu', 'Kamis', 'Jumat', 'Sabtu', 'Ahad'][holiday.date.weekday - 1];
        final monthStr = indonesianMonths[holiday.date.month - 1];
        
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: isDarkMode ? const Color(0xFF2D2D2D) : Colors.grey[50],
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: isDarkMode ? Colors.white10 : Colors.grey[200]!),
          ),
          child: Row(
            children: [
              Container(
                width: 50,
                padding: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  color: isDarkMode ? const Color(0xFF1E1E1E) : Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: isDarkMode ? Colors.white10 : Colors.grey[200]!),
                ),
                child: Column(
                  children: [
                    Text(monthStr.substring(0, 3), style: TextStyle(color: Colors.red[300], fontSize: 10, fontWeight: FontWeight.bold)),
                    Text('${holiday.date.day}', style: TextStyle(color: accentGreen, fontWeight: FontWeight.bold, fontSize: 18)),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      holiday.description,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: isDarkMode ? Colors.white : Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '$dayName, ${holiday.date.day} $monthStr ${holiday.date.year} / ${hDate.hDay} ${hijriMonths[hDate.hMonth]} ${hDate.hYear}',
                      style: TextStyle(color: isDarkMode ? Colors.white60 : Colors.grey[600], fontSize: 11),
                    ),
                  ],
                ),
              ),
              Icon(Icons.info_outline, size: 20, color: Colors.grey[400]),
            ],
          ),
        );
      },
    );
  }
}
