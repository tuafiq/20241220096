import 'package:flutter/material.dart';
import 'package:hijri/hijri_calendar.dart';
import 'holiday_model.dart';
import 'holiday_service.dart';

class AllHolidaysPage extends StatefulWidget {
  final List<Holiday> holidays;
  const AllHolidaysPage({super.key, required this.holidays});

  @override
  State<AllHolidaysPage> createState() => _AllHolidaysPageState();
}

class _AllHolidaysPageState extends State<AllHolidaysPage> {
  late List<Holiday> _filteredHolidays;
  final TextEditingController _searchController = TextEditingController();

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
    _filteredHolidays = List.from(widget.holidays);
    _filteredHolidays.sort((a, b) => a.date.compareTo(b.date));
  }

  void _filterHolidays(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredHolidays = List.from(widget.holidays);
      } else {
        _filteredHolidays = widget.holidays
            .where((h) => h.description.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
      _filteredHolidays.sort((a, b) => a.date.compareTo(b.date));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text('Semua Hari Besar', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFF0C5441),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.white,
            child: TextField(
              controller: _searchController,
              onChanged: _filterHolidays,
              decoration: InputDecoration(
                hintText: 'Cari hari besar...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                filled: true,
                fillColor: Colors.grey[100],
              ),
            ),
          ),
          Expanded(
            child: _filteredHolidays.isEmpty
                ? const Center(child: Text('Tidak ada hasil.'))
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _filteredHolidays.length,
                    itemBuilder: (context, index) {
                      final holiday = _filteredHolidays[index];
                      final hDate = HijriCalendar.fromDate(holiday.date);
                      final dayName = ['Senin', 'Selasa', 'Rabu', 'Kamis', 'Jumat', 'Sabtu', 'Ahad'][holiday.date.weekday - 1];

                      return Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(16),
                          leading: Container(
                            width: 50,
                            decoration: BoxDecoration(color: const Color(0xFF13A884).withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text('${holiday.date.day}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Color(0xFF13A884))),
                                Text(indonesianMonths[holiday.date.month - 1].substring(0, 3), style: const TextStyle(fontSize: 10)),
                              ],
                            ),
                          ),
                          title: Text(holiday.description, style: const TextStyle(fontWeight: FontWeight.bold)),
                          subtitle: Text(
                            '$dayName, ${holiday.date.day} ${indonesianMonths[holiday.date.month - 1]} ${holiday.date.year}\n${hDate.hDay} ${hijriMonths[hDate.hMonth]} ${hDate.hYear}',
                            style: TextStyle(color: Colors.grey[600], fontSize: 12),
                          ),
                          trailing: const Icon(Icons.info_outline, size: 20, color: Colors.grey),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
