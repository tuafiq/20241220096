import 'dart:async';
import 'dart:math' show pi;
import 'package:flutter/material.dart';
import 'package:flutter_qiblah/flutter_qiblah.dart';
import 'package:geolocator/geolocator.dart';

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
      appBar: AppBar(
        title: const Text('Arah Kiblat'),
        backgroundColor: const Color(0xFF13A884),
        foregroundColor: Colors.white,
      ),
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

class QiblahCompassWidget extends StatelessWidget {
  const QiblahCompassWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FlutterQiblah.qiblahStream,
      builder: (_, AsyncSnapshot<QiblahDirection> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        }
        
        if (snapshot.hasError) {
          return Center(
            child: Text("Error membaca sensor: ${snapshot.error.toString()}"),
          );
        }

        final qiblahDirection = snapshot.data!;
        
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Sejajarkan panah hijau dengan jarum kiblat",
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 10),
            Text(
              "${qiblahDirection.direction.toInt()}°",
              style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 40),
            Stack(
              alignment: Alignment.center,
              children: <Widget>[
                // Kompas (Utara, Selatan, Timur, Barat)
                Transform.rotate(
                  angle: (qiblahDirection.direction * (pi / 180) * -1),
                  child: _buildCompassBackground(),
                ),
                // Jarum Kiblat
                Transform.rotate(
                  angle: (qiblahDirection.qiblah * (pi / 180) * -1),
                  child: _buildQiblaNeedle(),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  Widget _buildCompassBackground() {
    return Container(
      width: 250,
      height: 250,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.grey.shade300, width: 2),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Lingkaran luar
          Container(
            width: 230,
            height: 230,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: const Color(0xFF13A884), width: 1.5),
            ),
          ),
          // Penanda Utara
          Positioned(
            top: 5,
            child: Text("U", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.red)),
          ),
          Positioned(
            bottom: 5,
            child: Text("S", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
          ),
          Positioned(
            left: 10,
            child: Text("B", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
          ),
          Positioned(
            right: 10,
            child: Text("T", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
          ),
        ],
      ),
    );
  }

  Widget _buildQiblaNeedle() {
    return Container(
      width: 250,
      height: 250,
      alignment: Alignment.center,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Gambar Ka'bah kecil atau panah kiblat
          const Icon(Icons.arrow_upward_rounded, size: 40, color: Color(0xFF13A884)),
          Container(
            width: 4,
            height: 100,
            decoration: BoxDecoration(
              color: const Color(0xFF13A884),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Container(
            width: 12,
            height: 12,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Color(0xFF13A884),
            ),
          ),
          const SizedBox(height: 120), // Balance the bottom
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
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        const Icon(
          Icons.location_off,
          size: 100,
          color: Colors.redAccent,
        ),
        const SizedBox(height: 32),
        Text(
          error ?? '',
          style: const TextStyle(fontSize: 16, color: Colors.black87),
        ),
        const SizedBox(height: 32),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF13A884),
            foregroundColor: Colors.white,
          ),
          onPressed: () {
            if (callback != null) callback!();
          },
          child: const Text("Coba Lagi"),
        )
      ],
    );
  }
}
