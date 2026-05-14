import 'package:flutter/material.dart';

class LanguageSelectionPage extends StatefulWidget {
  const LanguageSelectionPage({super.key});

  @override
  State<LanguageSelectionPage> createState() => _LanguageSelectionPageState();
}

class _LanguageSelectionPageState extends State<LanguageSelectionPage> {
  String _selectedLanguage = 'Indonesia';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF0C5441),
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Pilih Bahasa',
          style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Column(
          children: [
            _buildLanguageItem(
              'Indonesia',
              '🇮🇩',
            ),
            _buildLanguageItem(
              'English',
              '🇺🇸',
            ),
            _buildLanguageItem(
              'العربية',
              '🇸🇦',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLanguageItem(String name, String flag) {
    bool isSelected = _selectedLanguage == name;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: isSelected ? const Color(0xFF13A884).withOpacity(0.3) : Colors.grey[100]!),
        boxShadow: isSelected ? [
          BoxShadow(
            color: const Color(0xFF13A884).withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ] : null,
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        leading: Text(
          flag,
          style: const TextStyle(fontSize: 24),
        ),
        title: Text(
          name,
          style: TextStyle(
            fontSize: 16,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            color: Colors.black87,
          ),
        ),
        trailing: isSelected 
          ? const Icon(Icons.check, color: Color(0xFF13A884), size: 20)
          : null,
        onTap: () {
          setState(() {
            _selectedLanguage = name;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Bahasa diubah ke $name'), duration: const Duration(seconds: 1)),
          );
        },
      ),
    );
  }
}
