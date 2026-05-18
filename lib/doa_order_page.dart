import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'settings_provider.dart';
import 'doa_data.dart';

class DoaOrderPage extends StatefulWidget {
  const DoaOrderPage({Key? key}) : super(key: key);

  @override
  State<DoaOrderPage> createState() => _DoaOrderPageState();
}

class _DoaOrderPageState extends State<DoaOrderPage> {
  late List<DoaModel> _doaList;

  @override
  void initState() {
    super.initState();
    // Initialize from provider or default data
    final settings = context.read<SettingsProvider>();
    if (settings.doaOrder.isNotEmpty) {
      _doaList = [];
      for (var title in settings.doaOrder) {
        final doa = DoaData.listDoaHarian.firstWhere((d) => d.title == title, orElse: () => DoaData.listDoaHarian.first);
        if (!_doaList.contains(doa)) {
          _doaList.add(doa);
        }
      }
      // Add any missing ones
      for (var doa in DoaData.listDoaHarian) {
        if (!_doaList.contains(doa)) {
          _doaList.add(doa);
        }
      }
    } else {
      _doaList = List.from(DoaData.listDoaHarian);
    }
  }

  void _onReorder(int oldIndex, int newIndex) {
    setState(() {
      if (newIndex > oldIndex) {
        newIndex -= 1;
      }
      final DoaModel item = _doaList.removeAt(oldIndex);
      _doaList.insert(newIndex, item);
    });
    
    // Save to settings
    final settings = context.read<SettingsProvider>();
    settings.setDoaOrder(_doaList.map((e) => e.title).toList());
  }

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF13A884);
    
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7F8),
      appBar: AppBar(
        title: const Text('Urutan Doa', style: TextStyle(color: Colors.white)),
        backgroundColor: primaryColor,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: ReorderableListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _doaList.length,
        onReorder: _onReorder,
        itemBuilder: (context, index) {
          final doa = _doaList[index];
          return Card(
            key: ValueKey(doa.title),
            margin: const EdgeInsets.only(bottom: 12),
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: BorderSide(color: primaryColor.withOpacity(0.2)),
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              leading: Container(
                width: 32,
                height: 32,
                decoration: const BoxDecoration(
                  color: Color(0xFFE8F5F1),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    '${index + 1}',
                    style: const TextStyle(
                      color: primaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              title: Text(
                doa.title,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              trailing: const Icon(Icons.drag_handle, color: Colors.grey),
            ),
          );
        },
      ),
    );
  }
}
