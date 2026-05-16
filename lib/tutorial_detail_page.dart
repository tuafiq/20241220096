import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:share_plus/share_plus.dart';
import 'tutorial_model.dart';

class TutorialDetailPage extends StatefulWidget {
  final TutorialModel item;
  final List<TutorialModel> allItems;
  final int currentIndex;

  const TutorialDetailPage({
    super.key, 
    required this.item, 
    required this.allItems, 
    required this.currentIndex,
  });

  @override
  State<TutorialDetailPage> createState() => _TutorialDetailPageState();
}

class _TutorialDetailPageState extends State<TutorialDetailPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late TutorialModel currentItem;
  late int currentIndex;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _tabController.addListener(() {
      setState(() {}); // Segarkan UI saat tab berubah
    });
    currentItem = widget.item;
    currentIndex = widget.currentIndex;
  }

  void _navigateToNext() {
    if (currentIndex < widget.allItems.length - 1) {
      setState(() {
        currentIndex++;
        currentItem = widget.allItems[currentIndex];
      });
    }
  }

  void _navigateToPrevious() {
    if (currentIndex > 0) {
      setState(() {
        currentIndex--;
        currentItem = widget.allItems[currentIndex];
      });
    }
  }

  void _shareContent() {
    final String shareText = '''
${currentItem.name}

Arab:
${currentItem.arabic}

Latin:
${currentItem.latin}

Artinya:
${currentItem.terjemahan}

Bagikan dari Aplikasi UAS
''';
    Share.share(shareText);
  }

  @override
  Widget build(BuildContext context) {
    const primaryGreen = Color(0xFF149177);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF2D3436)),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          currentItem.name,
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold, 
            color: const Color(0xFF2D3436),
            fontSize: 18,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.share_outlined, color: primaryGreen),
            onPressed: _shareContent,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 10),

            // Tabs
            TabBar(
              controller: _tabController,
              indicatorColor: primaryGreen,
              indicatorWeight: 3,
              labelColor: primaryGreen,
              unselectedLabelColor: Colors.grey[400],
              labelStyle: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 13),
              tabs: const [
                Tab(icon: Icon(Icons.menu_book, size: 20), text: 'Bacaan'),
                Tab(icon: Icon(Icons.translate, size: 20), text: 'Latin'),
                Tab(icon: Icon(Icons.info_outline, size: 20), text: 'Artinya'),
                Tab(icon: Icon(Icons.description_outlined, size: 20), text: 'Penjelasan'),
              ],
            ),

            const SizedBox(height: 20),

            // Content
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Logika Filter Tampilan berdasarkan Tab
                  // Tab 0 (Bacaan) -> Tampilkan Semua (Arab, Latin, Artinya)
                  // Tab 1 (Latin) -> Hanya Latin
                  // Tab 2 (Artinya) -> Hanya Artinya
                  // Tab 3 (Penjelasan) -> Hanya Penjelasan
                  
                  if (_tabController.index == 0) ...[
                    _buildContentSection('ARAB', currentItem.arabic, primaryGreen),
                    const SizedBox(height: 24),
                    _buildContentSection('LATIN', currentItem.latin, primaryGreen, isItalic: true),
                    const SizedBox(height: 24),
                    _buildContentSection('ARTINYA', currentItem.terjemahan, primaryGreen),
                  ],
                  
                  if (_tabController.index == 1) 
                    _buildContentSection('LATIN', currentItem.latin, primaryGreen, isItalic: true),
                  
                  if (_tabController.index == 2)
                    _buildContentSection('ARTINYA', currentItem.terjemahan, primaryGreen),
                  
                  if (_tabController.index == 3 || _tabController.index == 0) ...[
                    const SizedBox(height: 24),
                    Text(
                      'PENJELASAN',
                      style: GoogleFonts.poppins(
                        fontSize: 12, 
                        fontWeight: FontWeight.bold, 
                        color: primaryGreen,
                        letterSpacing: 1.2,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: primaryGreen.withOpacity(0.05),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Text(
                        '${currentItem.name} dibaca dengan khusyu sebagai bagian dari rukun/sunnah dalam sholat untuk menyempurnakan ibadah.',
                        style: GoogleFonts.poppins(fontSize: 13, height: 1.6, color: const Color(0xFF2D3436)),
                      ),
                    ),
                  ],
                ],
              ),
            ),


            
            const SizedBox(height: 100),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNav(primaryGreen),
    );
  }

  Widget _buildContentSection(String title, String content, Color color, {bool isItalic = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: GoogleFonts.poppins(
                fontSize: 12, 
                fontWeight: FontWeight.bold, 
                color: color,
                letterSpacing: 1.2,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          content,
          textAlign: title == 'ARAB' ? TextAlign.right : TextAlign.left,
          style: title == 'ARAB' 
            ? GoogleFonts.scheherazadeNew(fontSize: 24, height: 1.8, color: const Color(0xFF2D3436), fontWeight: FontWeight.bold)
            : GoogleFonts.poppins(fontSize: 14, height: 1.6, color: const Color(0xFF2D3436), fontStyle: isItalic ? FontStyle.italic : FontStyle.normal),
        ),
      ],
    );
  }

  Widget _buildBottomNav(Color primaryGreen) {
    return Container(
      height: 90,
      decoration: BoxDecoration(
        color: const Color(0xFFF8FBFA),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10, offset: const Offset(0, -5)),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: InkWell(
              onTap: _navigateToPrevious,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.arrow_back, size: 16, color: Colors.grey),
                      const SizedBox(width: 8),
                      Text('Sebelumnya', style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey)),
                    ],
                  ),
                  Text(
                    currentIndex > 0 ? widget.allItems[currentIndex - 1].name : '-',
                    style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.bold),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ),
          Container(
            width: 60,
            height: 60,
            decoration: const BoxDecoration(color: Color(0xFF149177), shape: BoxShape.circle),
            child: const Icon(Icons.menu_book, color: Colors.white),
          ),
          Expanded(
            child: InkWell(
              onTap: _navigateToNext,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Selanjutnya', style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey)),
                      const SizedBox(width: 8),
                      const Icon(Icons.arrow_forward, size: 16, color: Colors.grey),
                    ],
                  ),
                  Text(
                    currentIndex < widget.allItems.length - 1 ? widget.allItems[currentIndex + 1].name : '-',
                    style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.bold),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
