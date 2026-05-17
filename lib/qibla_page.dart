import 'dart:async';
import 'dart:math' show pi, atan2, sin, cos, tan;
import 'package:flutter/material.dart';
import 'package:flutter_qiblah/flutter_qiblah.dart';
import 'package:geolocator/geolocator.dart';
import 'city_data.dart';

class QiblaPage extends StatefulWidget {
  const QiblaPage({super.key});

  @override
  State<QiblaPage> createState() => _QiblaPageState();
}

class _QiblaPageState extends State<QiblaPage> {
  final _deviceSupport = FlutterQiblah.androidDeviceSensorSupport();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: _deviceSupport,
        builder: (_, AsyncSnapshot<bool?> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(
              child: Text("Error: ${snapshot.error.toString()}"),
            );
          }
          if (snapshot.data!) {
            return const QiblahCompass();
          } else {
            return const Center(
              child: Text(
                "Perangkat ini tidak memiliki sensor kompas.",
                style: TextStyle(fontSize: 16),
              ),
            );
          }
        },
      ),
    );
  }
}

class QiblahCompass extends StatefulWidget {
  const QiblahCompass({super.key});

  @override
  State<QiblahCompass> createState() => _QiblahCompassState();
}

class _QiblahCompassState extends State<QiblahCompass> {
  final _locationStreamController = StreamController<LocationStatus>.broadcast();

  get stream => _locationStreamController.stream;

  @override
  void initState() {
    super.initState();
    _checkLocationStatus();
  }

  @override
  void dispose() {
    _locationStreamController.close();
    FlutterQiblah().dispose();
    super.dispose();
  }

  Future<void> _checkLocationStatus() async {
    final locationStatus = await FlutterQiblah.checkLocationStatus();
    if (locationStatus.enabled &&
        locationStatus.status == LocationPermission.denied) {
      await FlutterQiblah.requestPermissions();
      final s = await FlutterQiblah.checkLocationStatus();
      _locationStreamController.sink.add(s);
    } else {
      _locationStreamController.sink.add(locationStatus);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.all(8.0),
      child: StreamBuilder(
        stream: stream,
        builder: (context, AsyncSnapshot<LocationStatus> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          }
          if (snapshot.data?.enabled == true) {
            switch (snapshot.data!.status) {
              case LocationPermission.always:
              case LocationPermission.whileInUse:
                return const QiblahCompassWidget();
              case LocationPermission.denied:
                return LocationErrorWidget(
                  error: "Izin lokasi ditolak",
                  callback: _checkLocationStatus,
                );
              case LocationPermission.deniedForever:
                return LocationErrorWidget(
                  error: "Izin lokasi ditolak secara permanen",
                  callback: _checkLocationStatus,
                );
              default:
                return Container();
            }
          } else {
            return LocationErrorWidget(
              error: "Tolong aktifkan layanan GPS/Lokasi Anda",
              callback: _checkLocationStatus,
            );
          }
        },
      ),
    );
  }
}



class QiblahCompassWidget extends StatefulWidget {
  const QiblahCompassWidget({super.key});

  @override
  State<QiblahCompassWidget> createState() => _QiblahCompassWidgetState();
}

class _QiblahCompassWidgetState extends State<QiblahCompassWidget> {
  City? _manualCity;

  double _calculateQibla(double lat, double lng) {
    double phiK = lat * pi / 180.0;
    double lambdaK = lng * pi / 180.0;
    double phiM = 21.422487 * pi / 180.0;
    double lambdaM = 39.826206 * pi / 180.0;

    double qibla = atan2(
      sin(lambdaM - lambdaK),
      cos(phiK) * tan(phiM) - sin(phiK) * cos(lambdaM - lambdaK)
    );

    double result = qibla * 180.0 / pi;
    if (result < 0) result += 360.0;
    return result;
  }

