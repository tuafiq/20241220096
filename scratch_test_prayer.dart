import 'lib/prayer_service.dart';

void main() async {
  final service = PrayerService();
  try {
    print('Fetching provinces...');
    final provinces = await service.getProvinces();
    print('Provinces: ${provinces.take(5).toList()}');
    
    final prov = 'Jawa Timur';
    print('Fetching cities for $prov...');
    final cities = await service.getCities(prov);
    print('Cities: ${cities.take(5).toList()}');
    
    final city = cities.contains('Kab. Bangkalan') ? 'Kab. Bangkalan' : cities.first;
    print('Fetching monthly schedule for $prov, $city...');
    final schedule = await service.getMonthlySchedule(province: prov, city: city);
    print('Keys: ${schedule.keys}');
    final list = schedule['jadwal'] as List;
    print('First day schedule: ${list.first}');
  } catch (e) {
    print('Error: $e');
  }
}
