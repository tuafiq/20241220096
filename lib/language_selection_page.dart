import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'settings_provider.dart';

class LanguageSelectionPage extends StatelessWidget {
  const LanguageSelectionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<SettingsProvider>(
      builder: (context, settings, child) {
        String currentLang = settings.language;
        // Map localized strings to page representation
        String selectedRep = 'Indonesia';
        if (currentLang == 'Inggris' || currentLang == 'English') {
          selectedRep = 'English';
        } else if (currentLang == 'Arab' || currentLang == 'العربية') {
          selectedRep = 'العربية';
        }

        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: const Color(0xFF0C5441),
            elevation: 0,
            centerTitle: true,
            title: Text(
              settings.translate('lang_dialog'),
              style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
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
                  context,
                  settings,
                  'Indonesia',
                  '🇮🇩',
                  selectedRep == 'Indonesia',
                ),
                _buildLanguageItem(
                  context,
                  settings,
                  'English',
                  '🇺🇸',
                  selectedRep == 'English',
                ),
                _buildLanguageItem(
                  context,
                  settings,
                  'العربية',
                  '🇸🇦',
                  selectedRep == 'العربية',
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildLanguageItem(BuildContext context, SettingsProvider settings, String name, String flag, bool isSelected) {
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
          String valToSave = 'Indonesia';
          if (name == 'English') {
            valToSave = 'Inggris';
          } else if (name == 'العربية') {
            valToSave = 'Arab';
          }

          settings.setLanguage(valToSave);
          
          final message = valToSave == 'Inggris' 
              ? 'Language changed to English' 
              : (valToSave == 'Arab' ? 'تم تغيير اللغة إلى العربية' : 'Bahasa diubah ke Indonesia');

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(message), duration: const Duration(seconds: 1)),
          );
        },
      ),
    );
  }
}