  void _showCityPicker() {
    String searchQuery = "";
    final TextEditingController searchController = TextEditingController();
    
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            final filteredCities = indonesianCities.where((city) => 
              city.name.toLowerCase().contains(searchQuery.toLowerCase())
            ).toList();

            return Container(
              height: MediaQuery.of(context).size.height * 0.75,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  const SizedBox(height: 12),
                  Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    "Pilih Kota/Kabupaten",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF13A884)),
                  ),
                  const SizedBox(height: 16),
                  // Search Bar
                  TextField(
                    controller: searchController,
                    onChanged: (value) {
                      setModalState(() {
                        searchQuery = value;
                      });
                    },
                    decoration: InputDecoration(
                      hintText: "Cari kota atau kabupaten",
                      prefixIcon: const Icon(Icons.search, color: Color(0xFF13A884)),
                      suffixIcon: searchQuery.isNotEmpty 
                        ? IconButton(
                            icon: const Icon(Icons.clear, size: 20),
                            onPressed: () {
                              setModalState(() {
                                searchQuery = "";
                                searchController.clear();
                              });
                            },
                          )
                        : null,
                      filled: true,
                      fillColor: Colors.grey.shade100,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(vertical: 0),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: ListView.builder(
                      itemCount: (searchQuery.isEmpty ? 1 : 0) + filteredCities.length,
                      itemBuilder: (context, index) {
                        if (searchQuery.isEmpty && index == 0) {
                          return ListTile(
                            leading: const CircleAvatar(
                              backgroundColor: Colors.blue,
                              child: Icon(Icons.my_location, color: Colors.white, size: 20),
                            ),
                            title: const Text("Gunakan Lokasi Saat Ini (GPS)", style: TextStyle(fontWeight: FontWeight.bold)),
                            onTap: () {
                              setState(() {
                                _manualCity = null;
                              });
                              Navigator.pop(context);
                            },
                          );
                        }
                        
                        final cityIndex = searchQuery.isEmpty ? index - 1 : index;
                        final city = filteredCities[cityIndex];
                        
                        return ListTile(
                          leading: const CircleAvatar(
                            backgroundColor: Color(0xFF13A884),
                            child: Icon(Icons.location_city, color: Colors.white, size: 20),
                          ),
                          title: Text(city.name),
                          subtitle: Text("Lat: ${city.latitude}, Lng: ${city.longitude}", style: const TextStyle(fontSize: 12)),
                          onTap: () {
                            setState(() {
                              _manualCity = city;
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
          }
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FlutterQiblah.qiblahStream,
      builder: (_, AsyncSnapshot<QiblahDirection> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        
        if (snapshot.hasError) {
          return Center(
            child: Text("Error membaca sensor: ${snapshot.error.toString()}"),
          );
        }

        final qiblahDirection = snapshot.data!;

        final double qiblaAngle = _manualCity != null 
            ? _calculateQibla(_manualCity!.latitude, _manualCity!.longitude)
            : qiblahDirection.qiblah;

        return Stack(
          children: [
            Positioned.fill(
              child: Opacity(
                opacity: 0.1,
                child: Image.asset(
                  'assets/images/islamic_pattern_bg.png',
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Opacity(
                opacity: 0.2,
                child: Image.asset(
                  'assets/images/mosque_silhouette_footer.png',
                  fit: BoxFit.fitWidth,
                ),
              ),
            ),
            Column(
              children: [
                _buildHeader(context),
                Expanded(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      child: Column(
                        children: [
                          const SizedBox(height: 20),
                          Image.asset(
                            'assets/images/kiblat_icon.png',
                            height: 100,
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            "Sejajarkan panah hijau",
                            style: TextStyle(fontSize: 18, color: Color(0xFF13A884), fontWeight: FontWeight.bold),
                          ),
                          const Text(
                            "dengan jarum kiblat",
                            style: TextStyle(fontSize: 16, color: Colors.grey),
                          ),
                          const SizedBox(height: 20),
                          Text(
                            "${qiblahDirection.direction.toInt()}°",
                            style: const TextStyle(
                              fontSize: 64,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF13A884),
                            ),
                          ),
                          _buildArahKiblatLabel(),
                          const SizedBox(height: 24),
                          _buildLocationCard(),
                          const SizedBox(height: 40),
                          _buildCompass(qiblahDirection, qiblaAngle),
                          const SizedBox(height: 40),
                          _buildFooterCard(),
                          const SizedBox(height: 40),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 40, bottom: 20, left: 16, right: 16),
      decoration: const BoxDecoration(
        color: Color(0xFF13A884),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
          const Text(
            "Arah Kiblat",
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          Image.asset(
            'assets/images/kiblat_icon.png',
            height: 40,
          ),
        ],
      ),
    );
  }

  Widget _buildArahKiblatLabel() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.diamond, size: 12, color: Colors.orange.shade300),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.0),
          child: Text(
            "Arah Kiblat",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.grey),
          ),
        ),
        Icon(Icons.diamond, size: 12, color: Colors.orange.shade300),
      ],
    );
  }

  Widget _buildLocationCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          const CircleAvatar(
            backgroundColor: Color(0xFF13A884),
            child: Icon(Icons.location_on, color: Colors.white),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Lokasi Terpilih",
                  style: TextStyle(fontSize: 12, color: Color(0xFF13A884), fontWeight: FontWeight.bold),
                ),
                Text(
                  _manualCity?.name ?? "Gunakan GPS (Otomatis)",
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Text(
                  _manualCity != null 
                      ? "Lat: ${_manualCity!.latitude}, Lng: ${_manualCity!.longitude}"
                      : "Mendeteksi lokasi otomatis...",
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          ),
          TextButton(
            onPressed: _showCityPicker,
            child: const Text("Ubah", style: TextStyle(color: Color(0xFF13A884), fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  Widget _buildCompass(QiblahDirection qiblahDirection, double qiblaAngle) {
    return Center(
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          _buildCompassBackground(qiblahDirection, qiblaAngle),
          Transform.rotate(
            angle: (qiblaAngle * (pi / 180) * -1),
            child: _buildQiblaNeedle(),
          ),
        ],
      ),
    );
  }

  Widget _buildCompassBackground(QiblahDirection qiblahDirection, double qiblaAngle) {
    return Container(
      width: 300,
      height: 300,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.grey.shade200, width: 1),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Opacity(
            opacity: 0.1,
            child: Image.asset('assets/images/islamic_pattern_bg.png', width: 200),
          ),
          ...List.generate(72, (index) {
            return Transform.rotate(
              angle: (index * 5) * (pi / 180),
              child: Align(
                alignment: Alignment.topCenter,
                child: Container(
                  height: index % 2 == 0 ? 15 : 10,
                  width: 1,
                  color: index % 18 == 0 ? const Color(0xFF13A884) : Colors.grey.shade300,
                ),
              ),
            );
          }),
          Transform.rotate(
            angle: (qiblahDirection.direction * (pi / 180) * -1),
            child: Stack(
              children: [
                _buildCardinalLabel("U", Alignment.topCenter, Colors.green),
                _buildCardinalLabel("S", Alignment.bottomCenter, Colors.black),
                _buildCardinalLabel("B", Alignment.centerLeft, Colors.black),
                _buildCardinalLabel("T", Alignment.centerRight, Colors.black),
                Transform.rotate(
                  angle: (qiblaAngle * (pi / 180)),
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: Image.asset('assets/images/kiblat_icon.png', height: 30),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCardinalLabel(String label, Alignment alignment, Color color) {
    return Align(
      alignment: alignment,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ),
    );
  }

  Widget _buildQiblaNeedle() {
    return Container(
      width: 300,
      height: 300,
      alignment: Alignment.center,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.keyboard_arrow_up, size: 48, color: Color(0xFF13A884)),
              const SizedBox(height: 100), 
            ],
          ),
          Container(
            width: 16,
            height: 16,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
              border: Border.all(color: const Color(0xFF13A884), width: 4),
              boxShadow: [
                BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 4),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFooterCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          const Icon(Icons.compass_calibration, color: Color(0xFF13A884), size: 32),
          const SizedBox(width: 16),
          const Expanded(
            child: Text(
              "Pastikan posisi perangkat dalam keadaan datar untuk hasil yang akurat",
              style: TextStyle(fontSize: 13, color: Colors.grey),
            ),
          ),
          const SizedBox(width: 8),
          Icon(Icons.check_circle, color: Colors.green.shade400, size: 24),
        ],
      ),
    );
  }
}

class LocationErrorWidget extends StatelessWidget {
  final String? error;
  final Function? callback;

  const LocationErrorWidget({super.key, this.error, this.callback});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(24),
        margin: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 20),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const Icon(
              Icons.location_off_rounded,
              size: 80,
              color: Colors.redAccent,
            ),
            const SizedBox(height: 24),
            Text(
              error ?? 'Terjadi kesalahan lokasi',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
            ),
            const SizedBox(height: 12),
            const Text(
              "Aplikasi memerlukan akses lokasi untuk menentukan arah kiblat yang akurat.",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF13A884),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: () {
                  if (callback != null) callback!();
                },
                child: const Text("Aktifkan Lokasi", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            )
          ],
        ),
      ),
    );
  }
}
