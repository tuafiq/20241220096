import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:hijri/hijri_calendar.dart';
import 'holiday_model.dart';
import 'holiday_service.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  final HolidayService _holidayService = HolidayService();
  Map<DateTime, List<Holiday>> _holidays = {};
  bool _isLoading = true;

  static const indonesianMonths = [
    'Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni',
    'Juli', 'Agustus', 'September', 'Oktober', 'November', 'Desember'
  ];

  static const hijriMonths = [
    '', 'Muharram', 'Shafar', 'Rabiul Awal', 'Rabiul Akhir', 'Jumadil Awal', 'Jumadil Akhir',
    'Rajab', 'Sya\'ban', 'Ramadhan', 'Syawal', 'Dzulqa\'dah', 'Dzulhijjah'
  ];

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
    // Fetch current year, and also next/prev year to be safe for 2026-2027
    _fetchAllHolidays();
  }

  Future<void> _fetchAllHolidays() async {
    setState(() => _isLoading = true);

    // Fetch 2026 and 2027 to ensure both are loaded
    final list2026 = await _holidayService.getHolidays(2026);
    final list2027 = await _holidayService.getHolidays(2027);
    
    // Also fetch current year if it's not 2026 or 2027
    final currentYear = DateTime.now().year;
    List<Holiday> listCurrent = [];
    if (currentYear != 2026 && currentYear != 2027) {
      listCurrent = await _holidayService.getHolidays(currentYear);
    }

    final newHolidaysMap = <DateTime, List<Holiday>>{};
    final allHolidays = [...list2026, ...list2027, ...listCurrent];

    for (var holiday in allHolidays) {
      final normalizedDate = DateTime.utc(holiday.date.year, holiday.date.month, holiday.date.day);
      if (newHolidaysMap[normalizedDate] == null) {
        newHolidaysMap[normalizedDate] = [];
      }
      // Prevent duplicates
      bool exists = newHolidaysMap[normalizedDate]!.any((h) => h.description == holiday.description);
      if (!exists) {
        newHolidaysMap[normalizedDate]!.add(holiday);
      }
    }

    if (mounted) {
      setState(() {
        _holidays = newHolidaysMap;
        _isLoading = false;
      });
    }
  }

  List<Holiday> _getEventsForDay(DateTime day) {
    final normalizedDate = DateTime.utc(day.year, day.month, day.day);
    return _holidays[normalizedDate] ?? [];
  }

  String _toArabic(int number) {
    const digits = ['٠', '١', '٢', '٣', '٤', '٥', '٦', '٧', '٨', '٩'];
    return number.toString().split('').map((e) => digits[int.parse(e)]).join();
  }

  String _getPasaran(DateTime date) {
    const pasaran = ['Legi', 'Pahing', 'Pon', 'Wage', 'Kliwon'];
    // Base date: 7 May 2026 is Wage (index 3).
    final baseDate = DateTime(2026, 5, 7);
    final diff = DateTime(date.year, date.month, date.day).difference(baseDate).inDays;
    int index = (3 + diff) % 5;
    if (index < 0) index += 5;
    return pasaran[index];
  }

  String _getHijriRange() {
    final firstDay = DateTime(_focusedDay.year, _focusedDay.month, 1);
    final lastDay = DateTime(_focusedDay.year, _focusedDay.month + 1, 0);
    final hFirst = HijriCalendar.fromDate(firstDay);
    final hLast = HijriCalendar.fromDate(lastDay);
    
    if (hFirst.hMonth == hLast.hMonth) {
      return '${hijriMonths[hFirst.hMonth]} ${hFirst.hYear}';
    } else {
      if (hFirst.hYear == hLast.hYear) {
        return '${hijriMonths[hFirst.hMonth]} - ${hijriMonths[hLast.hMonth]} ${hFirst.hYear}';
      } else {
        return '${hijriMonths[hFirst.hMonth]} ${hFirst.hYear} - ${hijriMonths[hLast.hMonth]} ${hLast.hYear}';
      }
    }
  }

  Widget _buildDayCell(DateTime day, {bool isSelected = false, bool isOutside = false}) {
    final hDate = HijriCalendar.fromDate(day);
    final pasaran = _getPasaran(day);
    final isSunday = day.weekday == DateTime.sunday;
    final isHoliday = _getEventsForDay(day).isNotEmpty;
    final isRed = isSunday || isHoliday;
    
    Color textColor = isOutside ? Colors.grey[300]! : (isRed ? Colors.red : Colors.black87);
    Color pasaranColor = isOutside ? Colors.grey[300]! : Colors.grey[500]!;

    return Container(
      margin: const EdgeInsets.all(2),
      decoration: isSelected 
        ? BoxDecoration(
            border: Border.all(color: Colors.blue.withOpacity(0.5), width: 1.5),
            borderRadius: BorderRadius.circular(8),
            color: Colors.blue.withOpacity(0.05),
          ) 
        : null,
      child: Stack(
        children: [
          // Hijri Top Left
          Positioned(
            top: 2,
            left: 4,
            child: Text(
              _toArabic(hDate.hDay),
              style: TextStyle(fontSize: 10, color: isOutside ? Colors.grey[300] : Colors.black54),
            ),
          ),
          // Center Date
          Center(
            child: Text(
              '${day.day}',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
          ),
          // Bottom Pasaran
          Positioned(
            bottom: 8,
            left: 0,
            right: 0,
            child: Text(
              pasaran,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 9, color: pasaranColor),
            ),
          ),
          // Holiday Dot
          if (isHoliday && !isOutside)
            Positioned(
              bottom: 2,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 4,
                    height: 4,
                    decoration: const BoxDecoration(
                      color: Colors.red,
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
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text('Kalender', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFF13A884),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Custom Header
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back_ios, color: Color(0xFF13A884), size: 18),
                  onPressed: () {
                    setState(() {
                      _focusedDay = DateTime(_focusedDay.year, _focusedDay.month - 1, 1);
                    });
                  },
                ),
                Column(
                  children: [
                    Text(
                      '${indonesianMonths[_focusedDay.month - 1]} ${_focusedDay.year}',
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      _getHijriRange(),
                      style: TextStyle(color: Colors.grey[700], fontSize: 13),
                    ),
                  ],
                ),
                IconButton(
                  icon: const Icon(Icons.arrow_forward_ios, color: Color(0xFF13A884), size: 18),
                  onPressed: () {
                    setState(() {
                      _focusedDay = DateTime(_focusedDay.year, _focusedDay.month + 1, 1);
                    });
                  },
                ),
              ],
            ),
          ),
          // Calendar Grid
          Container(
            color: Colors.white,
            child: Stack(
              children: [
                TableCalendar<Holiday>(
                  firstDay: DateTime.utc(2020, 1, 1),
                  lastDay: DateTime.utc(2030, 12, 31),
                  focusedDay: _focusedDay,
                  selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                  startingDayOfWeek: StartingDayOfWeek.sunday,
                  headerVisible: false,
                  rowHeight: 58, 
                  daysOfWeekHeight: 30,
                  calendarBuilders: CalendarBuilders(
                    dowBuilder: (context, day) {
                      final text = ['Senin', 'Selasa', 'Rabu', 'Kamis', 'Jumat', 'Sabtu', 'Ahad'][day.weekday - 1];
                      return Center(
                        child: Text(
                          text,
                          style: TextStyle(
                            color: Colors.grey[700],
                            fontSize: 13,
                          ),
                        ),
                      );
                    },
                    defaultBuilder: (context, day, focusedDay) => _buildDayCell(day),
                    todayBuilder: (context, day, focusedDay) => _buildDayCell(day),
                    selectedBuilder: (context, day, focusedDay) => _buildDayCell(day, isSelected: true),
                    outsideBuilder: (context, day, focusedDay) => _buildDayCell(day, isOutside: true),
                  ),
                  onDaySelected: (selectedDay, focusedDay) {
                    setState(() {
                      _selectedDay = selectedDay;
                      _focusedDay = focusedDay; // update focused day to keep it in sync
                    });
                  },
                  onPageChanged: (focusedDay) {
                    setState(() {
                      _focusedDay = focusedDay;
                    });
                  },
                ),
                if (_isLoading)
                  Positioned.fill(
                    child: Container(
                      color: Colors.white.withOpacity(0.7),
                      child: const Center(
                        child: CircularProgressIndicator(color: Color(0xFF13A884)),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 12.0),
          // Holidays List for the current month
          Expanded(
            child: Container(
              color: Colors.white,
              child: _buildHolidayList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHolidayList() {
    // Get all holidays for current month
    List<Holiday> currentMonthHolidays = [];
    _holidays.forEach((date, list) {
      if (date.month == _focusedDay.month && date.year == _focusedDay.year) {
        currentMonthHolidays.addAll(list);
      }
    });

    currentMonthHolidays.sort((a, b) => a.date.compareTo(b.date));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
          child: Row(
            children: [
              Container(width: 4, height: 16, color: const Color(0xFF8D6E63)),
              const SizedBox(width: 8),
              const Text('Hari Besar & Libur Nasional', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              const Spacer(),
              const Icon(Icons.keyboard_arrow_up, color: Color(0xFF13A884)),
            ],
          ),
        ),
        const Divider(height: 1),
        if (currentMonthHolidays.isEmpty)
          Expanded(
            child: Center(
              child: Text('Tidak ada hari besar/libur di bulan ini.', style: TextStyle(color: Colors.grey[500])),
            ),
          )
        else
          Expanded(
            child: ListView.builder(
              itemCount: currentMonthHolidays.length,
              itemBuilder: (context, index) {
                final holiday = currentMonthHolidays[index];
                final hDate = HijriCalendar.fromDate(holiday.date);
                final dayName = ['Senin', 'Selasa', 'Rabu', 'Kamis', 'Jumat', 'Sabtu', 'Ahad'][holiday.date.weekday - 1];
                final monthStr = indonesianMonths[holiday.date.month - 1].substring(0, 3);
                
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 52,
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey[300]!),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          children: [
                            Text(monthStr, style: TextStyle(color: Colors.grey[600], fontSize: 12)),
                            Text('${holiday.date.day}', style: const TextStyle(color: Colors.blue, fontWeight: FontWeight.bold, fontSize: 18)),
                          ],
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              holiday.description,
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              '$dayName, ${holiday.date.day} ${indonesianMonths[holiday.date.month - 1]} ${holiday.date.year} / ${hDate.hDay} ${hijriMonths[hDate.hMonth]} ${hDate.hYear}',
                              style: TextStyle(color: Colors.grey[600], fontSize: 12),
                            ),
                            const SizedBox(height: 16),
                            const Divider(height: 1),
                          ],
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.only(top: 4.0),
                        child: Icon(Icons.info, size: 16, color: Colors.grey),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
      ],
    );
  }
}
