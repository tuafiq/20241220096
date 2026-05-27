import 'package:flutter/material.dart';
import 'doa_data.dart';
import 'wirid_data.dart';
import 'wirid_detail_page.dart';
import 'doa_detail_page.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'settings_provider.dart';
import 'dzikir_card.dart';




class WiridDoaPage extends StatefulWidget {
  final int initialIndex;
  const WiridDoaPage({super.key, this.initialIndex = 0});

  @override
  State<WiridDoaPage> createState() => _WiridDoaPageState();
}

class _WiridDoaPageState extends State<WiridDoaPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this, initialIndex: widget.initialIndex);
    _searchController.addListener(_filterDoa);
  }

  void _filterDoa() {
    setState(() {}); // Trigger rebuild to filter using search text
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF13A884);
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    
    final settings = context.watch<SettingsProvider>();
    List<DoaModel> orderedList = [];
    if (settings.doaOrder.isNotEmpty) {
      for (var title in settings.doaOrder) {
        final doa = DoaData.listDoaHarian.firstWhere((d) => d.title == title, orElse: () => DoaData.listDoaHarian.first);
        if (!orderedList.contains(doa)) orderedList.add(doa);
      }
      for (var doa in DoaData.listDoaHarian) {
        if (!orderedList.contains(doa)) orderedList.add(doa);
      }
    } else {
      orderedList = DoaData.listDoaHarian;
    }
    
    final query = _searchController.text.toLowerCase();
    final displayDoa = orderedList.where((doa) {
      return doa.title.toLowerCase().contains(query) ||
             doa.translation.toLowerCase().contains(query);
    }).toList();

    return Scaffold(
      backgroundColor: isDarkMode ? const Color(0xFF121212) : const Color(0xFFF5F7F8),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(140),
        child: Container(
          decoration: const BoxDecoration(
            color: primaryColor,
          ),
          child: SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.arrow_back, color: Colors.white),
                              onPressed: () => Navigator.pop(context),
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    settings.translate('title'),
                                    style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  Text(
                                    settings.translate('subtitle'),
                                    style: const TextStyle(color: Colors.white70, fontSize: 12),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 16.0),
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.white, width: 1.5),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: IconButton(
                            padding: EdgeInsets.zero,
                            icon: const Icon(Icons.settings, color: Colors.white, size: 24),
                            onPressed: () {
                              _showSettingsModal(context);
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  height: 45,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: TabBar(
                    controller: _tabController,
                    indicator: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                      color: Colors.white,
                    ),
                    indicatorSize: TabBarIndicatorSize.tab,
                    labelColor: primaryColor,
                    unselectedLabelColor: Colors.white,
                    dividerColor: Colors.transparent,
                    tabs: [
                      Tab(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.menu_book, size: 16),
                            const SizedBox(width: 8),
                            Text(settings.translate('wirid'), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                          ],
                        ),
                      ),
                      Tab(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(FontAwesomeIcons.handsPraying, size: 16),
                            const SizedBox(width: 8),
                            Text(settings.translate('doa_harian'), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildWiridTab(),
          Column(
            children: [
              _buildSearchBar(),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  itemCount: displayDoa.length,
                  itemBuilder: (context, index) {
                    return _buildDoaCard(displayDoa[index], index, displayDoa);
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildWiridTab() {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const DzikirCard(),
        const SizedBox(height: 16),
        ...wiridData.map((category) {
          IconData categoryIcon;
          switch (category.id) {
            case '1': categoryIcon = Icons.mosque; break;
            case '2': categoryIcon = Icons.access_time; break;
            case '3': categoryIcon = Icons.blur_on; break;
            case '4': categoryIcon = Icons.menu_book; break;
            case '5': categoryIcon = Icons.nights_stay; break;
            case '6': categoryIcon = Icons.calendar_month; break;
            default: categoryIcon = Icons.book;
          }

          return Container(
            margin: const EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
              color: isDarkMode ? const Color(0xFF1E1E1E) : Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFF13A884).withOpacity(isDarkMode ? 0.15 : 0.3), width: 1),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.02),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(16),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => WiridDetailPage(category: category),
                    ),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Text(
                        category.id,
                        style: const TextStyle(
                          color: Color(0xFF13A884),
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: isDarkMode ? const Color(0xFF203630) : const Color(0xFFF0F9F6),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(categoryIcon, color: const Color(0xFF13A884)),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              category.title,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: isDarkMode ? Colors.white : const Color(0xFF2D3436),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              category.subtitle,
                              style: TextStyle(
                                fontSize: 12,
                                color: isDarkMode ? Colors.white60 : Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Icon(
                        Icons.chevron_right,
                        size: 20,
                        color: Color(0xFF13A884),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }),
      ],
    );
  }

  Widget _buildSearchBar() {
    final settings = context.watch<SettingsProvider>();
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.all(16),
      color: isDarkMode ? const Color(0xFF121212) : Colors.white,
      child: TextField(
        controller: _searchController,
        style: TextStyle(color: isDarkMode ? Colors.white : Colors.black87),
        decoration: InputDecoration(
          hintText: settings.translate('search_hint'),
          hintStyle: TextStyle(color: isDarkMode ? Colors.white30 : Colors.grey),
          prefixIcon: const Icon(Icons.search, color: Color(0xFF13A884)),
          filled: true,
          fillColor: isDarkMode ? const Color(0xFF1E1E1E) : const Color(0xFFF1F3F4),
          contentPadding: const EdgeInsets.symmetric(horizontal: 20),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

  Widget _buildDoaCard(DoaModel doa, int index, List<DoaModel> displayDoaList) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: isDarkMode ? const Color(0xFF1E1E1E) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF13A884).withOpacity(isDarkMode ? 0.15 : 0.2), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => DoaDetailPage(
                  doa: doa,
                  doaList: displayDoaList,
                  currentIndex: index,
                ),
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Text(
                  '${index + 1}',
                  style: const TextStyle(
                    color: Color(0xFF13A884),
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(width: 16),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        doa.title,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: isDarkMode ? Colors.white : const Color(0xFF2D3436),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Bacaan doa harian',
                        style: TextStyle(
                          fontSize: 12,
                          color: isDarkMode ? Colors.white60 : Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(
                  Icons.chevron_right,
                  size: 20,
                  color: Color(0xFF13A884),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }



  void _showSettingsModal(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Consumer<SettingsProvider>(
          builder: (context, settings, child) {
            return Container(
          height: MediaQuery.of(context).size.height * 0.9,
          decoration: BoxDecoration(
            color: isDarkMode ? const Color(0xFF1E1E1E) : Colors.white,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(24),
              topRight: Radius.circular(24),
            ),
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      settings.translate('settings'),
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: isDarkMode ? Colors.white : const Color(0xFF2D3436),
                      ),
                    ),
                    InkWell(
                      onTap: () => Navigator.pop(context),
                      child: const Icon(Icons.close, color: Color(0xFF13A884), size: 28),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  children: [

                    _buildSettingsSectionTitle(settings.translate('appearance')),
                    _buildSettingsItem(
                      icon: Icons.text_fields,
                      title: settings.translate('font_size'),
                      subtitle: settings.translate('font_size_desc'),
                      trailingText: settings.fontSize,
                      onTap: () {
                        _showOptionsDialog(context, settings.translate('font_size_dialog'), ['Kecil', 'Sedang', 'Besar'], settings.fontSize, (val) {
                          settings.setFontSize(val);
                        });
                      },
                    ),
                    _buildSettingsItem(
                      icon: Icons.font_download,
                      title: settings.translate('font_style'),
                      subtitle: settings.translate('font_style_desc'),
                      trailingText: settings.fontFamily,
                      onTap: () {
                        _showOptionsBottomSheet(context, settings.translate('font_style_dialog'), ['Poppins', 'Inter', 'Roboto', 'Times New Roman', 'Arial', 'Courier New', 'Georgia', 'Verdana'], settings.fontFamily, (val) {
                          settings.setFontFamily(val);
                        });
                      },
                    ),
                    _buildSettingsItem(
                      icon: Icons.dark_mode_outlined,
                      title: settings.translate('theme_mode'),
                      subtitle: settings.translate('theme_mode_desc'),
                      trailingText: settings.themeModeStr == 'Gelap'
                          ? (settings.language == 'Inggris' ? 'Dark' : (settings.language == 'Arab' ? 'داكن' : 'Gelap'))
                          : (settings.language == 'Inggris' ? 'Light' : (settings.language == 'Arab' ? 'فاتح' : 'Terang')),
                      onTap: () => _showThemeSelectionBottomSheet(context, settings),
                    ),


                    const SizedBox(height: 24),
                    _buildSettingsSectionTitle(settings.translate('others')),
                    _buildSettingsItem(
                      icon: Icons.notifications,
                      title: settings.translate('reminder'),
                      subtitle: settings.translate('reminder_desc'),
                      onTap: () {
                        _showReminderDialog(context, settings);
                      },
                    ),

                    _buildSettingsItem(
                      icon: Icons.language,
                      title: settings.translate('language'),
                      subtitle: settings.translate('language_desc'),
                      trailingText: settings.language,
                      onTap: () {
                        _showOptionsBottomSheet(context, settings.translate('lang_dialog'), ['Indonesia', 'Inggris', 'Arab'], settings.language, (val) {
                          settings.setLanguage(val);
                        });
                      },
                    ),

                    const SizedBox(height: 32),
                  ],
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

  void _showThemeSelectionBottomSheet(BuildContext context, SettingsProvider settings) {
    final isDarkMode = settings.themeModeStr == 'Gelap';
    showModalBottomSheet(
      context: context,
      backgroundColor: isDarkMode ? const Color(0xFF1E1E1E) : Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: isDarkMode ? Colors.white24 : Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                settings.translate('theme_mode_dialog'),
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: isDarkMode ? Colors.white : Colors.black87,
                ),
              ),
              const SizedBox(height: 16),
              ListTile(
                leading: Icon(Icons.light_mode, color: isDarkMode ? Colors.white70 : const Color(0xFF13A884)),
                title: Text(
                  settings.language == 'Inggris' 
                      ? 'Light Mode (Green)' 
                      : (settings.language == 'Arab' ? 'الوضع الفاتح (الأخضر)' : 'Mode Terang (Hijau)'),
                  style: TextStyle(
                    color: isDarkMode ? Colors.white : Colors.black87,
                    fontWeight: settings.themeModeStr == 'Hijau' ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
                trailing: settings.themeModeStr == 'Hijau'
                    ? const Icon(Icons.check_circle, color: Color(0xFF13A884))
                    : null,
                onTap: () {
                  settings.setThemeModeStr('Hijau');
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: Icon(Icons.dark_mode, color: isDarkMode ? const Color(0xFF13A884) : Colors.black54),
                title: Text(
                  settings.language == 'Inggris' 
                      ? 'Dark Mode' 
                      : (settings.language == 'Arab' ? 'الوضع الداكن' : 'Mode Gelap'),
                  style: TextStyle(
                    color: isDarkMode ? Colors.white : Colors.black87,
                    fontWeight: settings.themeModeStr == 'Gelap' ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
                trailing: settings.themeModeStr == 'Gelap'
                    ? const Icon(Icons.check_circle, color: Color(0xFF13A884))
                    : null,
                onTap: () {
                  settings.setThemeModeStr('Gelap');
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSettingsSectionTitle(String title) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: isDarkMode ? Colors.white : const Color(0xFF2D3436),
        ),
      ),
    );
  }

  Widget _buildSettingsItem({
    required IconData icon,
    required String title,
    required String subtitle,
    String? trailingText,
    bool isSwitch = false,
    VoidCallback? onTap,
  }) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12.0),
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: isDarkMode ? const Color(0xFF252525) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: isDarkMode ? Colors.white10 : const Color(0xFFF1F3F4), width: 1.5),
        ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: isDarkMode ? const Color(0xFF1F3530) : const Color(0xFFE8F5F1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: const Color(0xFF13A884), size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: isDarkMode ? Colors.white : const Color(0xFF2D3436),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 12,
                    color: isDarkMode ? Colors.white60 : Colors.grey,
                  ),
                ),
              ],
            ),
          ),
          if (trailingText != null) ...[
            Text(
              trailingText,
              style: TextStyle(
                fontSize: 14,
                color: isDarkMode ? Colors.white60 : Colors.grey,
              ),
            ),
            const SizedBox(width: 8),
          ],
          if (isSwitch)
            Switch(
              value: false,
              onChanged: (val) {},
              activeColor: const Color(0xFF13A884),
            )
          else
            const Icon(Icons.chevron_right, color: Color(0xFF13A884), size: 24),
        ],
      ),
      ),
    );
  }

  void _showOptionsDialog(BuildContext context, String title, List<String> options, String currentValue, Function(String) onSelected) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: options.map((option) {
              return RadioListTile<String>(
                title: Text(option),
                value: option,
                groupValue: currentValue,
                activeColor: const Color(0xFF13A884),
                onChanged: (String? value) {
                  if (value != null) {
                    onSelected(value);
                    Navigator.pop(context);
                  }
                },
              );
            }).toList(),
          ),
        );
      },
    );
  }

  void _showOptionsBottomSheet(BuildContext context, String title, List<String> options, String currentValue, Function(String) onSelected) {
    String selectedValue = currentValue;
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            return SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Text(
                        title,
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(height: 16),
                    ...options.map((option) {
                      final isSelected = selectedValue == option;
                      return ListTile(
                        contentPadding: const EdgeInsets.symmetric(horizontal: 24),
                        title: Text(
                          option,
                          style: TextStyle(
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                            color: isSelected ? const Color(0xFF13A884) : Colors.black87,
                          ),
                        ),
                        trailing: isSelected
                            ? const Icon(Icons.check, color: Color(0xFF13A884))
                            : null,
                        onTap: () {
                          setModalState(() {
                            selectedValue = option;
                          });
                          onSelected(option);
                          Future.delayed(const Duration(milliseconds: 300), () {
                            if (context.mounted) {
                              Navigator.pop(context);
                            }
                          });
                        },
                      );
                    }),
                  ],
                ),
              ),
            );
          }
        );
      },
    );
  }

  void _showReminderDialog(BuildContext context, SettingsProvider settings) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Pengingat Doa', style: TextStyle(fontWeight: FontWeight.bold)),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SwitchListTile(
                    title: const Text('Aktifkan Pengingat'),
                    value: settings.reminderEnabled,
                    activeColor: const Color(0xFF13A884),
                    onChanged: (bool value) {
                      setState(() {
                        settings.setReminderEnabled(value);
                      });
                    },
                  ),
                  if (settings.reminderEnabled)
                    ListTile(
                      title: const Text('Waktu Pengingat'),
                      trailing: Text(
                        settings.reminderTime,
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      onTap: () async {
                        final timeParts = settings.reminderTime.split(':');
                        final initialTime = TimeOfDay(
                          hour: int.tryParse(timeParts[0]) ?? 4,
                          minute: int.tryParse(timeParts[1]) ?? 0,
                        );
                        final TimeOfDay? picked = await showTimePicker(
                          context: context,
                          initialTime: initialTime,
                        );
                        if (picked != null) {
                          setState(() {
                            final formattedTime = '${picked.hour.toString().padLeft(2, '0')}:${picked.minute.toString().padLeft(2, '0')}';
                            settings.setReminderTime(formattedTime);
                          });
                        }
                      },
                    ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Tutup', style: TextStyle(color: Color(0xFF13A884))),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
